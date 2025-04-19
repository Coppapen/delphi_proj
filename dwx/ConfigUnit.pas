unit ConfigUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Mask,
  Vcl.ExtCtrls, BookmarkManager, Winapi.ShellAPI, System.IOUtils, ApplicationSettings;

type
  TMainForm = class(TForm)
    BookmarkTree: TTreeView;
    BtnAdd: TButton;
    BtnDelete: TButton;
    BtnSave: TButton;
    EditCategory: TLabeledEdit;
    EditName: TLabeledEdit;
    EditPath: TLabeledEdit;
    PageControl1: TPageControl;
    Panel1: TPanel;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    ColorBox1: TColorBox;
    Label4: TLabel;
    LabeledEdit5: TLabeledEdit;
    LabeledEdit6: TLabeledEdit;
    ColorBox7: TColorBox;
    Label5: TLabel;
    LabeledEdit3: TLabeledEdit;
    LabeledEdit4: TLabeledEdit;
    ColorBox3: TColorBox;
    Label6: TLabel;
    ColorBox5: TColorBox;
    Label7: TLabel;
    ColorBox6: TColorBox;
    Label8: TLabel;
    ColorBox2: TColorBox;
    Label9: TLabel;
    ColorBox4: TColorBox;
    Label10: TLabel;
    ColorBox8: TColorBox;
    Label11: TLabel;
    Label12: TLabel;
    LabeledEdit7: TLabeledEdit;
    LabeledEdit8: TLabeledEdit;
    ColorBox9: TColorBox;
    Label13: TLabel;
    ColorBox10: TColorBox;
    Label14: TLabel;
    BtnSaveFontAndColors: TButton;
    Label15: TLabel;
    LabeledEdit9: TLabeledEdit;
    LabeledEdit10: TLabeledEdit;
    ColorBox11: TColorBox;
    Label16: TLabel;
    Label17: TLabel;
    ColorBox12: TColorBox;
    Label18: TLabel;
    ColorBox13: TColorBox;
    Label19: TLabel;
    ColorBox14: TColorBox;
    Label20: TLabel;
    ColorBox15: TColorBox;
    Label21: TLabel;
    Label22: TLabel;
    procedure BookmarkTreeChange(Sender: TObject; Node: TTreeNode);
    procedure BookmarkTreeDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnDeleteClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure BtnSaveFontAndColorsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BookmarkTreeEndDrag(Sender, Target: TObject; X, Y: Integer);
  private
    { Private 宣言 }
    FBookmarks: TBookmarkCollection;
    FJsonPath: string;
    procedure DeleteChildNode;
    procedure DeleteParentNode;
    procedure LoadFontAndColors;
    procedure PopulateTreeView(Tree: TTreeView; Bookmarks: TBookmarkCollection);
    procedure WMDropFiles(var msg: TMessage); message WM_DROPFILES;
  public
    { Public 宣言 }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.BookmarkTreeChange(Sender: TObject; Node: TTreeNode);
var
  Item: TBookmarkItem;
begin
  // 子ノード（ブックマークアイテム）のときだけ処理
  if (Node <> nil) and (Node.Parent <> nil) and (Node.Data <> nil) then
  begin
    Item := TBookmarkItem(Node.Data);
    if Item.OwnerCategory <> nil then
      EditCategory.Text := Item.OwnerCategory.Category;
    EditName.Text := Item.Name;
    EditPath.Text := Item.Path;
  end
  else
  begin
    EditName.Clear;
    EditPath.Clear;
  end;
end;

procedure TMainForm.BookmarkTreeDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  TargetNode, SourceNode: TTreeNode;

begin
  TargetNode := BookmarkTree.GetNodeAt(X, Y);
  SourceNode := BookmarkTree.Selected;
  Accept := False;
  if (Source = BookmarkTree) and Assigned(SourceNode) and Assigned(TargetNode) then
  begin
    if (SourceNode.Parent = TargetNode.Parent) and
       (SourceNode.Level = TargetNode.Level) then
    begin
      Accept := True;
    end;
  end;
end;

procedure TMainForm.BookmarkTreeEndDrag(Sender, Target: TObject; X, Y: Integer);
var
  TargetNode, SourceNode: TTreeNode;
  TargetItem, SourceItem: TBookmarkItem;
  SourceCatName: string;

