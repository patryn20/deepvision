class HostsController < ApplicationController

  before_filter :load_host_and_instant


  def overview
    longterm_stats = Longterm.get_range_by_apikey(params[:id]).to_a

    @overview_series = Graph.get_overview_series(longterm_stats)

    @cpu_series = @overview_series["CPU.total.usage"]
    @disk_series = @overview_series["Disk./dev/dm-0.reads"]
    @load_series = @overview_series["Load"]
    @memory_used_series = @overview_series["Memory.real.used"]
    @memory_cache_series = @overview_series["Memory.real.cache"]
    @memory_buffers_series = @overview_series["Memory.real.buffers"]
    @network_series = @overview_series["Network.Interface.total.Bps"]
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
