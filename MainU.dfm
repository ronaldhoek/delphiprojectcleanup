object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Cleanup converted projects'
  ClientHeight = 342
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
    342)
  PixelsPerInch = 96
  TextHeight = 13
  object lblInfo: TLabel
    Left = 222
    Top = 200
    Width = 139
    Height = 95
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
  end
  object lblProjectCount: TLabel
    Left = 293
    Top = 23
    Width = 73
    Height = 13
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    Caption = 'lblProjectCount'
  end
  object lvProjects: TListView
    Left = 8
    Top = 39
    Width = 361
    Height = 139
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
    Top = 309
    Width = 97
    Height = 25
    Action = actnExecute
    Anchors = [akLeft, akBottom]
    TabOrder = 4
    ExplicitTop = 313
  end
  object ProgressBar1: TProgressBar
    Left = 111
    Top = 314
    Width = 258
    Height = 17
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 5
    ExplicitTop = 318
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 184
    Width = 208
    Height = 119
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'Options'
    TabOrder = 3
    object cbCleanVerInfo: TCheckBox
      Left = 8
      Top = 16
      Width = 192
      Height = 17
      Hint = 
        'Removes versioninformation which is stored voor an specific buil' +
        'd configuration'
      Caption = 'Clean up inherited version info'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object cbCleanMainIcon: TCheckBox
      Left = 8
      Top = 48
      Width = 192
      Height = 17
      Hint = 
        'Removes main icon specification which is stored voor an specific' +
        ' build configuration'
      Caption = 'Clean up inherited main icon info'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
    object cbCreateBackup: TCheckBox
      Left = 8
      Top = 80
      Width = 97
      Height = 17
      Hint = 'Create a backup of the original file, before it is modified'
      Caption = 'Create backup'
      Checked = True
      State = cbChecked
      TabOrder = 4
    end
    object cbCleanManifest: TCheckBox
      Left = 8
      Top = 64
      Width = 192
      Height = 17
      Hint = 
        'Removes manifest information which is stored voor an specific bu' +
        'ild configuration. USE WITH CARE (make backup!!!)'
      Caption = 'Clean up inherited Manifest File info'
      TabOrder = 3
    end
    object cbCreateLog: TCheckBox
      Left = 102
      Top = 81
      Width = 74
      Height = 17
      Hint = 'Log modifications'
      Caption = 'Create log'
      Checked = True
      State = cbChecked
      TabOrder = 5
    end
    object cbCleanObsoleteVerinfo: TCheckBox
      Left = 8
      Top = 32
      Width = 197
      Height = 17
      Hint = 
        'Removes te '#39'old'#39' obsolete versioninformation from older Delphi v' +
        'ersion'
      Caption = 'Clean up '#39'old'#39' version info'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object cbOldStyleXMLFormat: TCheckBox
      Left = 8
      Top = 96
      Width = 185
      Height = 17
      Hint = 
        'With some Delphi versions (XE?) the projectfile XML uses TABs as' +
        ' indents and adds one in front'
      Caption = 'Old XML text format (XE?/older)'
      TabOrder = 6
    end
  end
  object ActionList1: TActionList
    Left = 184
    Top = 80
    object actnAddProjects: TFileOpen
      Caption = 'Add projects'
      Dialog.DefaultExt = 'dproj'
      Dialog.Filter = 'Delphi project(group) files|*.dproj;*.groupproj'
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
    StoredProps.Strings = (
      'cbCleanMainIcon.Checked'
      'cbCleanManifest.Checked'
      'cbCleanVerInfo.Checked'
      'cbCreateBackup.Checked'
      'cbCreateLog.Checked'
      'cbCleanObsoleteVerinfo.Checked'
      'cbOldStyleXMLFormat.Checked')
    StoredValues = <>
    Left = 280
    Top = 136
  end
end
