class ApplicationController < ActionController::API
  before_action :authenticate

  def authenticate
    user_id = session[:user]

    logger.debug "Authenticating user ##{user_id}"
    @logged_in_user = user_id.nil? ? nil : User.find(user_id)

    if @logged_in_user
      logger.debug "Successfully authenticated user ##{user_id}"
      true
    else
      logger.debug "Failed to authenticate user ##{user_id}"
      render json: {'errors' => ['Login required']}, status: 403
      false
    end
  end
end
