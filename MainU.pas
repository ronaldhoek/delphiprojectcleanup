unit MainU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Forms, Vcl.ComCtrls, Vcl.ActnList, Vcl.StdActns, Vcl.Controls, Vcl.StdCtrls,
  Xml.xmldom, Xml.XMLIntf, Xml.Win.msxmldom, Xml.XMLDoc, JvFormPlacement,
  JvComponentBase, JvAppStorage, JvAppIniStorage;

type
  TCleanOptions = set of (coCreateBackup, coVerInfo, coMainIcon, coManifest);

  TfrmMain = class(TForm)
    ActionList1: TActionList;
    actnAddProjects: TFileOpen;
    actnExecute: TAction;
    actnRemoveProjects: TAction;
    btnAddProjects: TButton;
    btnExecute: TButton;
    btnRemoveProjects: TButton;
    cbCleanMainIcon: TCheckBox;
    cbCleanManifest: TCheckBox;
    cbCleanVerInfo: TCheckBox;
    cbCreateBackup: TCheckBox;
    GroupBox1: TGroupBox;
    JvAppIniFileStorage1: TJvAppIniFileStorage;
    JvFormStorage1: TJvFormStorage;
    Label1: TLabel;
    lvProjects: TListView;
    ProgressBar1: TProgressBar;
    XMLDocument1: TXMLDocument;
    procedure actnAddProjectsAccept(Sender: TObject);
    procedure actnExecuteExecute(Sender: TObject);
    procedure actnExecuteUpdate(Sender: TObject);
    procedure actnRemoveProjectsExecute(Sender: TObject);
    procedure actnRemoveProjectsUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure JvFormStorage1RestorePlacement(Sender: TObject);
    procedure JvFormStorage1SavePlacement(Sender: TObject);
    procedure WMDropFiles(var Message: TWMDropFiles); message WM_DROPFILES;
  private
    procedure AddFile(aFilename: string);
    function CleanupProjectFile(const aFilename: string; aCleanupOptions:
        TCleanOptions): Boolean;
    function GetCleanOptions(out oOptions: TCleanOptions): Boolean;
  protected
    procedure ListItemsDeleteItem(Sender: TJvCustomAppStorage; const Path: string;
        const List: TObject; const First, Last: Integer; const ItemName: string);
    procedure ListItemsReadItem(Sender: TJvCustomAppStorage; const Path: string;
        const List: TObject; const Index: Integer; const ItemName: string);
    procedure ListItemsWriteItem(Sender: TJvCustomAppStorage; const Path: string;
        const List: TObject; const Index: Integer; const ItemName: string);
  end;

var
  frmMain: TfrmMain;

implementation

uses
  Dialogs, ShellApi;

{$R *.dfm}

procedure TfrmMain.actnAddProjectsAccept(Sender: TObject);
var
  s: string;
begin
  with (Sender as TFileOpen).Dialog do
    for S in Files do AddFile(S);
end;

procedure TfrmMain.actnExecuteExecute(Sender: TObject);
var
  I: Integer;
  _CleanOptions: TCleanOptions;
begin
  if GetCleanOptions(_CleanOptions) then
  begin
    ProgressBar1.Position := 0;
    ProgressBar1.Max := lvProjects.Items.Count;
    for I := 0 to lvProjects.Items.Count - 1 do
    begin
      lvProjects.Items[I].SubItems.Clear;
      if CleanupProjectFile(lvProjects.Items[I].Caption, _CleanOptions) then
        lvProjects.Items[I].SubItems.Add('*');

      ProgressBar1.StepBy(1);
    end;
    lvProjects.Invalidate;
  end else
    ShowMessage('No cleanup options selected!');
end;

procedure TfrmMain.actnExecuteUpdate(Sender: TObject);
begin
  (Sender as TCustomAction).Enabled := lvProjects.Items.Count > 0;
end;

procedure TfrmMain.actnRemoveProjectsExecute(Sender: TObject);
begin
  lvProjects.DeleteSelected;
end;

