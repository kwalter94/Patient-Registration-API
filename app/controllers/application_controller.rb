class ApplicationController < ActionController::API
  USER_AUTH_TOKEN_VALIDITY = 200     # Time in minutes an authentication token is valid

  before_action :authenticate
  before_action :enforce_privileges  # Enforces user privileges on a given resource (see method add_privileges)

  def authenticate
    auth_header = request.headers['x-api-key']
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

  # Limits access to a particular action to users having a privilige
  # to perform that action (see method bind_privilege).
  def enforce_privileges
    logger.debug "Enforcing privileges on action (#{action_name})"
    privilege_map = self.class.privilege_map

    # If no privilege is attached or no user is logged in then it is assumed
    # that action is accessible to everyone
    unless privilege_map.has_key? action_name.to_s and @logged_in_user
      logger.debug "Aborting privilege enforcement - action not bound to privilege or user not logged in"
      return true
    end

    has_privilege = @logged_in_user.role.privileges.where(
      name: privilege_map[action_name.to_s]
    ).size == 1
    unless has_privilege
      logger.debug "User, #{@logged_in_user}, denied access to action, #{action_name}!"
      render json: {'errors': ['User not allowed to perform action']}, status: 404
      return false
    end

    logger.debug "User, #{@logged_in_user.username}, granted access to action, #{action_name}"
    return true
  end

  protected

  # Attach a privilege to an action or more.
  #
  # Example:
  #
  #   class Foobar < ApplicationController
  #     ...
  #     bind_privilege 'edit_foobar', [:create, :update, :delete]  # Multiple actions
  #     bind_privilege 'view_foobar',  :index   # Single action
  #     ...
  #
  # This will limit access to :create and :index actions to users with roles that
  # have the privileges 'edit_foobar' and 'view_foobar' respectively.
  def self.bind_privilege(privilege_name, actions)
    # logger.debug "Binding actions (#{action}) to privilege (#{privilege_name})"
    privilege_name = privilege_name.to_s
    if actions.respond_to? :each
      actions.each do |action|
        # logger.debug "Binding privilege (#{privilege_name}) to action (#{action})"
        privilege_map[action.to_s] = privilege_name
      end
    else
      # logger.debug "Binding privilege (#{privilege_name}) to action (#{actions})"
      privilege_map[action.to_s] = privilege_name
    end
  end

  private

  # Returns a map of :action => privilege_name
  def self.privilege_map
    @privilege_map = Hash.new unless @privilege_map
    @privilege_map
  end

  # Get user authentication token validity in seconds
  def user_auth_token_validity
    USER_AUTH_TOKEN_VALIDITY * 60   # Convert minutes to seconds
  end
end
