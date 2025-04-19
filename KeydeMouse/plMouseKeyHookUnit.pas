//{$WARNINGS OFF}
//{$WARN SYMBOL_PLATFORM OFF}
//{$WARN UNIT_PLATFORM OFF}
//=============================================================================
//  グローバルマウスキーフック用DLL
//
//-----------------------------------------------------------------------------
//
//  【履歴】
//
//  2010年08月23日 ～
//  2013年09月22日 Windows 7 U64(SP1) + Delphi XE Proで動作再確認
//
//-----------------------------------------------------------------------------
//
//  【動作確認環境】
//
//  Windows 7 U64(SP1) + Delphi XE Pro
//
//  Presented by Mr.XRAY
//  http://mrxray.on.coocan.jp/
//=============================================================================
unit plMouseKeyHookUnit;

interface

uses
  Windows, Messages;

//外部のアプリケーションから使用する関数類
function StartMouseKeyHook(Wnd: HWND): Boolean; stdcall;
procedure StopMouseKeyHook; stdcall;

implementation

//共有メモリの内容の構造体
type
  PHookInfo  = ^THookInfo;
  THookInfo  = record
  HookKeyHandle   : HHOOK;
  HookMouseHandle : HHOOK;
  HostWnd         : HWND;
end;

var
  //メモリマップドファイルのハンドル
  hMapFile : THandle;

const
  //メモリマップドファイル名
  MapFileName = 'plMouseKeyHookDLL';

//-----------------------------------------------------------------------------
//  共有メモリアクセスのための準備
//
//  成功すると0を返す.失敗すると負数を返す.
//  負の値で処理を分岐できるようになっているが,このコードでは未使用.
//-----------------------------------------------------------------------------
function MapFileMemory(var hMap: THandle; var pMap: pointer): Integer;
begin
  //メモリマップドファイルを開く
  hMap := OpenFileMapping(FILE_MAP_ALL_ACCESS, False, MapFileName);
  if hMap = 0 then begin
    Result := -1;
    exit;
  end;

  //メモリマップドファイルの割り当て
  pMap := MapViewOfFile(hMap, FILE_MAP_ALL_ACCESS, 0, 0, 0);
  if pMap = nil then begin
    Result := -2;
    CloseHandle(hMap);
    exit;
  end;

  Result := 0;
end;

//-----------------------------------------------------------------------------
//  共有メモリアクセスの後始末
//  割当てたメモリがあればビューを解除
//  ハンドルがあればクローズ
//-----------------------------------------------------------------------------
procedure UnMapFileMemory(hMap: THandle; pMap: Pointer);
begin
  if pMap <> nil then UnmapViewOfFile(pMap);
  if hMap <> 0 then CloseHandle(hMap);
end;

//-----------------------------------------------------------------------------
//  マウスフックのコールバック関数
//  このDLLを使用したアプリにメッセージを送る
//-----------------------------------------------------------------------------
function MouseHookProc(nCode:integer; wPar: WPARAM; lPar: LPARAM): LRESULT; stdcall;
var
  LpMap   : Pointer;
  LMapWnd : THANDLE;
begin
  Result := 0;
  if MapFileMemory(LMapWnd, LpMap) <> 0 then exit;

  if nCode < 0 then begin
    Result := CallNextHookEx(pHookInfo(LpMap)^.HookMouseHandle, nCode, wPar, lPar);
  end else begin
    if nCode = HC_ACTION then begin
      PostMessage(pHookInfo(LpMap)^.HostWnd, WM_APP+100, wPar, 0);
    end;
    Result := CallNextHookEx(pHookInfo(LpMap)^.HookMouseHandle, nCode, wPar, lPar);
  end;

  UnMapFileMemory(LMapWnd, LpMap);
end;

