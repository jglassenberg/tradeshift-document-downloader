window.App.Views.ErrorPopup = Backbone.View.extend
  events: 
    'click .js-close': 'close'

  initialize: (options={}) ->
    html = JST['error_popup'](options)

    $.fancybox html,
      afterClose: =>
        @undelegateEvents()
        options.onClose()

    @$el = $('.fancybox-inner')

  close: ->
    $.fancybox.close()