begin
  TargetNode := BookmarkTree.GetNodeAt(X, Y);
  SourceNode := BookmarkTree.Selected;
  if Assigned(SourceNode) and Assigned(TargetNode) then
  begin
    if (TargetNode.Level = 0) and (SourceNode.Level = 0) then
    begin
      FBookmarks.SwapCategories(TargetNode.Index, SourceNode.Index);
      FBookmarks.SaveToFile(FJsonPath);
      SourceNode.MoveTo(TargetNode, naInsert);
    end else
    begin
      TargetItem := TBookmarkItem(TargetNode.Data);
      SourceItem := TBookmarkItem(SourceNode.Data);
      if Assigned(SourceItem) and Assigned(TargetItem) and
         Assigned(SourceItem.OwnerCategory) then
      begin
        SourceCatName := SourceItem.OwnerCategory.Category;
        FBookmarks.SwapItemsByName(SourceCatName, SourceItem.Name, TargetItem.Name);
        FBookmarks.SaveToFile(FJsonPath);
        SourceNode.MoveTo(TargetNode, naInsert);
      end;
    end;
  end;
  BookmarkTree.Refresh;
  BookmarkTree.FullExpand;
end;

procedure TMainForm.BtnAddClick(Sender: TObject);
var
  Category, Name_, Path: string;
  Added: Boolean;
  CatNode, NewNode: TTreeNode;
  Cat: TBookmarkCategory;

begin
  Category := Trim(EditCategory.Text);
  Name_ := Trim(EditName.Text);
  Path := Trim(EditPath.Text);
  if (Name_ = '') or (Path = '') then
  begin
    ShowMessage('すべての項目を入力してや！');
    Exit;
  end;
  // アイテム追加（重複チェック付き）
  Added := FBookmarks.AddItem(Category, Name_, Path);
  if not Added then
  begin
    ShowMessage('同じ名前のブックマークがすでにあるで！');
    Exit;
  end;
  // TreeView に反映
  BookmarkTree.Items.BeginUpdate;
  try
    // 同じカテゴリのノードがすでにあるか確認
    CatNode := nil;
    for var i := 0 to BookmarkTree.Items.Count - 1 do
    begin
      if (BookmarkTree.Items[i].Parent = nil) and
         SameText(BookmarkTree.Items[i].Text, Category) then
      begin
        CatNode := BookmarkTree.Items[i];
        Break;
      end;
    end;
    // なければカテゴリノード作成
    if CatNode = nil then
      CatNode := BookmarkTree.Items.Add(nil, Category);
    // 対応する TBookmarkCategory を探してノードにデータを割り当て
    Cat := nil;
    for var C in FBookmarks.Categories do
    begin
      if SameText(C.Category, Category) then
      begin
        Cat := C;
        Break;
      end;
    end;
    if Assigned(Cat) and (Cat.Items.Count > 0) then
    begin
      NewNode := BookmarkTree.Items.AddChild(CatNode, Name_);
      NewNode.Data := Pointer(Cat.Items.Last); // 追加されたアイテム
    end;
    CatNode.Expand(True);
  finally
    BookmarkTree.Items.EndUpdate;
  end;
  // 入力欄クリア
  EditName.Clear;
  EditPath.Clear;
  FBookmarks.SaveToFile(FJsonPath);
end;

procedure TMainForm.BtnDeleteClick(Sender: TObject);
var
  Node: TTreeNode;

begin
  Node := BookmarkTree.Selected;
  if (Node = nil) then
    Exit;
  if Node.Level = 0 then
    DeleteParentNode
  else
    DeleteChildNode;
end;

procedure TMainForm.BtnSaveClick(Sender: TObject);
var
  Node: TTreeNode;
  Item: TBookmarkItem;

begin
  Node := BookmarkTree.Selected;
  // 子ノード（ブックマーク）かどうかチェック
  if (Node <> nil) and (Node.Parent <> nil) and (Node.Data <> nil) then
  begin
    Item := TBookmarkItem(Node.Data);
    // Editの内容で更新
    Item.Name := EditName.Text;
    Item.Path := EditPath.Text;
    // ツリーノードの表示も更新
    Node.Text := Item.Name;
    FBookmarks.SaveToFile(FJsonPath);
  end;
end;

procedure TMainForm.BtnSaveFontAndColorsClick(Sender: TObject);
var
  AppSettings: TApplicationSettings;
  WindowConfig: TWindowConfig;
  TabSetConfig: TTabSetConfig;
  HistoryMemoConfig: THistoryMemoConfig;
  JsonPath: string;

