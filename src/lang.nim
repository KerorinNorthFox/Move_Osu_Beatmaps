import ./utils

type Language = object
  startProgram*: string
  mainWindowTitle*: string
  settingWindowTitle*: string
  sChangePathUiFrameText*: string
  sChangeDirectoryButtonText*: string

let japanese: Language = Language(
  startProgram:"[Info]: プログラムが開始されました。",
  mainWindowTitle:"メインウィンドウ",
  settingWindowTitle:"設定",
  sChangePathUiFrameText:"譜面の移動先を設定", # TODO:
  sChangeDirectoryButtonText:"フォルダを選ぶ"
)

let english: Language = Language(
  startProgram:"[Info]: Start the program.",
  mainWindowTitle:"Main Window",
  settingWindowTitle:"Settings",
  sChangePathUiFrameText:"Set up destination of beatmaps", # TODO:
  sChangeDirectoryButtonText:"Select folder"
)

let LANG*: array[2, Language] = [japanese, english]
const LANGNAME*: seq[string] = @["Japanese", "English"]