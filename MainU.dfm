object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Cleanup converted projects'
  ClientHeight = 346
  ClientWidth = 377
  Color = clBtnFace
  Constraints.MinHeight = 380
  Constraints.MinWidth = 385
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  OnCreate = FormCreate
  DesignSize = (
    377
    346)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 222
    Top = 228
    Width = 139
    Height = 79
    Anchors = [akRight, akBottom]
    AutoSize = False
    Caption = 
      'This tool will only cleanup the information of the child build c' +
      'onfigurations, so the parent informations will propegate to the ' +
      'child configuration'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    WordWrap = True
    ExplicitLeft = 214
    ExplicitTop = 279
  end
  object lvProjects: TListView
    Left = 8
    Top = 39
    Width = 361
    Height = 176
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        AutoSize = True
        Caption = 'Filename'
      end
      item
        Width = 25
      end>
    MultiSelect = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 2
    ViewStyle = vsReport
  end
  object btnAddProjects: TButton
    Left = 8
    Top = 8
    Width = 97
    Height = 25
    Action = actnAddProjects
    TabOrder = 0
  end
  object btnRemoveProjects: TButton
    Left = 111
    Top = 8
    Width = 97
    Height = 25
    Action = actnRemoveProjects
    TabOrder = 1
  end
  object btnExecute: TButton
    Left = 8
    Top = 313
    Width = 97
    Height = 25
    Action = actnExecute
    Anchors = [akLeft, akBottom]
    TabOrder = 4
  end
  object ProgressBar1: TProgressBar
    Left = 111
    Top = 318
    Width = 258
    Height = 17
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 5
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 221
    Width = 208
    Height = 86
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'Options'
    TabOrder = 3
    object cbCleanVerInfo: TCheckBox
      Left = 8
      Top = 16
      Width = 192
      Height = 17
      Caption = 'Clean up inherited version info'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object cbCleanMainIcon: TCheckBox
      Left = 8
      Top = 32
      Width = 192
      Height = 17
      Caption = 'Clean up inherited main icon info'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object cbCreateBackup: TCheckBox
      Left = 8
      Top = 64
      Width = 97
      Height = 17
      Caption = 'Create backup'
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
    object cbCleanManifest: TCheckBox
      Left = 8
      Top = 48
      Width = 192
      Height = 17
      Caption = 'Clean up inherited Manifest File info'
      TabOrder = 2
    end
  end
  object ActionList1: TActionList
    Left = 184
    Top = 80
    object actnAddProjects: TFileOpen
      Caption = 'Add projects'
      Dialog.DefaultExt = 'dproj'
      Dialog.Filter = 'Delphi project files|*.dproj'
      Dialog.Options = [ofAllowMultiSelect, ofPathMustExist, ofFileMustExist, ofEnableSizing]
      Dialog.Title = 'Select Delphi projects'
      Hint = 'Add projects to convert'
      ImageIndex = 7
      ShortCut = 16463
      OnAccept = actnAddProjectsAccept
    end
    object actnRemoveProjects: TAction
      Caption = 'Remove projects'
      Hint = 'Remove the selected projects'
      ShortCut = 16430
      OnExecute = actnRemoveProjectsExecute
      OnUpdate = actnRemoveProjectsUpdate
    end
    object actnExecute: TAction
      Caption = 'Execute'
      Hint = 'Execute conversion'
      ShortCut = 120
      OnExecute = actnExecuteExecute
      OnUpdate = actnExecuteUpdate
    end
  end
  object XMLDocument1: TXMLDocument
    Left = 96
    Top = 80
    DOMVendorDesc = 'MSXML'
  end
  object JvAppIniFileStorage1: TJvAppIniFileStorage
    StorageOptions.BooleanStringTrueValues = 'TRUE, YES, Y'
    StorageOptions.BooleanStringFalseValues = 'FALSE, NO, N'
    SubStorages = <>
    Left = 280
    Top = 80
  end
  object JvFormStorage1: TJvFormStorage
    AppStorage = JvAppIniFileStorage1
    AppStoragePath = '%FORM_NAME%\'
    OnSavePlacement = JvFormStorage1SavePlacement
    OnRestorePlacement = JvFormStorage1RestorePlacement
    StoredValues = <>
    Left = 280
    Top = 136
  end
end
