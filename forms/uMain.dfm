object FormMain: TFormMain
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1043#1077#1085#1077#1088#1072#1090#1086#1088' '#1085#1072#1090#1091#1088#1072#1083#1100#1085#1099#1093' '#1095#1080#1089#1077#1083
  ClientHeight = 121
  ClientWidth = 408
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lblMsg: TLabel
    AlignWithMargins = True
    Left = 8
    Top = 91
    Width = 392
    Height = 30
    Margins.Left = 8
    Margins.Top = 0
    Margins.Right = 8
    Align = alBottom
    AutoSize = False
    WordWrap = True
  end
  object lblLimitat: TLabel
    Left = 7
    Top = 5
    Width = 67
    Height = 13
    Caption = #1054#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077
  end
  object edtLimitat: TEdit
    Left = 7
    Top = 23
    Width = 121
    Height = 21
    TabOrder = 0
    Text = '10000'
  end
  object Panel1: TPanel
    Left = 0
    Top = 50
    Width = 408
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnRun: TButton
      Left = 7
      Top = 6
      Width = 75
      Height = 26
      Caption = #1047#1072#1087#1091#1089#1090#1080#1090#1100
      TabOrder = 0
      OnClick = btnRunClick
    end
    object btnCancel: TButton
      Left = 88
      Top = 6
      Width = 75
      Height = 26
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      TabOrder = 1
      OnClick = btnCancelClick
    end
    object ProgressBar: TProgressBar
      AlignWithMargins = True
      Left = 168
      Top = 10
      Width = 119
      Height = 17
      Margins.Left = 8
      Margins.Right = 8
      TabOrder = 2
    end
  end
end
