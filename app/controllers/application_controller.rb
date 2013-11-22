class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  after_filter :close_rethinkdb_connection

  def close_rethinkdb_connection
    LovelyRethink.connection.close
  end

end
