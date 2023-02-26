import std/strformat


const VERSION*: string = "v1.1.0"
let mainWindowTitle: string = fmt"MoveBeatmaps[{VERSION}]"


type Language = object
  language*: string
  doNotGetVer*: string
  diffVerFront*: string
  diffVerBack*: string
  updateDetected*: string
  startProgram*: string
  mainWindowTitle*: string
  settingWindowTitle*: string
  sChangePathUiFrameText*: string
  sChangeDirButtonText*: string
  sSaveButton*: string
  sChangeLangUiFrameText*: string
  sChangeLangButton*: string
  mLeftUiFrameText*: string
  mBeatmapMoveButton*: string
  mSettingButton*: string
  changeOsuSongsDirDialogTitle*: string
  changeLangTextAreaFront*: string
  changeLangTextAreaBack*: string
  fileDoesNotExistErrorText*: string
  keywordDoesNotExistErrorTextFront*: string
  keywordDoesNotExistErrorTextBack*: string
  endProgram*: string
  endProgramTitle*: string
  endProgramButton*: string
  cancel*: string
  updatePathReturnText*: string
  getPathReturnTextFront*: string
  getPathReturnTextCenter*: string
  getPathReturnTextBack*: string
  pathIsNotSongsDir*: string
  pathDoesNotExist*: string
  noBeatmaps*: string
  processFailed*: string
  moveBeatmapsFront*: string
  moveBeatmapsBack*: string

let japanese: Language = Language(
  language:"日本語",
  doNotGetVer:"バージョン情報が取得できませんでした。",
  diffVerFront:"最新バージョン '",
  diffVerBack:"' がリリースされています。\nGithubのサイトから最新バージョンをダウンロードして\n更新してください。\n",
  updateDetected:"アップデート通知",
  startProgram:"[Info]: プログラムが開始されました。",
  mainWindowTitle:mainWindowTitle,
  settingWindowTitle:"設定",
  sChangePathUiFrameText:"譜面の移動先を設定",
  sChangeDirButtonText:"フォルダを選ぶ",
  sSaveButton:"保存",
  sChangeLangUiFrameText:"言語変更",
  sChangeLangButton:"保存",
  mLeftUiFrameText:"メニュー",
  mBeatmapMoveButton:"譜面移動",
  mSettingButton:"設定",
  changeOsuSongsDirDialogTitle:"osu!/Songsフォルダを選んでください",
  changeLangTextAreaFront:"[Info]: 言語が'",
  changeLangTextAreaBack:"'に変更されました。プログラムを再起動して下さい。",
  fileDoesNotExistErrorText:"設定ファイルが存在しません。設定からパスを設定してください。",
  keywordDoesNotExistErrorTextFront:"[Error]: '",
  keywordDoesNotExistErrorTextBack:"' 設定ファイルにキーワード'path'が存在しません。",
  endProgram:"終了しますか?",
  endProgramTitle:"終了?",
  endProgramButton:"終了",
  cancel:"キャンセル",

  updatePathReturnText:"[Success]: パスを更新しました。",
  getPathReturnTextFront:"[Success]: パス'",
  getPathReturnTextCenter:"'を'",
  getPathReturnTextBack:"'から取得に成功しました。",
  pathIsNotSongsDir:"これはosu!/Songsフォルダのパスではありません。設定からパスを変更してください。",
  pathDoesNotExist:"フォルダが存在しません。設定からパスを変更してください。",
  noBeatmaps:"[Info]: ダウンロードフォルダに譜面がありません。",
  processFailed:"[Error]: 譜面の移動に失敗しました。",
  moveBeatmapsFront:"[Success]: ",
  moveBeatmapsBack:" 個の譜面を移動しました。"
)

let english: Language = Language(
  language:"English",
  doNotGetVer:"Can not get the update info.",
  diffVerFront:"Latest version '",
  diffVerBack:"' is released. \nPlease download the updated version on Github.\n",
  updateDetected:"Update detected",
  startProgram:"[Info]: Start the program.",
  mainWindowTitle:mainWindowTitle,
  settingWindowTitle:"Settings",
  sChangePathUiFrameText:"Set up the destination of beatmaps",
  sChangeDirButtonText:"Select folder",
  sSaveButton:"Save",
  sChangeLangUiFrameText:"Change language",
  sChangeLangButton:"Save",
  mLeftUiFrameText:"Menu",
  mBeatmapMoveButton:"Move beatmaps",
  mSettingButton:"Settings",
  changeOsuSongsDirDialogTitle:"Select osu!/Songs folder",
  changeLangTextAreaFront:"[Info]: Change the language to '",
  changeLangTextAreaBack:"'. Restart the program.",
  fileDoesNotExistErrorText:"Config file does not exists. Set the path in the settings.",
  keywordDoesNotExistErrorTextFront:"[Error]: Keyword 'path' does not exist in config file '",
  keywordDoesNotExistErrorTextBack:"'.",
  endProgram:"Do you want to quit?",
  endProgramTitle:"Quit?",
  endProgramButton:"Quit",
  cancel:"Cancel",

  updatePathReturnText:"[Success]: Updated the path.",
  getPathReturnTextFront:"[Success]: Get the path '",
  getPathReturnTextCenter:"' from '",
  getPathReturnTextBack:"'.",
  pathIsNotSongsDir:"The path is not osu!/Songs folder. Change the path in the settings.",
  pathDoesNotExist:"The folder does not exist. Change the path in the settings.",
  noBeatmaps:"[Info]: There are no beatmaps in the Download folder.",
  processFailed:"[Error]: Process failed.",
  moveBeatmapsFront:"[Success]: Move ",
  moveBeatmapsBack:" beatmaps."
)

let LANG*: array[2, Language] = [english, japanese]