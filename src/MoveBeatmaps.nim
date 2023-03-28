import
  std/os,
  std/strformat,
  ./pkg/utils

# ヘルプを表示
proc help(error:string=""): void =
  echo error
  echo "[Help]"
  echo "Available commands:"
  echo fmt"""  {"-c":<22}: Run the app with console version."""
  echo fmt"""  {"--run":<22}: Run the program to move beatmaps."""
  echo fmt"""  {"--path":<22}: Display the configured path."""
  echo fmt"""  {"--path 'DirectoryPath'":<22}: Set the path. Enter the path to Osu!'s Songs directory in 'DirectoryPath'."""
  echo fmt"""  {" ":<22}  EXECUTE THIS COMMAND FIRST."""
  echo fmt"""  {"--help":<22}: Display the help."""

proc main(): void =
  let argCount: int = paramCount()
  case argCount
  of 0:
    if not (hostOS == "windows"):
      help("[Error]: No CommandLine Args.")
      return
    discard execShellCmd("start /min gui.exe")

  of 1:
    help("[Error]: The commands are not enough.")

  of 2:
    let
      firstArg: string = paramStr(1)
      secondArg: string = paramStr(2)
    if firstArg == "-c":
      if secondArg == "--run": # ファイル移動実行
        let result: ReturnPath = returnPath()
        echo result.text
        if result.isError != 0:
          quit(QuitSuccess)
        let obj: MoveMapFiles = moveMapFiles(result.path)
        echo obj.msg
        return
      elif secondArg == "--path":
          let result: ReturnPath = returnPath()
          echo result.text
          if result.isError != 0:
            quit(QuitSuccess)
          echo fmt"[Info]: The configured path is '{result.path}'"
          return
      elif secondArg == "--help": # ヘルプ表示
        help()
        return
    help("[Error]: unexpected command in one args: " & secondArg)

  of 3:
    let
      firstArg: string = paramStr(1)
      secondArg: string = paramStr(2)
      thirdArg: string = paramStr(3)
    if firstArg == "-c":
      if secondArg == "--path": # パス設定
        let msg: string = updatePath(thirdArg)
        echo msg
    help("[Error]: Unexpected command in two args: " & secondArg)

  else: # コマンドライン引数多すぎ
    help("[Error]: Too many CommandLine Args")


when isMainModule:
  main()