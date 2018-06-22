require 'utils/string_utils'

class UsersController < ApplicationController
  DEFAULT_ROLENAME = 'clerk'

  def index
    render json: User.all
  end

  def show
    user = User.find(params[:id])

    if user.nil?
      return render json: {'errors' => ['Not found']}, status: 404
    end

    render json: user
  end

  def create
    data = validate_user_data JSON.parse(request.body.read)
    user = create_user data

    if !user.save
      return render json: {'errors' => user.errors.full_messages}, status: 400
    end

    render json: user, status: 201
  rescue JSON::ParserError
    render json: {'errors' => ['Bad input']}, status: 400
  rescue ArgumentError => e
    render json: {'errors' => [e.to_s]}, status: 400
  end

  def update
    user = User.find(params[:id])

    if user.nil?
      return render json: {'errors' => ['Not found']}, status: 404
    end

    data = validate_user_data JSON.parse(request.body.read)
    user.update data

    if !user.save
      return render json: {'errors' => user.errors.full_messages}, status: 400
    end

    render json: user, status: 204
  rescue JSON::ParserError
    render json: {'errors' => ['Bad input']}, status: 400
  rescue ArgumentError => e
    render json: {'errors' => [e.to_s]}
  end

  def destroy
    user = User.find(params[:id])

    if user.nil?
      return render json: {'errors' => ['Not found']}, status: 404
    end
    
    unless user.destroy
      return render json: {'errors' => user.errors.full_messages}, status: 400
    end

    render json: user, status: 204
  rescue JSON::ParserError => e
    render json: {'errors' => ['Bad input']}, status: 400
  end

  private
    # List of fields required for creating a full user (see method full_new_user)
    USER_DATA_FIELDS = %w{
      username password firstname lastname birthdate gender role
    }

    DEFAULT_USER_ROLE = 'clerk'

    # Validate data used in creating a full user.
    #
    # Returns - validated user data.
    #
    # NOTE: Method converts roles from string to Role objects upon validation.
    def validate_user_data(user_data)
      USER_DATA_FIELDS.inject({}) do |validated_user_data, field|
        value = user_data[field]

        if field == 'role'
          rolename = value or DEFAULT_USER_ROLE
          value = Role.find_by_rolename(rolename)
          raise ArgumentError.new("Invalid role: #{rolename}") if value.nil?
        elsif StringUtils::is_empty_string?(value)
          raise ArgumentError.new("#{field} required")
        end

        validated_user_data[field] = value
        validated_user_data
      end
    end

    # Creates a user together with all related sub models.
    def create_user(data)
      user = User.new(
        username: data['username'],
        person: Person.new(
          birthdate: data['birthdate'],
          gender: data['gender'],
          person_name: PersonName.new({
            firstname: data['first_name'],
            lastname: data['last_name']
          })
        ),
        role: data['role']
      )
      user.set_password data['password']
      user
    end
end
