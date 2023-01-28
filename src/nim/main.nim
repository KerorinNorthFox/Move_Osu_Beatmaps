import
  std/os,
  std/parsecfg,
  std/strformat

const configFilePath: string = "config.ini"

proc help*(error:string="") = # ヘルプを表示
  echo error

# proc progressReport*(text:string) = # 結果表示
#   echo "\n########################"
#   echo text
#   echo "########################\n"

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

proc moveFile*(toPath:string) = # ファイル移動
  echo toPath

proc main() =
  let cmdArgCount: int = paramCount()
  if cmdArgCount == 0:
    help("[Error]: No CommandLine Args.")

  elif cmdArgCount == 1:
    let cmdArg: string = paramStr(1)
    if cmdArg == "--run": # ファイル移動実行
      let path: string = returnPath()
      moveFile(path)
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