class DashboardController < ApplicationController

  def index
    @dashboard = true

    @r = LovelyRethink.db    

    @last_longterms = Longterm.get_all_most_recent

  end

end