begin
  AppSettings := TApplicationSettings.Create;
  JsonPath := ChangeFileExt(Application.ExeName, '.json');
  try
    if FileExists(JsonPath) then
      AppSettings.LoadFromFile(JsonPath);
    WindowConfig.AddressBar.Font.Name          := LabeledEdit1.Text;
    WindowConfig.AddressBar.Font.Size          := StrToInt(LabeledEdit2.Text);
    WindowConfig.AddressBar.Colors.Text        := ColorBox1.Selected;
    WindowConfig.AddressBar.Colors.Background  := ColorBox2.Selected;
    WindowConfig.ListView.Font.Name            := LabeledEdit3.Text;
    WindowConfig.ListView.Font.Size            := StrToInt(LabeledEdit4.Text);
    WindowConfig.ListView.Colors.Text          := ColorBox3.Selected;
    WindowConfig.ListView.Colors.Background    := ColorBox4.Selected;
    WindowConfig.ListView.Colors.SelectedItems := ColorBox5.Selected;
    WindowConfig.ListView.Colors.UnderLine     := ColorBox6.Selected;
    WindowConfig.SearchBox.Font.Name           := LabeledEdit5.Text;
    WindowConfig.SearchBox.Font.Size           := StrToInt(LabeledEdit6.Text);
    WindowConfig.SearchBox.Colors.Text         := ColorBox7.Selected;
    WindowConfig.SearchBox.Colors.Background   := ColorBox8.Selected;
    WindowConfig.Width                         := AppSettings.WindowConfig.Width;
    HistoryMemoConfig.Font.Name                := LabeledEdit7.Text;
    HistoryMemoConfig.Font.Size                := StrToInt(LabeledEdit8.Text);
    HistoryMemoConfig.Colors.Text              := ColorBox9.Selected;
    HistoryMemoConfig.Colors.Background        := ColorBox10.Selected;
    HistoryMemoConfig.Height                   := AppSettings.HistoryMemoConfig.Height;
    TabSetConfig.Font.Name                     := LabeledEdit9.Text;
    TabSetConfig.Font.Size                     := StrToInt(LabeledEdit10.Text);
    TabSetConfig.Colors.Text                   := ColorBox11.Selected;
    TabSetConfig.Colors.Background             := ColorBox12.Selected;
    TabSetConfig.Colors.SelectedColor          := ColorBox13.Selected;
    TabSetConfig.Colors.UnselectedColor        := ColorBox14.Selected;
    TabSetConfig.Colors.SelectedFontColor      := ColorBox15.Selected;
    AppSettings.WindowConfig := WindowConfig;
    AppSettings.TabSetConfig := TabSetConfig;
    AppSettings.HistoryMemoConfig := HistoryMemoConfig;
    AppSettings.SaveToFile(JsonPath);
  finally
    AppSettings.Free;
  end;
end;

procedure TMainForm.DeleteChildNode;
var
  Node, ParentNode: TTreeNode;
  Item: TBookmarkItem;
  Cat: TBookmarkCategory;
  i: Integer;

begin
  Node := BookmarkTree.Selected;
  // 子ノードかどうか確認（親がある＝カテゴリの子）
  if (Node = nil) or (Node.Parent = nil) or (Node.Data = nil) then
  begin
    ShowMessage('削除するブックマークを選んでや〜');
    Exit;
  end;
  // アイテム取得
  Item := TBookmarkItem(Node.Data);
  ParentNode := Node.Parent;
  // カテゴリ取得
  Cat := nil;
  for var C in FBookmarks.Categories do
  begin
    if SameText(C.Category, ParentNode.Text) then
    begin
      Cat := C;
      Break;
    end;
  end;
  if Cat = nil then
    Exit;
  // アイテムを削除
  for i := Cat.Items.Count - 1 downto 0 do
  begin
    if Cat.Items[i] = Item then
    begin
      Cat.Items.Delete(i);
      Break;
    end;
  end;
  // カテゴリが空になったら、カテゴリごと削除（オプション）
  if Cat.Items.Count = 0 then
  begin
    FBookmarks.Categories.Remove(Cat);
    BookmarkTree.Items.Delete(ParentNode);
  end
  else
    BookmarkTree.Items.Delete(Node); // ノードだけ削除
  // Edit をクリア
  EditName.Clear;
  EditPath.Clear;
end;

procedure TMainForm.DeleteParentNode;
var
  SelNode: TTreeNode;
  CatName: string;

begin
  SelNode := BookmarkTree.Selected;
  if not Assigned(SelNode) then
    Exit;
  if SelNode.Level = 0 then
  begin
    CatName := SelNode.Text;
    if MessageDlg(CatName + 'カテゴリーごと消してしまうで？', mtConfirmation,
      [mbYes, mbNo], 0) = mrYes then
    begin
      FBookmarks.RemoveCategory(CatName);
      SelNode.Delete;
      FBookmarks.SaveToFile(FJsonPath);
    end;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FJsonPath := ExtractFilePath(Application.ExeName) + 'bookmarks.json';
  FBookmarks := TBookmarkCollection.Create;
  FBookmarks.LoadFromFile(FJsonPath);
  LoadFontAndColors;
  PopulateTreeView(BookmarkTree, FBookmarks);
  DragAcceptFiles(Handle, True);
  PageControl1.ActivePageIndex := 0;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FBookmarks.Free;
