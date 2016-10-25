define [], ->
  {
    searchDonuts: ->
      dat = @
      $.ajax
        url: '/search'
        data:
          ll: @center.lat + ',' + @center.lng
          category_filter: 'donuts'
        dataType: 'json'
        success: ( results ) ->
          dat.locations.reset( )
          dat.locations.add results
        error: ( e ) ->
          console.error e

    geocodeFromAddress: ( geocoder, callback ) ->
      geocoder.geocode { }, ( results, status ) ->
        if status == google.maps.GeocoderStatus.OK
          center = {
            lat: results[0].geometry.location.lat(),
            lng: results[0].geometry.location.lng()
          }
          dat.center = center
          callback( results )
  }
