import
  std/os,
  nigui,
  nigui/msgbox # example4,5
# First, import the library.

# NiGuiの基本的な使い方の例
proc example1(): void =
  app.init() # まず最初に初期化必須

  var window = newWindow("NiGui Example")
  # 引数にウィンドウのタイトルを取り、ウィンドウを作成する
  # デフォルトではウィンドウは空で、不可視状態
  # ウィンドウは画面の中央に表示される(画面左上を0としてwindow.x、window.yで指定可能)
  # 一つのウィンドウにつきコントロールは一つまで(コントロール->コンテナやボタンなどのオブジェクト)
  # コンテナは複数のコントロールを含めることができる(つまりウィンドウにつき一つコンテナを作り、その中に子コンテナを沢山追加してuiを構成する)

  window.width = 600.scaleToDpi
  window.height = 400.scaleToDpi
  # ウィンドウのサイズを設定

  # window.iconPath = "example_01_basic_app.png"
  # ウィンドウのアイコンを指定する
  # デフォルトでは実行するファイル名+.pngの名前が設定されている

  var container = newLayoutContainer(Layout_Vertical)
  # コントロールのコンテナを作成する
  # コンテナはコントロールを沢山まとめた親コントロール
  # デフォルトではコンテナは空
  # コンテナの大きさは子コントロールに合わせられる
  # LayoutContainerは自動的に子コンテナを整列させる
  # The layout is set to clhorizontal.

  window.add(container)
  # ウィンドウにコンテナを追加

  var button = newButton("Button 1")
  # 引数にタイトルを取り、ボタンを作成

  container.add(button)
  # コンテナにボタンを追加

  var textArea = newTextArea()
  # 複数行のテキストエリアを作成
  # デフォルトではテキストエリアは空で、編集可能

  container.add(textArea)
  # コンテナにテキストエリアを追加

  button.onClick = proc(event: ClickEvent) =
  # obj.onClick()でイベントハンドラを設定(ここでは無名関数として)

    textArea.addLine("Button 1 clicked, message box opened.")
    window.alert("This is a simple message box.")
    textArea.addLine("Message box closed.")

  window.show()
  # 画面上にウィンドウを可視化する
  # コントロール(コンテナ、ボタン、etc...)はデフォルトで可視状態

  app.run()
  # 最後にメインループを走らせる
  # これは入力イベントをアプリケーションが終了するまで処理する
  # アプリケーションを終了するには、ウィンドウをすべて閉じるか、"app.quit()"を呼び出す

# NiGuiのいくつかのコントロールの例
proc example2(): void =
  app.init()

  var window = newWindow()

  var container = newLayoutContainer(Layout_Vertical)
  window.add(container)

  # ボタンコントロールを追加:
  var button = newButton("Button")
  container.add(button)

  # チェックボックスコントロールを追加:
  var checkbox = newCheckbox("Checkbox")
  container.add(checkbox)

  # コンボボックスコントロールを追加:
  var comboBox = newComboBox(@["Option 1", "Option 2"])
  container.add(comboBox)

  # ラベルコントロールを追加:
  var label = newLabel("Label")
  container.add(label)

  # プログレスバーコントロールを追加:
  var progressBar = newProgressBar()
  progressBar.value = 0.5
  container.add(progressBar)

  # テキストボックスコントロールを追加:
  var textBox = newTextBox("TextBox")
  container.add(textBox)

  # テキストエリアコントロールを追加:
  var textArea = newTextArea("TextArea\pLine 2\p")
  container.add(textArea)

  # テキストエリアにテキストを追加
  for i in 3..15:
    textArea.addLine("Line " & $i)

  # ボタンにクリックイベントを追加
  button.onClick = proc(event: ClickEvent) =
    textArea.addLine("Button clicked")

  window.show()

  app.run()

