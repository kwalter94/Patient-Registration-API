class UsersController < ApplicationController
  DEFAULT_ROLENAME = 'clerk'

  def index
  end

  def show
  end

  def create
    data = JSON.parse(request.body.read)
    validate_user_data data

    user = User.new
    user.username = data['username']
    user.set_password data['password']
    user.roles << Role.find_by_rolename(data['role'])
    user.person = Person.new(
      birthdate: data['birthdate'],
      gender: data['gender'],
      person_name: PersonName.new({
        firstname: data['first_name'],
        lastname: data['last_name']
      })
    )

    if !user.save
      return render :json => {'error' => 'Bad input', 'data' => user.errors.full_messages},
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
  end


  def destroy

  end

  def user_params
    # params.require(:user, :person).permit(:name, :password, )
  end

  def validate_user_data(data)
    logger.debug(data)
    %w{username password role first_name last_name birthdate gender}.each do |field|
      raise ArgumentError.new("#{field} required") if is_empty_string?(data[field])
    end
  end

  def is_empty_string?(str)
    logger.debug("Validating #{str}")
    str == nil or str.empty?
  end
end
