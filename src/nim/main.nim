import
  std/os,
  std/parsecfg,
  std/strformat

const configPath: string = "config.ini"

proc help*(error:string="") = # ヘルプを表示
  echo error

proc progressReport*(text:string) = # 結果表示
  echo "\n####################"
  echo text
  echo "####################\n"

proc makeConfigFile*(path:string) = # configを作成する
  var dict: Config = newConfig()
  dict.setSectionKey("", "path", path)
  dict.writeConfig(configPath)
  progressReport("Made new config file.")

proc updateConfigFile*(path:string) = # config編集
  if not configPath.existsFile:
    makeConfigFile(path)
    return
  var dict: Config = loadConfig(configPath)
  dict.setSectionKey("", "path", path)
  dict.writeConfig(configPath)
  progressReport("Updated new config file.")

proc loadConfigFile*(): string = # configを読み込む
  if not configPath.existsFile:
    help(fmt"""Error: '{configPath}'  file does not exist.
Try the command '--path *DirectoryPath*' to make config file and set path""")
    return
  var dict: Config = loadConfig(configPath)
  try:
    let path = dict.getSectionValue("", "path")
    return path
  except KeyError:
    help(fmt"""Error: Keyword 'path' does not exist in '{configPath}'.
Try the command '--path *DirectoryPath*' to set path.""")

proc moveFile*(toPath:string) = # ファイル移動
  discard

proc main() =
  let cmdArgCount: int = paramCount()
  if cmdArgCount == 0:
    help("Error: No CommandLine Args.")

  elif cmdArgCount == 1:
    let cmdArg: string = paramStr(0)
    if cmdArg == "--run": # ファイル移動実行
      let path: string = loadConfigFile()
      moveFile(path)
    elif cmdArg == "--help": # ヘルプ表示
      help()
    else:
      help("Error: unexpected command: " & cmdArg)

  elif cmdArgCount == 2:
    let firstCmdArg: string = paramStr(0)
    let secondCmdArg: string = paramStr(1)
    if firstCmdArg == "--path": # パス設定
      updateConfigFile(secondCmdArg)
    else:
      help("Error: unexpected command: " & firstCmdArg)

  else: # コマンドライン引数多すぎ
    help("Error: Too many CommandLine Args")


when isMainModule:
  discard