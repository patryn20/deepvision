$ ->
  $('div[data-percent]').easyPieChart
    scaleColor: false
    lineWidth: 15
    size: 200
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