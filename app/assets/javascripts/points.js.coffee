# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  window.markersArray = []
  # On click, clear markers, place a new one, update coordinates in the form
  if Gmaps.map
    Gmaps.map.callback = ->
      google.maps.event.addListener(Gmaps.map.serviceObject, 'click', (event) ->
        clearOverlays()
        placeMarker(event.latLng)
        get_address(event.latLng)
        updateFormLocation(event.latLng)
        close_infowindows()
      )

      for marker in Gmaps.map.markers
        google.maps.event.addListener(marker.serviceObject, 'click', (event) ->
          clearOverlays()
        )


  # Update form attributes with given coordinates
  updateFormLocation = (latLng) ->
    $('section #point_latitude').val(latLng.lat())
    $('section #point_longitude').val(latLng.lng())
    $('#location_attributes_gmaps_zoom').val(Gmaps.map.serviceObject.getZoom())

  # Add a marker with an open infowindow
  placeMarker = (latLng) ->
    marker = new google.maps.Marker(
      position: latLng
      map: Gmaps.map.serviceObject
      draggable: false
    )
    window.markersArray.push(marker)
    # Set and open infowindow

    infowindow = new google.maps.InfoWindow(
      content: $('#popup-form').html()
    )
    infowindow.open(Gmaps.map.serviceObject, marker)
    validate_form()

  get_address = (latLng) ->
    $.ajax(
      url: '/get_address'
      type: 'POST'
      data: "latLng=" + latLng
    ).success (data) ->
      $('.address h5.address').text(data)
      $('section #point_address').val(data)
      $('.coordinates div.latitude').text(latLng.lat().toFixed(6))
      $('.coordinates div.longitude').text(latLng.lng().toFixed(6))

  close_infowindows = ->
    for marker in Gmaps.map.markers
      marker.infowindow.close()
#====================Edit description process=============================================
$ ->
  $("body").on("click", "p.point_desc[owner='1']", ->
    $(this).removeClass("point_desc").html("<textarea name='description'>" + $(this).text().trim() + "</textarea>")
    $('p.actions a.btn').css display: 'inline-block'
  )

  $("body").on("click", "#cancel", ->
    text = $(this).parents('div#infowindow').children('div.thumbnail').children('p').children('textarea').text()
    $(this).parents('div#infowindow').children('div.thumbnail').children('p').children('textarea').remove()
    $(this).parents('div#infowindow').children('div.thumbnail').children('p').addClass('point_desc').text(text)
    $('p.actions a.btn').hide()
  )

  $("body").on("click", "#save", ->
    text = $(this).parents('div#infowindow').children('div.thumbnail').children('p').children('textarea').val()
    id = $(this).parents('div#infowindow').children('div.thumbnail').children('p').attr('id')
    latitude = $('div#infowindow .latitude').text().trim()
    longitude = $('div#infowindow .longitude').text().trim()
    data = point:
      description: text
      id: id
      latitude: latitude
      longitude: longitude

    $.ajax(
      url: "/points/" + id,
      type: 'PUT',
      data: JSON.stringify(data),
      contentType: "application/json"
      dataType: "script"
    )
  )

  $("body").on("click", "#delete", ->
    id = $(this).parents('div#infowindow').children('div.thumbnail').children('p').attr('id')
    $.ajax(
      url: "/points/" + id,
      type: 'DELETE',
      dataType: "script"
    )
  )

# Removes the overlays from the map
@clearOverlays = ->
  if window.markersArray?
    for i in window.markersArray
      i.setMap(null)
  window.markersArray.length = 0


#Form validations
@validate_form = ->
  $(".map_container #new_point").validate
    rules:
      "user[email]":
        email: true
        required: true

      "point[description]":
        required: true
        minlength: 6

      "user[password_confirmation]":
        minlength: 6
        required: true
        equalTo: "#user_password"

    highlight: (label) ->
      $(label).closest(".control-group").addClass "error"

    success: (label) ->
      label.text("OK!").addClass("valid").closest(".control-group").addClass "success"
