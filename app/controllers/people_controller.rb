require 'utils/string_utils'

class PeopleController < ApplicationController
  def index
    render json: Person.all
  end

  def search
    posted_params = get_posted_params(required = ['firstname', 'lastname'])
    render json: Person.joins(:person_name).where(
      "person_names.firstname LIKE ? AND person_names.lastname LIKE ?",
      "%#{posted_params['firstname']}%", "%#{posted_params['lastname']}%"
    )
  end

  def show
    person = Person.find(params[:id])
    person.nil? ? render(json: {'errors': ['Not found']}, status: 404)
                : render(json: person, status: 200)
  end

  def create
    person = process_create_params
    if person.nil?
      render json: ['errors' => person.errors.full_messages], status: 400
    elsif person.save
      render json: person, status: 201
    else
      render json: {'errors' => person.errors.messages}, status: 400
    end
  rescue JSON::ParserError => e
    logger.error("Failed to parse JSON: #{e}")
    render json: {'errors' => ['Bad input']}, status: 400
  rescue ArgumentError => e
    render json: {'errors' => [e.to_s]}, status: 400
  end

  def update
    person = process_update_params
    if person.nil?
      render json: ['errors' => person.errors.full_messages], status: 400
    elsif person.save
      render json: person, status: 204
    else
      render json: {'errors' => person.errors.messages}, status: 400
    end
  rescue JSON::ParserError => e
    logger.error("Failed to parse JSON: #{e}")
    render json: {'errors' => ['Bad input'], status: 400}
  rescue ArgumentError => e
    render json: {'errors' => [e.to_s], status: 400}
  rescue ActiveModel::UnknownAttributeError => e
    logger.error("Failed to update person: #{e}")
    render json: {'errors' => [e.to_s], status: 400}
  end

  def destroy
    person = Person.find(params[:id])
    if person.nil?
      render json: {'errors' => ['Person not found']}, status: 404
    elsif person.destroy
      render json: person, status: 204
    else
      render json: {'errors' => ['Destroy through bound user or patient']}, status: 400
    end
  end

  private
    PERSON_NAME_FIELDS = %w{firstname lastname}


    def process_create_params
      data = JSON.parse request.body.read
      validate_params data, PERSON_NAME_FIELDS

      person = Person.new(
        person_name: PersonName.new(
          firstname: data['firstname'],
          lastname: data['lastname']
        ),
        birthdate: data['birthdate'],
        gender: data['gender']
      )
    end

    def process_update_params
      data = JSON.parse request.body.read
      person = Person.find(params[:id])
      person.nil? ? nil
                  : person.update(data) and person
    end

    def validate_params(params, fields)
      fields.each do |field|
        if StringUtils::is_empty_string?(params[field])
          throw ArgumentError.new("#{field} can't be blank")
        end
      end
    end

    # TODO: Refactor this method... It's duplicated in users_controller.
    # Having this here was a quick hack to get things done temporarily.
    def get_posted_params(required = [])
      required = required.dup
      
      processed_params = JSON.parse(request.body.read).inject({}) do |hash, items|
        key, value = items

        required.delete key if required.include? key or StringUtils::is_empty_string? value

        case key
        when 'person_id' then
          hash['person'] = get_person_by_id value
        when 'role' then
          hash['role'] = get_role_by_name value
        else
          hash[key] = value
        end

        hash
      end

      if required.size > 0
        raise ArgumentError.new "Following are required: #{required}"
      end

      processed_params
    end
end
