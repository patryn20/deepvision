class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :connect_to_rethinkdb

  protected
  def connect_to_rethinkdb
    LovelyRethink.connect 'rethinkdb://127.0.0.1:28015/deepvision'
  end
end
