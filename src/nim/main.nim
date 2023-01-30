import
  std/os,
  std/parsecfg,
  std/strformat,
  std/strutils

const configFilePath*: string = "config.ini"
const downloadPath*: string = joinPath(getEnv("USERPROFILE"), "Downloads")

proc help*(error:string="") = # ヘルプを表示 
  echo error
  echo "[Help]"
  echo "commands:"
  echo fmt"""  {"--run":<22}: Run the program to move Maps."""
  echo fmt"""  {"--path":<22}: Display the configured path."""
  echo fmt"""  {"--path 'DirectoryPath'":<22}: Set the path. Enter the path to Osu!'s Songs directory in 'DirectoryPath'."""
  echo fmt"""  {" ":<22}  EXECUTE THIS COMMAND FIRST."""
  echo fmt"""  {"--help":<22}: Display this help."""

proc makeConfigFile*(configPath:string, path:string): string = # configを作成する
  var dict: Config = newConfig()
  dict.setSectionKey("", "path", path)
  dict.writeConfig(configPath)
  return "[Success]: Made new config file."

proc updateConfigFile*(configPath:string, path:string): string = # config編集
  if not configPath.fileExists:
    return makeConfigFile(configPath, path)
  var dict: Config = loadConfig(configPath)
  dict.setSectionKey("", "path", path)
  dict.writeConfig(configPath)
  return "[Success]: Updated new config file."

proc loadConfigFile*(configPath:string): string = # configからpathを読み込む
  var dict: Config = loadConfig(configPath)
  let path = dict.getSectionValue("", "path")
  return path

proc returnPath(): string = # 読み込んだpathを返す
  if not configFilePath.fileExists:
    help(fmt"""[Error]: '{configFilePath}'  file does not exist. Try the command '--path "DirectoryPath"' to make config file and set path""")
    quit(QuitSuccess)
  try:
    let path: string = loadConfigFile(configFilePath)
    echo fmt"[Success]: Get 'path' Value from '{configFilePath}'."
    return path
  except KeyError:
    help(fmt"""[Error]: Keyword 'path' does not exist in '{configFilePath}'. Try the command '--path "DirectoryPath"' to set path.""")
    quit(QuitSuccess)

proc moveMapFiles*(toPath:string): string = # ファイル移動
  if not toPath.contains("osu!") or not toPath.contains("Songs"): # パスが"/osu!/Songs"なのか
    return fmt"path {toPath} is not Osu!'s Songs directory."
  if not toPath.dirExists:
    return fmt"path {toPath} does not exist."

  var osuFiles: seq[string]
  for f in walkFiles(joinPath(getEnv("USERPROFILE"), "Downloads") / "*.osz"): # 譜面パス集め
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
      let path: string = returnPath()
      let flg: string = moveMapFiles(path)
      echo flg
    elif cmdArg == "--path":
        let path: string = returnPath()
        echo fmt"[Info]: The configured path is '{path}'"
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