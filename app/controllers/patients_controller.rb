class PatientsController < ApplicationController
  def index
    render json: Patient.all
  end

  def show
    patient = Patient.find params[:id]
    if patient.nil?
      render json: {'errors' => ['Person ##{params[:id] not found']}, status: 404
    else
      render json: patient
    end
  end

  def create
    patient = process_create_params
    if patient.save
      render json: patient, status: 201
    else
      render json: {'errors': patient.errors.messages}, status: 400
    end
  rescue JSON::ParserError => e
    logger.error('Failed to parse JSON: %s', e.to_s)
    render :json => {'errors' => 'Bad input'}, status: 400
  rescue ArgumentError => e
    render :json => {'errors' => [e.to_s]}, status: 400
  end

  def update
    patient = process_update_params
    if patient.nil?
      errors = ["Patient ##{params[:id]} with given id not found"]
      render json: {'errors': errors}, status: 400
    elsif patient.save
      render json: patient, status: 204
    else
      render json: {'errors': patient.errors.messages}, status: 400
    end
  rescue JSON::ParserError => e
    logger.error('Failed to parse JSON: %s', e.to_s)
    render :json => {'errors' => 'Bad input'}, status: 400
  rescue ArgumentError => e
    render :json => {'errors' => [e.to_s]}, status: 400
  end

  def destroy
    patient = Patient.find params[:id]
    if patient.nil?
      render json: {'errors' => ['Not found']}, status: 404
    elsif patient.destroy
      render json: patient, status: 204
    else
      render json: {'errors' => patient.errors.messages}, status: 400
    end
  rescue JSON::ParserError => e
    render json: {'errors' => ['Bad input']}, status: 400
  end

  private
    def process_create_params
      person = get_target_person

      # New patients have to be attached to free people (ie people without another
      # patient already bound). Doesn't make sense having multiple patients
      # linked to the same person.
      raise ArgumentError.new(
        "Person ##{person.id} already attached to patient ##{person.patient.id}"
      ) unless person.patient.nil?  

      Patient.new person: person
    end

    def process_update_params
      patient = Patient.find params[:id]
      return nil if patient.nil?

      person = get_target_person

      patient.person = person
      patient
    end

    def get_target_person
      data =  JSON.parse request.body.read

      person_id = data['person_id']
      if person_id.nil? or !person_id.match? /^\d+$/
        raise ArgumentError.new 'person_id can not be blank'
      elsif !person_id.match? /^\d+$/
        raise ArgumentError.new "person_id ##{person_id} is invalid"
      end

      person = Person.find person_id.to_i
      raise ArgumentError.new "Person ##{person_id} not found" if person.nil?
      person
    end
end
