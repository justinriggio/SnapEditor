if hasW3CRanges
  require ["core/range/range.w3c", "core/helpers"], (Module, Helpers) ->
    describe "Range.W3C", ->
      Range = $editable = $start = $end = null
      beforeEach ->
        class Range
          doc: document
          win: window
          find: (selector) -> $(@doc).find(selector)
          getParentElements: null
        Helpers.extend(Range, Module.static)
        Helpers.include(Range, Module.instance)
        $editable = addEditableFixture()
        $start = $('<div id="start">start</div>').appendTo($editable)
        $end = $('<div id="end">end</div>').appendTo($editable)

      afterEach ->
        $editable.remove()

      describe "static functions", ->
        describe ".getBlankRange", ->
          it "returns a new range", ->
            spyOn(document, "createRange").andReturn("range")
            range = Range.getBlankRange()
            expect(range).toEqual("range")
            expect(document.createRange).toHaveBeenCalled()

        describe ".getRangeFromSelection", ->
          it "returns the selected range", ->
            # Create a selection.
            expectedRange = Range.getBlankRange()
            expectedRange.selectNodeContents($start[0])
            expectedRange.collapse(true)
            selection = window.getSelection()
            selection.removeAllRanges()
            selection.addRange(expectedRange)

            actualRange = Range.getRangeFromSelection()
            expect(actualRange.collapsed).toBeTruthy()

            # Insert a span and ensure it is in the correct place.
            actualRange.insertNode($("<span/>")[0])
            expect($start.html()).toEqual("<span></span>start")

        describe ".getRangeFromElement", ->
          it "returns a range encompassing the element", ->
            range = Range.getRangeFromElement($start[0])
            expect(range.collapsed).toBeFalsy()
            # Check that the range includes the entire div.
            range.deleteContents()
            expect($editable.html()).toEqual('<div id="end">end</div>')

      describe "instance functions", ->
        selection = null
        beforeEach ->
          selection = window.getSelection()

        describe "#isCollapsed", ->
          it "returns whether the range is collapsed", ->
            range = new Range()
            range.range = Range.getRangeFromElement($start[0])
            expect(range.isCollapsed()).toBeFalsy()
            range.range.collapse(true)
            expect(range.isCollapsed()).toBeTruthy()

        describe "#isImageSelected", ->
          $img = null
          beforeEach ->
            $img = $('<img style="width:100px;height:200px"/>').appendTo($editable)

          it "returns false if text is selected", ->
            range = new Range()
            range.range = Range.getBlankRange()
            range.range.setStart($start[0].childNodes[0], 0)
            range.range.setEnd($start[0].childNodes[0], 5)
            range.select()
            expect(range.isImageSelected()).toBeFalsy()

          it "returns false if text and image is selected", ->
            imgRange = Range.getRangeFromElement($img[0])
            range = new Range()
            range.range = Range.getRangeFromElement($start[0])
            range.range.setEnd(imgRange.endContainer, imgRange.endOffset)
            expect(range.isImageSelected()).toBeFalsy()

          it "returns true if image is selected", ->
            range = new Range()
            range.range = Range.getRangeFromElement($img[0])
            expect(range.isImageSelected()).toBeTruthy()

          it "returns true if image is already selected", ->
            range = new Range()
            range.range = Range.getRangeFromElement($img[0])
            range.select()
            range.range = Range.getRangeFromSelection()
            expect(range.isImageSelected()).toBeTruthy()

        describe "#isStartOfElement", ->
          $text = textnode = null
          beforeEach ->
            $text = $("<div>\n  \t#{Helpers.zeroWidthNoBreakSpace}\n \t\n    text</div>").appendTo($editable)
            textnode = $text[0].childNodes[0]

          it "returns true if range is at the start", ->
            range = new Range()
            range.range = Range.getBlankRange()
            # Place the selection at the beginning of "|text".
            range.range.setStart(textnode, textnode.nodeValue.indexOf('t'))
            range.range.collapse(true)
            expect(range.isStartOfElement($text[0])).toBeTruthy()

          it "returns false if range is not at the start", ->
            range = new Range()
            range.range = Range.getBlankRange()
            # Place the selection in the middle of "te|xt".
            range.range.setStart(textnode, textnode.nodeValue.indexOf('x'))
            range.range.collapse(true)
            expect(range.isStartOfElement($text[0])).toBeFalsy()

          it "returns false if &nbsp; is before", ->
            $text.html("&nbsp;text")
            textnode = $text[0].childNodes[0]

            range = new Range()
            range.range = Range.getBlankRange()
            # Place the selection at the beginning of "|text".
            range.range.setStart(textnode, textnode.nodeValue.indexOf('t'))
            range.range.collapse(true)
            expect(range.isStartOfElement($text[0])).toBeFalsy()

        describe "#isEndOfElement", ->
          $text = textnode = null
          beforeEach ->
            $text = $("<div>text \t  \n\t      #{Helpers.zeroWidthNoBreakSpace}\n\n\t</div>").appendTo($editable)
            textnode = $text[0].childNodes[0]

          it "returns true if range is at the end", ->
            range = new Range()
            range.range = Range.getBlankRange()
            # Place the selection at the end of "text|".
            range.range.setStart(textnode, 4)
            range.range.collapse(true)
            expect(range.isEndOfElement($text[0])).toBeTruthy()

          it "returns false if range is not at the end", ->
            range = new Range()
            range.range = Range.getBlankRange()
            # Place the selection in the middle of "te|xt".
            range.range.setStart(textnode, 2)
            range.range.collapse(true)
            expect(range.isEndOfElement($text[0])).toBeFalsy()

          it "returns false if &nbsp; is after", ->
            $text.html("text&nbsp;")
            textnode = $text[0].childNodes[0]

            range = new Range()
            range.range = Range.getBlankRange()
            # Place the selection at the end of "text|".
            range.range.setStart(textnode, 4)
            range.range.collapse(true)
            expect(range.isEndOfElement($text[0])).toBeFalsy()

        describe "#getImmediateParentElement", ->
          it "returns the immediate parent", ->
            range = new Range()
            range.range = Range.getBlankRange()
            range.range.selectNodeContents($start[0])
            range.range.collapse(true)
            selection.removeAllRanges()
            selection.addRange(range.range)
            expect(range.getImmediateParentElement()).toBe($start[0])

        # TODO: Once it is confirmed that #getStartText is not used, remove this
        # test.
        #describe "#getStartText", ->
          #it "returns all the text from the start of its parent that matches to the range", ->
            #range = new Range()
            #range.getParentElement = ->
            #spyOn(range, "getParentElement").andReturn($start[0])

            ## Set the range at "sta|rt"
            #range.range = Range.getBlankRange()
            #range.range.setStart($start[0].childNodes[0], 3)
            #range.range.collapse(true)

            #text = range.getStartText("match")
            #expect(text).toEqual("sta")
            #expect(range.getParentElement).toHaveBeenCalledWith("match")

        describe "#select", ->
          it "selects the given range even if it has its own", ->
            givenRange = Range.getBlankRange()
            givenRange.selectNodeContents($start[0])
            ownRange = Range.getBlankRange()
            ownRange.selectNodeContents($end[0])

            range = new Range()
            range.range = ownRange
            range.select(givenRange)
            selection.getRangeAt(0).deleteContents()
            expect($start.html()).toEqual("")

          it "selects its own range if none is given", ->
            ownRange = Range.getBlankRange()
            ownRange.selectNodeContents($start[0])

            range = new Range()
            range.range = ownRange
            range.select()
            selection.getRangeAt(0).deleteContents()
            expect($start.html()).toEqual("")

          it "keeps the range when no range is given", ->
            expectedRange = Range.getBlankRange()

            range = new Range()
            range.range = expectedRange
            range.select()
            expect(range.range).toBe(expectedRange)

          it "saves the given range", ->
            expectedRange = Range.getBlankRange()

            range = new Range()
            range.select(expectedRange)
            expect(range.range).toBe(expectedRange)

          it "returns itself", ->
            range = new Range()
            expect(range.select(Range.getBlankRange())).toBe(range)

        describe "#unselect", ->
          it "unselects the current range", ->
            range = new Range()
            range.select(Range.getBlankRange())
            expect(selection.rangeCount).toEqual(1)
            range.unselect()
            expect(selection.rangeCount).toEqual(0)

        describe "#selectEndOfElement", ->
          it "selects the end of the inside of the element when there is content", ->
            range = new Range()
            range.el = $editable[0]
            range.range = Range.getBlankRange()
            range.selectEndOfElement($start[0])

            actualRange = selection.getRangeAt(0)
            actualRange.insertNode($("<span/>")[0])
            expect($start.html()).toEqual("start<span></span>")

          it "selects the end of the inside of the cell when there is content", ->
            $table = $('<table><tbody><tr><td id="td">before</td><td>after</td></tr></tbody></table>').appendTo($editable)
            $td = $("#td")

            range = new Range()
            range.el = $editable[0]
            range.range = Range.getBlankRange()
            range.selectEndOfElement($td[0])

            actualRange = selection.getRangeAt(0)
            actualRange.insertNode($("<span/>")[0])
            expect($td.html()).toEqual("before<span></span>")

          it "selects the end of the inside of the cell when there is no content", ->
            $table = $('<table><tbody><tr><td id="td"></td><td>after</td></tr></tbody></table>').appendTo($editable)
            $td = $("#td")

            range = new Range()
            range.el = $editable[0]
            range.range = Range.getBlankRange()
            range.selectEndOfElement($td[0])

            actualRange = selection.getRangeAt(0)
            actualRange.insertNode($("<span/>")[0])
            expect($td.html()).toEqual("<span></span>")

        describe "#selectAfterElement", ->
          it "puts the selection after the node", ->
            $div = $('<div><span id="span"></span>after</div>').appendTo($editable)
            $span = $("#span")

            range = new Range()
            range.range = Range.getBlankRange()
            range.selectAfterElement($span[0])

            actualRange = window.getSelection().getRangeAt(0)
            actualRange.insertNode($("<b/>")[0])
            expect($div.html()).toEqual('<span id="span"></span><b></b>after')

        describe "#keepRange", ->
          it "calls the given function", ->
            called = false
            fn = -> called = true

            range = new Range()
            range.range = Range.getBlankRange()
            range.range.setStart($start[0].childNodes[0], 2)
            range.range.collapse(true)
            range.select()

            range.keepRange(fn)
            expect(called).toBeTruthy()

          it "inserts the spans in the correct order when the range is collapsed", ->
            html = null
            range = new Range()
            range.range = Range.getBlankRange()
            range.range.setStart($start[0].childNodes[0], 2)
            range.range.collapse(true)
            range.select()
            range.keepRange(-> html = $start.html())
            expect(clean(html)).toEqual("st<span id=range_start></span><span id=range_end></span>art")

          it "keeps the range when collapsed", ->
            range = new Range()
            range.range = Range.getBlankRange()
            range.range.setStart($start[0].childNodes[0], 2)
            range.range.collapse(true)
            range.select()
            range.keepRange(->)
            range.range = Range.getRangeFromSelection()
            range.pasteHTML("<b></b>")
            expect(clean($start.html())).toEqual("st<b></b>art")

          it "keeps the range when not collapsed", ->
            range = new Range()
            spyOn(range, "getParentElements").andReturn([$start[0], $start[0]])
            range.range = Range.getBlankRange()
            range.range.setStart($start[0].childNodes[0], 2)
            range.range.setEnd($start[0].childNodes[0], 4)
            range.select()
            range.delete()
            expect(clean($start.html())).toEqual("stt")

          it "keeps the range when the function changes the range", ->
            fn = ->
              range = new Range()
              range.range = Range.getRangeFromElement($end[0])
              range.select()

            range = new Range()
            spyOn(range, "getParentElements").andReturn([$start[0], $start[0]])
            range.range = Range.getBlankRange()
            range.range.setStart($start[0].childNodes[0], 2)
            range.range.setEnd($start[0].childNodes[0], 4)
            range.select()

            range.keepRange(fn)
            range.delete()
            expect(clean($start.html())).toEqual("stt")

        describe "#pasteNode", ->
          it "pastes the given element node", ->
            range = new Range()
            range.el = $editable
            range.range = Range.getBlankRange()
            range.range.selectNodeContents($start[0])
            range.range.collapse(true)
            range.pasteNode($("<span/>")[0])
            expect($start.html()).toEqual("<span></span>start")

          it "pastes the given text node", ->
            range = new Range()
            range.el = $editable
            range.range = Range.getBlankRange()
            range.range.selectNodeContents($start[0])
            range.range.collapse(true)
            range.pasteNode(document.createTextNode("test"))
            expect($start.html()).toEqual("teststart")

          it "puts the selection after the node", ->
            text = document.createTextNode("test")

            range = new Range()
            spyOn(range, "selectAfterElement")
            range.el = $editable
            range.range = Range.getBlankRange()
            range.range.selectNodeContents($start[0])
            range.range.collapse(true)
            range.pasteNode(text)
            expect(range.selectAfterElement).toHaveBeenCalledWith(text)


        describe "#pasteHTML", ->
          it "inserts the given HTML", ->
            range = new Range()
            range.range = Range.getBlankRange()
            range.range.selectNodeContents($start[0])
            range.range.collapse(true)
            range.pasteHTML("<span><b>bold</b></span><div><ul><li>item</li></ul></div>")
            expect($start.html()).toEqual("<span><b>bold</b></span><div><ul><li>item</li></ul></div>start")

          it "puts the selection after the node", ->
            range = new Range()
            spyOn(range, "selectAfterElement")
            range.range = Range.getBlankRange()
            range.range.selectNodeContents($start[0])
            range.range.collapse(true)
            range.pasteHTML("<span></span>")
            expect(range.selectAfterElement).toHaveBeenCalled()

        describe "#surroundContents", ->
          it "inserts the given HTML", ->
            range = new Range()
            range.el = $editable
            range.range = Range.getBlankRange()
            range.range.selectNodeContents($start[0])
            range.surroundContents($("<span/>")[0])
            expect($start.html()).toEqual("<span>start</span>")

          it "puts the selection after the node", ->
            $span = $("<span/>")

            range = new Range()
            spyOn(range, "selectAfterElement")
            range.el = $editable
            range.range = Range.getBlankRange()
            range.range.selectNodeContents($start[0])
            range.surroundContents($span[0])
            expect(range.selectAfterElement).toHaveBeenCalledWith($span[0])

        describe "#delete", ->
          $table = $tds = $after = range = null
          beforeEach ->
            $table = $("<table><tbody><tr><td>first cell</td><td>second cell</td></tr></tbody></table>").appendTo($editable)
            $tds = $table.find("td")
            $after = $("<div>after</div>").appendTo($editable)
            range = new Range()
            range.el = $editable[0]
            range.range = Range.getBlankRange()
            spyOn(range, "getParentElements")

          it "deletes the contents of the range when not selecting from a table cell", ->
            range.getParentElements.andReturn([$start[0], $start[0]])
            range.range.selectNodeContents($start[0])
            range.delete()
            expect($start.html()).toEqual("")

          it "deletes the contents of the range including the table", ->
            range.getParentElements.andReturn([$start[0], $after[0]])
            range.range.setStart($start[0].childNodes[0], 0)
            range.range.setEnd($after[0].childNodes[0], 5)
            range.delete()
            expect(clean($editable.html())).toEqual("<div id=start></div>")

          it "does nothing when the start of the range starts in a table cell", ->
            html = $editable.html()
            range.getParentElements.andReturn([$tds[0], $after[0]])
            range.range.setStart($tds[0].childNodes[0], 0)
            range.range.setEnd($after[0].childNodes[0], 5)
            range.delete()
            expect(clean($editable.html())).toEqual(clean(html))

          it "does nothing when the end of the range ends in a table cell", ->
            html = $editable.html()
            range.getParentElements.andReturn([$start[0], $tds[0]])
            range.range.setStart($start[0].childNodes[0], 0)
            range.range.setEnd($tds[0].childNodes[0], 5)
            range.delete()
            expect(clean($editable.html())).toEqual(clean(html))

          it "does nothing when the start and end of the range are in different table cells", ->
            html = $editable.html()
            range.getParentElements.andReturn([$tds[0], $tds[1]])
            range.range.setStart($tds[0].childNodes[0], 0)
            range.range.setEnd($tds[1].childNodes[0], 5)
            range.delete()
            expect(clean($editable.html())).toEqual(clean(html))

          it "deletes the contents of the range when it starts and ends in the same table cell", ->
            html = $editable.html()
            range.getParentElements.andReturn([$tds[0], $tds[0]])
            range.range.setStart($tds[0].childNodes[0], 0)
            range.range.setEnd($tds[0].childNodes[0], 5)
            range.delete()
            expect($tds[0].innerHTML).toEqual(" cell")

          it "merges the nodes if the range starts and ends in different blocks", ->
            range.getParentElements.andReturn([$start[0], $after[0]])
            range.range.setStart($start[0].childNodes[0], 4)
            range.range.setEnd($after[0].childNodes[0], 2)
            range.select()
            range.delete()
            expect($editable.find("div").length).toEqual(1)
            expect($editable.find("div").html()).toEqual("starter")

          it "keeps the range", ->
            range.getParentElements.andReturn([$start[0], $end[0]])
            range.range.setStart($start[0].childNodes[0], 4)
            range.range.setEnd($end[0].childNodes[0], 2)
            range.select()
            range.delete()
            range.pasteHTML("<b></b>")
            expect($editable.find("div").html()).toEqual("star<b></b>d")

          it "returns true if something was deleted", ->
            range.getParentElements.andReturn([$start[0], $start[0]])
            range.range.selectNodeContents($start[0])
            expect(range.delete()).toBeTruthy()

          it "returns false if nothing was deleted", ->
            html = $editable.html()
            range.getParentElements.andReturn([$tds[0], $after[0]])
            range.range.setStart($tds[0].childNodes[0], 0)
            range.range.setEnd($after[0].childNodes[0], 5)
            expect(range.delete()).toBeFalsy()
