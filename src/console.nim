import
  std/os,
  std/strformat,
  ./utils


proc main(): void =
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
      help("[Error]: Unexpected command in two args: " & firstCmdArg)

  else: # コマンドライン引数多すぎ
    help("[Error]: Too many CommandLine Args")


when isMainModule:
  main()