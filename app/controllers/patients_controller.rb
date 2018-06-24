class PatientsController < ApplicationController
  # DEFAULT_ROLENAME = 'clerk'

  def index

        patient = Patient.new
        patient = Patient.all
        render json: patient
  end

  def show
  end

  def create
    data = JSON.parse(request.body.read)
    validate_user_data data

    patient = Patient.new
    patient.person = Person.new(
      birthdate: data['birthdate'],
      gender: data['gender'],
      person_name: PersonName.new({
        firstname: data['first_name'],
        lastname: data['last_name']
      })
    )

    if !patient.save
      return render :json => {'error' => 'Bad input', 'data' => patient.errors.full_messages},
                    :status => 400
    end

    render :json => data
  rescue JSON::ParserError => e
    render :json => {'error' => 'Bad input'}, :status => 400
  rescue ArgumentError => e
    render :json => {'error' => 'Bad input', 'message' => e.to_s},
           :status => 400
  end

  def update

    patient = Patient.find(params[:id])
    patient.deleted_at = Time.now
    if   patient.save
      render json: patient
    else
      puts 'error updating record'
    end

  end

  def destroy
    patient = Patient.find(params[:id])

    if patient.nil?
      return render json: {'errors' => ['Not found']}, status: 404
    end

    unless patient.destroy
      return render json: {'errors' => patient.errors.full_messages}, status: 400
    end

    render json: patient, status: 204
  rescue JSON::ParserError => e
    render json: {'errors' => 'Bad input'}, status: 400
  end

  end


  def validate_user_data(data)
    logger.debug(data)
    %w{firstname lastname birthdate gender}.each do |field|
      raise ArgumentError.new("#{field} required") if is_empty_string?(data[field])
    end
  end

  def is_empty_string?(str)
    logger.debug("Validating #{str}")
    str == nil or str.empty?
  end
end
end
