import
  std/os,
  std/parsecfg,
  std/strformat,
  std/strutils,
  std/httpclient,
  std/json,
  ./lang

const
  configFilePath*: string = "config.ini"
  downloadPath*: string = joinPath(getEnv("USERPROFILE"), "Downloads")

type
  ReturnPath* = ref object
    path*: string
    isError*: int
    text*: string

  MoveMapFiles* = ref object
    msg*: string
    isError*: bool

# configを作成する
proc makeConfigFile*(path:string=""): void =
  var dict: Config = newConfig()
  dict.setSectionKey("PATH", "path", path)
  dict.setSectionKey("LANGUAGE", "mode", "0")
  dict.writeConfig(configFilePath)

if not configFilePath.fileExists:
  makeConfigFile()

# configから言語のmodeを読み込む
proc loadLangMode(): int =
  var dict: Config = loadConfig(configFilePath)
  let mode = dict.getSectionValue("LANGUAGE", "mode")
  return mode.parseInt

let LANGMODE*: int = loadLangMode()

# githubからlatest releaseのタグを取得する
proc getLatestVersion*(url:string): string =
  var clt = newHttpClient()
  var res: string
  try:
    res = clt.getContent(url)
  except OSError:
    return ""

  let j = res.parseJson()
  return j["name"].getStr()

# configからpathを読み込む
proc loadPath(): string =
  var dict: Config = loadConfig(configFilePath)
  let path = dict.getSectionValue("PATH", "path")
  return path

# configのpath編集
proc updatePath*(path:string): string =
  if not configFilePath.fileExists:
    makeConfigFile(path)
  var dict: Config = loadConfig(configFilePath)
  dict.setSectionKey("PATH", "path", path)
  dict.writeConfig(configFilePath)
  return LANG[LANGMODE].updatePathReturnText

# configのlanguage編集
proc updateLangMode*(mode:int): void =
  var dict: Config = loadConfig(configFilePath)
  dict.setSectionKey("LANGUAGE", "mode", $mode)
  dict.writeConfig(configFilePath)

# 読み込んだpathを返す
proc returnPath*(): ReturnPath =
  if not configFilePath.fileExists:
    let text: string = fmt"""[Error]: '{configFilePath}'  file does not exist. Try the command '--path "DirectoryPath"' to make config file and set path"""
    return ReturnPath(path:"", text:text, isError:1)
  try:
    let path: string = loadPath()
    let text = LANG[LANGMODE].getPathReturnTextFront & path & LANG[LANGMODE].getPathReturnTextCenter & configFilePath & LANG[LANGMODE].getPathReturnTextBack
    return ReturnPath(path:path, text:text, isError:0)
  except KeyError:
    let text: string = fmt"""[Error]: Keyword 'path' does not exist in '{configFilePath}'. Try the command '--path "DirectoryPath"' to set path."""
    return ReturnPath(path:"", text:text, isError:2)

# ファイル移動
proc moveMapFiles*(toPath:string): MoveMapFiles =
  if not toPath.contains("osu!") and not toPath.contains("Songs"): # パスが"/osu!/Songs"なのか
    let msg: string = fmt"[Error]: '{toPath}' " & LANG[LANGMODE].pathIsNotSongsDir
    return MoveMapFiles(msg:msg, isError:true)
  if not toPath.dirExists:
    let msg: string = fmt"[Error]: '{toPath}' " & LANG[LANGMODE].pathDoesNotExist
    return MoveMapFiles(msg:msg, isError:true)

  var osuFiles: seq[string]
  for f in walkFiles(downloadPath / "*.osz"): # 譜面パス集め
    osuFiles.add(f)

  if osuFiles.len == 0:
    let msg: string = LANG[LANGMODE].noBeatmaps
    return MoveMapFiles(msg:msg, isError:false)

  for osuFile in osuFiles:
    try:
      execShellCmd(&"move \"{osuFile}\" \"{toPath}\"")
    except:
      return MoveMapFiles(msg:LANG[LANGMODE].processFailed, isError:true)

  let msg: string = LANG[LANGMODE].moveBeatmapsFront & $osuFiles.len & LANG[LANGMODE].moveBeatmapsBack
  return MoveMapFiles(msg:msg, isError:false)