procedure TfrmMain.actnRemoveProjectsUpdate(Sender: TObject);
begin
  (Sender as TCustomAction).Enabled := lvProjects.SelCount > 0;
end;

procedure TfrmMain.AddFile(aFilename: string);
begin
  if FileExists(aFilename) and
     (lvProjects.FindCaption(0, aFilename, False, True, False) = nil) then
    lvProjects.Items.Add.Caption := aFilename;
end;

function TfrmMain.CleanupProjectFile(const aFilename: string; aCleanupOptions:
    TCleanOptions): Boolean;
const
  sVerinfoPrefix = 'VerInfo_';
var
  I, J: Integer;
  vCondition: Variant;
  _PropertyNode, _CurSubNode: IXMLNode;
  _Root: IXMLNode;
  _Log: TStrings;
begin
  // Open file
  Result := False;
  try
    XMLDocument1.LoadFromFile(aFilename);
  except
    Exit;
  end;
  _Root := XMLDocument1.DocumentElement;
  _Log := TStringList.Create;
  try
    // Loop thru PropertyGroups
    for I := 0 to _Root.ChildNodes.Count - 1 do
    begin
      _PropertyNode := _Root.ChildNodes[I];
      if SameText('PropertyGroup', _PropertyNode.NodeName) then
      begin
        vCondition := _PropertyNode.Attributes['Condition'];
        if not (VarIsNull(vCondition) or SameText(VarToStr(vCondition), '''$(Base)''!=''''')) then
        begin
          _Log.Add('Cleanup config: ' + _PropertyNode.NodeName + ' - ' + _PropertyNode.Attributes['Condition']);
          for J := _PropertyNode.ChildNodes.Count - 1 downto 0 do
          begin
            _CurSubNode := _PropertyNode.ChildNodes[J];
            // Find nodes to cleanup
            if SameText(_CurSubNode.NodeName, 'Version') or
               SameText(Copy(_CurSubNode.NodeName, 1, Length(sVerInfoPrefix)), sVerInfoPrefix) then
            begin
              if not (coVerInfo in aCleanupOptions) then Continue;

              _Log.Add('- Removed: ' + _CurSubNode.XML);
              _CurSubNode := nil;
              _PropertyNode.ChildNodes.Delete(J);
              Result := True;
            end else
              if SameText(_CurSubNode.NodeName, 'Icon_MainIcon') then
            begin
              if not (coMainIcon in aCleanupOptions) then Continue;

              _Log.Add('- Removed: ' + _CurSubNode.XML);
              _CurSubNode := nil;
              _PropertyNode.ChildNodes.Delete(J);
              Result := True;
            end else
              if SameText(_CurSubNode.NodeName, 'Manifest_File') then
            begin
              if not (coManifest in aCleanupOptions) then Continue;

              _Log.Add('- Removed: ' + _CurSubNode.XML);
              _CurSubNode := nil;
              _PropertyNode.ChildNodes.Delete(J);
              Result := True;
            end;
          end;
        end;
      end;
    end;

    // Are there modifications?
    if Result then
    begin
      // If file is readonly, ask to overwrite it and remove readonly attribute...
      if (FileGetAttr(aFilename, False) and faReadOnly) <> 0 then
      begin
        if Application.MessageBox(PChar(Format('Overwrite readonly file "%s"', [ExtractFileName(aFilename)])), 'Confirm', MB_ICONQUESTION or MB_YESNO) = ID_YES then
          FileSetAttr(aFilename, FileGetAttr(aFilename, False) - faReadOnly, False)
        else
          Exit(False); // Exit
      end;

      // Create backup?
      if (coCreateBackup in aCleanupOptions) and not CopyFile(PChar(aFilename), PChar(aFilename + '.bak'), False) then
          raise Exception.Create('Cannot create backup!');

      // Save log
      _Log.SaveToFile(aFilename + '.log');

      // Save file again
      XMLDocument1.SaveToFile();
    end;
  finally
    _Log.Free;
    XMLDocument1.Active := False; // Close
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  DragAcceptFiles(Handle, True);
  JvAppIniFileStorage1.FileName := ChangeFileExt(Application.ExeName, '.ini');
