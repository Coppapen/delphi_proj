//{$WARNINGS OFF}
//{$WARN SYMBOL_PLATFORM OFF}
//{$WARN UNIT_PLATFORM OFF}
//-----------------------------------------------------------------------------
//  WH_MOUSE,WH_KEYBOARD�t�b�N�pDLL�v���W�F�N�g�\�[�X
//-----------------------------------------------------------------------------
library plMouseKeyHook;

uses
  plMouseKeyHookUnit in 'plMouseKeyHookUnit.pas';

//-----------------------------------------------------------------------------
//  �O������DLL���̃��\�b�h�𗘗p�\�ɂ��邽�߂̃I�}�W�i�C
//-----------------------------------------------------------------------------
exports
  StartMouseKeyHook,
  StopMouseKeyHook;
end.

