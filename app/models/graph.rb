class Graph

  def self.get_cpu_graph_series(longterm_stats)
    series = Array.new

    longterm_stats.each do |longterm|
      series << [ longterm["timestamp"].to_i * 1000, longterm["CPU.total.usage"] ]
    end

    series
  end

  def self.get_load_graph_series(longterm_stats)
    longterm_stats.map {|longterm| [longterm["timestamp"].to_i * 1000, longterm["Load"]]}
  end

end