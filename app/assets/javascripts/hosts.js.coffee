$ ->
  $("[data-flot-height]").each ->
    $(this).css("height", $(this).attr("data-flot-height"))

  # intiate the CPU series
  $("#cpu-flot").plot [{data: gon.cpu_series}],
    series:
      stacked: true
      lines:
        fill: true
    xaxis:
      mode: "time"
    yaxis:
      min: 0
      tickFormatter: (val, axis) ->
          return val.toFixed(axis.tickDecimals) + "%"

  $("#memory-flot").plot [
      {label: "Used", data: gon.memory_used_series}
      {label: "Cache", data: gon.memory_cache_series}
      {label: "Buffers", data: gon.memory_buffers_series}
      {label: "Swap", data: gon.memory_swap_series}
    ],
    series:
      stacked: true
      lines:
        fill: true
    xaxis:
      mode: "time"
    yaxis:
      min: 0
      tickFormatter: (val, axis) ->
          return val.toFixed(axis.tickDecimals) + " bytes"

  $("#load-flot").plot [{data: gon.load_series}],
    series:
      stacked: true
      lines:
        fill: true
    xaxis:
      mode: "time"
    yaxis:
      min: 0

  $("#network-flot").plot [
      {label: "Out", data: gon.network_out_series}
      {label: "In", data: gon.network_in_series}
    ],
    series:
      stacked: true
      lines:
        fill: true
    xaxis:
      mode: "time"
    yaxis:
      min: 0
      tickFormatter: (val, axis) ->
          return val.toFixed(axis.tickDecimals) + " Kbps"