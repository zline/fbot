object AddUserForm: TAddUserForm
  Left = 242
  Top = 226
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1053#1086#1074#1099#1081' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
  ClientHeight = 121
  ClientWidth = 209
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 11
    Width = 23
    Height = 13
    Caption = #1053#1080#1082':'
  end
  object Label2: TLabel
    Left = 8
    Top = 41
    Width = 41
    Height = 13
    Caption = #1055#1072#1088#1086#1083#1100':'
  end
  object Label3: TLabel
    Left = 8
    Top = 70
    Width = 40
    Height = 13
    Caption = #1044#1086#1089#1090#1091#1087':'
  end
  object Edit1: TEdit
    Left = 56
    Top = 8
    Width = 145
    Height = 21
    BevelKind = bkSoft
    BorderStyle = bsNone
    TabOrder = 0
  end
  object Edit2: TEdit
    Left = 56
    Top = 37
    Width = 145
    Height = 21
    BevelKind = bkSoft
    BorderStyle = bsNone
    TabOrder = 1
  end
  object ComboBox1: TComboBox
    Left = 56
    Top = 66
    Width = 145
    Height = 21
    BevelKind = bkSoft
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 2
    Text = 'Root Administrator'
    Items.Strings = (
      'Root Administrator'
      'Global Operator'
      'User')
  end
  object Button1: TButton
    Left = 8
    Top = 96
    Width = 93
    Height = 19
    Caption = 'OK'
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 107
    Top = 96
    Width = 93
    Height = 19
    Caption = #1042#1099#1093#1086#1076
    TabOrder = 4
    OnClick = Button2Click
  end
end
