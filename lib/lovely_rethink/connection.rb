# This is a copy pasta from the NoBrainer ODM. All credit goes to Nicolas Viennot (https://github.com/nviennot/nobrainer)
# @TODO Extend this class so when it is passed to a .run call it returns the raw connection object
module LovelyRethink
  class Connection
    # A connection is bound to a specific database.

    attr_accessor :uri, :host, :port, :database_name

    def initialize(uri)
      Rails.logger.debug 'initializing rethinkdb'
      self.uri = uri
      parse_uri
    end

    def raw
      Rails.logger.debug 'calling rethinkdb raw'
      @raw ||= RethinkDB::Connection.new(:host => host, :port => port, :db => database_name)
    end

    alias_method :connect, :raw
    delegate :reconnect, :close, :run, :to => :raw

    private

    def parse_uri
      Rails.logger.debug 'parsing uri'
      require 'uri'
      parsed_uri = URI.parse(uri)

      if parsed_uri.scheme != 'rethinkdb'
        raise LovelyRethink::Error::Connection,
          "Invalid URI. Expecting something like rethinkdb://host:port/database. Got #{uri}"
      end

      self.host = parsed_uri.host
      self.port = parsed_uri.port || 28015
      self.database_name = parsed_uri.path.gsub(/^\//, '')
    end
  end
end