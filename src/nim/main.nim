import
  std/os,
  std/parsecfg

proc help*(error:string="") = # ヘルプを表示
  echo error

proc progressReport*(text:string) = # 結果表示
  echo "\n####################"
  echo text
  echo "####################\n"

proc makeConfigFile*(osuPath:string) = # configを作成する
  var dict: Config = newConfig()
  dict.setSectionKey("", "path", osuPath)
  dict.writeConfig("config.ini")
  progressReport("Made new config file.")

proc updateConfigFile*(osuPath:string) = # config編集
  if not "config.ini".existsFile:
    makeConfigFile(osuPath)
    return
  var dict: Config = loadConfig("config.ini")
  dict.setSectionKey("", "path", osuPath)
  dict.writeConfig("config.ini")
  progressReport("Updated new config file.")

proc loadConfigFile*(): string = # configを読み込む
  if not "config.ini".existsFile:
    help("Error: 'config.ini' file does not exist.\nTry the command '--path *DirectoryPath*' to make config file and set path")
    return
  var dict: Config = loadConfig("config.ini")
  try:
    let path = dict.getSectionValue("", "path")
    return path
  except KeyError:
    help("Error: Keyword 'path' does not exist in 'config.ini'.\nTry the command '--path *DirectoryPath*' to set path.")

proc moveFile*(path:string) = # ファイル移動
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