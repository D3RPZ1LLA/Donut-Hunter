define [ 'backbone' ], ->
  Backbone.View.extend
    events:
      'submit form': 'searchDonutsByLocation'

    searchDonutsByLocation: ( e ) ->
      e.preventDefault( )
      @trigger 'search', @$el.find( 'input' ).val()

    toggleMenu: ->

    toggleResultsView: ->
