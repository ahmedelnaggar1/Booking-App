object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 299
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inline Frame11: TFrame1
    Left = 120
    Top = 0
    Width = 320
    Height = 240
    Color = clAppWorkSpace
    ParentBackground = False
    ParentColor = False
    TabOrder = 0
    ExplicitLeft = 120
  end
  object mainConnection: TSQLConnection
    DriverName = 'Sqlite'
    Params.Strings = (
      'DriverUnit=Data.DbxSqlite'
      
        'DriverPackageLoader=TDBXSqliteDriverLoader,DBXSqliteDriver210.bp' +
        'l'
      
        'MetaDataPackageLoader=TDBXSqliteMetaDataCommandFactory,DbxSqlite' +
        'Driver210.bpl'
      'FailIfMissing=True'
      'Database=main.db')
    Left = 520
    Top = 176
  end
end