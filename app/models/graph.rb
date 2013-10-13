class Graph

  def self.get_cpu_graph_series(longterm_stats)
    Graph.get_graph_series(longterm_stats, "CPU.total.usage")
  end

  def self.get_disk_graph_series(longterm_stats)
    Graph.get_graph_series(longterm_stats, "Disk./dev/dm-0.reads")
  end

  def self.get_load_graph_series(longterm_stats)
    Graph.get_graph_series(longterm_stats, "Load")
  end

  def self.get_memory_used_graph_series(longterm_stats)
    Graph.get_graph_series(longterm_stats, "Memory.real.used")
  end

  def self.get_memory_cache_graph_series(longterm_stats)
    Graph.get_graph_series(longterm_stats, "Memory.real.cache")
  end

  def self.get_memory_buffers_graph_series(longterm_stats)
    Graph.get_graph_series(longterm_stats, "Memory.real.buffers")
  end

  def self.get_network_graph_series(longterm_stats)
    Graph.get_graph_series(longterm_stats, "Network.Interface.total.Bps")
  end

  def self.get_overview_series(longterm_stats)
    attributes = ["CPU.total.usage", "Disk./dev/dm-0.reads", "Load", "Memory.real.used", "Memory.real.cache", "Memory.real.buffers", "Memory.swap.used", "Network.Interface.total.rx_Bps", "Network.Interface.total.tx_Bps"]
    #longterm_stats.map {|longterm| [longterm["timestamp"].to_i * 1000, [ attributes.map {|attribute| { attribute => longterm[attribute] } } ]]}

    attributes_hash = Hash[attributes.collect {|attribute| [attribute, []]}]

    longterm_stats.each do |longterm| 
      attributes.each do |attribute|
        attributes_hash[attribute] << [longterm["timestamp"].to_i * 1000, longterm[attribute]]
      end
    end
    return attributes_hash
  end

  def self.get_graph_series(longterm_stats, attribute)
    longterm_stats.map {|longterm| [longterm["timestamp"].to_i * 1000, longterm[attribute]]}
  end

end