end;

function TfrmMain.GetCleanOptions(out oOptions: TCleanOptions): Boolean;
begin
  oOptions := [];
  // Items to cleanup
  if cbCleanVerInfo.Checked then Include(oOptions, coVerInfo);
  if cbCleanMainIcon.Checked then Include(oOptions, coMainIcon);
  if cbCleanManifest.Checked then Include(oOptions, coManifest);

  if oOptions <> [] then
  begin
    // Backup optie nog toevoegen
    if cbCreateBackup.Checked then Include(oOptions, coCreateBackup);
    Result := True;
  end else
    Result := False;
end;

procedure TfrmMain.JvFormStorage1RestorePlacement(Sender: TObject);
var
  FormStore: TJvFormStorage;
  sPath: String;
begin
  FormStore := (Sender as TJvFormStorage);
  sPath := FormStore.AppStorage.ConcatPaths([FormStore.AppStoragePath, FormStore.StoredPropsPath, 'LastItems']);

  lvProjects.Items.BeginUpdate;
  try
    FormStore.AppStorage.ReadList(sPath, lvProjects.Items, ListItemsReadItem);
  finally
    lvProjects.Items.EndUpdate;
  end;
end;

procedure TfrmMain.JvFormStorage1SavePlacement(Sender: TObject);
var
  FormStore: TJvFormStorage;
  sPath: String;
begin
  FormStore := (Sender as TJvFormStorage);
  sPath := FormStore.AppStorage.ConcatPaths([FormStore.AppStoragePath, FormStore.StoredPropsPath, 'LastItems']);
  FormStore.AppStorage.WriteList(sPath, lvProjects.Items, lvProjects.Items.Count, ListItemsWriteItem, ListItemsDeleteItem);
end;

procedure TfrmMain.ListItemsDeleteItem(Sender: TJvCustomAppStorage; const Path:
    string; const List: TObject; const First, Last: Integer; const ItemName:
    string);
var
  I: Integer;
begin
  if List is TListItems then
    for I := First to Last do
      Sender.DeleteValue(Sender.ConcatPaths([Path, ItemName + IntToStr(I)]));
end;

procedure TfrmMain.ListItemsReadItem(Sender: TJvCustomAppStorage; const Path:
    string; const List: TObject; const Index: Integer; const ItemName: string);
var
  NewItem: TListItem;
  NewPath: string;
begin
  if List is TListItems then
  begin
    NewPath := Sender.ConcatPaths([Path, Sender.ItemNameIndexPath (ItemName, Index)]);
    NewItem := TListItems(List).Add;
    NewItem.Caption := Sender.ReadString(NewPath);
    // Sender.ReadPersistent(NewPath, NewItem);
  end;
end;

procedure TfrmMain.ListItemsWriteItem(Sender: TJvCustomAppStorage; const Path:
    string; const List: TObject; const Index: Integer; const ItemName: string);
var
  Item: TListItem;
begin
  if List is TListItems then
  begin
    Item := TListItems(List).Item[Index];
    if Assigned(Item) then
      Sender.WriteString(Sender.ConcatPaths([Path, Sender.ItemNameIndexPath (ItemName, Index)]), Item.Caption);
      // Sender.WritePersistent(Sender.ConcatPaths([Path, Sender.ItemNameIndexPath (ItemName, Index)]), TPersistent(Item));
  end;
end;

procedure TfrmMain.WMDropFiles(var Message: TWMDropFiles);
var
  num: integer;
  aFileName: array[0..MAX_PATH] of char;
  i: Integer;
begin
  num := DragQueryFile(Message.Drop, $FFFFFFFF, aFileName, 0);
  if num < 1 then Exit;

  for i:=0 to num-1 do
  begin
    DragQueryFile(Message.Drop, i, aFileName, MAX_PATH-1);
    AddFile(aFileName);
  end;
  DragFinish(Message.Drop);
end;

end.
