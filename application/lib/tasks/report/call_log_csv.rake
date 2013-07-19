require 'csv'
require 'delegate'
require 'pry'

F_DATE = '%Y-%m-%d'
F_TIME = '%H:%M:%S'
F_DATETIME = '%Y-%m-%d %H:%M:%S'
REPORTS_DIR = File.join(Rails.root, 'tmp', 'reports')

FILENAME_DATE_FORMAT = '%B-%Y'

def csv_reports_reporting_date_label(range_end)
  if range_end
    reporting_date = DateTime.parse(range_end)
  else    
    reporting_date = CallLog.last.start_time.to_date - 15.days  #second half of month = report on current
  end
  reporting_date.strftime(FILENAME_DATE_FORMAT)
end

namespace :report do  
  desc "call log CSV reports"
  task :call_log_csv, [:start,:end] => :environment do |t,args|
    range_start, range_end = [:start,:end].map do |d|
      case args[d]
      when 'nil',nil then nil
      when /^(\d{4}-\d{2}-\d{2}(?: \d{2}:\d{2}:\d{2})?)$/ then $1
      when /^(\d{4}-\d{2})$/ then "#{$1}-01"
      else
        raise "invalid #{d}_date: #{args[d]} (format: YYYY-MM[-DD[ HH:MM:SS]] or nil)"
      end
    end

    conditions = ""
    conditions +=  "start_time >= '{DateTime.parse(range_start).to_s}'"  if range_start
    conditions +=  "start_time <  '{DateTime.parse(range_end).to_s}'"    if range_end
    conditions = nil if conditions.empty?

    reporting_date_label = csv_reports_reporting_date_label(range_end)


    Dir.mkdir(REPORTS_DIR) unless File.directory?(REPORTS_DIR)
    Dir.chdir(REPORTS_DIR)


    call_log_reports = [
      CallDataCSV.new("Call-Data", reporting_date_label),
      OutcomesCSV.new('Outcomes', reporting_date_label),
      ChildHealthSymptomsCSV.new("Child-Health", reporting_date_label),
      MaternalHealthSymptomsCSV.new("Maternal-Health", reporting_date_label),
      TipsAndRemindersCSV.new("Tips-and-Reminders-Activity", reporting_date_label),  #FIXME:  ensure this is monthly activity,  add ever-enrolled Participants separately.  (current enrollments from notifier)
    ]
    unique_reports = [
      UniqueRegistrantCSV.new("Unique-Registrants", reporting_date_label),
      UniqueEnrolleeCSV.new("Unique-Enrollees", reporting_date_label)
    ]

    if limit = ENV['MNCH_LIMIT'] 
      order = ENV['MNCH_RAND'] ? 'rand()' : 'call_log.call_log_id ASC'
      offset = ENV['MNCH_OFFSET'] || 0
      all_calls = CallLog.find(:all, :conditions => conditions, :order=>order, :limit => limit, :offset=>offset)
    else
      all_calls = CallLog.find(:all, :conditions => conditions) 
    end
    puts "call count #{all_calls.size}"

    all_calls.each_with_index do |call, idx|
      puts "call #{idx}" if idx % 50 == 0
      fc = FlattenedCall.new(call)
      call_log_reports.each {|r| r.write(fc) }
      unique_reports.each {|r| r.conditional_write(fc) }
    end

  end
end



class FormattedCSV < SimpleDelegator
  def initialize(filename, date_label)
    @csv = CSV.open("#{filename}-#{date_label}.csv", 'wb')
    @col_defs = column_definitions # cache
    @record_delegator = self

    @csv << columns # header row
  end

  def [](key)
    fun = @col_defs[key]

    begin
      case
      when fun.nil? then self.send(methodize(key))
      when fun.arity < 1 then fun.call()
      else fun.call(self.send(methodize(key)))
      end
    rescue
      puts "KEY FAIL:  #{key} in #{self.class}"
    end
  end

  def has_encounter
    false
  end

  def columns
    []
  end

  def column_definitions
    {}
  end

  def write(record)
    @record = record
    @record_delegator.__setobj__(record)
    @csv << columns.map {|c| @record_delegator[c] }
  end
end


class EncounterCSV < FormattedCSV
  def has_encounter
    @record.encounters.any?
  end

  def columns
    [ 'CALL ID', 'CALL TYPE', 'CALL DROPPED', 'HAS ENCOUNTER', 'NATIONAL ID', 'DISTRICT', 'DISTRICT NAME', 'REPEAT CALLER', 'GENDER', 'DOB', 'VILLAGE', 'NEAREST HC',
      'PREGNANCY STATUS', 'EXPECTED DUE DATE', 'CALL DATE', 
    ]
  end

  def column_definitions
    { 'DOB'       => lambda {|v| v.try(:strftime, F_DATE) },
    'CALL DATE' => lambda { call_start.try(:strftime, F_DATE) },
    'CALL DROPPED' => lambda { call_type == 3 },
    'DISTRICT NAME' => lambda { District.find(district).name },
    'REPEAT CALLER' => lambda { ["n/a",'New','Repeat'][repeat_caller] }
    }
  end
end


class UniqueRegistrantCSV < EncounterCSV
  def columns 
    [ 'NATIONAL ID', 'DISTRICT', 'DISTRICT NAME', 'GENDER', 'DOB', 'VILLAGE', 'NEAREST HC', 'OCCUPATION', 'CALL DATE', 'CALL ID' ]
  end

  def initialize(filename, date_label)
    super(filename, date_label)
    @written_ids = []
  end

  def conditional_write(fc)
    if !@written_ids.include?(fc.national_id)
      write(fc)
      @written_ids << fc.national_id
    end
  end
end


