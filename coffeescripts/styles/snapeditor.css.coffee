define [], ->
  """
    /* GENERAL TOOLBAR */

    .snapeditor_toolbar_content_outer {
      background-color: #DDDDDD;
      height: 32px;
    }

    .snapeditor_toolbar_content {
      height: 30px;
      padding: 1px;
    }

    .snapeditor_toolbar_content_inner {
      background: #F0F0F0;
      filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#F5F5F5', endColorstr='#E6E6E6');
      background: -webkit-gradient(linear, left top, left bottom, from(#F5F5F5), to(#E6E6E6));
      background: -moz-linear-gradient(top, #F5F5F5, #E6E6E6);
      height: 30px;
    }

    .snapeditor_toolbar_group {
      float: left;
    }

    .snapeditor_toolbar_divider {
      float: left;
      background: #E0E0E0;
      filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#DDDDDD', endColorstr='#E6E6E6');
      background: -webkit-gradient(linear, left top, left bottom, from(#DDDDDD), to(#E6E6E6));
      background: -moz-linear-gradient(top,  #DDDDDD,  #E6E6E6);
      width: 1px;
      height: 30px;
    }

    .snapeditor_toolbar_button {
      float: left;
      padding: 3px 3px 0 3px;
    }

    /* FORM TOOLBAR */

    .snapeditor_toolbar_static {
      width: 100%;
    }

    .snapeditor_form_iframe_container {
      border: 1px solid #dddddd;
      border-top: none;
    }

    /* IN-PLACE TOOLBAR */

    .snapeditor_toolbar_floating {
      position: relative;
      z-index: 200;
    }

    .snapeditor_toolbar_floating .snapeditor_toolbar_frame_outer {
      padding: 2px 0;
    }

    .snapeditor_toolbar_floating .snapeditor_toolbar_frame {
      border: 1px solid #b8b8b8;
      -webkit-border-radius: 4px;
      -moz-border-radius: 4px;
      border-radius: 4px;
      padding: 4px;
      background: #FBFBFB;
      filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#FFFFFF', endColorstr='#F8F8F8');
      background: -webkit-gradient(linear, left top, left bottom, from(#FFFFFF), to(#F8F8F8));
      background: -moz-linear-gradient(top,  #FFFFFF,  #F8F8F8);
    }

    /* CONTEXTMENU */

    .snapeditor_contextmenu {
      background-color: white;
      width: 300px;
    }

    .snapeditor_contextmenu_content {
      border: 1px solid #808080;
    }

    .snapeditor_contextmenu_separator {
      height: 0px;
      border-bottom: 1px solid #808080;
    }

    .snapeditor_contextmenu_description, .snapeditor_contextmenu_shortcut {
      cursor: default;
    }

    /* DIALOG */
    .snapeditor_dialog {
      z-index: 210;
      border: 1px solid #b8b8b8;
      background-color: #FBFBFB;
      font-color: #333333;
      font-size: 14px;
      font-family: Arial, Helvetica, sans-serif;
    }

    .snapeditor_dialog_title_container {
      background: #F0F0F0;
      filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#F5F5F5', endColorstr='#E6E6E6');
      background: -webkit-gradient(linear, left top, left bottom, from(#F5F5F5), to(#E6E6E6));
      background: -moz-linear-gradient(top, #F5F5F5, #E6E6E6);
      border-bottom: 1px solid #b8b8b8;
    }

    .snapeditor_dialog_title {
      font-weight: bold;
      padding: 3px 5px;
    }

    .snapeditor_dialog_content {
      padding: 20px;
    }

    .snapeditor_dialog .error {
      color: #b94a48;
      background-color: #f2dede;
      border: 1px solid #eed3d7;
      padding: 8px 15px;
      margin-bottom: 20px;
    }

    .snapeditor_dialog .button {
      border: none;
      border: 1px solid rgba(0, 0, 0, 0.1);
      border-radius: 5px 5px 5px 5px;
      cursor: pointer;
      outline: none;
      padding: 0.50em 1em;
      text-decoration: none;
    }

    .snapeditor_dialog .submit {
      background: #83c312;
      background: -webkit-gradient(linear, left top, left bottom, from(#9bc03a), to(#649d00));
      background: -moz-linear-gradient(top , #9bc03a, #649d00);
      filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#9bc03a', endColorstr='#649d00');
      color: #ffffff;
    }

    .snapeditor_dialog .delete {
      background: #cd1313;
      background: -webkit-gradient(linear, left top, left bottom, from(#d73e3e), to(#ba0000));
      background: -moz-linear-gradient(top , #d73e3e, #ba0000);
      filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#d73e3e', endColorstr='#ba0000');
      color: #ffffff;
    }

    .snapeditor_dialog .cancel {
      background: #dddddd;
      background: -webkit-gradient(linear, left top, left bottom, from(#ededed), to(#cdcdcd));
      background: -moz-linear-gradient(top , #ededed, #cdcdcd);
      filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#ededed', endColorstr='#cdcdcd');
      color: #666666;
    }

    /* LINK DIALOG */
    /* TODO: This should be moved inside the plugin */
    .snapeditor_dialog .link_form .field_container {
      margin-bottom: 3px;
    }

    .snapeditor_dialog .link_form .buttons {
      margin-top: 15px;
    }

    .snapeditor_dialog .link_form .label_left {
      display: inline-block;
      text-align: right;
      margin-right: 5px;
      width: 5em;
    }

    .snapeditor_dialog .link_form input[type="text"] {
      width: 225px;
    }

    .snapeditor_dialog .link_form .link_new_window_text {
      font-size: 90%;
    }

    /* IMAGE DIALOG */
    /* TODO: This should be moved inside the plugin */
    .snapeditor_dialog .insert_image_form .insert_image_text {
      margin-bottom: 10px;
    }

    /* SAVE DIALOG */
    /* TODO: This should be moved inside the plugin */
    .save_dialog .buttons {
      margin-top: 20px;
      margin-bottom: 15px;
    }

    .save_dialog .save {
      margin-right: 10px;
    }

    .save_dialog .discard_message {
      text-align: right;
    }

    .save_dialog .discard_message a {
      text-decoration: none;
      color: #46a7b0;
    }
  """
