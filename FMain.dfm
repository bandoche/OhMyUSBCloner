object TFMain: TTFMain
  Left = 181
  Top = 136
  Width = 1022
  Height = 713
  Caption = 'TFMain'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object LabelCount: TLabel
    Left = 416
    Top = 400
    Width = 54
    Height = 13
    Caption = 'LabelCount'
  end
  object lstConsole: TListBox
    Left = 0
    Top = 32
    Width = 625
    Height = 121
    ImeName = 'Microsoft Office IME 2007'
    ItemHeight = 13
    TabOrder = 0
  end
  object Button1: TButton
    Left = 504
    Top = 328
    Width = 57
    Height = 57
    Caption = 'Button1'
    TabOrder = 1
    OnClick = Button1Click
  end
  object FileList: TListBox
    Left = 584
    Top = 248
    Width = 153
    Height = 265
    ImeName = 'Microsoft Office IME 2007'
    ItemHeight = 13
    TabOrder = 2
  end
  object EditStartDir: TEdit
    Left = 408
    Top = 328
    Width = 89
    Height = 21
    ImeName = 'Microsoft Office IME 2007'
    TabOrder = 3
    Text = 'EditStartDir'
  end
  object EditFileMask: TEdit
    Left = 408
    Top = 360
    Width = 89
    Height = 21
    ImeName = 'Microsoft Office IME 2007'
    TabOrder = 4
    Text = 'EditFileMask'
  end
  object ListBox1: TListBox
    Left = 744
    Top = 248
    Width = 153
    Height = 265
    ImeName = 'Microsoft Office IME 2007'
    ItemHeight = 13
    TabOrder = 5
  end
  object rxtMain: TRxTrayIcon
    Icon.Data = {
      0000010001001010000001002000680400001600000028000000100000002000
      0000010020000000000000000000000000000000000000000000000000008385
      88FF808287FF292A2EFF0B0B0DFF0C0E0DFF0F0D0FFF0C0B0AFF262A2CFF1B20
      21FF0F1312FF1B2020FF1E2323FF1C1F24FF676F7BFFE2E6E5FFE0E2E2FF8587
      8BFF878A8DFF2C2F30FF0E0C0EFF11110AFF13100CFF0B080DFF42494EFF3338
      3BFF100E11FF171616FF1A1E1AFF1A1E22FF5D6571FFDEE1DFFFE1E3E2FF8E91
      94FF8C8E92FF313334FF131011FF14130EFF151310FF110F0EFF444B50FF3C42
      45FF110E0EFF1B181AFF1E201EFF19191EFF5D6473FFDCDEDEFFE4E5E4FFA6A9
      ABFF919397FF363839FF161413FF16140FFF18180FFF14130EFF1A1B19FF1D1E
      1FFF171215FF1D1C1BFF20241CFF1D1F24FF5D6574FFD9DBDBFFE8E9E8FFBFC1
      C2FFAEB0B2FF545757FF323331FF31332EFF323631FF30352EFF2D302BFF3234
      34FF383A3AFF3D3F3FFF424342FF4B4D55FF818792FFE2E5E4FFE6E7E7FFC6C7
      C8FFC3C4C5FFABADAEFF6E6F72FF303233FF242322FF242225FF22241FFF2526
      21FF262824FF2A2A25FF282B24FF737572FFDDDDDCFFE7E9E8FFE3E6E5FFD2D2
      D2FFD0D0CFFFB4B5B6FF707175FF222120FF171D1AFF161C1AFF192121FF1C24
      29FF1E2524FF222C28FF1E251EFF73746FFFE6E5E5FFE5E6E6FFE5E7E6FFDCDC
      DCFFD8D9D9FFAFB0B2FF6F7074FF27271EFF355561FF314D59FF3E6375FF416C
      82FF3B5C6AFF457185FF31474DFF74716CFFE3E3E3FFE7E9E9FFE6E7E7FFDCDC
      DEFFD8D8D9FFB3B3B5FF737378FF2B2E27FF416470FF3E5B69FF466F82FF4979
      90FF466877FF527F95FF3B525CFF757471FFE3E3E3FFEAEBEAFFE9EAEAFFDFDF
      E1FFDADADAFFB4B5B7FF76777DFF373732FF456572FF44606DFF4B6E81FF4F78
      8DFF486879FF537F95FF425962FF7B7B77FFE4E4E4FFEDEDEDFFECEDEDFFE0E0
      E1FFDADADBFFB7B9BAFF7A7B80FF3F3F3CFF4D6C7BFF4C6777FF5A8298FF5C8C
      A4FF54798BFF5B8AA2FF4D6370FF81817EFFE7E8E7FFEFEFEFFFF0F1F2FFE1E2
      E3FFD9D9DAFFBCBDBEFF828488FF454543FF61899EFF5A7C8FFF597587FF5D7E
      8FFF566F7DFF6B9FBAFF57707DFF8A8985FFEBEBEBFFF0F1F0FFF2F4F4FFE2E2
      E4FFDADADAFFC3C4C5FFA6A6A8FF5C5D5EFF5A6A71FF59656CFF4F4D4CFF5050
      50FF535351FF687983FF60696CFFA5A5A2FFF6F6F6FFF2F3F3FFF2F4F4FFE1E2
      E4FFDADBDBFFCCCDCDFFC1C2C3FFB8B9B9FFB5B3B1FFBBB9B8FFC4C3C2FFCBCA
      C9FFD2D1D0FFD9D6D3FFE3E0DEFFF3F2F2FFF7F7F6FFF3F4F3FFF6F7F7FFE2E3
      E4FFDBDCDCFFD3D4D4FFD1D1D1FFD6D5D6FFDEDDDFFFE3E3E4FFE9E9E9FFF1F1
      F1FFF7F7F6FFFCFCFBFFFEFEFEFFFDFDFCFFF7F8F7FFF5F6F6FFF9FAF9FFE1E3
      E5FFDCDDDDFFD5D6D6FFD3D5D4FFD6D6D6FFDDDCDFFFE4E4E6FFECECECFFF3F2
      F2FFF8F8F8FFFBFBFBFFFCFCFCFFFBFCFBFFF9F9F9FFF8F9F9FFF8FAFAFF0000
      AC410000AC410000AC410000AC410000AC410000AC410000AC410000AC410000
      AC410000AC410000AC410000AC410000AC410000AC410000AC410000AC41}
    PopupMenu = pmuMain
  end
  object pmuMain: TPopupMenu
    Left = 32
    object pmuAbout: TMenuItem
      Caption = #51221#48372' (&A)...'
      OnClick = pmuAboutClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object pmuExit: TMenuItem
      Caption = #51333#47308' (&X)'
      OnClick = pmuExitClick
    end
  end
end
