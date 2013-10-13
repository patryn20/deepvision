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

  def self.get_memory_graph_series(longterm_stats)
    Graph.get_graph_series(longterm_stats, "Memory.real.used")
  end

  def self.get_network_graph_series(longterm_stats)
    Graph.get_graph_series(longterm_stats, "Network.Interface.total.Bps")
  end

  def self.get_graph_series(longterm_stats, attribute)
    longterm_stats.map {|longterm| [longterm["timestamp"].to_i * 1000, longterm[attribute]]}
  end

end