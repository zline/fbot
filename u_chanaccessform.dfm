object ChanAccessForm: TChanAccessForm
  Left = 192
  Top = 107
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  ClientHeight = 114
  ClientWidth = 361
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
    Top = 8
    Width = 31
    Height = 13
    Caption = #1050#1072#1085#1072#1083
  end
  object Label2: TLabel
    Left = 208
    Top = 8
    Width = 37
    Height = 13
    Caption = #1044#1086#1089#1090#1091#1087
  end
  object cbChan: TComboBox
    Left = 8
    Top = 28
    Width = 185
    Height = 21
    BevelKind = bkSoft
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnChange = cbChanChange
  end
  object btNewChan: TButton
    Left = 8
    Top = 56
    Width = 89
    Height = 19
    Caption = #1053#1086#1074#1099#1081
    TabOrder = 1
    OnClick = btNewChanClick
  end
  object btDelChan: TButton
    Left = 104
    Top = 56
    Width = 89
    Height = 19
    Caption = #1059#1076#1072#1083#1080#1090#1100
    TabOrder = 2
    OnClick = btDelChanClick
  end
  object cbAcc: TComboBox
    Left = 208
    Top = 28
    Width = 145
    Height = 21
    BevelKind = bkSoft
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 3
    Text = 'Channel Administrator'
    OnChange = cbAccChange
    Items.Strings = (
      'Channel Administrator'
      'Channel Operator'
      'Channel Half-Operator'
      'Channel Voice')
  end
  object Button1: TButton
    Left = 88
    Top = 88
    Width = 89
    Height = 20
    Caption = #1054#1050
    TabOrder = 4
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 184
    Top = 88
    Width = 89
    Height = 20
    Caption = #1042#1099#1093#1086#1076
    TabOrder = 5
    OnClick = Button2Click
  end
end
