_ = require 'ep_etherpad-lite/static/js/underscore'

if not (typeof require is 'undefined')
  Ace2Common = require 'ep_etherpad-lite/static/js/ace2_common' if typeof Ace2Common is 'undefined'
  if typeof Changeset is 'undefined' then Changeset = require 'ep_etherpad-lite/static/js/Changeset'

exports.aceInitInnerdocbodyHead = (hook_name, args, cb) ->
  args.iframeHTML.push '<link rel="stylesheet" type="text/css" href="/static/plugins/ep_tables/static/css/dataTables.css"/>'

exports.postAceInit = (hook, context) ->
  $.createTableMenu = (init) ->
    showTblPropPanel = ->
      if not $.tblPropDialog
        $.tblPropDialog = new YAHOO.widget.Dialog 'yui-tbl-prop-panel', {
          width: '600px'
          height: '450px'
          close: true
          visible: false
          zindex: 1001
          constraintoviewport: true
        }
        $.tblPropDialog.setBody $.getTblPropertiesHTML!
        $.tblPropDialog.render!
        $.alignMenu $.tblPropDialog, @id
        initTableProperties!
      $.tblPropDialog.show!
    createColorPicker = ->
      createOColorPicker = ->
        $.oColorPicker = new YAHOO.widget.ColorPicker 'color-picker-menu', {
          showhsvcontrols: false
          showrgbcontrols: false
          showwebsafe: false
          showhexsummary: false
          showhexcontrols: true
          images: {
            PICKER_THUMB: 'http://yui.yahooapis.com/2.9.0/build/colorpicker/assets/picker_thumb.png'
            HUE_THUMB: 'http://yui.yahooapis.com/2.9.0/build/colorpicker/assets/hue_thumb.png'
          }
        }
        $.oColorPicker.on 'rgbChange', colorPickerButtonClick
        $.colorPickerAligned = true
      handleColorPickerSubmit = -> colorPickerButtonClick $.oColorPicker.get 'hex'
      handleDialogCancel = -> @cancel!
      $.oColorPickerDialog = new YAHOO.widget.Dialog 'yui-picker-panel', {
        width: '500px'
        close: true
        visible: false
        zindex: 1002
        constraintoviewport: true
        buttons: [{
          text: 'Exit'
          handler: @handleDialogCancel
        }]
      }
      $.oColorPickerDialog.renderEvent.subscribe (-> createOColorPicker! if not $.oColorPicker)
      $.oColorPickerDialog.render!
      $.oColorPickerDialog.show!
    colorPickerButtonClick = (sColor) ->
      if typeof sColor is 'string' and sColor? and (sColor.indexOf '#') is -1
        sColor = '#' + sColor
      else
        if typeof sColor is 'object' then sColor = if not (@get 'hex')? then @get 'value' else '#' + @get 'hex'
      selParams = {
        borderWidth: null
        tblPropertyChange: true
      }
      switch $.tblfocusedProperty
      case 'tbl_border_color'
        selParams.tblBorderColor = true
        selParams.attrName = 'borderColor'
        $.borderColorPickerButton.set 'value', sColor
        ($ '#current-color').css 'backgroundColor', sColor
        ($ '#current-color').innerHTML = 'Current color is ' + sColor
      case 'tbl_cell_bg_color'
        selParams.tblCellBgColor = true
        selParams.attrName = 'bgColor'
        $.cellBgColorPickerButton.set 'value', sColor
        ($ '#current-cell-bg-color').css 'backgroundColor', sColor
        ($ '#current-cell-bg-color').innerHTML = 'Current color is ' + sColor
      case 'tbl_even_row_bg_color'
        selParams.tblEvenRowBgColor = true
        selParams.attrName = 'evenBgColor'
        $.evenRowBgColorPickerButton.set 'value', sColor
        ($ '#even-row-bg-color').css 'backgroundColor', sColor
        ($ '#even-row-bg-color').innerHTML = 'Current color is ' + sColor
      case 'tbl_odd_row_bg_color'
        selParams.tblOddRowBgColor = true
        selParams.attrName = 'oddBgColor'
        $.oddRowBgColorPickerButton.set 'value', sColor
        ($ '#odd-row-bg-color').css 'backgroundColor', sColor
        ($ '#odd-row-bg-color').innerHTML = 'Current color is ' + sColor
      case 'tbl_single_row_bg_color'
        selParams.tblSingleRowBgColor = true
        selParams.attrName = 'bgColor'
        $.singleRowBgColorPickerButton.set 'value', sColor
        ($ '#single-row-bg-color').css 'backgroundColor', sColor
        ($ '#single-row-bg-color').innerHTML = 'Current color is ' + sColor
      case 'tbl_single_col_bg_color'
        selParams.tblSingleColBgColor = true
        selParams.attrName = 'bgColor'
        $.singleColBgColorPickerButton.set 'value', sColor
        ($ '#single-col-bg-color').css 'backgroundColor', sColor
        ($ '#single-col-bg-color').innerHTML = 'Current color is ' + sColor
      selParams.attrValue = sColor
      context.ace.callWithAce ((ace) -> ace.ace_doDatatableOptions selParams), 'tblOptions', true
    top.templatesMenu.hide! if not (typeof top.templatesMenu is 'undefined')
    if $.tblContextMenu
      $.alignMenu $.tblContextMenu, 'tbl-menu'
      $.tblContextMenu.show!
      return 
    $.handleTableBorder = (selectValue) ->
      selParams = {
        tblBorderWidth: true
        attrName: 'borderWidth'
        attrValue: selectValue
        tblPropertyChange: true
      }
      context.ace.callWithAce ((ace) -> ace.ace_doDatatableOptions selParams), 'tblOptions', true
    $.getTblPropertiesHTML = ->
      '<span id=\'table_properties\'><span class=\'tbl-prop-menu-header\'></span><br><span id=\'tbl-prop-menu\'class=\'tbl-prop-menu\'>' + '<table class=\'left-tbl-props tbl-inline-block\'>' + '<tr><td class=\'tbl-prop-label-td\'><span class=\'tbl-prop-label\' style=\'padding-top: 8px;\'>Table border</span></td></tr>' + '<tr><td><span class=\'tbl-inline-block\' id=\'tbl_border_color\'> </span><span id=\'tbl_border_width\'class=\'tbl-inline-block tbl_border_width\'></span></td></tr>' + '<tr><td class=\'tbl-prop-label-td\'><span class=\'tbl-prop-label\'>Cell background color</span></td></tr><tr><td><span id=\'tbl_cell_bg_color\'></td></tr><tr><td></span></td></tr>' + '<tr><td class=\'tbl-prop-label-td\'><span class=\'tbl-prop-label\'>Even/Odd Row background color</span></td></tr>' + '\t<tr><td><span class=\'tbl-inline-block\' id=\'tbl_even_row_bg_color\'>Even   </span><span id=\'tbl_odd_row_bg_color\' class=\'tbl-inline-block\'>Odd</span></td></tr>' + '<tr><td class=\'tbl-prop-label-td\'><span class=\'tbl-prop-label\'>Single Row/Col background color</span></td></tr>' + '\t<tr><td><span class=\'tbl-inline-block\' id=\'tbl_single_row_bg_color\'>Single Row   </span><span id=\'tbl_single_col_bg_color\' class=\'tbl-inline-block\'>Single Col</span></td></tr>' + '<tr><td class=\'tbl-prop-label-td\'><span class=\'tbl-prop-label\'>Row/Col alignment</span></td></tr>' + '\t<tr><td><span class=\'tbl-inline-block\' id=\'tbl_row_v_align\'>Row align </span><span id=\'tbl_col_v_align\' class=\'tbl-inline-block\'>Col align</span></td></tr>' + '</table>' + '\t<span class=\' tbl-inline-block\'>' + '\t\t<span class=\'tbl-prop-label\' style=\'padding-top: 8px;\'>' + 'Dimensions(Inches) ' + '\t\t</span>  <span id=\'text_input_message\'></span>' + '\t\t<table class=\'tbl-prop-dim\'>' + '\t\t\t<tbody>' + '\t\t\t\t<tr>' + '\t\t\t\t\t<td>\t\t\t\t\t\t\t' + '\t\t\t\t\t\t<span class=\'tbl-prop-dim-label tbl-inline-block\'>' + '\t\t\t\t\t\t\t<label  >Table width</label>' + '\t\t\t\t\t\t</span>' + '\t\t\t\t\t</td>' + '\t\t\t\t\t<td class=\'td-spacer\'></td>' + '\t\t\t\t\t<td>' + '\t\t\t\t\t\t<span class=\' tbl-inline-block\'>' + '\t\t\t\t\t\t\t<input id=\'tbl_width\' type=\'text\' size=\'4\' class=\'text-input\' >' + '\t\t\t\t\t\t</span>' + '\t\t\t\t\t</td>' + '\t\t\t\t</tr>' + '\t\t\t\t<tr>' + '\t\t\t\t\t<td>\t\t\t\t\t\t\t' + '\t\t\t\t\t\t<span class=\'tbl-prop-dim-label tbl-inline-block\'>' + '\t\t\t\t\t\t\t<label  >Table height</label>' + '\t\t\t\t\t\t</span>' + '\t\t\t\t\t</td>' + '\t\t\t\t\t<td class=\'td-spacer\'></td>' + '\t\t\t\t\t<td>' + '\t\t\t\t\t\t<span class=\' tbl-inline-block\'>' + '\t\t\t\t\t\t\t<input id=\'tbl_height\' type=\'text\' size=\'4\' class=\'text-input\' >' + '\t\t\t\t\t\t</span>' + '\t\t\t\t\t</td>' + '\t\t\t\t</tr>' + '\t\t\t\t<tr>' + '\t\t\t\t\t<td>\t\t\t\t\t\t\t' + '\t\t\t\t\t\t<span class=\'tbl-prop-dim-label tbl-inline-block\'>' + '\t\t\t\t\t\t\t<label  >Column width</label>' + '\t\t\t\t\t\t</span>' + '\t\t\t\t\t</td>' + '\t\t\t\t\t<td class=\'td-spacer\'></td>' + '\t\t\t\t\t<td>' + '\t\t\t\t\t\t<span class=\' tbl-inline-block\'>' + '\t\t\t\t\t\t\t<input id=\'tbl_col_width\' type=\'text\' size=\'4\' class=\'text-input\' >' + '\t\t\t\t\t\t</span>' + '\t\t\t\t\t</td>' + '\t\t\t\t</tr>' + '\t\t\t\t<tr>' + '\t\t\t\t\t<td>\t' + '\t\t\t\t\t\t<span class=\'tbl-prop-dim-label tbl-inline-block\'>' + '\t\t\t\t\t\t\t<label  >Minimum row height</label>' + '\t\t\t\t\t\t</span>' + '\t\t\t\t\t</td>' + '\t\t\t\t\t<td class=\'td-spacer\'></td>' + '\t\t\t\t\t<td>' + '\t\t\t\t\t\t<span class=\' tbl-inline-block\'>' + '\t\t\t\t\t\t\t<input id=\'tbl_row_height\' type=\'text\' size=\'4\' class=\'text-input\' >' + '\t\t\t\t\t\t</span>' + '\t\t\t\t\t</td>' + '\t\t\t\t</tr>' + '\t\t\t\t<tr>' + '\t\t\t\t\t<td>' + '\t\t\t\t\t\t<span class=\'tbl-prop-dim-label tbl-inline-block\'>' + '\t\t\t\t\t\t\t<label >Cell padding</label>' + '\t\t\t\t\t\t</span>' + '\t\t\t\t\t</td>' + '\t\t\t\t\t<td class=\'td-spacer\'></td>' + '\t\t\t\t\t<td>' + '\t\t\t\t\t\t<span class=\' tbl-inline-block\'>' + '\t\t\t\t\t\t\t<input id=\'tbl_cell_padding\' type=\'text\' size=\'4\' class=\'text-input\'>' + '\t\t\t\t\t\t</span>' + '\t\t\t\t\t</td>' + '\t\t\t\t</tr>' + '\t\t\t</tbody>' + '\t\t</table>' + '\t\t<br> ' + '\t\t<span class=\'tbl-prop-label\' style=\'padding-top: 8px;\'>' + '\t\t\tFonts ' + '\t\t</span>' + '\t\t<table class=\'tbl-prop-dim\'>' + '\t\t\t\t<tr>' + '\t\t\t\t\t<td>' + '\t\t\t\t\t\t<span class=\'tbl-prop-dim-label tbl-inline-block\'>' + '\t\t\t\t\t\t\t<label >Cell font size</label>' + '\t\t\t\t\t\t</span>' + '\t\t\t\t\t</td>' + '\t\t\t\t\t<td class=\'select-font-spacer\'></td>' + '\t\t\t\t\t<td>' + '\t\t\t\t\t\t<span class=\' tbl-inline-block\'>' + '\t\t\t\t\t\t\t<input id=\'tbl_cell_font_size\' type=\'text\' size=\'4\' class=\'text-input\'>' + '\t\t\t\t\t\t</span>' + '\t\t\t\t\t</td>' + '\t\t\t\t</tr>' + '\t\t\t</tbody>' + '\t\t</table>' + '\t</span>' + '</span>' + '</span>' + '<span id=\'img_properties\'>' + '<span class=\'tbl-prop-menu-header\'></span><span id=\'img-prop-menu\'class=\'tbl-prop-menu\'>' + '<table class=\'left-tbl-props tbl-inline-block\'>' + '\t\t<caption><span class=\'tbl-prop-label\' style=\'padding-top: 8px;\'>' + '\t\t\tDimensions(Intches) ' + '\t\t</span></caption>' + '\t\t\t<tbody>' + '\t\t\t\t<tr>' + '\t\t\t\t\t<td>\t\t\t\t\t\t\t' + '\t\t\t\t\t\t<span class=\'tbl-prop-dim-label tbl-inline-block\'>' + '\t\t\t\t\t\t\t<label  >Image width</label>' + '\t\t\t\t\t\t</span>' + '\t\t\t\t\t</td>' + '\t\t\t\t\t<td class=\'td-spacer\'></td>' + '\t\t\t\t\t<td>' + '\t\t\t\t\t\t<span class=\' tbl-inline-block\'>' + '\t\t\t\t\t\t\t<input id=\'img_width\' type=\'text\' size=\'4\' class=\'text-input\' >' + '\t\t\t\t\t\t</span>' + '\t\t\t\t\t</td>' + '\t\t\t\t</tr>' + '\t\t\t\t<tr>' + '\t\t\t\t\t<td>\t\t\t\t\t\t\t' + '\t\t\t\t\t\t<span class=\'tbl-prop-dim-label tbl-inline-block\'>' + '\t\t\t\t\t\t\t<label  >Image height</label>' + '\t\t\t\t\t\t</span>' + '\t\t\t\t\t</td>' + '\t\t\t\t\t<td class=\'td-spacer\'></td>' + '\t\t\t\t\t<td>' + '\t\t\t\t\t\t<span class=\' tbl-inline-block\'>' + '\t\t\t\t\t\t\t<input id=\'img_height\' type=\'text\' size=\'4\' class=\'text-input\' >' + '\t\t\t\t\t\t</span>' + '\t\t\t\t\t</td>' + '\t\t\t\t</tr>' + '</table>' + '</span>' + '</span>'
    if typeof $.tblContextMenu is 'undefined'
      initTableProperties = ->
        colVAligns = [
          'Left'
          'Center'
          'Right'
        ]
        $.colVAlignsMenu = new YAHOO.widget.ContextMenu 'tbl_col_v_align_menu', {
          iframe: true
          zindex: 1003
          shadow: false
          position: 'dynamic'
          keepopen: true
          clicktohide: true
        }
        $.colVAlignsMenu.addItems colVAligns
        $.colVAlignsMenu.render document.body
        $.colVAlignsMenu.subscribe 'click', (p_sType, p_aArgs) ->
          oEvent = p_aArgs.0
          oMenuItem = p_aArgs.1
          if oMenuItem
            align = oMenuItem.cfg.getProperty 'text'
            selParams = {
              tblColVAlign: true
              attrName: 'colVAlign'
              attrValue: align
              tblPropertyChange: true
            }
            $.colVAlignsMenuButton.set 'value', selParams.attrValue
            ($ '#current-col-v-alignment').html align
            context.ace.callWithAce ((ace) -> ace.ace_doDatatableOptions selParams), 'tblOptions', true
        $.colVAlignsMenuButton = new YAHOO.widget.Button {
          disabled: false
          type: 'split'
          label: '<em id="current-col-v-alignment">Left</em>'
          container: 'tbl_col_v_align'
        }
        ($ '#tbl_col_v_align').click (->
          aligned = false
          $.alignMenu $.colVAlignsMenu, 'tbl_col_v_align' if not aligned
          if $.borderWidthsMenu then $.borderWidthsMenu.hide!
          if $.oColorPickerDialog then $.oColorPickerDialog.hide!
          $.colVAlignsMenu.show!
          vAlignValue = $.colVAlignsMenuButton.get 'value'
          if vAlignValue
            selParams = {
              tblColVAlign: true
              attrName: 'colVAlign'
              attrValue: vAlignValue
              tblPropertyChange: true
            }
            context.ace.callWithAce ((ace) -> ace.ace_doDatatableOptions selParams), 'tblOptions', true)
        rowVAligns = [
          'Top'
          'Center'
          'Bottom'
        ]
        $.rowVAlignsMenu = new YAHOO.widget.ContextMenu 'tbl_row_v_align_menu', {
          iframe: true
          zindex: 1003
          shadow: false
          position: 'dynamic'
          keepopen: true
          clicktohide: true
        }
        $.rowVAlignsMenu.addItems rowVAligns
        $.rowVAlignsMenu.render document.body
        $.rowVAlignsMenu.subscribe 'click', (p_sType, p_aArgs) ->
          oEvent = p_aArgs.0
          oMenuItem = p_aArgs.1
          if oMenuItem
            align = oMenuItem.cfg.getProperty 'text'
            selParams = {
              tblRowVAlign: true
              attrName: 'rowVAlign'
              attrValue: align
              tblPropertyChange: true
            }
            $.rowVAlignsMenuButton.set 'value', selParams.attrValue
            ($ '#current-v-alignment').html align
            context.ace.callWithAce ((ace) -> ace.ace_doDatatableOptions selParams), 'tblOptions', true
        $.rowVAlignsMenuButton = new YAHOO.widget.Button {
          disabled: false
          type: 'split'
          label: '<em id="current-v-alignment">Top</em>'
          container: 'tbl_row_v_align'
        }
        ($ '#tbl_row_v_align').click (->
          aligned = false
          $.alignMenu $.rowVAlignsMenu, 'tbl_row_v_align' if not aligned
          if $.borderWidthsMenu then $.borderWidthsMenu.hide!
          if $.oColorPickerDialog then $.oColorPickerDialog.hide!
          $.rowVAlignsMenu.show!
          vAlignValue = $.rowVAlignsMenuButton.get 'value'
          if vAlignValue
            selParams = {
              tblRowVAlign: true
              attrName: 'rowVAlign'
              attrValue: vAlignValue
              tblPropertyChange: true
            }
            context.ace.callWithAce ((ace) -> ace.ace_doDatatableOptions selParams), 'tblOptions', true)
        borderWidths = [
          '0px'
          '1px'
          '2px'
          '3px'
          '4px'
          '5px'
          '6px'
          '7px'
          '8px'
        ]
        $.borderWidthsMenu = new YAHOO.widget.ContextMenu 'tbl_border_width_menu', {
          iframe: true
          zindex: 1003
          shadow: false
          position: 'dynamic'
          keepopen: true
          clicktohide: true
        }
        $.borderWidthsMenu.addItems borderWidths
        $.borderWidthsMenu.render document.body
        $.borderWidthsMenu.subscribe 'click', (p_sType, p_aArgs) ->
          oEvent = p_aArgs.0
          oMenuItem = p_aArgs.1
          if oMenuItem
            borderReq = oMenuItem.cfg.getProperty 'text'
            selParams = {
              tblBorderWidth: true
              attrName: 'borderWidth'
              attrValue: borderReq.substring 0, borderReq.indexOf 'px'
              tblPropertyChange: true
            }
            $.borderWidthPickerButton.set 'value', selParams.attrValue
            ($ '#current-width').html borderReq
            context.ace.callWithAce ((ace) -> ace.ace_doDatatableOptions selParams), 'tblOptions', true
        $.borderWidthPickerButton = new YAHOO.widget.Button {
          disabled: false
          type: 'split'
          label: '<em id="current-width">1px</em>'
          container: 'tbl_border_width'
        }
        ($ '#tbl_border_width').click (->
          aligned = false
          $.alignMenu $.borderWidthsMenu, 'tbl_border_width' if not aligned
          if $.oColorPickerDialog then $.oColorPickerDialog.hide!
          if $.rowVAlignsMenu then $.rowVAlignsMenu.hide!
          $.borderWidthsMenu.show!
          widthValue = $.borderWidthPickerButton.get 'value'
          if widthValue
            selParams = {
              tblBorderWidth: true
              attrName: 'borderWidth'
              attrValue: widthValue
              tblPropertyChange: true
            }
            context.ace.callWithAce ((ace) -> ace.ace_doDatatableOptions selParams), 'tblOptions', true)
        $.tblfocusedProperty = ''
        ($ '#tbl_properties').click (->
          $.borderWidthsMenu.hide! if not (typeof $.borderWidthsMenu is 'undefined')
          if not (typeof $.oColorPickerDialog is 'undefined') then $.oColorPickerDialog.hide!
          if not (typeof $.rowVAlignsMenu is 'undefined') then $.rowVAlignsMenu.hide!)
        $.colorPickerAligned = false
        ($ '#tbl_border_color').click (->
          createColorPicker! if not $.colorPickerAligned
          $.alignMenu $.oColorPickerDialog, 'tbl_border_color'
          $.tblfocusedProperty = 'tbl_border_color'
          if $.rowVAlignsMenu then $.rowVAlignsMenu.hide!
          if $.borderWidthsMenu then $.borderWidthsMenu.hide!
          $.oColorPickerDialog.setHeader 'Please choose a color for: Table Border color'
          $.oColorPickerDialog.show!
          hexValue = $.borderColorPickerButton.get 'value'
          if hexValue then colorPickerButtonClick hexValue)
        $.borderColorPickerButton = new YAHOO.widget.Button {
          disabled: false
          type: 'split'
          label: '<em  class=\'color-picker-button\' id="current-color">Current color is #FFFFFF.</em>'
          container: 'tbl_border_color'
        }
        $.cellBgColorPickerButton = new YAHOO.widget.Button {
          disabled: false
          type: 'split'
          label: '<em class=\'color-picker-button\' id="current-cell-bg-color">Current color is #FFFFFF.</em>'
          container: 'tbl_cell_bg_color'
        }
        ($ '#tbl_cell_bg_color').click (->
          createColorPicker! if not $.colorPickerAligned
          $.alignMenu $.oColorPickerDialog, 'tbl_cell_bg_color'
          $.tblfocusedProperty = 'tbl_cell_bg_color'
          if $.rowVAlignsMenu then $.rowVAlignsMenu.hide!
          if $.borderWidthsMenu then $.borderWidthsMenu.hide!
          $.oColorPickerDialog.setHeader 'Please choose a color for: Cell Background color'
          $.oColorPickerDialog.show!
          hexValue = $.cellBgColorPickerButton.get 'value'
          if hexValue then colorPickerButtonClick hexValue)
        $.evenRowBgColorPickerButton = new YAHOO.widget.Button {
          disabled: false
          type: 'split'
          label: '<em class=\'color-picker-button\' id="even-row-bg-color">Current color is #FFFFFF.</em>'
          container: 'tbl_even_row_bg_color'
        }
        ($ '#tbl_even_row_bg_color').click (->
          createColorPicker! if not $.colorPickerAligned
          $.alignMenu $.oColorPickerDialog, 'tbl_even_row_bg_color'
          $.tblfocusedProperty = 'tbl_even_row_bg_color'
          if $.borderWidthsMenu then $.borderWidthsMenu.hide!
          if $.rowVAlignsMenu then $.rowVAlignsMenu.hide!
          $.oColorPickerDialog.setHeader 'Please choose a color for: Even Row Background color'
          $.oColorPickerDialog.show!
          hexValue = $.evenRowBgColorPickerButton.get 'value'
          if hexValue then colorPickerButtonClick hexValue)
        $.oddRowBgColorPickerButton = new YAHOO.widget.Button {
          disabled: false
          type: 'split'
          label: '<em class=\'color-picker-button\' id="odd-row-bg-color">Current color is #FFFFFF.</em>'
          container: 'tbl_odd_row_bg_color'
        }
        ($ '#tbl_odd_row_bg_color').click (->
          createColorPicker! if not $.colorPickerAligned
          $.alignMenu $.oColorPickerDialog, 'tbl_odd_row_bg_color'
          $.tblfocusedProperty = 'tbl_odd_row_bg_color'
          if $.rowVAlignsMenu then $.rowVAlignsMenu.hide!
          if $.borderWidthsMenu then $.borderWidthsMenu.hide!
          $.oColorPickerDialog.setHeader 'Please choose a color for: Odd Row Background color'
          $.oColorPickerDialog.show!
          hexValue = $.oddRowBgColorPickerButton.get 'value'
          if hexValue then colorPickerButtonClick hexValue)
        $.singleRowBgColorPickerButton = new YAHOO.widget.Button {
          disabled: false
          type: 'split'
          label: '<em class=\'color-picker-button\' id="single-row-bg-color">Current color is #FFFFFF.</em>'
          container: 'tbl_single_row_bg_color'
        }
        ($ '#tbl_single_row_bg_color').click (->
          createColorPicker! if not $.colorPickerAligned
          $.alignMenu $.oColorPickerDialog, 'tbl_single_row_bg_color'
          $.tblfocusedProperty = 'tbl_single_row_bg_color'
          if $.borderWidthsMenu then $.borderWidthsMenu.hide!
          if $.rowVAlignsMenu then $.rowVAlignsMenu.hide!
          $.oColorPickerDialog.setHeader 'Please choose a color for: Single Row Background color'
          $.oColorPickerDialog.show!
          hexValue = $.singleRowBgColorPickerButton.get 'value'
          if hexValue then colorPickerButtonClick hexValue)
        $.singleColBgColorPickerButton = new YAHOO.widget.Button {
          disabled: false
          type: 'split'
          label: '<em class=\'color-picker-button\' id="single-col-bg-color">Current color is #FFFFFF.</em>'
          container: 'tbl_single_col_bg_color'
        }
        ($ '#tbl_single_col_bg_color').click (->
          createColorPicker! if not $.colorPickerAligned
          $.alignMenu $.oColorPickerDialog, 'tbl_single_col_bg_color'
          $.tblfocusedProperty = 'tbl_single_col_bg_color'
          if $.rowVAlignsMenu then $.rowVAlignsMenu.hide!
          if $.borderWidthsMenu then $.borderWidthsMenu.hide!
          $.oColorPickerDialog.setHeader 'Please choose a color for: Single Column Background color'
          $.oColorPickerDialog.show!
          hexValue = $.singleColBgColorPickerButton.get 'value'
          if hexValue then colorPickerButtonClick hexValue)
        ($ '.text-input').change (->
          selParams = {tblPropertyChange: true}
          if @id is 'tbl_width'
            selParams.tblWidth = true
            selParams.attrName = 'width'
          else
            if @id is 'tbl_height'
              selParams.tblHeight = true
              selParams.attrName = 'height'
            else
              if @id is 'tbl_col_width'
                selParams.tblColWidth = true
                selParams.attrName = 'width'
              else
                if @id is 'tbl_row_height'
                  selParams.tblCellHeight = true
                  selParams.attrName = 'height'
                else
                  if @id is 'tbl_cell_padding'
                    selParams.tblCellPadding = true
                    selParams.attrName = 'padding'
                  else
                    if @id is 'tbl_cell_font_size'
                      selParams.tblCellFontSize = true
                      selParams.attrName = 'fontSize'
                    else
                      if @id is 'img_width'
                        selParams.imgWidth = true
                        selParams.attrName = 'width'
                      else
                        if @id is 'img_height'
                          selParams.imgHeight = true
                          selParams.attrName = 'height'
          selParams.attrValue = @value
          @value = ''
          ($ '#text_input_message').text 'Ok'
          ($ '#text_input_message').removeAttr 'style'
          ($ '#text_input_message').fadeOut 'slow'
          context.ace.callWithAce ((ace) -> ace.ace_doDatatableOptions selParams), 'tblOptions', true)
      matrixTable = '<table id=\'matrix_table\'class=\'matrix-table\'><caption></caption>    <tr value=1><td value=1> </td><td value=2> </td><td value=3> </td><td value=4> </td><td value=5> </td><td value=6> </td><td value=7> </td><td value=8> </td><td value=9> </td><td value=10> </td><td value=11> </td><td value=12> </td><td value=13> </td><td value=14> </td><td value=15> </td><td value=16> </td><td value=17> </td><td value=18> </td><td value=19> </td><td value=20> </td></tr>    <tr value=2 ><td value=1> </td><td value=2> </td><td value=3> </td><td value=4> </td><td value=5> </td><td value=6> </td><td value=7> </td><td value=8> </td><td value=9> </td><td value=10> </td><td value=11> </td><td value=12> </td><td value=13> </td><td value=14> </td><td value=15> </td><td value=16> </td><td value=17> </td><td value=18> </td><td value=19> </td><td value=20> </td></tr>    <tr value=3 ><td value=1> </td><td value=2> </td><td value=3> </td><td value=4> </td><td value=5> </td><td value=6> </td><td value=7> </td><td value=8> </td><td value=9> </td><td value=10> </td><td value=11> </td><td value=12> </td><td value=13> </td><td value=14> </td><td value=15> </td><td value=16> </td><td value=17> </td><td value=18> </td><td value=19> </td><td value=20> </td></tr>    <tr value=4><td value=1> </td><td value=2> </td><td value=3> </td><td value=4> </td><td value=5> </td><td value=6> </td><td value=7> </td><td value=8> </td><td value=9> </td><td value=10> </td><td value=11> </td><td value=12> </td><td value=13> </td><td value=14> </td><td value=15> </td><td value=16> </td><td value=17> </td><td value=18> </td><td value=19> </td><td value=20> </td></tr>    <tr value=5 ><td value=1> </td><td value=2> </td><td value=3> </td><td value=4> </td><td value=5> </td><td value=6> </td><td value=7> </td><td value=8> </td><td value=9> </td><td value=10> </td><td value=11> </td><td value=12> </td><td value=13> </td><td value=14> </td><td value=15> </td><td value=16> </td><td value=17> </td><td value=18> </td><td value=19> </td><td value=20> </td></tr>    <tr value=6><td value=1> </td><td value=2> </td><td value=3> </td><td value=4> </td><td value=5> </td><td value=6> </td><td value=7> </td><td value=8> </td><td value=9> </td><td value=10> </td><td value=11> </td><td value=12> </td><td value=13> </td><td value=14> </td><td value=15> </td><td value=16> </td><td value=17> </td><td value=18> </td><td value=19> </td><td value=20> </td></tr>    <tr value=7><td value=1> </td><td value=2> </td><td value=3> </td><td value=4> </td><td value=5> </td><td value=6> </td><td value=7> </td><td value=8> </td><td value=9> </td><td value=10> </td><td value=11> </td><td value=12> </td><td value=13> </td><td value=14> </td><td value=15> </td><td value=16> </td><td value=17> </td><td value=18> </td><td value=19> </td><td value=20> </td></tr>    <tr value=8><td value=1> </td><td value=2> </td><td value=3> </td><td value=4> </td><td value=5> </td><td value=6> </td><td value=7> </td><td value=8> </td><td value=9> </td><td value=10> </td><td value=11> </td><td value=12> </td><td value=13> </td><td value=14> </td><td value=15> </td><td value=16> </td><td value=17> </td><td value=18> </td><td value=19> </td><td value=20> </td></tr>    <tr value=9><td value=1> </td><td value=2> </td><td value=3> </td><td value=4> </td><td value=5> </td><td value=6> </td><td value=7> </td><td value=8> </td><td value=9> </td><td value=10> </td><td value=11> </td><td value=12> </td><td value=13> </td><td value=14> </td><td value=15> </td><td value=16> </td><td value=17> </td><td value=18> </td><td value=19> </td><td value=20> </td></tr>    <tr value=10><td height=10 value=1> </td><td value=2> </td><td value=3> </td><td value=4> </td><td value=5> </td><td value=6> </td><td value=7> </td><td value=8> </td><td value=9> </td><td value=10> </td><td value=11> </td><td value=12> </td><td value=13> </td><td value=14> </td><td value=15> </td><td value=16> </td><td value=17> </td><td value=18> </td><td value=19> </td><td value=20> </td></tr></table>'
      $.tblContextMenu = new YAHOO.widget.ContextMenu 'tbl_context_menu', {
        iframe: true
        zindex: 500
        shadow: false
        position: 'dynamic'
        keepopen: true
        clicktohide: true
      }
      $.tblContextMenu.addItems [
        [{
          text: 'Insert Table'
          submenu: {
            id: 'tbl_insert'
            itemData: ['<div id=\'select_matrix\'>0 X 0</div>']
          }
        }]
        [
          'Insert Row Above'
          'Insert Row Below'
          'Insert Column Right'
          'Insert Column Left'
        ]
        [
          'Delete Row'
          'Delete Column'
          'Delete Table'
        ]
        [{
          id: 'tbl_prop_menu_item'
          text: 'Table Properties'
          onclick: {fn: showTblPropPanel}
        }]
      ]
      subMenus = $.tblContextMenu.getSubmenus!
      subMenus.0.setFooter matrixTable
      $.tblContextMenu.render document.body
      $.alignMenu = (menu, id, addX, addY, scrollY) ->
        region = YAHOO.util.Dom.getRegion id
        if typeof id is 'string' and (id is 'tbl-menu' or id is 'upload_image_cont')
          menu.cfg.setProperty 'xy', [region.left, region.bottom]
        else
          if typeof id is 'string' then menu.cfg.setProperty 'xy', [region.right, region.top] else menu.cfg.setProperty 'xy', [30 + addX, 36 + addY - scrollY]
      ($ 'table td').hover (->
        x = 0
        while x <= ($ this).index!
          y = 0
          while y <= ($ this).parent!.index!
            ((($ this).parent!.parent!.children!.eq y).children!.eq x).addClass 'selected'
            y++
          x++), -> ($ 'table td').removeClass 'selected'
      ($ 'table td').hover (->
        xVal = @getAttribute 'value'
        yVal = (($ this).closest 'tr').0.getAttribute 'value'
        ($ '#select_matrix').html xVal + ' X ' + yVal)
      ($ 'td', '#matrix_table').click ((e) ->
        context.ace.callWithAce ((ace) -> ace.ace_doDatatableOptions 'addTbl', 'addTblX' + ($ '#select_matrix').text!), 'tblOptions', true
        false)
      $.tblContextMenu.subscribe 'click', (p_sType, p_aArgs) ->
        oEvent = p_aArgs.0
        oMenuItem = p_aArgs.1
        if oMenuItem
          tblReq = oMenuItem.cfg.getProperty 'text'
          disabled = oMenuItem.cfg.getProperty 'disabled'
          return  if disabled
          id = ''
          switch tblReq
          case 'Insert Table'
            id = 'addTbl'
          case 'Insert Row Above'
            id = 'addTblRowA'
          case 'Insert Row Below'
            id = 'addTblRowB'
          case 'Insert Column Left'
            id = 'addTblColL'
          case 'Insert Column Right'
            id = 'addTblColR'
          case 'Delete Table'
            id = 'delTbl'
          case 'Delete Image'
            id = 'delImg'
          case 'Delete Row'
            id = 'delTblRow'
          case 'Delete Column'
            id = 'delTblCol'
          context.ace.callWithAce ((ace) -> ace.ace_doDatatableOptions id), 'tblOptions', true
          false
    if not init
      $.alignMenu $.tblContextMenu, 'tbl-menu'
      $.tblContextMenu.show!
  ($ '#tbl-menu').click $.createTableMenu
  YAHOO.util.Dom.addClass document.body, 'yui-skin-sam'
  ($ 'body').append $ '<div id="yui-picker-panel" class="yui-picker-panel">' + '<div class="hd">Please choose a color:</div>' + '<div class="bd">' + '\t<div class="yui-picker" id="color-picker-menu"></div>' + '</div>' + '<div class="ft"></div>' + '</div>'
  ($ 'body').append $ '<div id="yui-tbl-prop-panel" class="yui-picker-panel">' + '<div class="hd">Table/Image Properties</div>' + '<div class="bd">' + '\t<div class="yui-picker" id="tbl-props"></div>' + '</div>' + '<div class="ft"></div>' + '</div>'
  $.createTableMenu true

