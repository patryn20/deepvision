class HostsController < ApplicationController

  def overview
    longterm_stats = Longterm.get_range_by_apikey params[:id]
    @cpu_series = Graph.get_cpu_graph_series(longterm_stats)
    #@memory_series = Graph.get_memory_graph_series(longterm_stats)
  end
end
