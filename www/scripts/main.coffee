renderMap = (stateStyles) ->
  mapOptions =
    stateSpecificStyles: stateStyles
    stateHoverAnimation: 300
    showLabels: true
    labelWidth: 30
    labelHeight: 30
    labelGap: 10
    labelRadius: 10

  $('#map').usmap mapOptions

renderResults = (results) ->
  debugger

$(document).ready ->
  $.ajax
    type: "POST",
    url: "/map-data",
    success: (dataStr) ->
      data = JSON.parse dataStr
      renderMap data.stateStyles
      renderResults data.results

###
$('#map').usmap({
  <event>State: {
    'MD' : function(event, data) {
      console.log('You interacted with the state of Maryland');
    }
  }
});

trigger .usmap('trigger', state, eventType, event)

Manually trigger off an event and the resulting event handlers.

Parameters
state string
The two letter abbreviation of the state.
eventType string
The type of event to trigger
event Event (optional)
The original triggering event..

      mapOptions =
        stateSpecificStyles: 'VA': fill: 'teal'
        stateStyles: fill: 'blue'
        stateHoverStyles: fill: 'red'
        stateHoverAnimation: 300
        stateSpecificHoverStyles:
          'MD': fill: 'purple'
          'VA': fill: 'orange'
        showLabels: true
        labelWidth: 30
        labelHeight: 30
        labelGap: 10
        labelRadius: 10
        click: clickHandler

clickHandler = (event, data) ->
  $('#map > svg > path').each ->
    $(this).css 'fill', ''
  $('#' + data.name).css 'fill', 'pink'

https://newsignature.github.io/us-map/

###