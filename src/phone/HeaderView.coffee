define [ 'backbone' ], ->
  Backbone.View.extend
    inititialize: ->
      dat = @
      window.addEventListener( 'message', ( event ) ->
        if event.data == 'showList'
          dat.setDisplay( 'list' )
      , false )

    events:
      'submit form': 'searchDonutsByLocation'
      'click .mobile-controls': 'triggerResultsDisplay'
      'click .menu-icon': 'openMenu'

    searchDonutsByLocation: ( e ) ->
      e.preventDefault( )
      @trigger 'search', @$el.find( 'input' ).val()

    triggerResultsDisplay: ( e ) ->
      $target = $( e.target )
      if !!$target.closest( '.map' )[0]
        @trigger 'setResultsDisplay', 'map'
      else if !!$target.closest( '.list' )[0]
        @trigger 'setResultsDisplay', 'list'

    setDisplay: ( state ) ->
      @menuList ||= @$el.find( '.list' )
      @menuMap ||= @$el.find( '.map' )

      if state == 'list'
        @menuList.addClass 'selected'
        @menuMap.removeClass 'selected'
      else if state == 'map'
        @menuMap.addClass 'selected'
        @menuList.removeClass 'selected'
      else
        @trigger 'error', 'HeaderView.setResultsDisplay can only be called with map & list'

    openMenu: ->
      @trigger 'openMenu'