//-----------------------------------------------------------------------------
//  キーフックのコールバック関数
//  このDLLを使用したアプリにメッセージを送る
//-----------------------------------------------------------------------------
function KeyHookProc(nCode:integer; wPar: WPARAM; lPar: LPARAM): LRESULT; stdcall;
var
  LpMap   : Pointer;
  LMapWnd : THANDLE;
begin
  Result := 0;
  if MapFileMemory(LMapWnd, LpMap) <> 0 then exit;

  if nCode < 0 then begin
    Result := CallNextHookEx(pHookInfo(LpMap)^.HookKeyHandle, nCode, wPar, lPar);
  end else begin
    if nCode = HC_ACTION then begin
      PostMessage(pHookInfo(LpMap)^.HostWnd, WM_APP+110, wPar, lPar);
    end;
    Result := CallNextHookEx(pHookInfo(LpMap)^.HookKeyHandle, nCode, wPar, lPar);
  end;

  UnMapFileMemory(LMapWnd, LpMap);
end;

//-----------------------------------------------------------------------------
//  フック関数の登録
//-----------------------------------------------------------------------------
function StartMouseKeyHook(Wnd: HWND): Boolean; stdcall;
var
  LpMap   : Pointer;
  LMapWnd : THandle;
begin
  Result := False;

  //メモリマップドファイル使用準備
  MapFileMemory(LMapWnd, LpMap);
  if LpMap = nil then begin
    LMapWnd := 0;
    exit;
  end;

  //フック情報構造体初期化とフック関数の登録
  pHookInfo(LpMap)^.HostWnd := Wnd;
  //フックをインストール
  pHookInfo(LpMap)^.HookMouseHandle := SetWindowsHookEx(WH_MOUSE,
                                                    Addr(MouseHookProc),
                                                    hInstance,
                                                    0);
  pHookInfo(LpMap)^.HookKeyHandle := SetWindowsHookEx(WH_KEYBOARD,
                                                  Addr(KeyHookProc),
                                                  hInstance,
                                                  0);
  //フック成功
  if (pHookInfo(LpMap)^.HookMouseHandle > 0) and
     (pHookInfo(LpMap)^.HookKeyHandle > 0) then begin
    Result := True;
  end;

  //メモリマップドファイル使用終了処理
  UnMapFileMemory(LMapWnd, LpMap);
end;

//-----------------------------------------------------------------------------
//  フックの解除
//-----------------------------------------------------------------------------
procedure StopMouseKeyHook; stdcall;
var
  LpMap   : Pointer;
  LMapWnd : THandle;
begin
  //メモリマップドファイル使用準備
  MapFileMemory(LMapWnd, LpMap);
  if LpMap = nil then begin
    LMapWnd := 0;
    exit;
  end;

  //フック解除
  if pHookInfo(LpMap)^.HookMouseHandle > 0 then begin
    UnhookWindowsHookEx(pHookInfo(LpMap)^.HookMouseHandle);
  end;
  if pHookInfo(LpMap)^.HookKeyHandle > 0 then begin
    UnhookWindowsHookEx(pHookInfo(LpMap)^.HookKeyHandle);
  end;

  //メモリマップドファイル使用終了処理
  UnMapFileMemory(LMapWnd, LpMap);
end;

//-----------------------------------------------------------------------------
//  ユニット初期化部
//  メモリマップドファイルの作成
//
//  High(NativeUInt)の値は
//  32ビットアプリでは$FFFFFFFF
//  64ヒットアプリでは$FFFFFFFFFFFFFFFF
//-----------------------------------------------------------------------------
initialization
begin
  hMapFile := CreateFileMapping(High(NativeUInt),
                                nil,
                                PAGE_READWRITE,
                                0,
                                SizeOf(THookInfo),
                                MapFileName);
end;

//-----------------------------------------------------------------------------
//  ユニット終了処理部
//  メモリマップドファイルのクローズ
//-----------------------------------------------------------------------------
finalization
begin
  if hMapFile<>0 then CloseHandle(hMapFile);
end;

end.
