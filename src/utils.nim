import
  std/os,
  std/parsecfg,
  std/strformat,
  std/strutils

const configFilePath*: string = "config.ini"
const downloadPath*: string = joinPath(getEnv("USERPROFILE"), "Downloads")

type ReturnPath* = ref object
  path: string
  isError: bool
  text: string

proc `path=`*(self:ReturnPath, path:string): void =
  self.path = path

proc path*(self:ReturnPath): string =
  self.path

proc `isError=`*(self:ReturnPath, isError:bool): void =
  self.isError = isError

proc isError*(self:ReturnPath): bool =
  self.isError

proc `text=`*(self:ReturnPath, text:string): void =
  self.text = text

proc text*(self:ReturnPath): string =
  self.text

# ヘルプを表示
proc help*(error:string=""): void =
  echo error
  echo "[Help]"
  echo "Available commands:"
  echo fmt"""  {"--run":<22}: Run the program to move beatmaps."""
  echo fmt"""  {"--path":<22}: Display the configured path."""
  echo fmt"""  {"--path 'DirectoryPath'":<22}: Set the path. Enter the path to Osu!'s Songs directory in 'DirectoryPath'."""
  echo fmt"""  {" ":<22}  EXECUTE THIS COMMAND FIRST."""
  echo fmt"""  {"--help":<22}: Display the help."""

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
proc returnPath*(): ReturnPath =
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