object SegFileEdit: TSegFileEdit
  Left = 213
  Top = 101
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  ClientHeight = 406
  ClientWidth = 481
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
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 465
    Height = 73
    Caption = ' '#1056#1072#1079#1076#1077#1083' '
    TabOrder = 0
    object btNewSec: TButton
      Left = 328
      Top = 18
      Width = 113
      Height = 19
      Caption = #1053#1086#1074#1099#1081' '#1088#1072#1079#1076#1077#1083
      TabOrder = 0
      OnClick = btNewSecClick
    end
    object btDelSec: TButton
      Left = 328
      Top = 42
      Width = 113
      Height = 19
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1088#1072#1079#1076#1077#1083
      TabOrder = 1
      OnClick = btDelSecClick
    end
    object cbSegm: TComboBox
      Left = 16
      Top = 28
      Width = 265
      Height = 21
      BevelKind = bkSoft
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
      OnChange = cbSegmChange
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 80
    Width = 465
    Height = 293
    Caption = ' '#1076#1072#1085#1085#1099#1077' '#1088#1072#1079#1076#1077#1083#1072' '
    TabOrder = 1
    object lbData: TListBox
      Left = 8
      Top = 16
      Width = 449
      Height = 241
      ItemHeight = 13
      MultiSelect = True
      TabOrder = 0
    end
    object btDelString: TButton
      Left = 8
      Top = 264
      Width = 120
      Height = 19
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1089#1090#1088#1086#1082#1091
      TabOrder = 1
      OnClick = btDelStringClick
    end
    object btAddString: TButton
      Left = 136
      Top = 264
      Width = 120
      Height = 19
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089#1090#1088#1086#1082#1091
      TabOrder = 2
      OnClick = btAddStringClick
    end
  end
  object btExit: TButton
    Left = 392
    Top = 380
    Width = 81
    Height = 19
    Caption = #1042#1099#1093#1086#1076
    TabOrder = 2
    OnClick = btExitClick
  end
  object btHandEdit: TButton
    Left = 232
    Top = 380
    Width = 153
    Height = 19
    Caption = #1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100' '#1074#1088#1091#1095#1085#1091#1102
    TabOrder = 3
    OnClick = btHandEditClick
  end
end
