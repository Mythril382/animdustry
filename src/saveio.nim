import os, vars, types, strformat, core, fau/assets, msgpack4nim

let 
  dataDir = getSaveDir("absurd")
  dataFile = dataDir / "data.bin"

proc packType*[ByteStream](s: ByteStream, unit: Unit) =
  s.pack(if unit == nil: "nil" else: unit.name)

proc unpackType*[ByteStream](s: ByteStream, unit: var Unit) =
  var str: string
  s.unpack(str)

  if str == "nil":
    unit = nil
    return
  for other in allUnits:
    if other.name == str:
      unit = other
      return
  
  unit = unitMono

proc saveGame* =
  dataDir.createDir()

  try:
    dataFile.writeFile(pack(save))
  except IOError:
    echo &"Error: Failed to write save data: {getCurrentExceptionMsg()}"

proc loadGame* =
  echo "Loading game from ", dataFile
  ## Loads game data from the save file. Does nothing if there is no data.
  if fileExists(dataFile):
    try:
      unpack(dataFile.readFile, save)
      echo "Loaded game state."
    except: echo &"Failed to load save state: {getCurrentExceptionMsg()}"