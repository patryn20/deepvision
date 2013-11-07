require 'rethinkdb'

if Gem::Version.new(RUBY_VERSION.dup) < Gem::Version.new('1.9')
  raise 'Please use Ruby 1.9 or later'
end

module LovelyRethink
  require 'lovely_rethink/autoload'

  extend LovelyRethink::Autoload

  autoload :Connection, :Error

  class << self
    attr_accessor :connection, :uri

    def configure(uri)
      self.uri = uri
    end

    def connect(uri = nil)
      uri = self.uri if uri.nil? && !self.uri.nil?
      self.connection = Connection.new(uri).tap { |c| c.connect }
    end


    def db(db_name = nil)
      self.connect
      db_name ||= self.connection.database_name
      RethinkDB::RQL.new.db(db_name)
    end

  end
end