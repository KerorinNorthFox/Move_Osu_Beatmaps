import
  std/os, # ファイル操作
  std/parsecfg, # 設定ファイルを利用する
  std/strformat, # 文字列に変数埋め込み
  std/strutils

const configFilePath*: string = "config.ini"
const downloadPath*: string = joinPath(getEnv("USERPROFILE"), "Downloads")

type ReturnPath* = ref object
  path: string
  isError: bool
  text: string

# ヘルプを表示
proc help*(error:string="") =
  echo error
  echo "[Help]"
  echo "Available commands:"
  echo fmt"""  {"--run":<22}: Run the program to move Maps."""
  echo fmt"""  {"--path":<22}: Display the configured path."""
  echo fmt"""  {"--path 'DirectoryPath'":<22}: Set the path. Enter the path to Osu!'s Songs directory in 'DirectoryPath'."""
  echo fmt"""  {" ":<22}  EXECUTE THIS COMMAND FIRST."""
  echo fmt"""  {"--help":<22}: Display this help."""

# configを作成する
proc makeConfigFile*(configPath, path: string): string =
  var dict: Config = newConfig()
  dict.setSectionKey("", "path", path)
  dict.writeConfig(configPath)
  return "[Success]: Made new config file."

# config編集
proc updateConfigFile*(configPath, path: string): string =
  if not configPath.fileExists:
    return makeConfigFile(configPath, path)
  var dict: Config = loadConfig(configPath)
  dict.setSectionKey("", "path", path)
  dict.writeConfig(configPath)
  return "[Success]: Updated new config file."

# configからpathを読み込む
proc loadConfigFile*(configPath:string): string =
  var dict: Config = loadConfig(configPath)
  let path = dict.getSectionValue("", "path")
  return path

# 読み込んだpathを返す
proc returnPath(): ReturnPath =
  if not configFilePath.fileExists:
    let text: string = fmt"""[Error]: '{configFilePath}'  file does not exist. Try the command '--path "DirectoryPath"' to make config file and set path"""
    return ReturnPath(path:"", text:text, isError:true)
  try:
    let path: string = loadConfigFile(configFilePath)
    let text = fmt"[Success]: Get 'path' value from '{configFilePath}'."
    return ReturnPath(path:path, text:text, isError:false)
  except KeyError:
    let text: string = fmt"""[Error]: Keyword 'path' does not exist in '{configFilePath}'. Try the command '--path "DirectoryPath"' to set path."""
    return ReturnPath(path:"", text:text, isError:true)

# ファイル移動
proc moveMapFiles*(toPath:string): string =
  if not toPath.contains("osu!") and not toPath.contains("Songs"): # パスが"/osu!/Songs"なのか
    return fmt"path {toPath} is not Osu!'s Songs directory."
  if not toPath.dirExists:
    return fmt"path {toPath} does not exist."

  var osuFiles: seq[string]
  for f in walkFiles(downloadPath / "*.osz"): # 譜面パス集め
    osuFiles.add(f)

  if osuFiles.len == 0:
    return "No Files"

  for osuFile in osuFiles:
    try:
      execShellCmd(&"move \"{osuFile}\" \"{toPath}\"")
    except:
      return "Fail"

  return "Success"

proc main() =
  let cmdArgCount: int = paramCount()
  if cmdArgCount == 0:
    help("[Error]: No CommandLine Args.")

  elif cmdArgCount == 1:
    let cmdArg: string = paramStr(1)
    if cmdArg == "--run": # ファイル移動実行
      let result: ReturnPath = returnPath()
      echo result.text
      if result.isError:
        quit(QuitSuccess)
      let msg: string = moveMapFiles(result.path)
      echo "[INFO]: ", msg
    elif cmdArg == "--path":
        let result: ReturnPath = returnPath()
        echo result.text
        if result.isError:
          quit(QuitSuccess)
        echo fmt"[Info]: The configured path is '{result.path}'"
    elif cmdArg == "--help": # ヘルプ表示
      help()
    else:
      help("[Error]: unexpected command in one args: " & cmdArg)

  elif cmdArgCount == 2:
    let firstCmdArg: string = paramStr(1)
    let secondCmdArg: string = paramStr(2)
    if firstCmdArg == "--path": # パス設定
      let msg: string = updateConfigFile(configFilePath, secondCmdArg)
      echo msg
    else:
      help("[Error]: unexpected command in two args: " & firstCmdArg)

  else: # コマンドライン引数多すぎ
    help("[Error]: Too many CommandLine Args")


when isMainModule:
  main()