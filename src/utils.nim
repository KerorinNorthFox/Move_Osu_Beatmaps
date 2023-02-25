import
  std/os,
  std/parsecfg,
  std/strformat,
  std/strutils,
  ./lang


type ReturnPath* = ref object
  path: string
  isError: int
  text: string

type MoveMapFiles* = ref object
  msg: string
  isError: bool

proc `path=`*(self:ReturnPath, path:string): void =
  self.path = path

proc path*(self:ReturnPath): string =
  self.path

proc `isError=`*(self:ReturnPath, isError:int): void =
  self.isError = isError

proc isError*(self:ReturnPath): int =
  self.isError

proc `text=`*(self:ReturnPath, text:string): void =
  self.text = text

proc text*(self:ReturnPath): string =
  self.text

proc `msg=`*(self:MoveMapFiles, msg:string): void =
  self.msg = msg

proc msg*(self:MoveMapFiles): string =
  self.msg
  
proc `isError=`*(self:MoveMapFiles, isError:bool): void =
  self.isError = isError

proc isError*(self:MoveMapFiles): bool =
  self.isError


proc makeConfigFile*(): void
proc updatepath*(path:string): string
proc updateLangMode*(mode:int): void
proc loadPath(): string
proc loadLangMode(): int
proc returnPath*(): ReturnPath
proc moveMapFiles*(toPath:string): MoveMapFiles


const configFilePath*: string = "config.ini"
const downloadPath*: string = joinPath(getEnv("USERPROFILE"), "Downloads")
if not configFilePath.fileExists:
    makeConfigFile()
let LANGMODE*: int = loadLangMode()


# configを作成する
proc makeConfigFile*(): void =
  var dict: Config = newConfig()
  dict.setSectionKey("PATH", "path", "")
  dict.setSectionKey("LANGUAGE", "mode", "1")
  dict.writeConfig(configFilePath)


# configのpath編集
proc updatePath*(path:string): string =
  var dict: Config = loadConfig(configFilePath)
  dict.setSectionKey("PATH", "path", path)
  dict.writeConfig(configFilePath)
  return LANG[LANGMODE].updatePathReturnText


# configのlanguage編集
proc updateLangMode*(mode:int): void =
  var dict: Config = loadConfig(configFilePath)
  dict.setSectionKey("LANGUAGE", "mode", $mode)
  dict.writeConfig(configFilePath)


# configからpathを読み込む
proc loadPath(): string =
  var dict: Config = loadConfig(configFilePath)
  let path = dict.getSectionValue("PATH", "path")
  return path


# configから言語のmodeを読み込む
proc loadLangMode(): int =
  var dict: Config = loadConfig(configFilePath)
  let mode = dict.getSectionValue("LANGUAGE", "mode")
  return mode.parseInt


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