exports.aceInitialized = (hook, context) ->
  editorInfo = context.editorInfo
  editorInfo.ace_doDatatableOptions = (_ Datatables.doDatatableOptions).bind context

exports.acePostWriteDomLineHTML = (hook_name, args, cb) ->
  children = args.node.children
  i = 0
  while i < children.length
    continue if (args.node.children[i].className.indexOf 'list') isnt -1 or (args.node.children[i].className.indexOf 'tag') isnt -1 or (args.node.children[i].className.indexOf 'url') isnt -1
    lineText = ''
    if args.node.children[i].innerText then lineText = args.node.children[i].innerText else lineText = args.node.children[i].textContent
    if lineText and (lineText.indexOf 'data-tables') isnt -1
      dtAttrs = if typeof exports.Datatables isnt 'undefined' then exports.Datatables.attributes else null
      dtAttrs = dtAttrs or ''
      DatatablesRenderer.render {}, args.node.children[i], dtAttrs
      exports.Datatables.attributes = null
    i++

exports.eejsBlock_scripts = (hook_name, args, cb) ->
  args.content = args.content + (require 'ep_etherpad-lite/node/eejs/').require 'ep_tables/templates/datatablesScripts.ejs'

exports.eejsBlock_editbarMenuLeft = (hook_name, args, cb) ->
  args.content = args.content + (require 'ep_etherpad-lite/node/eejs/').require 'ep_tables/templates/datatablesEditbarButtons.ejs'

