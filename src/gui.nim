import
  nigui,
  nigui/msgbox,
  std/strformat,
  std/sugar,
  ./utils,
  ./lang


type Application = object of RootObj
  window: Window # メイン画面
  mainUi: LayoutContainer # 画面最上位コンテナ

# 設定画面のUI
type SettingWindow = object of Application
  changePathUi: LayoutContainer
  pathBox: TextBox # パスを表示＆入力するテキストボックス
  buttonUi: LayoutContainer
  changeDirectoryButton: Button # 下UI->移動先のディレクトリを選択するボタン
  saveButton: Button # 下UI->設定を保存するボタン

  changeLangUi: LayoutContainer
  comboBox: ComboBox
  changeLangButton: Button # 言語変更ボタン

# メイン画面のUI
type MainWindow = object of Application
  leftUi: LayoutContainer # 左UI
  beatmapMoveButton: Button # 左UI->譜面移動ボタン
  settingButton: Button # 左UI->設定画面ボタン

  resultArea: TextArea # 右UI->結果表示エリア

  setting: SettingWindow # 設定ウィンドウ


proc newApp(): MainWindow
method init(self:var Application, title:string="", height:int=100, width:int=100): void {.base.}
method setControls(self:var Application): void {.base.}
proc setButtonEvent(self: MainWindow): void
proc setButtonEvent(self: SettingWindow, ui: MainWindow): void


proc main(): void =
  app.init()
  let application: MainWindow = newApp()
  application.setButtonEvent()
  application.setting.setButtonEvent(application)

  application.window.show()
  application.setting.window.show()
  application.setting.window.visible = false

  application.resultArea.addLine(LANG[LANGMODE].startProgram)
  app.run()


proc newApp(): MainWindow =
  result.init(LANG[LANGMODE].mainWindowTitle, 400, 600) # メイン画面作成
  result.setting.init(LANG[LANGMODE].settingWindowTitle, 300, 400) # 設定画面作成
  result.setControls()
  result.setting.setControls()


method init(self:var Application, title:string="", height:int=100, width:int=100): void {.base.} =
  self.window = newWindow(title)
  self.window.height = height.scaleToDpi
  self.window.width = width.scaleToDpi


method setControls(self:var Application): void {.base.} =
  self.mainUi = newLayoutContainer(Layout_Horizontal)
  self.window.add(self.mainUi)


method setControls(self:var SettingWindow): void =
  self.mainUi = newLayoutContainer(Layout_Vertical)

  self.changePathUi = newLayoutContainer(Layout_Vertical)
  self.changePathUi.widthMode = WidthMode_Expand
  self.changePathUi.frame = newFrame(LANG[LANGMODE].sChangePathUiFrameText)

  self.pathBox = newTextBox()

  self.buttonUi = newLayoutContainer(Layout_Horizontal)

  self.changeDirectoryButton = newButton(LANG[LANGMODE].sChangeDirButtonText)

  self.saveButton = newButton(LANG[LANGMODE].sSaveButton)

  self.changeLangUi = newLayoutContainer(Layout_Vertical)
  self.changeLangUi.widthMode = WidthMode_Expand
  self.changeLangUi.frame = newFrame(LANG[LANGMODE].sChangeLangUiFrameText)

  let langSeq = collect(newSeq):
    for lang in LANG: lang.language
  self.comboBox = newComboBox(langSeq)

  self.changeLangButton = newButton(LANG[LANGMODE].sChangeLangButton)

  self.window.add(self.mainUi)
  self.mainUi.add(self.changePathUi)
  self.changePathUi.add(self.pathBox)
  self.changePathUi.add(self.buttonUi)
  self.buttonUi.add(self.changeDirectoryButton)
  self.buttonUi.add(self.saveButton)
  self.mainui.add(self.changeLangUi)
  self.changeLangUi.add(self.comboBox)
  self.changeLangUi.add(self.changeLangButton)


