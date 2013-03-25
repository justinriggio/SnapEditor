require ["jquery.custom", "core/helpers", "core/toolbar/toolbar.menu"], ($, Helpers, Menu) ->
  describe "Toolbar.Menu", ->
    menu = null
    beforeEach ->
      spyOn(Menu.prototype, "setup").andCallFake(-> @$menu = $("<div/>"))
      menu = new Menu({}, $("<div/>"), [])

    describe "#getDropDownStyles", ->
      beforeEach ->
        spyOn(menu.$relEl, "getCoordinates").andReturn(
          top: 100
          bottom: 200
          left: 300
          right: 350
        )
        spyOn(Helpers, "getWindowBoundary").andReturn(
          top: 0
          bottom: 250
          left: 0
          right: 400
        )
        spyOn(menu.$menu, "getSize")

      describe "below", ->
        it "fits", ->
          menu.$menu.getSize.andReturn(x: 5, y: 5)
          expect(menu.getDropDownStyles()).toEqual(top: 200, left: 300)

        it "doesn't fit to the right", ->
          menu.$menu.getSize.andReturn(x: 200, y: 5)
          expect(menu.getDropDownStyles()).toEqual(top: 200, left: 200)

      describe "above", ->
        it "fits", ->
          menu.$menu.getSize.andReturn(x: 5, y: 75)
          expect(menu.getDropDownStyles()).toEqual(top: 25, left: 300)

        it "doesn't fit to the right", ->
          menu.$menu.getSize.andReturn(x: 200, y: 75)
          expect(menu.getDropDownStyles()).toEqual(top: 25, left: 200)

      describe "side", ->
        it "fits", ->
          menu.$menu.getSize.andReturn(x: 5, y: 100)
          expect(menu.getDropDownStyles()).toEqual(top: 0, left: 300)

        it "doesn't fit to the right", ->
          menu.$menu.getSize.andReturn(x: 200, y: 150)
          expect(menu.getDropDownStyles()).toEqual(top: 0, left: 100)
