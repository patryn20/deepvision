class HostsController < ApplicationController

  before_filter :load_host_and_instant, except: [:add, :do_add]
  before_filter :get_date_range, except: [:add, :do_add, :processes]


  def add
    @add_host = true
    @api_key_original = SecureRandom.uuid().upcase
    api_key_array = @api_key_original.split("-")
    api_key_array[3] = api_key_array[3] + api_key_array[4]
    api_key_array.delete_at 4
    @api_key = api_key_array.join "-"
  end

  def do_add
    if !params[:host].nil?
      host_params = params.require(:host).permit(:name, :active, :interval, :id)
      @r = LovelyRethink.db
      @rr = RethinkDB::RQL.new
      @r.table('hosts').insert(host_params).run(LovelyRethink.connection.raw)
    end
    redirect_to root_path
  end


  def overview
    @longterm_stats = Longterm.get_host_overview_stats(params[:id], session[:range_obj], 0.minutes, @range)
    @overview_series = Graph.get_overview_series(@longterm_stats)

    gon.cpu_series = @overview_series["CPU.total.usage"]
    gon.disk_series = @overview_series["Disk./dev/dm-0.reads"]
    gon.load_series = @overview_series["Load"]
    gon.memory_used_series = @overview_series["Memory.real.used"]
    gon.memory_cache_series = @overview_series["Memory.real.cache"]
    gon.memory_buffers_series = @overview_series["Memory.real.buffers"]
    gon.memory_swap_series = @overview_series["Memory.swap.used"]
    gon.network_in_series = @overview_series["Network.Interface.total.rx_Bps"]
    gon.network_out_series = @overview_series["Network.Interface.total.tx_Bps"]
    gon.disk_reads_series = @overview_series["Disk.total.reads_ps"]
    gon.disk_writes_series = @overview_series["Disk.total.writes_ps"]
  end

  def network
    unless @instant.nil?
      @network_interfaces = Longterm.get_host_network_interfaces params[:id]
      @network_stats = Longterm.get_host_network_stats(params[:id], @network_interfaces, session[:range_obj], 0.minutes, @range)

      @network_series = Graph.get_network_series(@network_stats)
      gon.network_interfaces = @network_interfaces
      gon.network_series = @network_series
    end
  end

  def disks
    unless @instant.nil?
      @disks = Longterm.get_host_disks(params[:id])
      @disk_stats = Longterm.get_host_disk_stats(params[:id], @disks, session[:range_obj], 0.minutes, @range)

      @disk_series = Graph.get_disk_series(@disk_stats)
      gon.dev_disks = @disks
      gon.dev_disk_series = @disk_series
    end
  end

  def processes
    @longterm = Longterm.get_last_entry_by_apikey(params[:id]).first

    @processes = @longterm.select {|key, value| key =~ /^Processes\..*\..*\.count$/ } unless @longterm.nil?

  end

  def system
    @longterm = Longterm.get_last_entry_by_apikey(params[:id]).first
  end

  def settings
    if !params[:host].nil?
      host_params = params.require(:host).permit(:name, :active, :interval)
      @r = LovelyRethink.db
      @rr = RethinkDB::RQL.new
      @r.table('hosts').get(params[:id]).update(host_params).run(LovelyRethink.connection.raw)
      load_host_and_instant
    end
  end

  protected

  def load_longterm_stats(attributes = nil)
    Longterm.get_range_by_apikey(params[:id], session[:range_obj], 0.minutes, attributes).to_a
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
    @range
  end

end
