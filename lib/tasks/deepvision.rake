namespace :deepvision do
  desc "Bootstrap the RethinkDB database and required tables."
  task install: :environment do
    connection = RethinkDB::Connection.new(:host => "localhost", :port => "28015").repl
    @rr = RethinkDB::RQL.new
    @rr.db_create('deepvision_2').run(connection)
    @rr.db('deepvision_2').table_create('longterm').run(connection)
    @rr.db('deepvision_2').table_create('hosts').run(connection)
    @rr.db('deepvision_2').table_create('instant').run(connection)
    @rr.db('deepvision_2').table_create('time_adjustments').run(connection)
    @rr.db('deepvision_2').table('longterm').index_create('apikey').run(connection)
  end

end
