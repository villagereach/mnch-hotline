require 'forwardable'

# Flattened view of a call, including patient, encounter and observation data.
# Includes multiple ways of access values, via a hash or method syntax:
#   fc = FlattenedCall.new(CallLog.last)
#   fc.call_id
#   fc.pregnancy_status
#   fc['PREGNANCY STATUS']
#   fc.person.age
#
# Can provide a list of encounters instead of a call or can filter out
# irrelevant encounters you don't want observations for
#   fc = FlattenedCall.new(Encounter.where(...))
#        # ... but call and patient data is for first call only
#   fc = FlattenedCall.new(CallLog.last)
#   fc.encounter_types # => ["REGISTRATION", "TIPS AND REMINDERS"]
#   fc.obs_hash # => {...} (includes all encounters)
#   fc.filter!('TIPS AND REMINDERS')
#   fc.encounter_types # => ["TIPS AND REMINDERS"]
#   fc.obs_hash # => {...} (includes observations for only tips and reminders)
#

class FlattenedCall
  extend Forwardable

  def_delegators :call, :call_type
  def_delegator  :call, :call_log_id, :call_id
  def_delegator  :call, :start_time,  :call_start
  def_delegator  :call, :end_time,    :call_end
  def_delegator  :call, :call_mode,   :repeat_caller
  def_delegator  :call, :district
  
  
  def_delegators :patient, :national_id, :gender, :ivr_access_code
  def_delegator  :patient, :date_created, :patient_created

  def_delegator  :person, :birthdate, :dob
  def_delegator  :person, :address,   :village

  def_delegators :person_attrs, :occupation
  def_delegator  :person_attrs, :nearest_health_facility, :nearest_hc
  def_delegator  :person_attrs, :cell_phone_number, :person_cell_phone

  def_delegators :obs_hash, :pregnancy_status, :expected_due_date

  # update outcome encounters
  def_delegators :obs_hash, :outcome, :health_facility_name,
    :reason_for_referral, :secondary_outcome

  # tips and reminders encounters
  def_delegators :obs_hash, :on_tips_and_reminders_program,
    :telephone_number, :telephone_number_type, :type_of_message, :language_preference,
    :type_of_message_content

  # cold symptoms observations
  def_delegators :obs_hash, :fever, :diarrhea, :cough, :convulsions_symptom,
    :not_eating, :vomiting, :red_eye, :fast_breathing, :very_sleepy,
    :unconscious

  # child signs observations
  def_delegators :obs_hash, :fever_of_7_days_or_more,
    :cough_for_21_days_or_more, :blood_in_stool,
    :red_eye_for_4_days_or_more_with_visual_problems,
    :not_eating_or_drinking_anything, :very_sleepy_or_unconscious,
    :potential_chest_indrawing, :diarrhea_for_14_days_or_more,
    :convulsions_sign, :vomiting_everything

  # child info observations
  def_delegators :obs_hash, :sleeping, :growth_milestones, :feeding_problems,
    :skin_infections, :crying, :bowel_movements, :umbilicus_infection,
    :skin_rashes, :accessing_healthcare_services

  # maternal symptoms observations
  def_delegators :obs_hash, :vaginal_bleeding_during_pregnancy, :postnatal_bleeding, :fever_during_pregnancy_symptom, :postnatal_fever_symptom, :headaches, :fits_or_convulsions_symptom, :swollen_hands_or_feet_symptom, :paleness_of_the_skin_and_tiredness_symptom, :no_fetal_movements_symptom, :water_breaks_symptom, :postnatal_discharge_bad_smell, :abdominal_pain, :problems_with_monthly_periods, :problems_with_family_planning_method, :infertility, :frequent_miscarriages, :vaginal_bleeding_not_during_pregnancy, :vaginal_itching, :vaginal_discharge, :other,
    :patient_using_family_planning, :method_of_family_planning, :satisfied_with_family_planning_method, :require_information_on_family_planning

  # maternal signs observations
  def_delegators :obs_hash, :postnatal_fever_sign, :fits_or_convulsions_sign,
    :heavy_vaginal_bleeding_during_pregnancy,
    :paleness_of_the_skin_and_tiredness_sign, :excessive_postnatal_bleeding,
    :severe_headache, :swollen_hands_or_feet_sign, :no_fetal_movements_sign,
    :fever_during_pregnancy_sign, :water_breaks_sign, :acute_abdominal_pain

  # "other information" observations
  def_delegators :obs_hash, :healthcare_visits, :nutrition, :body_changes, :discomfort, :concerns, :emotions, :warning_signs, :routines, :beliefs, :baby_s_growth, :milestones, :prevention, :family_planning, :birth_planning_male, :birth_planning_female, :other

  # Follow-up info
  def_delegator :followup, :date_created, :followup_time
  def_delegator :followup, :district,  :followup_district
  def_delegator :followup, :result, :followup_result

  def initialize(call_or_followup)
    if call_or_followup.kind_of?(CallLog)
      @call = call_or_followup
    else
      @followup = call_or_followup
    end
  end

  def [](key)
    self.send(methodize(key))
  end

  def methodize(value)
    MethodizedHash::methodize(value)
  end

  def filter!(*encounter_types)
    @encounters = encounters.select {|e| encounter_types.include?(e.name) }
    @encounter_types, @observations, @obs_hash = nil
    self
  end

  def encounter_types
    @encounter_types ||= encounters.map(&:name)
  end

  def encounters
    @encounters ||= @call.encounters
  end

  def patient
    return @patient if @patient
    #for some reason, Patient.new and Person.new was creating records.   Probably a save buried in model code.  
    # this is a workaround to just return nils, without unwinding either model or delegation
    if followup
      @patient ||= Patient.find_by_patient_id(@followup.patient_id) 
    elsif encounters.any?
      @patient ||= encounters.first.patient
    end
    @patient ||= MethodizedHash[]
  end

  def person
    return @person if @person
    if @patient && @patient.kind_of?(Patient)
      @person = patient.person
    end
    @person ||= MethodizedHash[]  #also catches some personless-patient bad data
  end

  def person_attrs
    return @person_attrs if @person_attrs
    if @person && @person.kind_of?(Person)
      mapped_attrs = person.person_attributes.map {|a| [a.type.name, a.value]}
      @person_attrs = MethodizedHash[person.attributes.to_a | mapped_attrs]
    else
      @person_attrs =  MethodizedHash[]
    end
  end

  def observations
    # only includes observations with an attached concept name
    @observations ||= encounters.map(&:observations).flatten.select(&:concept)
  end

  def obs_hash
    @obs_hash ||= MethodizedHash[observations.map {|o| [o.concept.name, o.answer_string]}]
  end

  def call
    @call 
  end

  def followup
    @followup
  end

end