class UniqueEnrolleeCSV < UniqueRegistrantCSV
  def columns 
    super | [ 'NATIONAL ID', 'GENDER', 'DOB', 'VILLAGE', 'NEAREST HC', 'OCCUPATION', 'CALL DATE', 'CALL ID' ]    
  end

  def conditional_write(fc)
    if fc.on_tips_and_reminders_program == 'Yes'
      super(fc)
    end
  end
end



class CallDataCSV < EncounterCSV
  def columns
    (super - ['HAS ENCOUNTER'])  | ['IVR ACCESS CODE', 'DATE CREATED', 'CELL PHONE', 'OCCUPATION', 'START TIME', 'END TIME', 'DURATION SEC', 'DURATION M:S']
  end

  def column_definitions
    super.merge({
      'DATE CREATED' => lambda { patient_created.try(:strftime, F_DATETIME) },
      'CELL PHONE'   => lambda { person_cell_phone },
      'CALL DAY'   => lambda { call_start.try(:strftime, '%A') },
      'START TIME' => lambda { call_start.try(:strftime, F_TIME) },
      'END TIME'   => lambda { call_end.try(:strftime, F_TIME) },
      })
  end
  

  def duration_sec
    (call_end - call_start).to_i if call_start && call_end
  end

  def duration_m_s
    seconds = duration_sec or return
    "%d:%02d" % [seconds/60, seconds%60]
  end

end


class OutcomesCSV < EncounterCSV
  def has_encounter
    @record.encounter_types.include?('UPDATE OUTCOME')
  end

  def columns
    super | ['OUTCOME', 'HEALTH FACILITY NAME', 'REASON FOR REFERRAL']
  end
end


class ChildHealthSymptomsCSV < EncounterCSV
  # FIXME: refactor out the following concept names into Encounter model.
  # currently only available from within Encounter#health_symptoms_values.
  CHILD_SYMPTOMS = [
    'FEVER', 'DIARRHEA', 'COUGH', 'CONVULSIONS SYMPTOM', 'NOT EATING',
    'VOMITING', 'RED EYE', 'FAST BREATHING', 'VERY SLEEPY', 'UNCONSCIOUS'
  ]
  CHILD_SIGNS =  [
    'FEVER OF 7 DAYS OR MORE', 'DIARRHEA FOR 14 DAYS OR MORE',
    'BLOOD IN STOOL', 'COUGH FOR 21 DAYS OR MORE', 'CONVULSIONS SIGN',
    'NOT EATING OR DRINKING ANYTHING', 'VOMITING EVERYTHING',
    'RED EYE FOR 4 DAYS OR MORE WITH VISUAL PROBLEMS',
    'VERY SLEEPY OR UNCONSCIOUS', 'POTENTIAL CHEST INDRAWING'
  ]
  CHILD_INFO = [
    'SLEEPING', 'FEEDING PROBLEMS', 'CRYING', 'BOWEL MOVEMENTS',
    'SKIN RASHES', 'SKIN INFECTIONS', 'UMBILICUS INFECTION',
    'GROWTH MILESTONES', 'ACCESSING HEALTHCARE SERVICES'
  ]

  def has_encounter
    @record.encounter_types.include?('CHILD HEALTH SYMPTOMS')
  end

  def columns
    super | CHILD_SYMPTOMS | CHILD_SIGNS | CHILD_INFO
  end
end


class MaternalHealthSymptomsCSV < EncounterCSV
  # FIXME: refactor out the following concept names into Encounter model.
  # currently only available from within Encounter#health_symptoms_values.
  MATERNAL_SYMPTOMS = [
    'VAGINAL BLEEDING DURING PREGNANCY', 'POSTNATAL BLEEDING',
    'FEVER DURING PREGNANCY SYMPTOM', 'POSTNATAL FEVER SYMPTOM', 'HEADACHES',
    'FITS OR CONVULSIONS SYMPTOM', 'SWOLLEN HANDS OR FEET SYMPTOM',
    'PALENESS OF THE SKIN AND TIREDNESS SYMPTOM',
    'NO FETAL MOVEMENTS SYMPTOM', 'WATER BREAKS SYMPTOM'
  ]
  MATERNAL_SIGNS = [
    'HEAVY VAGINAL BLEEDING DURING PREGNANCY', 'EXCESSIVE POSTNATAL BLEEDING',
    'FEVER DURING PREGNANCY SIGN', 'POSTNATAL FEVER SIGN', 'SEVERE HEADACHE',
    'FITS OR CONVULSIONS SIGN', 'SWOLLEN HANDS OR FEET SIGN',
    'PALENESS OF THE SKIN AND TIREDNESS SIGN', 'NO FETAL MOVEMENTS SIGN',
    'WATER BREAKS SIGN'
  ]
  MATERNAL_INFO = [
    'HEALTHCARE VISITS', 'NUTRITION', 'BODY CHANGES', 'DISCOMFORT',
    'CONCERNS', 'EMOTIONS', 'WARNING SIGNS', 'ROUTINES', 'BELIEFS',
    'BABY\'S GROWTH', 'MILESTONES', 'PREVENTION'
  ]

  def has_encounter
    @record.encounter_types.include?('MATERNAL HEALTH SYMPTOMS')
  end

  def columns
    super | MATERNAL_SYMPTOMS | MATERNAL_SIGNS | MATERNAL_INFO
  end
end


class TipsAndRemindersCSV < EncounterCSV
  def has_encounter
    @record.encounter_types.include?('TIPS AND REMINDERS')
  end

  def columns
    super | [
      'ON TIPS AND REMINDERS PROGRAM', 'TELEPHONE NUMBER', 'TELEPHONE NUMBER TYPE',
      'TYPE OF MESSAGE', 'LANGUAGE PREFERENCE', 'TYPE OF MESSAGE CONTENT',
    ]
  end
end