end;

procedure TMainForm.LoadFontAndColors;
var
  AppSettings: TApplicationSettings;
  JsonPath: string;

begin
  AppSettings := TApplicationSettings.Create;
  try
    JsonPath := ChangeFileExt(Application.ExeName, '.json');
    if FileExists(JsonPath) then
      AppSettings.LoadFromFile(JsonPath);
    LabeledEdit1.Text   := AppSettings.WindowConfig.AddressBar.Font.Name;
    LabeledEdit2.Text   := AppSettings.WindowConfig.AddressBar.Font.Size.ToString;
    LabeledEdit3.Text   := AppSettings.WindowConfig.ListView.Font.Name;
    LabeledEdit4.Text   := AppSettings.WindowConfig.ListView.Font.Size.ToString;
    LabeledEdit5.Text   := AppSettings.WindowConfig.SearchBox.Font.Name;
    LabeledEdit6.Text   := AppSettings.WindowConfig.SearchBox.Font.Size.ToString;
    LabeledEdit7.Text   := AppSettings.HistoryMemoConfig.Font.Name;
    LabeledEdit8.Text   := AppSettings.HistoryMemoConfig.Font.Size.ToString;
    LabeledEdit9.Text   := AppSettings.TabSetConfig.Font.Name;
    LabeledEdit10.Text  := AppSettings.TabSetConfig.Font.Size.ToString;
    ColorBox1.Selected  := AppSettings.WindowConfig.AddressBar.Colors.Text;
    ColorBox2.Selected  := AppSettings.WindowConfig.AddressBar.Colors.Background;
    ColorBox3.Selected  := AppSettings.WindowConfig.ListView.Colors.Text;
    ColorBox4.Selected  := AppSettings.WindowConfig.ListView.Colors.Background;
    ColorBox5.Selected  := AppSettings.WindowConfig.ListView.Colors.SelectedItems;
    ColorBox6.Selected  := AppSettings.WindowConfig.ListView.Colors.UnderLine;
    ColorBox7.Selected  := AppSettings.WindowConfig.SearchBox.Colors.Text;
    ColorBox8.Selected  := AppSettings.WindowConfig.SearchBox.Colors.Background;
    ColorBox9.Selected  := AppSettings.HistoryMemoConfig.Colors.Text;
    ColorBox10.Selected := AppSettings.HistoryMemoConfig.Colors.Background;
    ColorBox11.Selected := AppSettings.TabSetConfig.Colors.Text;
    ColorBox12.Selected := AppSettings.TabSetConfig.Colors.Background;
    ColorBox13.Selected := AppSettings.TabSetConfig.Colors.SelectedColor;
    ColorBox14.Selected := AppSettings.TabSetConfig.Colors.UnselectedColor;
    ColorBox15.Selected := AppSettings.TabSetConfig.Colors.SelectedFontColor;
  finally
    AppSettings.Free;
  end;
end;

procedure TMainForm.PopulateTreeView(Tree: TTreeView;
  Bookmarks: TBookmarkCollection);
var
  CatNode, ItemNode: TTreeNode;
  Cat: TBookmarkCategory;
  Item: TBookmarkItem;

begin
  Tree.Items.BeginUpdate;
  try
    Tree.Items.Clear;
    for Cat in Bookmarks.Categories do
    begin
      CatNode := Tree.Items.Add(nil, Cat.Category);
      for Item in Cat.Items do
      begin
        ItemNode := Tree.Items.AddChild(CatNode, Item.Name);
        ItemNode.Data := Pointer(Item); // ← 詳細取得用にポインタ仕込む
      end;
    end;
    Tree.FullExpand;
  finally
    Tree.Items.EndUpdate;
  end;
end;

procedure TMainForm.WMDropFiles(var msg: TMessage);
var
  Count: Integer;
  Buf: Array [0..255] of Char;

begin
  Count := DragQueryFile(msg.WParam, $FFFFFFFF, Buf, 255);
  if Count = 1 then
  begin
    DragQueryFile(msg.WParam, 0, Buf, 255);
    if TDirectory.Exists(Buf) then
      EditPath.Text := Buf;
  end;
  DragFinish(msg.WParam);
end;

{$IFDEF DEBUG}
initialization
  ReportMemoryLeaksOnShutdown := True;
{$ENDIF}

end.
