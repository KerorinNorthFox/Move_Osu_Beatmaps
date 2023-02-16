import
  nigui,
  ./utils


proc makeNewWindow(name:string="", height:int=100, width:int=100, x:int=100, y:int=100): any =
  result = newWindow(name)
  result.height = height
  result.width = width
  result.x = x
  result.y = y

proc main(): void =
  app.init()
  let mainWindow = makeNewWindow("メインウィンドウ", 300, 500)

  let con = newLayoutContainer(Layout_Vertical)
  con.setPosition(100,130)
  mainWindow.add(con)

  mainWindow.show()
  app.run()


when isMainModule:
  main()
