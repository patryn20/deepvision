class DashboardController < ApplicationController

  def index
    @dashboard = true

    @r = LovelyRethink.db

    @longterms = @r.table('longterm').count.run

    @last_longterms = Longterm.get_all_most_recent

  end

end