method setControls(self:var MainWindow): void =
  self.mainUi = newLayoutContainer(Layout_Horizontal)

  const leftUiButtonHeight: int = 40

  self.leftUi = newLayoutContainer(Layout_Vertical)
  self.leftUi.heightMode = HeightMode_Expand # 縦方向に長さ最大
  self.leftUi.width = 150
  self.leftUi.xAlign = XAlign_Center # X軸で真ん中にコントロールを整列させる
  self.leftUi.frame = newFrame(LANG[LANGMODE].mLeftUiFrameText)

  self.beatmapMoveButton = newButton(LANG[LANGMODE].mBeatmapMoveButton)
  self.beatmapMoveButton.height = leftUiButtonHeight
  self.beatmapMoveButton.widthMode = WidthMode_Expand

  self.settingButton = newButton(LANG[LANGMODE].mSettingButton)
  self.settingButton.height = leftUiButtonHeight
  self.settingButton.widthMode = WidthMode_Expand

  self.resultArea = newTextArea()
  self.resultArea.editable = false

  self.window.add(self.mainUi)
  self.mainUi.add(self.leftUI)
  self.leftUi.add(self.beatmapMoveButton)
  self.leftUi.add(self.settingButton)
  self.mainUi.add(self.resultArea)


proc setButtonEvent(self: SettingWindow, ui: MainWindow): void =
  # パスを入力するテキストボックスの内容が変更されたときの処理
  self.pathBox.onTextChange = proc(event: TextChangeEvent) =
    self.saveButton.enabled = true

  # フォルダ選択のボタンが押されたときの処理
  self.changeDirectoryButton.onClick = proc(event: ClickEvent) =
    var dialog = SelectDirectoryDialog()
    dialog.title = LANG[LANGMODE].changeOsuSongsDirDialogTitle
    dialog.run()
    if dialog.selectedDirectory == "":
      return
    self.pathBox.text = dialog.selectedDirectory
    self.saveButton.enabled = true

  # 入力されたパスを保存するときの処理
  self.saveButton.onClick = proc(event: ClickEvent) =
    let path: string = self.pathBox.text
    if path == "":
      return
    let msg: string = updatePath(path)
    self.window.msgBox(msg, "Success")
    ui.resultArea.addLine(msg)
    self.saveButton.enabled = false

  # コンボボックスが変更されたときの処理
  self.comboBox.onChange = proc(event: ComboBoxChangeEvent) =
    self.changeLangButton.enabled = true

  # 言語変更のボタンが押されたときの処理
  self.changeLangButton.onClick = proc(event: ClickEvent) =
    updateLangMode(self.comboBox.index)
    self.window.alert("Language is changed. Please restart.", "Info")
    ui.resultArea.addLine(LANG[LANGMODE].changeLangTextAreaFront & self.comboBox.value & LANG[LANGMODE].changeLangTextAreaBack)
    self.changeLangButton.enabled = false

  # ウィンドウを閉じるボタンが押されたときの処理
  self.window.onCloseClick = proc(event: CloseClickEvent) =
    self.window.visible = false


proc setButtonEvent(self: MainWindow): void =
  # 譜面移動ボタンが押されたときの処理
  self.beatmapMoveButton.onClick = proc(event: ClickEvent) =
    let result: ReturnPath = returnPath()
    if result.isError == 0: # Success
      let obj: MoveMapFiles = moveMapFiles(result.path)
      if not obj.isError:
        self.resultArea.addLine(obj.msg)
        return
      self.window.alert(obj.msg, "Error")
      self.resultArea.addLine(obj.msg)

    elif result.isError == 1:
      let errorText: string = fmt"[Error]: '{configFilePath}'" & LANG[LANGMODE].fileDoesNotExistErrorText
      self.window.alert(errorText, "Error")
      self.resultArea.addLine(errorText)

    elif result.isError == 2:
      let errorText: string = LANG[LANGMODE].keywordDoesNotExistErrorTextFront & configFilePath & LANG[LANGMODE].keywordDoesNotExistErrorTextBack
      self.window.alert(errorText, "Error")
      self.resultArea.addLine(errorText)

  # 設定ボタンが押されたときの処理
  self.settingButton.onClick = proc(event: ClickEvent) =
    self.setting.pathBox.text = ""
    let result: ReturnPath = returnPath()
    if result.isError == 0:
      self.setting.pathBox.text = result.path
    self.setting.window.visible = true
    self.setting.changeLangButton.enabled = false
    self.setting.saveButton.enabled = false
    self.setting.pathBox.focus()

  # メイン画面を閉じるときの処理
  self.window.onCloseClick = proc(event: CloseClickEvent) =
    case self.window.msgBox(LANG[LANGMODE].endProgram, LANG[LANGMODE].endProgramTitle, LANG[LANGMODE].endProgramButton, LANG[LANGMODE].cancel)
    of 1: app.quit()
    else: discard


when isMainModule:
  main()
