package = "cosy-editor"
version = "master-1"
source  = {
  url = "git://github.com/cayonerie/server"
}

description = {
  summary    = "CosyVerif: editor",
  detailed   = [[
    Editor of the CosyVerif platform.
  ]],
  homepage   = "http://www.cosyverif.org/",
  license    = "MIT/X11",
  maintainer = "Alban Linard <alban@linard.fr>",
}

dependencies = {
  "lua >= 5.1",
  "argparse",
  "ansicolors",
  "copas",
  "jwt",
  "layeredata",
  "lua-websockets",
  "lustache",
}

build = {
  type    = "builtin",
  modules = {
    ["cosy.editor.cli"] = "src/cosy/editor/cli.lua",
  },
  install = {
    bin = {
      ["cosy-editor"] = "src/cosy/editor/bin.lua",
    },
  },
}