import
  nigui,
  nigui/msgbox,
  std/strformat,
  ./utils


type UI = object of RootObj
  mainWindow: Window # メイン画面
  mainUI: LayoutContainer # 画面最上位コンテナ

# 設定画面のUI
type SettingUI = object of UI
  pathBox: TextBox # パスを表示＆入力するテキストボックス
  downUI: LayoutContainer
  changeDirectoryButton: Button # 移動先のディレクトリを選択するボタン
  saveButton: Button # 設定を保存するボタン

# メイン画面のUI
type MainUI = object of UI
  leftUI: LayoutContainer # 左UI
  beatmapMoveButton: Button # 左UI->譜面移動ボタン
  settingButton: Button # 左UI->設定画面ボタン

  rightUI: LayoutContainer # 右UI
  resultArea: TextArea # 右UI->結果表示エリア
  progressBar: ProgressBar # 右UI->プログレスバー

  settingUI: SettingUI # 設定ウィンドウ


proc newUI(): MainUI
method initWindow(self:var UI, title:string="", height:int=100, width:int=100): void {.base.}
method addControls(self:var UI): void {.base.}
proc setButtonEvent(self: MainUI): void
proc setButtonEvent(self: SettingUI, ui: MainUI): void


proc main(): void =
  app.init()
  let ui: MainUI = newUI()
  ui.mainWindow.show()
  ui.settingUI.mainWindow.show()
  ui.settingUI.mainWindow.visible = false

  ui.resultArea.addLine("[Info]: Start program.")
  ui.setButtonEvent()
  ui.settingUI.setButtonEvent(ui)
  app.run()


proc newUI(): MainUI =
  result.initWindow("Main Window", 400, 600) # メイン画面作成
  result.settingUI.initWindow("Setting", 300, 400) # 設定画面作成
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
  self.mainUI = newLayoutContainer(Layout_Vertical)
  self.mainUI.heightMode = HeightMode_Expand
  self.mainUI.frame = newFrame("hogehoge")

  self.pathBox = newTextBox()

  self.downUI = newLayoutContainer(Layout_Horizontal)

  self.changeDirectoryButton = newButton("Change save directory")

  self.saveButton = newButton("Save settings")

  self.mainWindow.add(self.mainUI)
  self.mainUI.add(self.pathBox)
  self.mainUI.add(self.downUI)
  self.downUI.add(self.changeDirectoryButton)
  self.downUI.add(self.saveButton)


method addControls(self:var MainUI): void =
  self.mainUI = newLayoutContainer(Layout_Horizontal)

  self.leftUI = newLayoutContainer(Layout_Vertical)
  self.leftUI.heightMode = HeightMode_Expand # 縦方向に長さ最大
  self.leftUI.width = 150
  self.leftUI.xAlign = XAlign_Center # X軸で真ん中にコントロールを整列させる
  self.leftUI.frame = newFrame("-Menu-")

  let leftUIButtonHeight: int = 40

  self.beatmapMoveButton = newButton("Move beatmaps")
  self.beatmapMoveButton.height = leftUIButtonHeight
  self.beatmapMoveButton.widthMode = WidthMode_Expand

  self.settingButton = newButton("Settings")
  self.settingButton.height = leftUIButtonHeight
  self.settingButton.widthMode = WidthMode_Expand

  self.rightUI = newLayoutContainer(Layout_Vertical)

  self.resultArea = newTextArea()
  self.resultArea.editable = false

  self.progressBar =newProgressBar()

  self.mainWindow.add(self.mainUI)
  self.mainUI.add(self.leftUI)
  self.leftUI.add(self.beatmapMoveButton)
  self.leftUI.add(self.settingButton)
  self.mainUI.add(self.rightUI)
  self.rightUI.add(self.resultArea)
  self.rightUI.add(self.progressBar)


proc setButtonEvent(self: SettingUI, ui: MainUI): void =
  self.changeDirectoryButton.onClick = proc(event: ClickEvent) =
    var dialog = SelectDirectoryDialog()
    dialog.title = "Select Osu!/Songs directory"
    dialog.run()
    if dialog.selectedDirectory == "":
      return
    self.pathBox.text = dialog.selectedDirectory

  self.saveButton.onClick = proc(event: ClickEvent) =
    let path: string = self.pathBox.text
    if path == "":
      return
    let msg: string = updateConfigFile(configFilePath, path)
    self.mainWindow.msgBox(msg, "Success")
    ui.resultArea.addLine(msg)

  self.mainWindow.onCloseClick = proc(event: CloseClickEvent) =
    self.mainWindow.visible = false


proc setButtonEvent(self: MainUI): void =
  # 譜面移動ボタン
  self.beatmapMoveButton.onClick = proc(event: ClickEvent) =
    let result: ReturnPath = returnPath()
    if result.isError == 0: # Success
      let obj: MoveMapFiles = moveMapFiles(result.path)
      if not obj.isError:
        self.resultArea.addLine(obj.msg)
        return
      self.mainWindow.alert(obj.msg, "Error")
      self.resultArea.addLine(obj.msg)

    elif result.isError == 1:
      let errorText: string = fmt"[Error]: '{configFilePath}' file does not exist."
      self.mainWindow.alert(errorText, "Error")
      self.resultArea.addLine(errorText)

    elif result.isError == 2:
      let errorText: string = fmt"[Error]: Keyword 'path' does not exist in '{configFilePath}'."
      self.mainWindow.alert(errorText, "Error")
      self.resultArea.addLine(errorText)

  # 設定ボタン
  self.settingButton.onClick = proc(event: ClickEvent) =
    let result: ReturnPath = returnPath()
    if result.isError == 0:
      self.settingUI.pathBox.text = result.path
    self.settingUI.mainWindow.visible = true
    self.settingUI.pathBox.focus()
    echo self.settingUI.mainWindow.disposed

  # メイン画面を閉じる処理
  self.mainWindow.onCloseClick = proc(event: CloseClickEvent) =
    case self.mainWindow.msgBox("Do you want to quit?", "", "Quit", "Cancel")
    of 1: app.quit()
    else: discard


when isMainModule:
  main()
