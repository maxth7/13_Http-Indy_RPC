object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Client Indy RPC'
  ClientHeight = 469
  ClientWidth = 618
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object Label1: TLabel
    Left = 8
    Top = 1
    Width = 302
    Height = 21
    Caption = 'Received from the server in XML format'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 394
    Top = 1
    Width = 135
    Height = 21
    Caption = 'After parsing XML'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object MemoMess: TMemo
    Left = 8
    Top = 32
    Width = 321
    Height = 314
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    Lines.Strings = (
      '')
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object GetAllFuctions: TButton
    Left = 316
    Top = 361
    Width = 299
    Height = 100
    Caption = 'Get all name functions'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = GetAllFuctionsClick
  end
  object MemoOutParseXML: TMemo
    Left = 320
    Top = 33
    Width = 292
    Height = 313
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    Lines.Strings = (
      '')
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object GroupBox1: TGroupBox
    Left = 13
    Top = 352
    Width = 297
    Height = 109
    Caption = 'Select  Function'
    DefaultHeaderFont = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = []
    HeaderFont.Charset = DEFAULT_CHARSET
    HeaderFont.Color = clGreen
    HeaderFont.Height = -13
    HeaderFont.Name = 'Segoe UI'
    HeaderFont.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    object LabelNumberFunctions: TLabel
      Left = 3
      Top = 24
      Width = 213
      Height = 21
      Caption = 'Total functions on the server:'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clGreen
      Font.Height = -16
      Font.Name = 'Segoe UI Semibold'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object ComboBoxFunc: TComboBox
      Left = 3
      Top = 51
      Width = 270
      Height = 25
      TabOrder = 0
      OnChange = ComboBoxFuncChange
    end
  end
  object IdHTTP1: TIdHTTP
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 704
    Top = 320
  end
end
