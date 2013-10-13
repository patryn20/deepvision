$ ->
  $("[data-flot-height]").each ->
    $(this).css("height", $(this).attr("data-flot-height"))
  $("[data-flot-series]").each ->
    series = $.parseJSON($(this).attr("data-flot-series"))
    $(this).plot [{data: series}],
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
        