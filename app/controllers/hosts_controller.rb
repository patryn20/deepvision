class HostsController < ApplicationController

  before_filter :load_host_and_instant


  def overview
    longterm_stats = Longterm.get_range_by_apikey(params[:id]).to_a
    @cpu_series = Graph.get_cpu_graph_series(longterm_stats)
    @disk_series = Graph.get_disk_graph_series(longterm_stats)
    @load_series = Graph.get_load_graph_series(longterm_stats)
    @memory_series = Graph.get_memory_graph_series(longterm_stats)
    @network_series = Graph.get_network_graph_series(longterm_stats)
  end

  def network
  end

  def disks
  end

  def processes
  end

  def system
  end

  def settings
  end

  def load_host_and_instant
    @host = Host.get_by_id(params[:id])
    @instant = Instant.get_by_id(params[:id])
  end
end
