updateDatepickerOriginal = $.datepicker._updateDatepicker
$.datepicker._updateDatepicker = ->
  response = updateDatepickerOriginal.apply this, arguments
  this.dpDiv.find('select').chosen()
  response
