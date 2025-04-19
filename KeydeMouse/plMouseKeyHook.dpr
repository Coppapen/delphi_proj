//{$WARNINGS OFF}
//{$WARN SYMBOL_PLATFORM OFF}
//{$WARN UNIT_PLATFORM OFF}
//-----------------------------------------------------------------------------
//  WH_MOUSE,WH_KEYBOARDフック用DLLプロジェクトソース
//-----------------------------------------------------------------------------
library plMouseKeyHook;

uses
  plMouseKeyHookUnit in 'plMouseKeyHookUnit.pas';

//-----------------------------------------------------------------------------
//  外部からDLL内のメソッドを利用可能にするためのオマジナイ
//-----------------------------------------------------------------------------
exports
  StartMouseKeyHook,
  StopMouseKeyHook;
end.

