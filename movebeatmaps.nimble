version       = "1.1.1"
author        = "KerorinNF"
description   = "A tool for not osu! supporter player that moves beatmaps all at once."
license       = "MIT"
srcDir        = "src"
bin           = @["MoveBeatmaps"]

requires "nim >= 1.6.8"

import os, strformat

task dist, "Create zip for release":
  let
    app = "MoveBeatmaps"
    bin = app / "bin"
    srcApp = "src" / app
    guiApp = "src" / "pkg" / "gui"
  mkdir(bin)
  cpFile("LICENSE", app/"LICENSE")
  cpFile("README.md", app/"README.md")
  exec &"nim c -d:release -d:ssl --opt:size --app:gui {guiApp}.nim"
  exec &"nim c -d:release -d:ssl --opt:size {srcApp}.nim"