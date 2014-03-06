def without_callbacks(&block)
  TheCatch::Application.NO_CALLBACKS = true
  yield
  TheCatch::Application.NO_CALLBACKS = false
end
