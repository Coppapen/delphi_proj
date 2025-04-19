//{$WARNINGS OFF}
//{$WARN SYMBOL_PLATFORM OFF}
//{$WARN UNIT_PLATFORM OFF}
//=============================================================================
//  �O���[�o���}�E�X�L�[�t�b�N�pDLL
//
//-----------------------------------------------------------------------------
//
//  �y�����z
//
//  2010�N08��23�� �`
//  2013�N09��22�� Windows 7 U64(SP1) + Delphi XE Pro�œ���Ċm�F
//
//-----------------------------------------------------------------------------
//
//  �y����m�F���z
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

//�O���̃A�v���P�[�V��������g�p����֐���
function StartMouseKeyHook(Wnd: HWND): Boolean; stdcall;
procedure StopMouseKeyHook; stdcall;

implementation

//���L�������̓��e�̍\����
type
  PHookInfo  = ^THookInfo;
  THookInfo  = record
  HookKeyHandle   : HHOOK;
  HookMouseHandle : HHOOK;
  HostWnd         : HWND;
end;

var
  //�������}�b�v�h�t�@�C���̃n���h��
  hMapFile : THandle;

const
  //�������}�b�v�h�t�@�C����
  MapFileName = 'plMouseKeyHookDLL';

//-----------------------------------------------------------------------------
//  ���L�������A�N�Z�X�̂��߂̏���
//
//  ���������0��Ԃ�.���s����ƕ�����Ԃ�.
//  ���̒l�ŏ����𕪊�ł���悤�ɂȂ��Ă��邪,���̃R�[�h�ł͖��g�p.
//-----------------------------------------------------------------------------
function MapFileMemory(var hMap: THandle; var pMap: pointer): Integer;
begin
  //�������}�b�v�h�t�@�C�����J��
  hMap := OpenFileMapping(FILE_MAP_ALL_ACCESS, False, MapFileName);
  if hMap = 0 then begin
    Result := -1;
    exit;
  end;

  //�������}�b�v�h�t�@�C���̊��蓖��
  pMap := MapViewOfFile(hMap, FILE_MAP_ALL_ACCESS, 0, 0, 0);
  if pMap = nil then begin
    Result := -2;
    CloseHandle(hMap);
    exit;
  end;

  Result := 0;
end;

//-----------------------------------------------------------------------------
//  ���L�������A�N�Z�X�̌�n��
//  �����Ă�������������΃r���[������
//  �n���h��������΃N���[�Y
//-----------------------------------------------------------------------------
procedure UnMapFileMemory(hMap: THandle; pMap: Pointer);
begin
  if pMap <> nil then UnmapViewOfFile(pMap);
  if hMap <> 0 then CloseHandle(hMap);
end;

//-----------------------------------------------------------------------------
//  �}�E�X�t�b�N�̃R�[���o�b�N�֐�
//  ����DLL���g�p�����A�v���Ƀ��b�Z�[�W�𑗂�
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
//  �L�[�t�b�N�̃R�[���o�b�N�֐�
//  ����DLL���g�p�����A�v���Ƀ��b�Z�[�W�𑗂�
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
//  �t�b�N�֐��̓o�^
//-----------------------------------------------------------------------------
function StartMouseKeyHook(Wnd: HWND): Boolean; stdcall;
var
  LpMap   : Pointer;
  LMapWnd : THandle;
begin
  Result := False;

  //�������}�b�v�h�t�@�C���g�p����
  MapFileMemory(LMapWnd, LpMap);
  if LpMap = nil then begin
    LMapWnd := 0;
    exit;
  end;

  //�t�b�N���\���̏������ƃt�b�N�֐��̓o�^
  pHookInfo(LpMap)^.HostWnd := Wnd;
  //�t�b�N���C���X�g�[��
  pHookInfo(LpMap)^.HookMouseHandle := SetWindowsHookEx(WH_MOUSE,
                                                    Addr(MouseHookProc),
                                                    hInstance,
                                                    0);
  pHookInfo(LpMap)^.HookKeyHandle := SetWindowsHookEx(WH_KEYBOARD,
                                                  Addr(KeyHookProc),
                                                  hInstance,
                                                  0);
  //�t�b�N����
  if (pHookInfo(LpMap)^.HookMouseHandle > 0) and
     (pHookInfo(LpMap)^.HookKeyHandle > 0) then begin
    Result := True;
  end;

  //�������}�b�v�h�t�@�C���g�p�I������
  UnMapFileMemory(LMapWnd, LpMap);
end;

//-----------------------------------------------------------------------------
//  �t�b�N�̉���
//-----------------------------------------------------------------------------
procedure StopMouseKeyHook; stdcall;
var
  LpMap   : Pointer;
  LMapWnd : THandle;
begin
  //�������}�b�v�h�t�@�C���g�p����
  MapFileMemory(LMapWnd, LpMap);
  if LpMap = nil then begin
    LMapWnd := 0;
    exit;
  end;

  //�t�b�N����
  if pHookInfo(LpMap)^.HookMouseHandle > 0 then begin
    UnhookWindowsHookEx(pHookInfo(LpMap)^.HookMouseHandle);
  end;
  if pHookInfo(LpMap)^.HookKeyHandle > 0 then begin
    UnhookWindowsHookEx(pHookInfo(LpMap)^.HookKeyHandle);
  end;

  //�������}�b�v�h�t�@�C���g�p�I������
  UnMapFileMemory(LMapWnd, LpMap);
end;

//-----------------------------------------------------------------------------
//  ���j�b�g��������
//  �������}�b�v�h�t�@�C���̍쐬
//
//  High(NativeUInt)�̒l��
//  32�r�b�g�A�v���ł�$FFFFFFFF
//  64�q�b�g�A�v���ł�$FFFFFFFFFFFFFFFF
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
//  ���j�b�g�I��������
//  �������}�b�v�h�t�@�C���̃N���[�Y
//-----------------------------------------------------------------------------
finalization
begin
  if hMapFile<>0 then CloseHandle(hMapFile);
end;

end.
