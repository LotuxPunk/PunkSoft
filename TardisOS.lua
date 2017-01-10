--Cree par LotuxPunk
m = peripheral.wrap("left")
m.setBackgroundColor(colors.white)
m.clear()

--Initialisation de la table
c = {}
c[1] = " "
c[2] = " "
c[3] = " "
c[4] = " "
c[5] = " "
c[6] = " "
c[7] = " "
c[8] = " "
c[9] = " "
c[10] = " "
c[11] = " "
c[12] = " "
c[13] = " "
c[14] = " "
c[15] = " "
c[16] = " "
c[17] = " "
c[18] = " "
c[19] = " "
c[20] = " "

--Detection du dossier de donnees ou creation
if fs.getDir("appData")==false then
  fs.makeDir("appData")
end

function save()
  h = fs.open("appData/dataT","w")
  for i = 1,#c do
    texte = c[i]
    --print(texte)
    h.writeLine(texte)
    --print(i)
  end
  h.close()
  return
end

--Detection du fichier de donnees
if fs.exists("appData/dataT")==false then
  save()
else
  h = fs.open("appData/dataT","r")
  for i = 1,#c,1 do
    texte = h.readLine()
    c[i] = texte
  end
end

--fonction d'ecriture
function screen()
  local y = 3
  m.clear()
  m.setCursorPos(2,1)
  m.setTextColor(colors.cyan)
  m.write("PunkDows - TARDIS")
  m.setTextColor(colors.black)
  for i = 1,#c,1 do
    m.setCursorPos(1,y)
    y = y + 1
    m.write(i..") "..c[i])
  end
end

--Fonction de gestion de DB
function gestion()
  while true do
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.cyan)
    term.clear()
    term.setCursorPos(1,1)
    term.write("PunkDows - TARDIS")
    term.setTextColor(colors.white)
    term.setCursorPos(2,2)
    term.write("Quel est la position a editer ?")
    term.setCursorPos(3,3)
    local pos = read()
    local pos = tonumber(pos)
    term.setCursorPos(2,4)
    term.write("Quel est le nom a lui donner ?")
    term.setCursorPos(3,5)
    local info = read()
    c[pos]=info
    --print(c)
    --sleep(5)
    save()
    --sleep(3)
    screen()
  end
end

screen()
gestion()
