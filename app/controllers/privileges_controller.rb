class PrivilegesController <  ApplicationController
  def index
    render json: Privilege.all
  end

  def show
    privilege = Privilege.find(params[:id])
    
    if privilege.nil?
      return render json: {'errors' => ['Not found']}, status: 404
    end

    render json: {'privilege': privilege}
  end

  def create
    data = JSON.parse(request.body.read)

    privilege = Privilege.new name: data['name']
    if !privilege.save
      return render json: {'errors' => privilege.errors.full_messages}, status: 400
    end

    render json: {'privilege' => privilege}, status: 201
  rescue JSON::ParserException
    render json: {'errors' => ['Bad input']}, status: 400
  end

  def update
  end

  def destroy
  end
end