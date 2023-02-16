import nigui
# First, import the library.

proc example1(): void =
  # NiGuiの基本的な使い方の例

  app.init() # まず最初に初期化必須

  var window = newWindow("NiGui Example")
  # 引数にウィンドウのタイトルを取り、ウィンドウを作成する
  # デフォルトではウィンドウは空で、不可視
  # ウィンドウは画面の中央に表示される(画面左上を0としてwindow.x、window.yで指定可能)
  # 一つのウィンドウにつきコントロールは一つまで
  # コンテナは複数のコントロールを含めることができる

  window.width = 600.scaleToDpi
  window.height = 400.scaleToDpi
  # ウィンドウのサイズを設定

  # window.iconPath = "example_01_basic_app.png"
  # ウィンドウのアイコンを指定する
  # デフォルトでは実行するファイル名+.pngの名前が設定されている

  var container = newLayoutContainer(Layout_Vertical)
  # コントロールのコンテナを作成する
  # デフォルトではコンテナは空
  # It's size will adapt to it's child controls.
  # A LayoutContainer will automatically align the child controls.
  # The layout is set to clhorizontal.

  window.add(container)
  # Add the container to the window.

  var button = newButton("Button 1")
  # Create a button with a given title.

  container.add(button)
  # Add the button to the container.

  var textArea = newTextArea()
  # Create a multiline text box.
  # By default, a text area is empty and editable.

  container.add(textArea)
  # Add the text area to the container.

  button.onClick = proc(event: ClickEvent) =
  # Set an event handler for the "onClick" event (here as anonymous proc).

    textArea.addLine("Button 1 clicked, message box opened.")
    window.alert("This is a simple message box.")
    textArea.addLine("Message box closed.")

  window.show()
  # Make the window visible on the screen.
  # Controls (containers, buttons, ..) are visible by default.

  app.run()
  # At last, run the main loop.
  # This processes incoming events until the application quits.
  # To quit the application, dispose all windows or call "app.quit()".

proc example2(): void =
  # This example shows several controls of NiGui.

  app.init()

  var window = newWindow()

  var container = newLayoutContainer(Layout_Vertical)
  window.add(container)

  # Add a Button control:
  var button = newButton("Button")
  container.add(button)

  # Add a Checkbox control:
  var checkbox = newCheckbox("Checkbox")
  container.add(checkbox)

  # Add a ComboBox control:
  var comboBox = newComboBox(@["Option 1", "Option 2"])
  container.add(comboBox)

  # Add a Label control:
  var label = newLabel("Label")
  container.add(label)

  # Add a Progress Bar control:
  var progressBar = newProgressBar()
  progressBar.value = 0.5
  container.add(progressBar)

  # Add a TextBox control:
  var textBox = newTextBox("TextBox")
  container.add(textBox)

  # Add a TextArea control:
  var textArea = newTextArea("TextArea\pLine 2\p")
  container.add(textArea)

  # Add more text to the TextArea:
  for i in 3..15:
    textArea.addLine("Line " & $i)

  # Add click event to the button:
  button.onClick = proc(event: ClickEvent) =
    textArea.addLine("Button clicked")

  window.show()

  app.run()

proc example3(): void =
  # This example shows some possibilities to align controls with a LayoutContainer.

  app.init()

  # Row 1: Auto-sized:
  var innerContainer1 = newLayoutContainer(Layout_Horizontal)
  innerContainer1.frame = newFrame("Row 1: Auto-sized")
  for i in 1..3:
    var control = newButton("Button " & $i)
    innerContainer1.add(control)

  # Row 2: Auto-sized, more padding:
  var innerContainer2 = newLayoutContainer(Layout_Horizontal)
  innerContainer2.padding = 10
  innerContainer2.frame = newFrame("Row 2: Auto-sized, more padding")
  for i in 1..3:
    var control = newButton("Button " & $i)
    innerContainer2.add(control)

  # Row 3: Auto-sized, more spacing:
  var innerContainer3 = newLayoutContainer(Layout_Horizontal)
  innerContainer3.spacing = 15
  innerContainer3.frame = newFrame("Row 3: Auto-sized, more spacing")
  for i in 1..3:
    var control = newButton("Button " & $i)
    innerContainer3.add(control)

  # Row 4: Controls with WidthMode_Fill:
  var innerContainer4 = newLayoutContainer(Layout_Horizontal)
  innerContainer4.frame = newFrame("Row 4: Controls with WidthMode_Fill")
  innerContainer4.width = 600
  for i in 1..3:
    var control = newButton("Button " & $i)
    control.widthMode = WidthMode_Fill
    innerContainer4.add(control)

  # Row 5: Controls with WidthMode_Expand:
  var innerContainer5 = newLayoutContainer(Layout_Horizontal)
  innerContainer5.frame = newFrame("Row 5: Controls with WidthMode_Expand")
  for i in 1..3:
    var control = newButton("Button " & $i)
    control.widthMode = WidthMode_Expand
    innerContainer5.add(control)

  # Row 6: Controls centered:
  var innerContainer6 = newLayoutContainer(Layout_Horizontal)
  innerContainer6.widthMode = WidthMode_Expand
  innerContainer6.height = 80 # problem
  innerContainer6.xAlign = XAlign_Center
  innerContainer6.yAlign = YAlign_Center
  innerContainer6.frame = newFrame("Row 6: Controls centered")
  for i in 1..3:
    var control = newButton("Button " & $i)
    innerContainer6.add(control)

  # Row 7: Container expanded, spread:
  var innerContainer7 = newLayoutContainer(Layout_Horizontal)
  # innerContainer.height = 80
  innerContainer7.widthMode = WidthMode_Expand
  innerContainer7.xAlign = XAlign_Spread
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
    control.height = 15 * i
    innerContainer8.add(control)

  var mainContainer = newLayoutContainer(Layout_Vertical)
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

when isMainModule:
  discard