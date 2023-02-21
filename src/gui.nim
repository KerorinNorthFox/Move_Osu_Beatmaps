import
  nigui,
  ./utils

type UI = object of RootObj
  mainWindow: Window # メイン画面
  mainUI: Container # 画面最上位コンテナ

# 設定画面のUI
type SettingUI = object of UI
  label: Label # 題名
  changeDirectoryButton: Button # 移動先のディレクトリを選択するボタン
  saveButton: Button # 設定を保存するボタン

# メイン画面のUI
type MainUI = object of UI
  leftUI: Container # 左UI
  menuLabel: Label # 左UI->メニュー
  beatmapMoveButton: Button # 左UI->譜面移動ボタン

  rightUI: Container # 右UI
  resultArea: TextArea # 右UI->結果表示エリア
  progressBar: ProgressBar # 右UI->プログレスバー

  settingUI: SettingUI # 設定ウィンドウ

proc newUI(): MainUI # UIのコンストラクタ
method initWindow(self:var UI, title:string="", height:int=100, width:int=100): void {.base.}  # ウィンドウ作成
method addControls(self:var UI): void {.base.}  # ウィンドウにコントロール追加
proc setButtonEvent(self: MainUI): void # ボタンの処理

proc main(): void =
  app.init()
  let ui = newUI()
  ui.mainWindow.show()
  app.run()

proc newUI(): MainUI =
  result.initWindow("Main Window", 400, 600) # メイン画面作成
  result.settingUI.initWindow("Setting", 200, 200) # 設定画面作成
  result.addControls()
  result.settingUI.addControls()

method initWindow(self:var UI, title:string="", height:int=100, width:int=100): void {.base.} =
  self.mainWindow = newWindow(title)
  self.mainWindow.height = height.scaleToDpi
  self.mainWindow.width = width.scaleToDpi

method addControls(self:var UI): void {.base.} =
  self.mainUI = newLayoutContainer(Layout_Horizontal)
  self.mainWindow.add(self.mainUI)

method addControls(self:var SettingUI): void =
  self.mainUI = newLayoutContainer(Layout_Horizontal)
  self.mainWindow.add(self.mainUI)

  self.label = newLabel("hogehoge")
  self.mainUI.add(self.label)

  self.saveButton = newButton("Change save directory")
  self.mainUI.add(self.saveButton)

method addControls(self:var MainUI): void =
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

proc setButtonEvent(self: MainUI): void =
  discard

when isMainModule:
  main()
