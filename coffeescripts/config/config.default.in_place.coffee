define [
  "config/config.default"
  "plugins/snap/snap"
  "plugins/outline/outline"
  "plugins/save/save"
], (Defaults, Snap, Outline, Save) ->
  return {
    build: ->
      defaults = Defaults.build()
      defaults.plugins = defaults.plugins.concat([
        "snap"
        "outline"
        "save"
      ])
      defaults.toolbar = defaults.toolbar
      defaults.snap = true
      return defaults
  }
