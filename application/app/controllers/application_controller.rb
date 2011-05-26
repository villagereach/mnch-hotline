class ApplicationController < ActionController::Base
  include AuthenticatedSystem

  require "fastercsv"

  helper :all
  helper_method :next_task
  filter_parameter_logging :password
  before_filter :login_required, :except => ['login', 'logout','demographics']
  before_filter :location_required, :except => ['login', 'logout', 'location','demographics']
  
  def rescue_action_in_public(exception)
    @message = exception.message
    @backtrace = exception.backtrace.join("\n") unless exception.nil?
    render :file => "#{RAILS_ROOT}/app/views/errors/error.rhtml", :layout=> false, :status => 404
  end if RAILS_ENV == 'development' || RAILS_ENV == 'test'

  def rescue_action(exception)
    @message = exception.message
    @backtrace = exception.backtrace.join("\n") unless exception.nil?
    render :file => "#{RAILS_ROOT}/app/views/errors/error.rhtml", :layout=> false, :status => 404
  end if RAILS_ENV == 'production'

  def next_task(patient)
    session_date = session[:datetime].to_date rescue Date.today
    todays_encounter_types = patient.encounters.find_by_date(session_date).map{|e| e.type.name rescue ''}.uniq rescue []
    if (session[:mnch_protocol_required] || (!todays_encounter_types.include?"REGISTRATION"))
      task = Task.next_task(Location.current_location, patient, session_date, todays_encounter_types)
      return task.url if task.present? && task.url.present?
    end

    return "/patients/show/#{patient.id}" 
  end

  def print_and_redirect(print_url, redirect_url, message = "Printing, please wait...")
    @print_url = print_url
    @redirect_url = redirect_url
    @message = message
    render :template => 'print/print', :layout => nil
  end

  def void_encounter(reason = "Cancelled")
    @encounter = Encounter.find(params[:encounter_id])
    ActiveRecord::Base.transaction do
      @encounter.void(reason)
    end
    return
  end

  def void_clinic_schedule(reason = "Removed")
    schedule_id = params[:schedule_id] || params[:clinic_schedule_id]
    @schedule = ClinicSchedule.find(schedule_id)
    ActiveRecord::Base.transaction do
      @schedule.void(reason)
    end
    return
  end
  
private

  def find_patient
    @patient = Patient.find(params[:patient_id] || session[:patient_id] || params[:id]) rescue nil
  end
  
end
