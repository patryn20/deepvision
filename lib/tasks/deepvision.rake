namespace :deepvision do
  desc "Bootstrap the RethinkDB database and required tables."
  task install: :environment do
    connection = RethinkDB::Connection.new(:host => "localhost", :port => "28015").repl
    @rr = RethinkDB::RQL.new
    @rr.db_create('deepvision').run(connection)
    @rr.db('deepvision').table_create('longterm').run(connection)
    @rr.db('deepvision').table_create('hosts').run(connection)
    @rr.db('deepvision').table_create('instant').run(connection)
    @rr.db('deepvision').table_create('time_adjustments').run(connection)
    @rr.db('deepvision').table('longterm').index_create('apikey').run(connection)
  end

end
