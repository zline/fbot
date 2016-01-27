object AddBadword: TAddBadword
  Left = 225
  Top = 143
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  ClientHeight = 95
  ClientWidth = 281
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 44
    Width = 109
    Height = 13
    Caption = #1087#1086#1083#1086#1078#1077#1085#1080#1077' '#1074#1086' '#1092#1088#1072#1079#1077':'
  end
  object Edit1: TEdit
    Left = 8
    Top = 8
    Width = 265
    Height = 21
    BevelKind = bkSoft
    BorderStyle = bsNone
    TabOrder = 0
    OnKeyPress = Edit1KeyPress
  end
  object Button1: TButton
    Left = 26
    Top = 70
    Width = 110
    Height = 19
    Caption = 'OK'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 144
    Top = 70
    Width = 110
    Height = 19
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 2
    OnClick = Button2Click
  end
  object ComboBox1: TComboBox
    Left = 128
    Top = 41
    Width = 145
    Height = 21
    BevelKind = bkSoft
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 1
    TabOrder = 3
    Text = #1086#1090#1076#1077#1083#1100#1085#1086#1077' '#1089#1083#1086#1074#1086
    Items.Strings = (
      #1074' '#1083#1102#1073#1086#1084' '#1084#1077#1089#1090#1077
      #1086#1090#1076#1077#1083#1100#1085#1086#1077' '#1089#1083#1086#1074#1086
      #1074' '#1082#1086#1085#1094#1077' '#1089#1083#1086#1074#1072
      #1074' '#1085#1072#1095#1072#1083#1077' '#1089#1083#1086#1074#1072)
  end
end
