import
  std/os,
  std/strformat,
  ./utils


# ヘルプを表示
proc help(error:string=""): void =
  echo error
  echo "[Help]"
  echo "Available commands:"
  echo fmt"""  {"--run":<22}: Run the program to move beatmaps."""
  echo fmt"""  {"--path":<22}: Display the configured path."""
  echo fmt"""  {"--path 'DirectoryPath'":<22}: Set the path. Enter the path to Osu!'s Songs directory in 'DirectoryPath'."""
  echo fmt"""  {" ":<22}  EXECUTE THIS COMMAND FIRST."""
  echo fmt"""  {"--help":<22}: Display the help."""


proc main(): void =
  let cmdArgCount: int = paramCount()
  if cmdArgCount == 0:
    help("[Error]: No CommandLine Args.")

  elif cmdArgCount == 1:
    let cmdArg: string = paramStr(1)
    if cmdArg == "--run": # ファイル移動実行
      let result: ReturnPath = returnPath()
      echo result.text
      if result.isError != 0:
        quit(QuitSuccess)
      let obj: MoveMapFiles = moveMapFiles(result.path)
      echo obj.msg
    elif cmdArg == "--path":
        let result: ReturnPath = returnPath()
        echo result.text
        if result.isError != 0:
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
      let msg: string = updatePath(secondCmdArg)
      echo msg
    else:
      help("[Error]: Unexpected command in two args: " & firstCmdArg)

  else: # コマンドライン引数多すぎ
    help("[Error]: Too many CommandLine Args")


when isMainModule:
  main()