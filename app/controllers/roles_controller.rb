class RolesController < ApplicationController
  def index
    render json: Role.all
  end

  def show
    role = Role.find(params[:id])
    
    if role.nil?
      return render json: {'errors' => ['Not found']}
    end

    render json: role
  end

  def create
    data = validate_role_data JSON.parse(request.body.read)
    role = Role.new(rolename: data['rolename'], privileges: data['privileges'])
 
    if !role.save
      return render json: {'errors' => role.errors.full_messages}, status: 400
    end

    render json: role, status: 201
  rescue JSON::ParserError => e
    logger.error("Failed to parse JSON input: #{e}")
    render json: {'errors' => ['Bad input']}, status: 400
  rescue ArgumentError => e
    render json: {'errors' => e.to_s}
  end

  def update
    role = Role.find(params[:id])

    if role.nil?
      return render json: {'errors' => ['Not found']}, status: 404
    end

    data = JSON.parse request.body.read
    role.update validate_role_data(data)

    if !role.save
      return render json: {'errors' => role.errors.full_messages}, status: 400
    end

    render json: role, status: 204
  end

  def destroy
    role = Role.find(params[:id])

    if role.nil?
      return render json: {'errors' => ['Not found']}, status: 404
    end
    
    unless role.destroy
      return render json: {'errors' => role.errors.full_messages}, status: 400
    end

    render json: role, status: 204
  rescue JSON::ParserError => e
    render json: {'errors' => 'Bad input'}, status: 400
  end

  private
    def validate_role_data(data)
      validated = {}
     
      name = data['name']
      raise ArgumentError.new 'name is required' if name.nil?
      validated['rolename'] = name

      privileges = data['privileges'] 
      raise ArgumentError.new "List of 'privileges' is required" if !privileges.is_a? Array
      validated['privileges'] = privileges.map do |p|
        privilege = Privilege.find_by_name(p)
        raise ArgumentError.new "Unknown privilege: #{p}" if privilege.nil?
        privilege
      end

      logger.debug("Validated: #{validated}")

      validated
    end
end