require 'securerandom'
require 'utils/string_utils'

class UsersController < ApplicationController
  USER_AUTH_TOKEN_LENGTH = 32

  skip_before_action :authenticate, :only => :login

  def login
    posted_params = get_posted_params(required = ['username', 'password'])
    username = posted_params['username']
    password = posted_params['password']

    logger.debug "Attempting to login #{username}"
    user = User::authenticate username, password

    if user.nil?
      logger.debug "Login failed for #{username}"
      return render json: {'errors' => ['Invalid username or password']}, status: 403
    end

    logger.debug "Generating auth token for user ##{user.id} - #{username}"
    auth = UserAuth.create user: user, token: SecureRandom::hex(USER_AUTH_TOKEN_LENGTH)

    logger.debug "Successfully authenticated user ##{user.id} - #{username}"
    render json: {'message': 'Login successful', 'api-key': "#{auth.id}&#{auth.token}", 'user': user}
  end

  def check_login
    render json: @logged_in_user
  end

  def logout
    auth_header = request.headers['API_KEY']

    unless auth_header
      return render json: {message: 'Already logged out'}
    end

    auth_id, auth_token = auth_header.split '&', 2
    if auth_id.nil? or auth_token.nil?
      return render json: {message: 'Already logged out'}
    end

    UserAuth.find_by(id: auth_id, token: auth_token).destroy
    render json: {message: 'Successfully logged out'}
  end

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
    user = process_create_params

    if !user.save
      logger.error "Failed to save user: #{user.errors.messages}"
      return render json: {'errors' => user.errors.messages}, status: 400
    end

    render json: user, status: 201
  rescue JSON::ParserError => e
    logger.error "Failed to parse JSON: #{e.to_s}"
    render json: {'errors' => ['Bad input']}, status: 400
  rescue ArgumentError => e
    logger.error "Failed to save user: #{e}"
    render json: {'errors' => [e.to_s]}, status: 400
  end

  def update
    user = process_update_params

    if user.nil?
      return render json: {'errors' => ['User not found']}, status: 404
    end

    if !user.save
      return render json: {'errors' => user.errors.messages}, status: 400
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
    USER_DATA_FIELDS = %w{person_id username password role}

    def process_create_params
      create_params = get_posted_params(required = USER_DATA_FIELDS)

      person = create_params['person']
      # New users have to be bound to free (not bound to some other user) people.
      raise ArgumentError.new(
        "Person ##{person.id} already attached to user ##{person.user.id}"
      ) unless person.user.nil?  

      password = create_params.delete 'password'
      raise ArgumentError.new "password can't be blank" if password.nil?

      user = User.new create_params unless create_params.empty?
      user.set_password password

      user
    end

    def process_update_params
      user = User.find params[:id]
      return nil if user.nil?

      posted_params = get_posted_params
      password = posted_params.delete 'password'

      user.update posted_params unless posted_params.empty?
      user.set_password password unless password.nil?

      user
    end

    def get_posted_params(required = [])
      required = required.dup
      
      puts request.body.read
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

    def get_person_by_id(person_id)
      if StringUtils::is_empty_string? person_id
        raise ArgumentError.new 'person_id can not be blank'
      elsif !person_id.match? /^\d+$/
        raise ArgumentError.new "person_id ##{person_id} is invalid"
      end

      person = Person.find(person_id.to_i)
      raise ArgumentError.new "Person ##{person_id} not found" if person.nil?
      person
    end

    def get_role_by_name(rolename)
      raise ArgumentError.new "role can't be blank" if StringUtils::is_empty_string? rolename
      role = Role.find_by_rolename rolename
      raise ArgumentError.new "Role, #{rolename}, not found" if role.nil?
      role
    end
end
