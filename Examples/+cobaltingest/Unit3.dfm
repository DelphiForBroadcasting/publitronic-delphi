object Form3: TForm3
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Preview'
  ClientHeight = 232
  ClientWidth = 456
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 456
    Height = 190
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
  end
  object Panel2: TPanel
    Left = 0
    Top = 190
    Width = 456
    Height = 2
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 1
  end
  object Panel3: TPanel
    Left = 0
    Top = 192
    Width = 456
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      456
      40)
    object Button1: TButton
      Left = 366
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Save'
      TabOrder = 1
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 285
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Cancel'
      TabOrder = 0
      OnClick = Button2Click
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 192
    Top = 120
    object DateTimeoptions1: TMenuItem
      Caption = 'DateTime options'
      Enabled = False
    end
    object Addyearyyyy1: TMenuItem
      Caption = 'Add year ($yyyy)'
      OnClick = Addyearyyyy1Click
    end
    object Addmounnthmm1: TMenuItem
      Caption = 'Add mounth ($MM)'
      OnClick = Addmounnthmm1Click
    end
    object d1: TMenuItem
      Caption = 'Add day ($dd)'
      OnClick = d1Click
    end
    object Addhourhh1: TMenuItem
      Caption = 'Add hour ($HH)'
      OnClick = Addhourhh1Click
    end
    object Addminutemm1: TMenuItem
      Caption = 'Add minute ($mm)'
      OnClick = Addminutemm1Click
    end
    object Addsecss1: TMenuItem
      Caption = 'Add sec ($ss)'
      OnClick = Addsecss1Click
    end
    object Addmseczzz1: TMenuItem
      Caption = 'Add msec ($zzz)'
      OnClick = Addmseczzz1Click
    end
    object Adddateyyyymmdd1: TMenuItem
      Caption = 'Add date ($yyyy-$MM-$dd)'
      OnClick = Adddateyyyymmdd1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Otheroptions1: TMenuItem
      Caption = 'Other options'
      Enabled = False
    end
    object Addfilenamefn1: TMenuItem
      Caption = 'Add filename ($fn)'
      OnClick = Addfilenamefn1Click
    end
    object Addrandomnumericr1001: TMenuItem
      Caption = 'Add random numeric ($r[100])'
      OnClick = Addrandomnumericr1001Click
    end
  end
end
