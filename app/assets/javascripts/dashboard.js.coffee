$ ->
  $('div[data-percent]').each ->
    class_array = $(this).attr('class').split(" ")
    bar_color = null
    switch class_array[0]
      when 'host-cpu' then bar_color = "#F1B602"
      when 'host-memory' then bar_color = "#E47C04"
      when 'host-swap' then bar_color = "#DC0030"
      when 'host-load' then bar_color = "#B00057"
      when 'host-network' then bar_color = "#7B3689"
    $(this).easyPieChart
      scaleColor: false
      lineWidth: 15
      size: 200
      barColor: bar_color
      trackColor: '#ACAC9D'
  $('div.widget div.content div.pie-chart:not(.host-cpu)').hide()
  $('#widget-container').isotope
    itemSelector: '.widget'
    layoutMode: 'fitRows'
    getSortData:
      cpu: ( $elem )->
        return fetchSortStat $elem, '.host-cpu'
      memory: ( $elem )->
        return fetchSortStat $elem, '.host-memory'
      swap: ( $elem )->
        return fetchSortStat $elem, '.host-swap'
      load: ( $elem )->
        return fetchSortStat $elem, '.host-load'
      network: ( $elem )->
        return fetchSortStat $elem, '.host-network'
    sortBy: 'cpu'
  $('.navbar .nav [data-stat] a').each ->
    $(this).click ->
      toggleStat $(this).parent('li').attr('data-stat')
      $('.navbar .nav .active').removeClass('active')
      $(this).parent('li').addClass('active')
      return false

fetchSortStat = ( $elem, class_string ) ->
  found_percent = $elem.find(class_string).attr('data-percent')
  if typeof found_percent == "undefined"
    found_percent = 9999
  return found_percent

toggleStat = (stat)->
  # get all the chart elements and hide
  $('div.widget div.content div.pie-chart').hide()
  $('div.widget div.content div.pie-chart.host-' + stat).show()
  $('#widget-container').isotope
    sortBy: stat