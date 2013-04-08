define ["jquery.custom", "core/contextmenu/contextmenu.builder", "core/data_action_handler", "core/helpers"], ($, Builder, DataActionHandler, Helpers) ->
  class ContextMenu
    # Arguments:
    # api - editor API object
    # templates - element that contains #snapeditor_contextmenu_template
    # config - { "<context selector>": [<button object>, ...]
    constructor: (@api, templates, @config) ->
      @$el = $(@api.el)
      @$templates = $(templates)
      @setupTemplates()
      @contexts = []
      @contexts.push(context) for context, button of @config
      @setupMenu()
      @api.on("snapeditor.activate", @activate)
      @api.on("snapeditor.deactivate", @deactivate)

    setupTemplates: ->
      @$template = @$templates.find("#snapeditor_contextmenu_template")
      if @$template.length == 0
        throw "Missing template. Make sure there is an element with id snapeditor_contextmenu_template."

    setupMenu: ->
      @id = "snapeditor_contextmenu_#{Math.floor(Math.random() * 99999)}"
      # The class snapeditor_ignore_deactivate ensures the editor does not
      # deactivate when the contextmenu is clicked on.
      @$menu = $("<div/>").
        attr("id", @id).
        addClass("snapeditor_contextmenu_container").
        addClass("snapeditor_ignore_deactivate").
        css(position: "absolute", zIndex: 300).
        hide().
        appendTo("body").
        on("contextmenu", (e) -> e.preventDefault())
      @dataActionHandler = new DataActionHandler(@$menu, @api)
      #@dataActionHandler.on("click", @hide)
      @builder = new Builder(@$template, @config)

    activate: =>
      @$el.on("contextmenu", @show)

    deactivate: =>
      @$el.off("contextmenu", @show)
      @hide()

    show: (e) =>
      @buildMenu(e.target)
      if @$menu.children().length > 0
        e.preventDefault()
        coords = Helpers.transformCoordinatesRelativeToOuter(
          x: e.pageX
          y: e.pageY
          e.target
        )
        @$menu.css(@getStyles(coords.x, coords.y)).show()
        @api.on("snapeditor.document_mousedown": @tryHide, "snapeditor.document_keydown": @hide)

    hide: =>
      @$menu.hide() if @$menu
      @api.off("snapeditor.document_mousedown": @tryHide, "snapeditor.document_keydown": @hide)

    # Hide if the target is not the contextmenu.
    tryHide: (e) =>
      $target = $(e.target)
      @hide() if $target.closest("##{@id}").length == 0

    # Build the menu based on the current context.
    buildMenu: (target) ->
      $target = $(target)
      matchedContexts = $target.contexts(@contexts, @$el)
      contexts = ["default"]
      contexts.push(context) for context, el of matchedContexts
      @$menu.empty()
      @$menu.append(@builder.build(contexts))

    getMenuCoords: ->
      # Uses measure in case the menu is not visible.
      @$menu.measure(-> @getCoordinates())

    # Get the styles needed to display the contextmenu where the cursor is but
    # always stay within the viewable window.
    getStyles: (x, y) ->
      styles = top: y, left: x
      windowScroll = $(window).getScroll()
      windowSize = $(window).getSize()
      windowBottom = windowScroll.y + windowSize.y
      windowRight = windowScroll.x + windowSize.x
      menuCoords = @getMenuCoords()
      menuHeight = menuCoords.height
      menuWidth = menuCoords.width
      # If the menu doesn't fit vertically.
      if styles.top + menuHeight > windowBottom
        styles.top = windowBottom - menuHeight
      # If the menu doesn't fit horizontally.
      if styles.left + menuWidth > windowRight
        styles.left = windowRight - menuWidth
      styles

  return ContextMenu
