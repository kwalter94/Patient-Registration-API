class ApiController < ApplicationController
  def index
    begin
      result = ActiveRecord::Base.connection.execute('SELECT VERSION()')
    rescue
      result = nil
    end

    render :json => {'status': result != nil ? 'Running': 'Offline'}
  end
end