exports.eejsBlock_styles = (hook_name, args, cb) ->
  args.content = ((require 'ep_etherpad-lite/node/eejs/').require 'ep_tables/templates/styles.ejs') + args.content

exports.aceAttribsToClasses = (hook, context) ->
  Datatables.attributes = null
  if context.key is 'tblProp'
    Datatables.attributes = context.value
    ['tblProp:' + context.value]

exports.aceStartLineAndCharForPoint = (hook, context) ->
  selStart = null
  try
    Datatables.context = context
    selStart = Datatables.getLineAndCharForPoint! if Datatables.isFocused!
  catch error
    top.console.log 'error ' + error
    top.console.log 'context rep' + Datatables.context.rep
  selStart

exports.aceEndLineAndCharForPoint = (hook, context) ->
  selEndLine = null
  try
    Datatables.context = context
    selEndLine = Datatables.getLineAndCharForPoint! if Datatables.isFocused!
  catch error
    top.console.log 'error ' + error
    top.console.log 'context rep' + Datatables.context.rep
  selEndLine

exports.aceKeyEvent = (hook, context) ->
  specialHandled = false
  try
    Datatables.context = context
    if Datatables.isFocused!
      evt = context.evt
      type = evt.type
      keyCode = evt.keyCode
      isTypeForSpecialKey = if Ace2Common.browser.msie or Ace2Common.browser.safari then type is 'keydown' else type is 'keypress'
      isTypeForCmdKey = if Ace2Common.browser.msie or Ace2Common.browser.safari then type is 'keydown' else type is 'keypress'
      which = evt.which
      if not specialHandled and isTypeForSpecialKey and keyCode is 9 and not (evt.metaKey or evt.ctrlKey)
        context.editorInfo.ace_fastIncorp 5
        evt.preventDefault!
        Datatables.performDocumentTableTabKey!
        specialHandled = true
      if not specialHandled and isTypeForSpecialKey and keyCode is 13
        context.editorInfo.ace_fastIncorp 5
        evt.preventDefault!
        Datatables.doReturnKey!
        specialHandled = true
      if not specialHandled and isTypeForSpecialKey and (keyCode is Datatables.vars.JS_KEY_CODE_DEL or keyCode is Datatables.vars.JS_KEY_CODE_BS or (String.fromCharCode which).toLowerCase! is 'h' and evt.ctrlKey)
        context.editorInfo.ace_fastIncorp 20
        evt.preventDefault!
        specialHandled = true
        Datatables.doDeleteKey! if Datatables.isCellDeleteOk keyCode
  catch
  specialHandled