# LayoutContainerにおけるコントロールの整列の可能性の例
proc example3(): void =
  app.init()

  # Row 1: Auto-sized:
  var innerContainer1 = newLayoutContainer(Layout_Horizontal)
  innerContainer1.frame = newFrame("Row 1: Auto-sized")
  # container.frame: コンテナに引数にタイトルを取りフレームを付ける
  for i in 1..3:
    var control = newButton("Button " & $i)
    innerContainer1.add(control)

  # Row 2: Auto-sized, more padding:
  var innerContainer2 = newLayoutContainer(Layout_Horizontal)
  innerContainer2.padding = 10
  # container.padding :コンテナにの周りに空白を付ける
  innerContainer2.frame = newFrame("Row 2: Auto-sized, more padding")
  for i in 1..3:
    var control = newButton("Button " & $i)
    innerContainer2.add(control)

  # Row 3: Auto-sized, more spacing:
  var innerContainer3 = newLayoutContainer(Layout_Horizontal)
  innerContainer3.spacing = 15
  # container.spacing :コンテナ内のコントロール間の空白を空ける
  innerContainer3.frame = newFrame("Row 3: Auto-sized, more spacing")
  for i in 1..3:
    var control = newButton("Button " & $i)
    innerContainer3.add(control)

  # Row 4: Controls with WidthMode_Fill:
  var innerContainer4 = newLayoutContainer(Layout_Horizontal)
  innerContainer4.frame = newFrame("Row 4: Controls with WidthMode_Fill")
  innerContainer4.width = 600
  # コンテナの横幅指定
  for i in 1..3:
    var control = newButton("Button " & $i)
    control.widthMode = WidthMode_Fill
    # コンテナいっぱいに広がるように(コンテナの幅は固定)コントロールの横幅モード指定
    innerContainer4.add(control)

  # Row 5: Controls with WidthMode_Expand:
  var innerContainer5 = newLayoutContainer(Layout_Horizontal)
  innerContainer5.frame = newFrame("Row 5: Controls with WidthMode_Expand")
  for i in 1..3:
    var control = newButton("Button " & $i)
    control.widthMode = WidthMode_Expand
    # ウィンドウいっぱいに広がるように(コンテナは可変)コントロールの横幅モード指定
    innerContainer5.add(control)

  # Row 6: Controls centered:
  var innerContainer6 = newLayoutContainer(Layout_Horizontal)
  innerContainer6.widthMode = WidthMode_Expand
  # ウィンドウいっぱいに広がるようにコンテナの横幅モード指定
  innerContainer6.height = 80 # problem
  innerContainer6.xAlign = XAlign_Center
  # x軸の中心になるように
  innerContainer6.yAlign = YAlign_Center
  # y軸の中心になるように
  innerContainer6.frame = newFrame("Row 6: Controls centered")
  for i in 1..3:
    var control = newButton("Button " & $i)
    innerContainer6.add(control)

  # Row 7: Container expanded, spread:
  var innerContainer7 = newLayoutContainer(Layout_Horizontal)
  # innerContainer.height = 80
  innerContainer7.widthMode = WidthMode_Expand
  innerContainer7.xAlign = XAlign_Spread
  # x軸でいっぱいに広がるようにコントロールを配置
  innerContainer7.frame = newFrame("Row 7: Container expanded, spread")
  for i in 1..3:
    var control = newButton("Button " & $i)
    innerContainer7.add(control)

  # Row 8: Static size:
  var innerContainer8 = newLayoutContainer(Layout_Horizontal)
  innerContainer8.widthMode = WidthMode_Expand
  innerContainer8.xAlign = XAlign_Center
  innerContainer8.yAlign = YAlign_Center
  innerContainer8.frame = newFrame("Row 8: Static size")
  for i in 1..3:
    var control = newButton("Button " & $i)
    control.width = 90 * i
    # コントロールの横幅指定
    control.height = 15 * i
    # コントロールの縦幅指定
    innerContainer8.add(control)

  var mainContainer = newLayoutContainer(Layout_Vertical)
  # ウィンドウに配置し、沢山のコンテナに含む上位コンテナの作成
  # ウィンドウ<-上位コンテナ<-機能別や配置別に分けられたの子コンテナ、という風に構成
  # ウィンドウにはコントロールを一つしか配置できないため、上位コンテナを間に挟む
  mainContainer.add(innerContainer1)
  mainContainer.add(innerContainer2)
  mainContainer.add(innerContainer3)
  mainContainer.add(innerContainer4)
  mainContainer.add(innerContainer5)
  mainContainer.add(innerContainer6)
  mainContainer.add(innerContainer7)
  mainContainer.add(innerContainer8)

  var window = newWindow()
  window.width = 800
  window.height = 600
  window.add(mainContainer)
  window.show()

  app.run()

