#= require ./init

#= require_tree ./templates
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./views
#= require_tree ./routers

#= require view_helpers
#= require fancybox
#= require parsley


# # Initialize Backbone Routers here...
# game_router       = new App.Routers.GameRouter()
# invitation_router = new App.Routers.InvitationRouter()
# account_router    = new App.Routers.AccountRouter()

# on every click, check if it's an href that can be handled by the router
# Doing this to balance a mix of natural links (that backbone doesn't catch) with backbone's routers on the same page
$(document.body).on 'click', 'a', (event) ->
  # clean leading/trailing slashes
  href = $(this).attr('href').replace(/^\/+/, '').replace(/\/+$/, '')

  _(Backbone.history.handlers).chain().pluck('route').each (route) ->
    if route.test(href)
      event.preventDefault()
      Backbone.history.navigate href,
        trigger: true

# Then start the Backbone Routers
unless Backbone.History.started
  Backbone.history.start
    pushState: true
