object AddServForm: TAddServForm
  Left = 314
  Top = 181
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1044#1086#1073#1072#1074#1083#1077#1085#1080#1077' '#1089#1077#1088#1074#1077#1088#1072
  ClientHeight = 126
  ClientWidth = 289
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
    Top = 43
    Width = 79
    Height = 13
    Caption = #1040#1076#1088#1077#1089' '#1089#1077#1088#1074#1077#1088#1072':'
  end
  object Label2: TLabel
    Left = 8
    Top = 73
    Width = 28
    Height = 13
    Caption = #1055#1086#1088#1090':'
  end
  object Label3: TLabel
    Left = 136
    Top = 72
    Width = 41
    Height = 13
    Caption = #1055#1072#1088#1086#1083#1100':'
  end
  object Label4: TLabel
    Left = 8
    Top = 11
    Width = 53
    Height = 13
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077':'
  end
  object Edit1: TEdit
    Left = 96
    Top = 40
    Width = 185
    Height = 21
    BevelKind = bkSoft
    BorderStyle = bsNone
    TabOrder = 1
  end
  object Edit2: TEdit
    Left = 45
    Top = 69
    Width = 81
    Height = 21
    BevelKind = bkSoft
    BorderStyle = bsNone
    TabOrder = 2
    OnKeyPress = Edit2KeyPress
  end
  object Edit3: TEdit
    Left = 184
    Top = 69
    Width = 97
    Height = 21
    BevelKind = bkSoft
    BorderStyle = bsNone
    TabOrder = 3
  end
  object Button1: TButton
    Left = 44
    Top = 100
    Width = 97
    Height = 20
    Caption = 'OK'
    TabOrder = 4
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 148
    Top = 100
    Width = 97
    Height = 20
    Caption = #1042#1099#1093#1086#1076
    TabOrder = 5
    OnClick = Button2Click
  end
  object Edit4: TEdit
    Left = 96
    Top = 8
    Width = 185
    Height = 21
    BevelKind = bkSoft
    BorderStyle = bsNone
    TabOrder = 0
  end
end