# メッセージボックスを作る際のメソッドの違いの例
proc example4(): void =
  app.init()

  var window = newWindow()
  var mainContainer = newLayoutContainer(Layout_Vertical)
  window.add(mainContainer)

  var buttons = newLayoutContainer(Layout_Horizontal)
  mainContainer.add(buttons)

  var textArea = newTextArea()
  mainContainer.add(textArea)

  var button1 = newButton("Example 1")
  buttons.add(button1)
  button1.onClick = proc(event: ClickEvent) =
    window.alert("Hello.\n\nThis message box is created with \"alert()\".")
    # window.alert(text:string): 引数に表示するテキストを取る警告ウィンドウ
    textArea.addLine("Message box closed")

  var button2 = newButton("Example 2")
  buttons.add(button2)
  button2.onClick = proc(event: ClickEvent) =
    let res = window.msgBox("Hello.\n\nThis message box is created with \"msgBox()\".")
    # window.msgBox(text:string) :引数に表示するテキストを取るメッセージボックス
    # OKを押すと、返り値に1が返る
    textArea.addLine("Message box closed, result = " & $res)

  var button3 = newButton("Example 3")
  buttons.add(button3)
  button3.onClick = proc(event: ClickEvent) =
    let res = window.msgBox("Hello.\n\nThis message box is created with \"msgBox()\" and has three buttons.", "Title of message box", "Button 1", "Button 2", "Button 3")
    # window.msgBox(text:string, title:string, args:string)
    # 第二引数にメッセージボックスのタイトル、それ以降の引数でボタンを増やしていく
    # 返り値にはどのボタンを押したか1以降の数字が返ってくる
    textArea.addLine("Message box closed, result = " & $res)

  window.show()
  app.run()

# ウィンドウを閉じるボタンを押したときの処理の例
proc example5(): void =
  app.init()

  var window = newWindow()

  window.onCloseClick = proc(event: CloseClickEvent) =
    case window.msgBox("Do you want to quit?", "Quit?", "Quit", "Minimize", "Cancel")
    of 1: window.dispose() # ウィンドウを閉じる
    of 2: window.minimize() # ウィンドウを最小化
    else: discard # キャンセル

  window.show()
  app.run()

# キーボードのイベントを処理する例
proc example6(): void =
  app.init()

  var window = newWindow()

  var container = newLayoutContainer(Layout_Vertical)
  window.add(container)

  var textBox = newTextBox()
  container.add(textBox)

  var label = newLabel()

  window.onKeyDown = proc(event: KeyboardEvent) =
    label.text = label.text & "Window KeyDown event: key: " & $event.key & ", unicode: " & $event.unicode & ", character: " & event.character & ", down keys: " & $downKeys() & "\n"

    # Ctrl + Q -> Quit application
    if Key_Q.isDown() and Key_ControlL.isDown():
      app.quit() # アプリケーション終了

  textBox.onKeyDown = proc(event: KeyboardEvent) =
    label.text = label.text & "TextBox KeyDown event: key: " & $event.key & ", unicode: " & $event.unicode & ", character: " & event.character & ", down keys: " & $downKeys() & "\n"

    # Accept only digits
    if event.character.len > 0 and event.character[0].ord >= 32 and (event.character.len != 1 or event.character[0] notin '0'..'9'):
      event.handled = true

  container.add(label)

  window.show()
  textBox.focus() # テキストボックスにフォーカスした状態にする

  app.run()

# タイマーの使用例
proc example8(): void =
  app.init()

  var window = newWindow()

  var mainContainer = newLayoutContainer(Layout_Vertical)
  window.add(mainContainer)
  var buttonContainer = newLayoutContainer(Layout_Horizontal)
  mainContainer.add(buttonContainer)

  var textArea = newTextArea()
  mainContainer.add(textArea)

  var timer: Timer
  var counter = 1

  proc timerProc(event: TimerEvent) =
    textArea.addLine($counter)
    counter.inc()

  var button1 = newButton("startTimer()")
  buttonContainer.add(button1)
  button1.onClick = proc(event: ClickEvent) =
    timer = startTimer(2000, timerProc)
    # startTimerで第一引数の時間分delayし、第二引数のプロシージャを実行する

  var button2 = newButton("startRepeatingTimer()")
  buttonContainer.add(button2)
  button2.onClick = proc(event: ClickEvent) =
    timer = startRepeatingTimer(2000, timerProc)
    # startRepeatingTimerで第一引数の時間分delayし、第二引数のプロシージャを実行するのをtimer.stop()されるまで繰り返す

  var button3 = newButton("stopTimer()")
  buttonContainer.add(button3)
  button3.onClick = proc(event: ClickEvent) =
    timer.stop()

  window.show()

  app.run()

