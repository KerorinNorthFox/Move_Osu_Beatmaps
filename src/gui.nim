import
  nigui,
  ./utils

type UI = object of RootObj
  mainWindow: Window
  mainUI: Container # 画面最上位コンテナ

# 設定画面のUI
type SettingUI = object of UI
  label: Label
  whereToSave: SelectDirectoryDialog

# メイン画面のUI
type MainUI = object of UI
  leftUI: Container # 左UI
  menuLabel: Label # 左UI->メニュー
  beatmapMoveButton: Button # 左UI->譜面移動ボタン

  rightUI: Container # 右UI
  resultArea: TextArea # 右UI->結果表示エリア
  progressBar: ProgressBar # 右UI->プログレスバー

  settingUI: SettingUI

proc newUI(): MainUI # UIのコンストラクタ
proc initWindow(self:var MainUI, name:string="", height:int=100, width:int=100, x:int=100, y:int=100): void # ウィンドウ作成
proc addControls(self:var MainUI): void # ウィンドウにコントロール追加
proc setButtonEvent(self:MainUI) # ボタンの処理

proc main(): void =
  app.init()
  let ui = newUI()
  ui.mainWindow.show()
  app.run()

proc newUI(): MainUI =
  result.initWindow("メインウィンドウ", 400, 600)
  result.addControls()

proc initWindow(self:var MainUI, name:string="", height:int=100, width:int=100, x:int=100, y:int=100): void =
  self.mainWindow = newWindow(name)
  self.mainWindow.height = height.scaleToDpi
  self.mainWindow.width = width.scaleToDpi
  self.mainWindow.x = x
  self.mainWindow.y = y

  # self.settingWindow = newWindow("Setting")

proc addControls(self:var MainUI): void =
  self.mainUI = newLayoutContainer(Layout_Horizontal)
  self.mainWindow.add(self.mainUI)

  self.leftUI = newLayoutContainer(Layout_Vertical)
  self.mainUI.add(self.leftUI)

  self.menuLabel = newLabel("~Menu~")
  self.leftUI.add(self.menuLabel)

  self.beatmapMoveButton = newButton("Move beatmaps")
  self.leftUI.add(self.beatmapMoveButton)

  self.rightUI = newLayoutContainer(Layout_Vertical)
  self.mainUI.add(self.rightUI)

  self.resultArea = newTextArea(">>Start program.")
  self.rightUI.add(self.resultArea)

  self.progressBar =newProgressBar()
  self.rightUI.add(self.progressBar)

proc setButtonEvent(self:MainUI): void =
  discard

when isMainModule:
  main()
