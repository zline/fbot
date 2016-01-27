object DSegFileEdit: TDSegFileEdit
  Left = 97
  Top = 13
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  ClientHeight = 499
  ClientWidth = 689
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
  object Label2: TLabel
    Left = 8
    Top = 88
    Width = 269
    Height = 13
    Caption = #1060#1088#1072#1079#1072' ('#1080#1083#1080' '#1075#1088#1091#1087#1087#1072' '#1092#1088#1072#1079'), '#1085#1072' '#1082#1086#1090#1086#1088#1099#1077' '#1073#1086#1090' '#1088#1077#1072#1075#1080#1088#1091#1077#1090':'
  end
  object Label3: TLabel
    Left = 8
    Top = 128
    Width = 83
    Height = 13
    Caption = #1056#1077#1072#1075#1080#1088#1086#1074#1072#1090#1100' '#1085#1072':'
  end
  object Label4: TLabel
    Left = 232
    Top = 128
    Width = 46
    Height = 13
    Caption = #1056#1077#1072#1082#1094#1080#1103':'
  end
  object Bevel1: TBevel
    Left = 8
    Top = 463
    Width = 673
    Height = 2
  end
  object Bevel2: TBevel
    Left = 224
    Top = 131
    Width = 2
    Height = 326
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 449
    Height = 73
    Caption = ' '#1050#1072#1085#1072#1083' '
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 16
      Width = 289
      Height = 13
      Caption = #1050#1072#1085#1072#1083', '#1073#1072#1079#1091' '#1076#1080#1072#1083#1086#1075#1072' '#1082#1086#1090#1086#1088#1086#1075#1086' '#1042#1099' '#1093#1086#1090#1080#1090#1077' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100':'
    end
    object btNewSec: TButton
      Left = 328
      Top = 18
      Width = 113
      Height = 19
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1082#1072#1085#1072#1083
      TabOrder = 0
      OnClick = btNewSecClick
    end
    object btDelSec: TButton
      Left = 328
      Top = 42
      Width = 113
      Height = 19
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1082#1072#1085#1072#1083
      TabOrder = 1
      OnClick = btDelSecClick
    end
    object cbSection: TComboBox
      Left = 16
      Top = 36
      Width = 289
      Height = 21
      BevelKind = bkSoft
      Style = csDropDownList
      DropDownCount = 20
      ItemHeight = 13
      TabOrder = 2
      OnChange = cbSectionChange
    end
  end
  object btHandEdit: TButton
    Left = 440
    Top = 473
    Width = 153
    Height = 21
    Caption = #1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100' '#1074#1088#1091#1095#1085#1091#1102
    TabOrder = 1
    OnClick = btHandEditClick
  end
  object btExit: TButton
    Left = 600
    Top = 473
    Width = 81
    Height = 21
    Caption = #1042#1099#1093#1086#1076
    TabOrder = 2
    OnClick = btExitClick
  end
  object cbSubSec: TComboBox
    Left = 8
    Top = 104
    Width = 601
    Height = 21
    BevelKind = bkSoft
    Style = csDropDownList
    DropDownCount = 20
    ItemHeight = 13
    TabOrder = 3
    OnChange = cbSubSecChange
  end
  object btAddSubSec: TButton
    Left = 8
    Top = 438
    Width = 104
    Height = 19
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    TabOrder = 4
    OnClick = btAddSubSecClick
  end
  object btDelSubSec: TButton
    Left = 116
    Top = 438
    Width = 101
    Height = 19
    Caption = #1059#1076#1072#1083#1080#1090#1100
    TabOrder = 5
    OnClick = btDelSubSecClick
  end
  object btDelReact: TButton
    Left = 340
    Top = 438
    Width = 101
    Height = 19
    Caption = #1059#1076#1072#1083#1080#1090#1100
    TabOrder = 6
    OnClick = btDelReactClick
  end
  object btAddReact: TButton
    Left = 232
    Top = 438
    Width = 104
    Height = 19
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    TabOrder = 7
    OnClick = btAddReactClick
  end
  object lbReact: TListBox
    Left = 232
    Top = 144
    Width = 449
    Height = 289
    ItemHeight = 13
    TabOrder = 8
    OnKeyDown = lbReactKeyDown
  end
  object lbSubSec: TListBox
    Left = 8
    Top = 144
    Width = 209
    Height = 289
    ItemHeight = 13
    TabOrder = 9
  end
  object btNewGroup: TButton
    Left = 618
    Top = 96
    Width = 63
    Height = 17
    Caption = #1085#1086#1074#1072#1103
    TabOrder = 10
    OnClick = btNewGroupClick
  end
  object btDelGroup: TButton
    Left = 618
    Top = 116
    Width = 63
    Height = 17
    Caption = #1091#1076#1072#1083#1080#1090#1100
    TabOrder = 11
    OnClick = btDelGroupClick
  end
end
