object CopyForm: TCopyForm
  Left = 29
  Top = 235
  AutoScroll = False
  BorderIcons = []
  Caption = 'PRINT & COPY'
  ClientHeight = 227
  ClientWidth = 152
  Color = clBtnFace
  Constraints.MaxHeight = 254
  Constraints.MaxWidth = 160
  Constraints.MinHeight = 254
  Constraints.MinWidth = 160
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object RadioGroup1: TRadioGroup
    Left = 7
    Top = 7
    Width = 138
    Height = 146
    Caption = 'Export graph as:'
    Items.Strings = (
      'copy to clipboard'
      'print in low res.'
      'print in high res.'
      'bitmap file (.bmp)'
      'metafile, low res.'
      'metafile, med res.'
      'metafile, high res.')
    TabOrder = 0
  end
  object BitBtn1: TBitBtn
    Left = 7
    Top = 176
    Width = 62
    Height = 45
    Caption = 'GO'
    Font.Color = clGreen
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = BitBtn1Click
  end
  object BitBtn2: TBitBtn
    Left = 72
    Top = 174
    Width = 73
    Height = 23
    Caption = 'Printer SetUp'
    TabOrder = 2
    OnClick = BitBtn2Click
  end
  object BitBtn3: TBitBtn
    Left = 72
    Top = 198
    Width = 73
    Height = 23
    Caption = 'Cancel'
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnClick = BitBtn3Click
  end
  object ComboBox1: TComboBox
    Left = 7
    Top = 153
    Width = 138
    Height = 22
    Style = csDropDownList
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 4
    OnChange = ComboBox1Change
  end
  object PrinterSetupDialog1: TPrinterSetupDialog
    Left = 48
    Top = 16
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer1Timer
    Left = 92
    Top = 16
  end
end
