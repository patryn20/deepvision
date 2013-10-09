module HostsHelper

  def flot_series(series)
    flot_series = "["

    i = 0
    series.each do |x, y|
      if i > 0
        flot_series += ", "
      end
      flot_series += "[#{x}, #{y}]"
      i+=1
    end

    flot_series += "]"
    flot_series
  end

end
