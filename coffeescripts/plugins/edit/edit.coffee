# NOTE: There is no spec file for this file because the cut/copy/paste
# functionalities cannot be copied using execCommand. They are prohibited by
# the browser unless the user allows it through his/her preferences. Therefore,
# this needs to be manually tested.
define ["jquery.custom", "core/helpers"], ($, Helpers) ->
  class Edit
    register: (@api) ->
      @$el = $(@api.el)
      @api.on("snapeditor.activate", @activate)
      @api.on("snapeditor.deactivate", @deactivate)

    activate: =>
      @$el.on("keydown", @onkeydown)
      @$el.on("keyup", @onkeyup)

    deactivate: =>
      @$el.off("keydown", @onkeydown)
      @$el.off("keyup", @onkeyup)

    onkeydown: (e) =>
      keys = Helpers.keysOf(e)
      switch keys
        when "ctrl.v"
          @pasteOccurred = true
          # On paste, we want to save the start of the selection. We don't care
          # about the end of the selection yet.
          [startParent, endParent] = @api.getParentElements((el) -> Helpers.isBlock(el))
          # We take the parent's sibling because it is possible that the parent
          # gets deleted along with the paste.
          @pasteStartParent = startParent and startParent.previousSibling
        when "ctr.x"
          @cutOccurred = true

    onkeyup: (e) =>
      keys = Helpers.keysOf(e)
      switch keys
        when "ctrl.v", "v" then @paste()
        when "ctrl.x", "x" then @cut()

    cut: ->
      if @cutOccurred
        @cutOccurred = false
        # Cleanup after the content has been cut.
        @api.clean()

    paste: ->
      if @pasteOccurred
        @pasteOccurred = false
        # If the pasteStartParent is invalid, we just clean from the start of the
        # editor.
        pasteStartParent = @pasteStartParent or @api.el.firstChild
        # In all browsers, after a paste, the selection is collapsed at the end
        # of the paste. We use this to find the parent of the end of the paste.
        # If there is no parent, we clean until the end of the editor.
        pasteEndParent = @api.getParentElement((el) -> Helpers.isBlock(el)) or @api.el.lastChild
        @api.clean(pasteStartParent, pasteEndParent)
        @pasteStartParent = null

  return Edit
