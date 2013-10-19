class HostsController < ApplicationController

  before_filter :load_host_and_instant
  before_filter :get_date_range


  def overview
    longterm_stats = load_longterm_stats

    @overview_series = Graph.get_overview_series(longterm_stats)

    gon.cpu_series = @overview_series["CPU.total.usage"]
    gon.disk_series = @overview_series["Disk./dev/dm-0.reads"]
    gon.load_series = @overview_series["Load"]
    gon.memory_used_series = @overview_series["Memory.real.used"]
    gon.memory_cache_series = @overview_series["Memory.real.cache"]
    gon.memory_buffers_series = @overview_series["Memory.real.buffers"]
    gon.memory_swap_series = @overview_series["Memory.swap.used"]
    gon.network_in_series = @overview_series["Network.Interface.total.rx_Bps"]
    gon.network_out_series = @overview_series["Network.Interface.total.tx_Bps"]
    gon.disk_reads_series = @overview_series["Disk.reads"]
    gon.disk_writes_series = @overview_series["Disk.writes"]
  end

  def network
    longterm_stats = load_longterm_stats

    @network_series = Graph.get_network_series(longterm_stats)
    @interfaces = @network_series.keys
    gon.network_interfaces = @interfaces
    gon.network_series = @network_series
  end

  def disks
  end

  def processes
  end

  def system
  end

  def settings
  end

  protected

  def load_longterm_stats
    Longterm.get_range_by_apikey(params[:id], session[:range_obj]).to_a
  end

  def load_host_and_instant
    @host = Host.get_by_id(params[:id])
    @instant = Instant.get_by_id(params[:id])
  end

  def get_date_range
    @range_obj = 30.minutes
    @range = 1
    if !params[:r].nil?
      case params[:r].to_i
      when 5
        @range_obj = 1.year
        @range = 5
      when 4
        @range_obj = 1.month
        @range = 4
      when 3
        @range_obj = 7.days
        @range = 3
      when 2
        @range_obj = 24.hours
        @range = 2
      else
        @range_obj = 30.minutes
        1
      end
      redirect_to controller: params[:controller], action: params[:action], id: params[:id]
    elsif !session[:range].nil?
      @range = session[:range]
      @range_obj = session[:range_obj]
    end
    session[:range] = @range
    session[:range_obj] = @range_obj
    Rails.logger.info session[:range]
    @range
  end

end
