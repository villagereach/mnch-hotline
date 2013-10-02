require 'csv'
require 'delegate'
require 'pry'

F_DATE = '%Y-%m-%d'
F_TIME = '%H:%M:%S'
F_DATETIME = '%Y-%m-%d %H:%M:%S'
REPORTS_BASE_DIR = File.join(Rails.root, 'tmp', 'reports')

FILENAME_DATE_FORMAT = '%B-%Y'

def find_previous_national_ids(end_date)
  #WARN:  hardcoded ids.  nothing would be safe from a future data-dictionary update / migration.
  # ruby shown is confirmation, but not necessarily unique.  
  # national id type = 3 = PatientIdentifierType.find_by_name("National id").patient_identifier_type_id
  # 'Yes' 'concept' for tips enrollment observation = 1065  = ConceptName.find_by_concept_id(1065)
  # tips enrollment concept for observations = 8315  = ConceptName.find_by_name("ON TIPS AND REMINDERS PROGRAM").concept_id
  # also note person_id == patient_id in openMRS
  enrolled_patient_id_sql = "SELECT DISTINCT person_id FROM obs WHERE concept_id=8315 AND value_coded=1065 AND date_voided IS NULL AND obs_datetime < '#{end_date}'"
  any_encounter_patient_id_sql = "SELECT DISTINCT patient_id FROM encounter WHERE date_voided IS NULL  AND encounter_datetime < '#{end_date}' "
  
  national_id_sql = "SELECT DISTINCT patient_identifier.identifier FROM patient_identifier WHERE identifier_type = 3 "
  
  
  all_national_ids      = Patient.find_by_sql("#{national_id_sql} AND patient_id IN (#{any_encounter_patient_id_sql})").map(&:identifier)
  enrolled_national_ids = Patient.find_by_sql("#{national_id_sql} AND patient_id IN (#{enrolled_patient_id_sql})").map(&:identifier)
  
  [all_national_ids, enrolled_national_ids]
end

namespace :report do  
  desc "call log CSV reports"
  task :call_log_csv, [:month] => :environment do |t,args|
    #intended to do one month of reporting. format is "2013-09" 
    month = args[:month]
    raise "reporting month needed.  use 'all' to report all data" if month.empty?
    if month == "all"
      end_date = CallLog.last.start_time.to_date + 1.day
      reporting_date_label = "all-through-"+end_date.strftime(F_DATE)
      relevant_calls = CallLog.find(:all)       
      previous_all_ids, previous_enrollee_ids = [ [], [] ]
    else
      month_start = Date.parse(month+"-01")
      next_month_start = month_start + 1.month
      reporting_date_label = month_start.strftime(FILENAME_DATE_FORMAT)
      relevant_calls = CallLog.find(:all, :conditions => "start_time >= '#{month_start}' AND start_time < '#{next_month_start}'")
      previous_all_ids, previous_enrollee_ids = find_previous_national_ids(month_start)
    end

    reports_dir = File.join(REPORTS_BASE_DIR, reporting_date_label)

    Dir.mkdir(REPORTS_BASE_DIR) unless File.directory?(REPORTS_BASE_DIR)
    Dir.mkdir(reports_dir) unless File.directory?(reports_dir)
    Dir.chdir(reports_dir)


    call_log_reports = [
      CallDataCSV.new("Call-Data", reporting_date_label),
      OutcomesCSV.new('Outcomes', reporting_date_label),
      ChildHealthSymptomsCSV.new("Child-Health", reporting_date_label),
      MaternalHealthSymptomsCSV.new("Maternal-Health", reporting_date_label),
      TipsAndRemindersCSV.new("Tips-and-Reminders-Activity", reporting_date_label),  #FIXME:  ensure this is monthly activity,  add ever-enrolled Participants separately.  (current enrollments from notifier)
    ]
    unique_reports = [
      UniqueRegistrantCSV.new("Unique-Registrants", reporting_date_label, previous_all_ids),
      UniqueEnrolleeCSV.new("Unique-Enrollees", reporting_date_label, previous_enrollee_ids)
    ]


    puts "relevant call count for #{reporting_date_label}:  #{relevant_calls.size}"

    relevant_calls.each_with_index do |call, idx|
      puts "call #{idx} #{call.start_time}" if idx % 50 == 0
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
    [ 'CALL ID', 'CALL TYPE', 'CALL DROPPED', 'HAS ENCOUNTER', 'NATIONAL ID', 'DISTRICT', 'DISTRICT NAME', 'REPEAT CALLER', 'GENDER', 'DOB', 'VILLAGE', 'NEAREST HC', 'OCCUPATION',
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



class CallDataCSV < EncounterCSV
  def columns
    (super - ['HAS ENCOUNTER'])  | ['DATE CREATED', 'CELL PHONE', 'OCCUPATION', 'START TIME', 'END TIME', 'DURATION SEC', 'DURATION M:S']
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



class UniqueRegistrantCSV < CallDataCSV

  def initialize(filename, date_label, initial_ids)
    super(filename, date_label)
    @written_ids = initial_ids
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
    super | [ 'ON TIPS AND REMINDERS PROGRAM', 'TELEPHONE NUMBER', 'TELEPHONE NUMBER TYPE',
      'TYPE OF MESSAGE', 'LANGUAGE PREFERENCE', 'TYPE OF MESSAGE CONTENT' ]    
  end

  def conditional_write(fc)
    if fc.on_tips_and_reminders_program == 'Yes'
      super(fc)
    end
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