# コントロールのフォントサイズを変更する例
proc example9(): void =
  app.init()

  var window = newWindow()
  window.width = 500
  window.height = 600
  var container = newLayoutContainer(Layout_Vertical)
  window.add(container)

  for i in 12..20:
    var innerContainer = newLayoutContainer(Layout_Horizontal)
    container.add(innerContainer)
    innerContainer.frame = newFrame("Font size: " & $i)
    var button = newButton("Button")
    button.fontSize = i.float
    # control.fontSize :フォントサイズ変更、float値を渡す
    innerContainer.add(button)
    var label = newLabel("Label")
    label.fontSize = i.float
    innerContainer.add(label)

  window.show()
  app.run()

# コントロールのサーフェイスを描く例
proc example10(): void =
  app.init()
  var window = newWindow()
  window.width = 1000
  window.height = 800

  var control1 = newControl()
  window.add(control1)
  # Creates a drawable control

  control1.widthMode = WidthMode_Fill
  control1.heightMode = HeightMode_Fill
  # Let it fill out the whole window

  var image1 = newImage()
  image1.loadFromFile("example_01_basic_app.png")
  # Reads the file and holds the image as bitmap in memory

  var image2 = newImage()
  image2.resize(2, 2)
  # Creates a new bitmap

  image2.canvas.setPixel(0, 0, rgb(255, 0, 0))
  image2.canvas.setPixel(0, 1, rgb(255, 0, 0))
  image2.canvas.setPixel(1, 1, rgb(0, 255, 0))
  image2.canvas.setPixel(1, 0, rgb(0, 0, 255))
  # Modifies single pixels

  control1.onDraw = proc (event: DrawEvent) =
    let canvas = event.control.canvas
    # A shortcut

    canvas.areaColor = rgb(30, 30, 30) # dark grey
    canvas.fill()
    # Fill the whole area

    canvas.setPixel(0, 0, rgb(255, 0, 0))
    # Modifies a single pixel

    canvas.areaColor = rgb(255, 0, 0) # red
    canvas.drawRectArea(10, 10, 30, 30)
    # Draws a filled rectangle

    canvas.lineColor = rgb(255, 0, 0) # red
    canvas.drawLine(60, 10, 110, 40)
    # Draws a line

    let text = "Hello World!"
    canvas.textColor = rgb(0, 255, 0) # lime
    canvas.fontSize = 20
    canvas.fontFamily = "Arial"
    canvas.drawText(text, 10, 70)
    # Outputs a text

    canvas.drawRectOutline(10, 70, canvas.getTextWidth(text), canvas.getTextLineHeight())
    # Draws a rectangle outline

    canvas.drawImage(image1, 10, 120)
    # Draws an image in original size

    canvas.drawImage(image2, 120, 120, 50)
    # Draws an image stretched

  control1.onMouseButtonDown = proc (event: MouseEvent) =
    echo(event.button, " (", event.x, ", ", event.y, ")")
    # Shows where the mouse is clicked in control-relative coordinates

  window.show()
  app.run()

when isMainModule:
  let cmdArgCount: int = paramCount()
  if cmdArgCount == 0:
    echo "[Error]: No commandline args."
  elif cmdArgCount == 1:
    let cmdArg: string = paramStr(1)
    if cmdArg == "1":
      example1()
    elif cmdArg == "2":
      example2()
    elif cmdArg == "3":
      example3()
    elif cmdArg == "4":
      example4()
    elif cmdArg == "5":
      example5()
    elif cmdArg == "6":
      example6()
    elif cmdArg == "8":
      example8()
    elif cmdArg == "9":
      example9()
    elif cmdArg == "10":
      example10()
    else:
      echo "[Error]: Unexcepted command"

  else:
    echo "[Error]: Too many commandline args"
