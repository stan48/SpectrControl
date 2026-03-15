object proc: Tproc
  Left = 132
  Top = 48
  Width = 812
  Height = 614
  Caption = #1057#1087#1077#1082#1090#1088#1086#1084#1077#1090#1088' '#1044#1060#1057'-52 ['#1054#1073#1088#1072#1073#1086#1090#1082#1072' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1086#1074']'
  Color = 15396589
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ControlBar2: TControlBar
    Left = 0
    Top = 0
    Width = 804
    Height = 26
    Align = alTop
    AutoDock = False
    AutoSize = True
    BevelEdges = []
    TabOrder = 0
    object tbControl: TToolBar
      Left = 185
      Top = 2
      Width = 99
      Height = 22
      AutoSize = True
      Caption = 'tbControl'
      Customizable = True
      DockSite = True
      EdgeBorders = [ebLeft, ebRight, ebBottom]
      EdgeInner = esNone
      EdgeOuter = esNone
      Flat = True
      TabOrder = 0
      object ToolButton5: TToolButton
        Left = 0
        Top = 0
        Caption = 'ToolButton5'
        ImageIndex = 0
      end
      object ToolButton3: TToolButton
        Left = 23
        Top = 0
        Caption = 'ToolButton3'
        ImageIndex = 1
      end
      object ToolButton1: TToolButton
        Left = 46
        Top = 0
        Caption = 'ToolButton1'
        ImageIndex = 2
      end
      object ToolButton6: TToolButton
        Left = 69
        Top = 0
        Caption = 'ToolButton6'
        ImageIndex = 3
      end
    end
    object tbMenu: TToolBar
      Left = 11
      Top = 2
      Width = 158
      Height = 21
      AutoSize = True
      ButtonHeight = 21
      ButtonWidth = 50
      Caption = 'tbMenu'
      EdgeBorders = []
      EdgeInner = esNone
      EdgeOuter = esNone
      Flat = True
      ShowCaptions = True
      TabOrder = 1
      object ToolButton2: TToolButton
        Left = 0
        Top = 0
        Caption = #1060#1072#1081#1083
        Grouped = True
      end
      object ToolButton8: TToolButton
        Left = 50
        Top = 0
        Caption = #1057#1077#1088#1074#1080#1089
      end
      object ToolButton7: TToolButton
        Left = 100
        Top = 0
        Caption = #1057#1087#1088#1072#1074#1082#1072
      end
    end
  end
  object Chart1: TChart
    Left = 0
    Top = 26
    Width = 804
    Height = 425
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Title.AdjustFrame = False
    Title.Text.Strings = (
      'TChart')
    Title.Visible = False
    Legend.Visible = False
    View3D = False
    Align = alTop
    Color = 15396589
    TabOrder = 1
    object Series1: TLineSeries
      Marks.ArrowLength = 8
      Marks.Visible = False
      SeriesColor = clRed
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.DateTime = False
      XValues.Name = 'X'
      XValues.Multiplier = 1.000000000000000000
      XValues.Order = loAscending
      YValues.DateTime = False
      YValues.Name = 'Y'
      YValues.Multiplier = 1.000000000000000000
      YValues.Order = loNone
    end
  end
  object GroupBox3: TGroupBox
    Left = 0
    Top = 456
    Width = 804
    Height = 124
    Align = alBottom
    Caption = 'GroupBox3'
    TabOrder = 2
  end
end
