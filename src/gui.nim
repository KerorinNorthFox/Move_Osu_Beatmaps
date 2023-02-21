import
  nigui,
  ./utils

type UI = object
  mainWindow: Window
  mainUI: Container # メインウィンドウ最上位コンテナ
  leftUI: Container # 左UI
  rightUI: Container # 右UI
  menuLabel: Label # 左UI->メニュー
  beatmapMoveButton: Button # 左UI->譜面移動ボタン
  resultArea: TextArea # 右UI->結果表示エリア
  progressBar: ProgressBar # 右UI->プログレスバー

  settingWindow: Window
  settingUI: Container # 設定ウィンドウ最上位コンテナ

# UIのコンストラクタ
proc newUI(): UI
# ウィンドウ作成
proc initWindow(self:var UI, name:string="", height:int=100, width:int=100, x:int=100, y:int=100): void
# ウィンドウにコントロール追加
proc addControls(self:var UI): void
# ボタンの処理
proc setButtonEvent(self:UI)

proc main(): void =
  app.init()
  let ui = newUI()

  ui.mainWindow.show()
  app.run()

proc newUI(): UI =
  result.initWindow("メインウィンドウ", 400, 600)
  result.addControls()

proc initWindow(self:var UI, name:string="", height:int=100, width:int=100, x:int=100, y:int=100): void =
  self.mainWindow = newWindow(name)
  self.mainWindow.height = height.scaleToDpi
  self.mainWindow.width = width.scaleToDpi
  self.mainWindow.x = x
  self.mainWindow.y = y

  self.settingWindow = newWindow("Setting")

proc addControls(self:var UI): void =
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

proc setButtonEvent(self:UI): void =
  discard

when isMainModule:
  main()