if typeof Datatables is 'undefined'
  Datatables = do ->
    nodeText = (n) ->
      text = []
      self = arguments_.callee
      el = void
      els = n.childNodes
      excluded = {
        noscript: 'noscript'
        script: 'script'
      }
      i = 0
      iLen = els.length
      while i < iLen
        el = els[i]
        if el.nodeType is 1 and el.tagName.toLowerCase! of excluded then text.push self el else if el.nodeType is 3 then text.push el.data
        i++
      text.join ''
    dt = {
      defaults: {tblProps: {
        borderWidth: '1'
        cellAttrs: []
        width: '6'
        rowAttrs: {}
        colAttrs: []
        authors: {}
      }}
      config: {}
      vars: {
        OVERHEAD_LEN_PRE: '{"payload":[["'.length
        OVERHEAD_LEN_MID: '","'.length
        OVERHEAD_LEN_ROW_START: '["'.length
        OVERHEAD_LEN_ROW_END: '"],'.length
        JS_KEY_CODE_BS: 8
        JS_KEY_CODE_DEL: 46
        TBL_OPTIONS: [
          'addTbl'
          'addTblRowA'
          'addTblRowB'
          'addTblColL'
          'addTblColR'
          'delTbl'
          'delTblRow'
          'delTblCol'
          'delImg'
        ]
      }
      context: null
    }
    dt.isFocused = ->
      return false if not @context.rep.selStart or not @context.rep.selEnd
      line = @context.rep.lines.atIndex @context.rep.selStart.0
      if not line then return false
      currLineText = line.text or ''
      if (currLineText.indexOf 'data-tables') is -1 then return false
      true
    dt._getRowEndOffset = (rowStartOffset, tds) ->
      rowEndOffset = rowStartOffset + @vars.OVERHEAD_LEN_ROW_START
      i = 0
      len = tds.length
      while i < len
        overHeadLen = @vars.OVERHEAD_LEN_MID
        overHeadLen = @vars.OVERHEAD_LEN_ROW_END if i is len - 1
        rowEndOffset += tds[i].length + overHeadLen
        i++
      rowEndOffset
    dt.getFocusedTdInfo = (payload, colStart) ->
      payloadOffset = colStart - @vars.OVERHEAD_LEN_PRE
      rowStartOffset = 0
      payloadSum = 0
      rIndex = 0
      rLen = payload.length
      while rIndex < rLen
        tds = payload[rIndex]
        tIndex = 0
        tLen = tds.length
        while tIndex < tLen
          overHeadLen = @vars.OVERHEAD_LEN_MID
          overHeadLen = @vars.OVERHEAD_LEN_ROW_END if tIndex is tLen - 1
          payloadSum += tds[tIndex].length + overHeadLen
          if payloadSum >= payloadOffset
            tIndex++ if payloadSum is payloadOffset
            leftOverTdTxtLen = if payloadSum - payloadOffset is 0 then payload[rIndex][tIndex].length + @vars.OVERHEAD_LEN_MID else payloadSum - payloadOffset
            cellCaretPos = tds[tIndex].length - leftOverTdTxtLen - overHeadLen
            rowEndOffset = @_getRowEndOffset rowStartOffset, tds
            return {
              row: rIndex
              td: tIndex
              leftOverTdTxtLen: leftOverTdTxtLen
              rowStartOffset: rowStartOffset
              rowEndOffset: rowEndOffset
              cellStartOffset: payloadSum - tds[tIndex].length - overHeadLen
              cellEndOffset: payloadSum
              cellCaretPos: cellCaretPos
            }
          tIndex++
        rowStartOffset = payloadSum
        payloadSum += @vars.OVERHEAD_LEN_ROW_START
        rIndex++
    dt.printCaretPos = (start, end) ->
      top.console.log JSON.stringify start
      top.console.log JSON.stringify end
    dt.doDatatableOptions = (cmd, xByY) ->
      Datatables.context = this
      if typeof cmd is 'object' and cmd.tblPropertyChange
        Datatables.updateTableProperties cmd
      else
        switch cmd
        case Datatables.vars.TBL_OPTIONS.0
          Datatables.addTable xByY
        case Datatables.vars.TBL_OPTIONS.1
          Datatables.insertTblRow 'addA'
        case Datatables.vars.TBL_OPTIONS.2
          Datatables.insertTblRow 'addB'
        case Datatables.vars.TBL_OPTIONS.3
          Datatables.insertTblColumn 'addL'
        case Datatables.vars.TBL_OPTIONS.4
          Datatables.insertTblColumn 'addR'
        case Datatables.vars.TBL_OPTIONS.5
          Datatables.deleteTable!
        case Datatables.vars.TBL_OPTIONS.6
          Datatables.deleteTblRow!
        case Datatables.vars.TBL_OPTIONS.7
          Datatables.deleteTblColumn!
    dt.addTable = (tableObj) ->
      rep = @context.rep
      start = rep.selStart
      end = rep.selEnd
      line = rep.lines.atIndex rep.selStart.0
      hasMoreRows = null
      isRowAddition = null
      if tableObj
        hasMoreRows = tableObj.hasMoreRows
        isRowAddition = tableObj.isRowAddition
      if isRowAddition
        table = JSON.parse tableObj.tblString
        insertTblRowBelow 0, table
        performDocApplyTblAttrToRow rep.selStart, JSON.stringify table.tblProperties
        return 
      if line
        currLineText = line.text
        if not ((currLineText.indexOf 'data-tables') is -1)
          while true
            rep.selStart.0 = rep.selStart.0 + 1
            currLineText = (rep.lines.atIndex rep.selStart.0).text
            break if not ((currLineText.indexOf 'data-tables') isnt -1)
          rep.selEnd.1 = rep.selStart.1 = currLineText.length
          @context.editorInfo.ace_doReturnKey!
          @context.editorInfo.ace_doReturnKey!
        else
          rep.selEnd.1 = rep.selStart.1 = currLineText.length
          @context.editorInfo.ace_doReturnKey!
      if not tableObj?
        authors = {}
        @insertTblRowBelow 3
        @performDocApplyTblAttrToRow rep.selStart, @createDefaultTblProperties!
        @insertTblRowBelow 3
        @performDocApplyTblAttrToRow rep.selStart, @createDefaultTblProperties authors
        @insertTblRowBelow 3
        @performDocApplyTblAttrToRow rep.selStart, @createDefaultTblProperties authors
        @context.editorInfo.ace_doReturnKey!
        @updateAuthorAndCaretPos rep.selStart.0 - 3
        return 
      xByYSelect = if typeof tableObj is 'object' then null else tableObj.split 'X'
      if xByYSelect? and xByYSelect.length is 3
        cols = parseInt xByYSelect.1
        rows = parseInt xByYSelect.2
        jsoStrTblProp = JSON.stringify @createDefaultTblProperties!
        authors = {}
        i = 0
        while i < rows
          @insertTblRowBelow cols
          if i is 0 then @performDocApplyTblAttrToRow rep.selStart, @createDefaultTblProperties! else @performDocApplyTblAttrToRow rep.selStart, @createDefaultTblProperties authors
          i++
        @updateAuthorAndCaretPos rep.selStart.0 - rows + 1
        return 
      newText
    dt.insertTblRow = (aboveOrBelow) ->
      func = 'insertTblRow()'
      rep = @context.rep
      try
        newText = ''
        currLineText = (rep.lines.atIndex rep.selStart.0).text
        payload = (JSON.parse currLineText).payload
        currTdInfo = @getFocusedTdInfo payload, rep.selStart.1
        currRow = currTdInfo.row
        lastRowOffSet = 0
        start = []
        end = []
        start.0 = rep.selStart.0
        start.1 = rep.selStart.1
        end.0 = rep.selStart.0
        end.1 = rep.selStart.1
        if aboveOrBelow is 'addA'
          rep.selStart.0 = rep.selEnd.0 = rep.selStart.0 - 1
          @insertTblRowBelow payload.0.length
        else
          @insertTblRowBelow payload.0.length
        @context.editorInfo.ace_performDocApplyTblAttrToRow rep.selStart, @createDefaultTblProperties!
        @updateAuthorAndCaretPos rep.selStart.0
        updateEvenOddBgColor = true
        @sanitizeTblProperties rep.selStart, updateEvenOddBgColor
      catch
    dt.deleteTable = ->
      rep = @context.rep
      func = 'deleteTable()'
      start = rep.seStart
      end = rep.seEnd
      try
        line = rep.selStart.0 - 1
        numOfLinesAbove = 0
        numOfLinesBelow = 0
        while not (((rep.lines.atIndex line).text.indexOf 'data-tables') is -1)
          numOfLinesAbove++
          line--
        line = rep.selEnd.0 + 1
        while not (((rep.lines.atIndex line).text.indexOf 'data-tables') is -1)
          numOfLinesBelow++
          line++
        rep.selStart.1 = 0
        rep.selStart.0 = rep.selStart.0 - numOfLinesAbove
        rep.selEnd.0 = rep.selEnd.0 + numOfLinesBelow
        rep.selEnd.1 = (rep.lines.atIndex rep.selEnd.0).text.length
        @context.editorInfo.ace_performDocumentReplaceRange rep.selStart, rep.selEnd, ''
      catch
    dt.deleteTblRow = ->
      func = 'deleteTblRow()'
      rep = @context.rep
      try
        currLineText = (rep.lines.atIndex rep.selStart.0).text
        return  if (currLineText.indexOf 'data-tables') is -1
        rep.selEnd.0 = rep.selStart.0 + 1
        rep.selStart.1 = 0
        rep.selEnd.1 = 0
        @context.editorInfo.ace_performDocumentReplaceRange rep.selStart, rep.selEnd, ''
        currLineText = (rep.lines.atIndex rep.selStart.0).text
        if (currLineText.indexOf 'data-tables') is -1 then return 
        @updateAuthorAndCaretPos rep.selStart.0, 0, 0
        updateEvenOddBgColor = true
        @sanitizeTblProperties rep.selStart, updateEvenOddBgColor
      catch
    dt.updateTableProperties = (props) ->
      rep = @context.rep
      currTd = null
      if props.tblColWidth or props.tblSingleColBgColor or props.tblColVAlign
        currLine = rep.lines.atIndex rep.selStart.0
        currLineText = currLine.text
        tblJSONObj = JSON.parse currLineText
        payload = tblJSONObj.payload
        currTdInfo = @getFocusedTdInfo payload, rep.selStart.1
        currTd = currTdInfo.td
      if props.tblWidth or props.tblHeight or props.tblBorderWidth or props.tblBorderColor or props.tblColWidth or props.tblSingleColBgColor or props.tblEvenRowBgColor or props.tblOddRowBgColor or props.tblColVAlign
        start = []
        start.0 = rep.selStart.0
        start.1 = rep.selStart.1
        numOfLinesAbove = @getTblAboveRowsFromCurFocus start
        tempStart = []
        tempStart.0 = start.0 - numOfLinesAbove
        tempStart.1 = start.1
        while tempStart.0 < rep.lines.length! and ((rep.lines.atIndex tempStart.0).text.indexOf 'data-tables') isnt -1
          if props.tblEvenRowBgColor and tempStart.0 % 2 isnt 0
            tempStart.0 = tempStart.0 + 1
            continue
          else
            if props.tblOddRowBgColor and tempStart.0 % 2 is 0
              tempStart.0 = tempStart.0 + 1
              continue
          @updateTablePropertiesHelper props, tempStart, currTd
          tempStart.0 = tempStart.0 + 1
      else
        start = []
        start.0 = rep.selStart.0
        start.1 = rep.selStart.1
        @updateTablePropertiesHelper props, start, currTd
    dt.addCellAttr = (start, tblJSONObj, tblProperties, attrName, attrValue) ->
      rep = @context.rep
      payload = tblJSONObj.payload
      currTdInfo = @getFocusedTdInfo payload, start.1
      currRow = currTdInfo.row
      currTd = currTdInfo.td
      cellAttrs = tblProperties.cellAttrs
      row = cellAttrs[currRow]
      row = [] if not row? or typeof row is 'undefined'
      cell = row[currTd]
      if not cell? or typeof cell is 'undefined' then cell = {}
      if attrName is 'fontWeight' or attrName is 'fontStyle' or attrName is 'textDecoration' then attrValue = '' if cell[attrName] is attrValue else if cell[attrName] is attrValue then return false
      cell[attrName] = attrValue
      row[currTd] = cell
      cellAttrs[currRow] = row
      tblProperties.cellAttrs = cellAttrs
      tblProperties
    dt.addRowAttr = (tblJSONObj, tblProperties, attrName, attrValue) ->
      rep = @context.rep
      rowAttrs = tblProperties.rowAttrs
      if attrName is 'bgColor'
        payload = tblJSONObj.payload
        currTdInfo = @getFocusedTdInfo payload, rep.selStart.1
        currRow = currTdInfo.row
        singleRowAttrs = rowAttrs.singleRowAttrs
        singleRowAttrs = [] if not singleRowAttrs? or typeof singleRowAttrs is 'undefined'
        if not singleRowAttrs[currRow]? or typeof singleRowAttrs[currRow] is 'undefined' then singleRowAttrs[currRow] = {} else if singleRowAttrs[currRow][attrName] is attrValue then return false
        singleRowAttrs[currRow][attrName] = attrValue
        rowAttrs.singleRowAttrs = singleRowAttrs
      else
        return false if rowAttrs[attrName] is attrValue
        rowAttrs[attrName] = attrValue
      tblProperties.rowAttrs = rowAttrs
      tblProperties
    dt.addColumnAttr = (start, tblJSONObj, tblProperties, attrName, attrValue, currTd) ->
      payload = tblJSONObj.payload
      currTdInfo = @getFocusedTdInfo payload, start.1
      colAttrs = tblProperties.colAttrs
      colAttrs = [] if not colAttrs? or typeof colAttrs is 'undefined'
      if not colAttrs[currTd]? or typeof colAttrs[currTd] is 'undefined' then colAttrs[currTd] = {} else if colAttrs[currTd][attrName] is attrValue then return false
      colAttrs[currTd][attrName] = attrValue
      tblProperties.colAttrs = colAttrs
      tblProperties
    dt.updateTablePropertiesHelper = (props, start, currTd) ->
      rep = @context.rep
      lastTblPropertyUsed = 'updateTableProperties'
      start = start or rep.selStart
      return  if not start
      currLine = rep.lines.atIndex start.0
      currLineText = currLine.text
      if (currLineText.indexOf 'data-tables') is -1 then return true
      (try
        tblJSONObj = JSON.parse currLineText
        tblProperties = @getLineTableProperty start.0
        update = false
        if props.tblWidth or props.tblHeight or props.tblBorderWidth or props.tblBorderColor
          currAttrValue = tblProperties[props.attrName]
          if props.attrValue? and (typeof currAttrValue is 'undefined' or currAttrValue isnt props.attrValue)
            tblProperties[props.attrName] = props.attrValue
            update = true
        if props.tblCellFontWeight or props.tblCellFontStyle or props.tblCellTextDecoration
          tblProps = @addCellAttr start, tblJSONObj, tblProperties, props.attrName, props.attrValue
          if tblProps
            tblProperties = tblProps
            update = true
        if props.tblCellFontSize or props.tblCellBgColor or props.tblCellHeight or props.tblCellPadding or props.tblcellVAlign
          tblProps = @addCellAttr start, tblJSONObj, tblProperties, props.attrName, props.attrValue
          if tblProps
            tblProperties = tblProps
            update = true
        if props.tblEvenRowBgColor or props.tblOddRowBgColor
          tblProps = @addRowAttr tblJSONObj, tblProperties, props.attrName, props.attrValue
          if tblProps
            tblProperties = tblProps
            update = true
        if props.tblSingleRowBgColor or props.tblRowVAlign
          tblProps = @addRowAttr tblJSONObj, tblProperties, props.attrName, props.attrValue
          if tblProps
            tblProperties = tblProps
            update = true
        if props.tblColWidth or props.tblSingleColBgColor or props.tblColVAlign
          tblProps = @addColumnAttr start, tblJSONObj, tblProperties, props.attrName, props.attrValue, currTd
          if tblProps
            tblProperties = tblProps
            update = true
        if update then @updateTblPropInAPool -1, -1, tblProperties, start
      catch)
    dt.updateAuthorAndCaretPos = (magicDomLineNum, tblRowNum, tblColNum) ->
      rep = @context.rep
      rep.selStart.1 = rep.selEnd.1 = @vars.OVERHEAD_LEN_PRE
      rep.selStart.0 = rep.selEnd.0 = magicDomLineNum
      row = if typeof tblRowNum is 'undefined' or not tblRowNum? then 0 else tblRowNum
      col = if typeof tblColNum is 'undefined' or not tblRowNum? then 0 else tblColNum
      @updateTblPropInAPool row, col, null, rep.selStart
      rep.selStart.1 = rep.selEnd.1 = @vars.OVERHEAD_LEN_PRE
      @context.editorInfo.ace_performDocumentReplaceRange rep.selStart, rep.selEnd, ''
    dt.insertTblRowBelow = (numOfRows, table) ->
      rep = @rep
      currLineText = (rep.lines.atIndex rep.selStart.0).text
      payload = [[]]
      if not numOfRows and numOfRows isnt 0
        tblPayload = (JSON.parse currLineText).payload
        numOfRows = tblPayload.0.length
      tblRows = new Array numOfRows
      if not (numOfRows is 0)
        i = 0
        while i < tblRows.length
          tblRows[i] = ' '
          i++
      payload = [tblRows]
      if table then payload = table.payload
      tableObj = {
        payload: payload
        tblId: 1
        tblClass: 'data-tables'
        trClass: 'alst'
        tdClass: 'hide-el'
      }
      rep.selEnd.1 = rep.selStart.1 = currLineText.length
      @context.editorInfo.ace_doReturnKey!
      @context.editorInfo.ace_performDocumentReplaceRange rep.selStart, rep.selEnd, JSON.stringify tableObj
    dt.createDefaultTblProperties = (authors) ->
      rep = @context.rep
      defTblProp = {
        borderWidth: '1'
        cellAttrs: []
        width: '6'
        rowAttrs: {}
        colAttrs: []
        authors: {}
      }
      defTblProp.'authors' = authors if authors
      prevLine = rep.lines.atIndex rep.selEnd.0 - 1
      jsoTblProp = null
      if prevLine
        prevLineText = prevLine.text
        jsoTblProp = @getLineTableProperty rep.selStart.0 - 1 if not ((prevLineText.indexOf 'data-tables') is -1)
      if not jsoTblProp
        nextLine = rep.lines.atIndex rep.selEnd.0 - 1
        if nextLine
          nextLineText = nextLine.text
          jsoTblProp = @getLineTableProperty rep.selStart.0 + 1 if not ((nextLineText.indexOf 'data-tables') is -1)
      if jsoTblProp
        defTblProp.borderWidth = jsoTblProp.borderWidth
        defTblProp.borderColor = jsoTblProp.borderColor
        defTblProp.width = jsoTblProp.width
        defTblProp.height = jsoTblProp.height
        defTblProp.colAttrs = jsoTblProp.colAttrs
      jsoStrTblProp = JSON.stringify defTblProp
      jsoStrTblProp
    dt.performDocApplyTblAttrToRow = (start, jsoStrTblProp) ->
      tempStart = []
      tempEnd = []
      tempStart.0 = start.0
      tempEnd.0 = start.0
      tempStart.1 = 0
      tempEnd.1 = (@context.rep.lines.atIndex start.0).text.length
      @context.editorInfo.ace_performDocumentApplyAttributesToRange tempStart, tempEnd, [['tblProp', jsoStrTblProp]]
    dt.performDocumentTableTabKey = ->
      try
        context = @context
        rep = context.rep
        currLine = rep.lines.atIndex rep.selStart.0
        currLineText = currLine.text
        tblJSONObj = JSON.parse currLineText
        payload = tblJSONObj.payload
        currTdInfo = @getFocusedTdInfo payload, rep.selStart.1
        leftOverTdTxtLen = currTdInfo.leftOverTdTxtLen
        currRow = currTdInfo.row
        currTd = currTdInfo.td
        if typeof payload[currRow][currTd + 1] is 'undefined'
          currRow += 1
          nextLine = rep.lines.atIndex rep.selStart.0 + 1
          nextLineText = nextLine.text
          updateEvenOddBgColor = false
          if not nextLineText? or nextLineText is '' or (nextLineText.indexOf 'data-tables') is -1
            @insertTblRowBelow null, null
            @performDocApplyTblAttrToRow rep.selStart, @createDefaultTblProperties!
            rep.selEnd.1 = rep.selStart.1 = @vars.OVERHEAD_LEN_PRE
            updateEvenOddBgColor = true
          else
            currTd = -1
            rep.selStart.0 = rep.selEnd.0 = rep.selStart.0 + 1
            tblJSONObj = JSON.parse nextLineText
            payload = tblJSONObj.payload
            leftOverTdTxtLen = payload.0.0.length
            rep.selEnd.1 = rep.selStart.1 = @vars.OVERHEAD_LEN_PRE + leftOverTdTxtLen
          context.editorInfo.ace_performDocumentReplaceRange rep.selStart, rep.selEnd, ''
          start = []
          start.0 = rep.selStart.0
          start.1 = rep.selStart.1
          dt.updateTblCellAuthor 0, 0, null, start, updateEvenOddBgColor
        else
          nextTdTxtLen = if typeof payload[currRow] is 'undefined' then -leftOverTdTxtLen else payload[currRow][currTd + 1].length
          payload = tblJSONObj.payload
          rep.selStart.1 = rep.selEnd.1 = rep.selEnd.1 + nextTdTxtLen + leftOverTdTxtLen
          context.editorInfo.ace_performDocumentReplaceRange rep.selStart, rep.selEnd, ''
          dt.updateTblPropInAPool currRow, currTd + 1, null, rep.selStart
      catch
    dt.getTdInfo = (payload, tdIndex) ->
      rep = @context.rep
      startOffset = @vars.OVERHEAD_LEN_PRE
      rowStartOffset = startOffset
      payloadSum = startOffset
      tds = payload.0
      tIndex = 0
      tLen = tds.length
      while tIndex < tLen
        overHeadLen = @vars.OVERHEAD_LEN_MID
        overHeadLen = @vars.OVERHEAD_LEN_ROW_END if tIndex is tLen - 1
        payloadSum += tds[tIndex].length + overHeadLen
        if tIndex >= tdIndex
          return {
            cellStartOffset: payloadSum - tds[tIndex].length - overHeadLen
            cellEndOffset: payloadSum
          }
        tIndex++
    dt.getNextTdInfo = (payload, currTdInfo) ->
      rep = @context.rep
      startOffset = currTdInfo.rowEndOffset
      rowStartOffset = startOffset
      payloadSum = startOffset
      tds = payload[currTdInfo.row]
      tIndex = 0
      tLen = tds.length
      while tIndex < tLen
        overHeadLen = @vars.OVERHEAD_LEN_MID
        overHeadLen = @vars.OVERHEAD_LEN_ROW_END if tIndex is tLen - 1
        payloadSum += tds[tIndex].length + overHeadLen
        if tIndex >= currTdInfo.td
          leftOverTdTxtLen = if payloadSum - startOffset is 0 then payload[currTdInfo.row + 1][tIndex].length + @vars.OVERHEAD_LEN_MID else payloadSum - startOffset
          rowEndOffset = @_getRowEndOffset rowStartOffset, tds
          tdInfo = {
            row: currTdInfo.row + 1
            td: tIndex
            leftOverTdTxtLen: leftOverTdTxtLen
            rowStartOffset: rowStartOffset
            rowEndOffset: rowEndOffset
            cellStartOffset: payloadSum - tds[tIndex].length - overHeadLen
            cellEndOffset: payloadSum
          }
          return tdInfo
        tIndex++
    dt.insertTblColumn = (leftOrRight, start, end) ->
      rep = @context.rep
      func = 'insertTblColumn()'
      try
        currLineText = (rep.lines.atIndex rep.selStart.0).text
        tblJSONObj = JSON.parse currLineText
        payload = tblJSONObj.payload
        currTdInfo = @getFocusedTdInfo payload, rep.selStart.1
        currTd = currTdInfo.td
        start = []
        end = []
        start.0 = rep.selStart.0
        start.1 = rep.selStart.1
        end.0 = rep.selEnd.0
        end.1 = rep.selEnd.1
        currTd -= 1 if leftOrRight is 'addL'
        numOfLinesAbove = @getTblAboveRowsFromCurFocus start
        rep.selEnd.0 = rep.selStart.0 = rep.selStart.0 - numOfLinesAbove
        while rep.selStart.0 < rep.lines.length! and ((rep.lines.atIndex rep.selStart.0).text.indexOf 'data-tables') isnt -1
          currLineText = (rep.lines.atIndex rep.selStart.0).text
          tblJSONObj = JSON.parse currLineText
          payload = tblJSONObj.payload
          cellPos = (@getTdInfo payload, currTd).cellEndOffset
          newText = '" ",'
          if currTd is payload.0.length - 1
            rep.selStart.1 = rep.selEnd.1 = cellPos - @vars.OVERHEAD_LEN_ROW_END + 1
            newText = '," "'
          else
            if currTd is -1 then rep.selStart.1 = rep.selEnd.1 = @vars.OVERHEAD_LEN_PRE - 1 else rep.selStart.1 = rep.selEnd.1 = cellPos - 1
          @context.editorInfo.ace_performDocumentReplaceRange rep.selStart, rep.selEnd, newText
          rep.selEnd.0 = rep.selStart.0 = rep.selStart.0 + 1
        rep.selStart = start
        rep.selEnd = end
        if leftOrRight is 'addL'
          rep.selStart.1 = rep.selEnd.1 = @vars.OVERHEAD_LEN_PRE
          rep.selStart.0 = rep.selEnd.0 = rep.selStart.0
          @updateTblPropInAPool 0, 0, null, rep.selStart
          rep.selStart.1 = rep.selEnd.1 = @vars.OVERHEAD_LEN_PRE
        currTd++
        updateEvenOddBgColor = false
        updateColAttrs = true
        @sanitizeTblProperties start, updateEvenOddBgColor, updateColAttrs, currTd, 'add'
        @context.editorInfo.ace_performDocumentReplaceRange rep.selStart, rep.selEnd, ''
      catch
    dt.deleteTblColumn = ->
      func = 'deleteTblColumn()'
      rep = @context.rep
      try
        currLineText = (rep.lines.atIndex rep.selStart.0).text
        tblJSONObj = JSON.parse currLineText
        payload = tblJSONObj.payload
        deleteTable! if payload.0.length is 1
        currTdInfo = @getFocusedTdInfo payload, rep.selStart.1
        currTd = currTdInfo.td
        start = []
        end = []
        start.0 = rep.selStart.0
        start.1 = rep.selStart.1
        end.0 = rep.selEnd.0
        end.1 = rep.selEnd.1
        numOfLinesAbove = @getTblAboveRowsFromCurFocus start
        rep.selEnd.0 = rep.selStart.0 = rep.selStart.0 - numOfLinesAbove
        while rep.selStart.0 < rep.lines.length! and ((rep.lines.atIndex rep.selStart.0).text.indexOf 'data-tables') isnt -1
          currLineText = (rep.lines.atIndex rep.selStart.0).text
          tblJSONObj = JSON.parse currLineText
          payload = tblJSONObj.payload
          cellTdInfo = @getTdInfo payload, currTd
          newText = '" ",'
          if currTd is payload.0.length - 1
            rep.selStart.1 = cellTdInfo.cellStartOffset - 2
            rep.selEnd.1 = cellTdInfo.cellEndOffset - 2
          else
            if currTd is 0
              rep.selStart.1 = @vars.OVERHEAD_LEN_PRE - 1
              rep.selEnd.1 = cellTdInfo.cellEndOffset - 1
            else
              rep.selStart.1 = cellTdInfo.cellStartOffset - 1
              rep.selEnd.1 = cellTdInfo.cellEndOffset - 1
          @context.editorInfo.ace_performDocumentReplaceRange rep.selStart, rep.selEnd, ''
          rep.selEnd.0 = rep.selStart.0 = rep.selStart.0 + 1
        rep.selStart = start
        rep.selEnd = end
        updateEvenOddBgColor = false
        updateColAttrs = true
        @sanitizeTblProperties start, updateEvenOddBgColor, updateColAttrs, currTd, 'del'
        @updateAuthorAndCaretPos rep.selStart.0, 0, 0
      catch
    dt.insertTblRowBelow = (numOfRows, table) ->
      context = @context
      rep = context.rep
      currLineText = (rep.lines.atIndex rep.selStart.0).text
      payload = [[]]
      if not numOfRows and numOfRows isnt 0
        tblPayload = (JSON.parse currLineText).payload
        numOfRows = tblPayload.0.length
      tblRows = new Array numOfRows
      if not (numOfRows is 0)
        i = 0
        while i < tblRows.length
          tblRows[i] = ' '
          i++
      payload = [tblRows]
      if table then payload = table.payload
      tableObj = {
        payload: payload
        tblId: 1
        tblClass: 'data-tables'
        trClass: 'alst'
        tdClass: 'hide-el'
      }
      rep.selEnd.1 = rep.selStart.1 = currLineText.length
      @context.editorInfo.ace_inCallStackIfNecessary 'newline', @context.editorInfo.ace_doReturnKey
      context.editorInfo.ace_performDocumentReplaceRange rep.selStart, rep.selEnd, JSON.stringify tableObj
    dt.doReturnKey = ->
      context = @context
      rep = context.rep
      start = rep.seStart
      end = rep.selEnd
      lastTblPropertyUsed = 'doTableReturnKey'
      currLine = rep.lines.atIndex rep.selStart.0
      currLineText = currLine.text
      if not ((currLineText.indexOf 'data-tables') is -1)
        func = 'doTableReturnKey()'
        try
          currCarretPos = rep.selStart.1
          if (currLineText.substring currCarretPos - 1, currCarretPos + 2) is '","'
            return true
          else
            if (currLineText.substring currCarretPos - 2, currCarretPos + 1) is '","'
              return true
            else
              if currCarretPos < @vars.OVERHEAD_LEN_PRE then return true else if currCarretPos > currLineText.length then return true
          start = rep.selStart
          end = rep.selEnd
          newText = ' /r/n '
          start.1 = currCarretPos
          end.1 = currCarretPos
          (try
            jsonObj = JSON.parse (currLineText.substring 0, start.1) + newText + currLineText.substring start.1
            payloadStr = JSON.stringify jsonObj.payload
            return true if currCarretPos > payloadStr.length + @vars.OVERHEAD_LEN_PRE - 2
          catch error
            return true)
          context.editorInfo.ace_performDocumentReplaceRange start, end, newText
        catch
        true
    dt.isCellDeleteOk = (keyCode) ->
      context = @context
      rep = context.rep
      start = rep.selStart
      end = rep.selEnd
      currLine = rep.lines.atIndex rep.selStart.0
      currLineText = currLine.text
      return true if (currLineText.indexOf 'data-tables') is -1
      isDeleteAccepted = false
      (try
        tblJSONObj = JSON.parse currLineText
        table = tblJSONObj.payload
        currTdInfo = @getFocusedTdInfo table, rep.selStart.1
        cellEntryLen = table[currTdInfo.row][currTdInfo.td].length
        currCarretPos = rep.selStart.1
        if (currLineText.substring currCarretPos - 1, currCarretPos + 2) is '","'
          return false
        else
          if (currLineText.substring currCarretPos - 2, currCarretPos + 1) is '","' then return false
        switch keyCode
        case @vars.JS_KEY_CODE_BS
          isDeleteAccepted = true if cellEntryLen isnt 0 and cellEntryLen > currTdInfo.leftOverTdTxtLen - @vars.OVERHEAD_LEN_MID
        case @vars.JS_KEY_CODE_DEL
          return false
          isDeleteAccepted = true if cellEntryLen isnt 0 and currTdInfo.leftOverTdTxtLen - @vars.OVERHEAD_LEN_MID > 0
        default
          isDeleteAccepted = true if cellEntryLen isnt 0 and cellEntryLen > currTdInfo.leftOverTdTxtLen - @vars.OVERHEAD_LEN_MID
      catch error
        isDeleteAccepted = false)
      isDeleteAccepted
    dt.nodeTextPlain = (n) -> n.innerText or n.textContent or n.nodeValue or ''
    dt.toString = -> 'ep_tables'
    dt.getLineAndCharForPoint = ->
      context = @context
      point = context.point
      root = context.root
      if point.node is root
        if point.index is 0
          [0, 0]
        else
          N = @context.rep.lines.length!
          ln = @context.rep.lines.atIndex N - 1
          [N - 1, ln.text.length]
      else
        n = point.node
        col = 0
        col = point.index if (nodeText n) or point.index > 0
        parNode = void
        prevSib = void
        while not ((parNode = n.parentNode) is root)
          if prevSib = n.previousSibling
            n = prevSib
            textLen = if (nodeText n).length is 0 then (@nodeTextPlain n).length else (nodeText n).length
            col += textLen
          else
            n = parNode
        if n.id is '' then console.debug 'BAD'
        if n.firstChild and context.editorInfo.ace_isBlockElement n.firstChild then col += 1
        lineEntry = @context.rep.lines.atKey n.id
        lineNum = @context.rep.lines.indexOfEntry lineEntry
        [lineNum, col]
    dt.doDeleteKey = ->
      context = @context
      evt = context.evt or {}
      handled = false
      rep = @context.rep
      editorInfo = context.editorInfo
      if rep.selStart
        if editorInfo.ace_isCaret!
          lineNum = editorInfo.ace_caretLine!
          col = editorInfo.ace_caretColumn!
          lineEntry = rep.lines.atIndex lineNum
          lineText = lineEntry.text
          lineMarker = lineEntry.lineMarker
          if /^ +$/.exec lineText.substring lineMarker, col
            col2 = col - lineMarker
            tabSize = ''.length
            toDelete = (col2 - 1) % tabSize + 1
            editorInfo.ace_performDocumentReplaceRange [lineNum, col - toDelete], [lineNum, col], ''
            handled = true
        if not handled
          if editorInfo.ace_isCaret!
            theLine = editorInfo.ace_caretLine!
            lineEntry = rep.lines.atIndex theLine
            if editorInfo.ace_caretColumn! <= lineEntry.lineMarker
              action = 'delete_newline'
              prevLineListType = if theLine > 0 then editorInfo.ace_getLineListType theLine - 1 else ''
              thisLineListType = editorInfo.ace_getLineListType theLine
              prevLineEntry = theLine > 0 and rep.lines.atIndex theLine - 1
              prevLineBlank = prevLineEntry and prevLineEntry.text.length is prevLineEntry.lineMarker
              if thisLineListType
                if prevLineBlank and not prevLineListType
                  editorInfo.ace_performDocumentReplaceRange [theLine - 1, prevLineEntry.text.length], [theLine, 0], ''
                else
                  editorInfo.ace_performDocumentReplaceRange [theLine, 0], [theLine, lineEntry.lineMarker], ''
              else
                if theLine > 0
                  editorInfo.ace_performDocumentReplaceRange [theLine - 1, prevLineEntry.text.length], [theLine, 0], ''
            else
              docChar = editorInfo.ace_caretDocChar!
              if docChar > 0
                if evt.metaKey or evt.ctrlKey or evt.altKey
                  deleteBackTo = docChar - 1
                  while deleteBackTo > lineEntry.lineMarker and editorInfo.ace_isWordChar rep.alltext.charAt deleteBackTo - 1
                    deleteBackTo--
                  editorInfo.ace_performDocumentReplaceCharRange deleteBackTo, docChar, ''
                else
                  returnKeyWitinTblOffset = 0
                  returnKeyWitinTblOffset = 4 if (lineText.substring col - 5, col) is '/r/n '
                  editorInfo.ace_performDocumentReplaceCharRange docChar - 1 - returnKeyWitinTblOffset, docChar, ''
          else
            editorInfo.ace_performDocumentReplaceRange rep.selStart, rep.selEnd, ''
      line = editorInfo.ace_caretLine!
      if line isnt -1 and (editorInfo.ace_renumberList line + 1) is null then editorInfo.ace_renumberList line
    dt.getLineTableProperty = (lineNum) ->
      rep = @context.rep
      aline = rep.alines[lineNum]
      if aline
        opIter = Changeset.opIterator aline
        if opIter.hasNext!
          tblJSString = Changeset.opAttributeValue opIter.next!, 'tblProp', rep.apool
          try
            return JSON.parse tblJSString
          catch error
            return @defaults.tblProps
      @defaults.tblProps
    dt.updateTblPropInAPool = (row, td, jsoTblProp, start) ->
      try
        rep = @context.rep
        tblProps = void
        editorInfo = @context.editorInfo
        thisAuthor = editorInfo.ace_getAuthor!
        authorInfos = editorInfo.ace_getAuthorInfos!
        jsoTblProp = @getLineTableProperty start.0 if typeof jsoTblProp is 'undefined' or not jsoTblProp?
        if row isnt -1 and td isnt -1
          jsoTblProp.'authors'[thisAuthor] = {
            row: row
            cell: td
            colorId: authorInfos[thisAuthor].bgcolor
          }
        jsoStrTblProp = JSON.stringify jsoTblProp
        attrStart = []
        attrEnd = []
        attrStart.0 = start.0
        attrStart.1 = 0
        attrEnd.0 = start.0
        attrEnd.1 = (rep.lines.atIndex start.0).text.length
        editorInfo.ace_performDocumentApplyAttributesToRange attrStart, attrEnd, [['tblProp', jsoStrTblProp]]
      catch
    dt.getCurrTblOddEvenRowBgColor = (startRowNum, currRowNum) ->
      rowBgColors = {
        oddBgColor: null
        evenBgColor: null
      }
      if not (startRowNum is currRowNum)
        jsoTblProp1 = @getLineTableProperty startRowNum
        jsoTblProp2 = @getLineTableProperty startRowNum + 1
        rowBgColors.evenBgColor = jsoTblProp1.'rowAttrs'.'evenBgColor' or jsoTblProp2.'rowAttrs'.'evenBgColor'
        rowBgColors.oddBgColor = jsoTblProp1.'rowAttrs'.'oddBgColor' or jsoTblProp2.'rowAttrs'.'oddBgColor'
      rowBgColors
    dt.getTblAboveRowsFromCurFocus = (start) ->
      rep = @context.rep
      numOfLinesAbove = 0
      line = start.0 - 1
      while not (((rep.lines.atIndex line).text.indexOf 'data-tables') is -1)
        numOfLinesAbove++
        line--
      numOfLinesAbove
    dt.updateTableIndices = (tblProperties, currTd, addOrDel) ->
      cellAttrs = tblProperties.cellAttrs
      rIndex = 0
      rLen = cellAttrs.length
      while rIndex < rLen
        cellAttr = cellAttrs[rIndex]
        if addOrDel is 'add' then cellAttr.splice currTd, 0, null if cellAttr else cellAttr.splice currTd, 1 if cellAttr
        rIndex++
      colAttrs = tblProperties.colAttrs
      if addOrDel is 'add' then colAttrs.splice currTd, 0, null if colAttrs else colAttrs.splice currTd, 1 if colAttrs
      tblProperties
    dt.sanitizeTblProperties = (start, updateEvenOddBgColor, updateColAttrs, currTd, addOrDel) ->
      rep = @context.rep
      editorInfo = @context.editorInfo
      thisAuthor = editorInfo.ace_getAuthor!
      numOfLinesAbove = @getTblAboveRowsFromCurFocus start
      tempStart = []
      tempStart.0 = start.0 - numOfLinesAbove
      evenOddRowBgColors = {}
      updateEvenOddBgColor
      while tempStart.0 < rep.lines.length! and ((rep.lines.atIndex tempStart.0).text.indexOf 'data-tables') isnt -1
        jsoTblProp = @getLineTableProperty tempStart.0
        update = false
        if tempStart.0 isnt start.0 and jsoTblProp.'authors' and jsoTblProp.'authors'[thisAuthor]
          delete jsoTblProp.'authors'[thisAuthor]
          update = true
        if updateColAttrs
          jsoTblProp = @updateTableIndices jsoTblProp, currTd, addOrDel
          update = true
        if tempStart.0 isnt start.0 and updateEvenOddBgColor
          delete jsoTblProp.'rowAttrs'.'oddBgColor'
          delete jsoTblProp.'rowAttrs'.'evenBgColor'
          update = true
        if update then @updateTblPropInAPool -1, -1, jsoTblProp, tempStart
        tempStart.0 = tempStart.0 + 1
    dt.updateTblPropInAPool = (row, td, jsoTblProp, start) ->
      try
        rep = @context.rep
        editorInfo = @context.editorInfo
        thisAuthor = editorInfo.ace_getAuthor!
        authorInfos = editorInfo.ace_getAuthorInfos!
        tblProps = void
        jsoTblProp = @getLineTableProperty start.0 if typeof jsoTblProp is 'undefined' or not jsoTblProp?
        if row isnt -1 and td isnt -1
          jsoTblProp.'authors'[thisAuthor] = {
            row: row
            cell: td
            colorId: authorInfos[thisAuthor].bgcolor
          }
        jsoStrTblProp = JSON.stringify jsoTblProp
        attrStart = []
        attrEnd = []
        attrStart.0 = start.0
        attrStart.1 = 0
        attrEnd.0 = start.0
        attrEnd.1 = (rep.lines.atIndex start.0).text.length
        editorInfo.ace_performDocumentApplyAttributesToRange attrStart, attrEnd, [['tblProp', jsoStrTblProp]]
      catch
    dt.updateTblCellAuthor = (row, td, tblProperties, start, updateEvenOddBgColor) ->
      try
        @updateTblPropInAPool row, td, tblProperties, start
        tempStart = []
        tempStart.0 = start.0
        tempStart.1 = start.1
        @sanitizeTblProperties tempStart, updateEvenOddBgColor
      catch
    dt

if typeof exports isnt 'undefined' then exports.Datatables = Datatables else null
