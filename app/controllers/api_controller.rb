class ApiController < ApplicationController
  skip_before_action :authenticate, only: [:index]

  def index
    # A simple health check for the API.
    begin
      result = ActiveRecord::Base.connection.execute('SELECT VERSION()')
    rescue
      result = nil
    end

    render :json => {'status': result != nil ? 'Running': 'Offline'}
  end
end
