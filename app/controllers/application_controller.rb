class ApplicationController < ActionController::API
  USER_AUTH_TOKEN_VALIDITY = 200     # Time in minutes an authentication token is valid

  before_action :authenticate

  def authenticate
    auth_header = request.headers['x-api-key'] or request.headers['API_KEY']
    if auth_header.nil?
      logger.debug 'x-api-key header not found'
      render json: {'errors' => ['"x-api-key" header required. Please log in to generate one.']},
             status: 403
      return false
    end

    auth_id, auth_token = auth_header.split '&', 2

    if auth_id.nil? or auth_token.nil?
      logger.error 'Empty x-api-key header'
      render json: {'errors' => ['"x-api-key" header required. Please log in to generate one.']},
             status: 403
      return false
    end

    logger.debug "Authenticating token ##{auth_id}"
    auth = UserAuth.find_by(id: auth_id, token: auth_token)

    if auth and auth.user
      auth_expiry_time = auth.created_at + user_auth_token_validity()
      if auth_expiry_time > Time.now
        logger.debug "Successfully authenticated user ##{auth.user.id}"
        @logged_in_user = auth.user
        return true
      end

      logger.debug "Auth token ##{auth_token} expired"
      auth.destroy
      # Falling through...
    end

    logger.debug "Failed to authenticate token ##{auth_id}"
    render json: {'errors' => ['Invalid or expired "x-api-key". Please login to generate one.']},
           status: 403
    false
  end

  protected

    # Get user authentication token validity in seconds
    def user_auth_token_validity
      USER_AUTH_TOKEN_VALIDITY * 60   # Convert minutes to seconds
    end
end
