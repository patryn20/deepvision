class DashboardController < ApplicationController

  def index
    @dashboard = true

    @r = LovelyRethink.db

    @longterms = @r.table('longterm').count.run(LovelyRethink.connection.raw)

    @last_longterms = Longterm.get_all_most_recent

  end

end
