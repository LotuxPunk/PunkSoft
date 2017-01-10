--Cree par LotuxPunk

--initialisation des peripheriques
local r = peripheral.wrap("back") --reacteur
local m = peripheral.wrap("top") --monitor
--local w = peripheral.wrap("right") --wifi
--Introduire ici le maximum souhaite :v
local maxE = 8500000
--Introduire ici le minimum souhaite :v
local minE = 5000000
--Ancien stockage en RF
local ancien = r.getEnergyStored()
local mode = "0"
local theme = "J"
local bg = colors.white
local ctexte = colors.gray
local ctitre = colors.black
local mx,my = m.getSize()

--creation ou lecture du fichier "dataR"
if fs.exists("dataR4") == false then
  local h = fs.open("dataR4","w")
  h.writeLine("0")
  h.writeLine("J")
  mode = "0" -- 0 = manuel / 1 = auto
  theme = "J" -- J = clair / N = sombre
  print("Creation du fichier dataR4")
else
  local h = fs.open("dataR4","r")
  mode = h.readLine()
  print(mode)
  theme = h.readLine()
  print("Lecture du fichier dataR4")
  h.close()
end

--Definition de la couleur
function couleur()
if theme == "J" then
  bg = colors.white
  ctexte = colors.gray
  ctitre = colors.black
else
  bg = colors.black
  ctexte = colors.white
  ctitre = colors.lightBlue
end
end

--fonction gerant l'ecran
function ecran(mode)
  m.setBackgroundColor(bg)
  m.setCursorPos(1,1)
  m.setTextColor(colors.cyan)
  m.clear()
  m.write("PunkDows - Reactor")
  m.setCursorPos(2,3)
  if r.getEnergyStored() >= minE then
  m.setTextColor(colors.green)
  else
  m.setTextColor(colors.red)
  end
  local conso = r.getEnergyStored() - ancien
  m.write(r.getEnergyStored().." RF")
  ancien = r.getEnergyStored()
  m.setCursorPos(2,4)
  m.setTextColor(ctexte)
  if r.getEnergyStored() > 0 then
  m.write(conso.." RF/S")
  else
  m.write(r.getEnergyProducedLastTick().." RF/T")
  end
  m.setCursorPos(2,5)
  if r.getActive() == false then
  m.setTextColor(colors.red)
  m.write("OFF")
  else
  m.setTextColor(colors.green)
  m.write("ON")
  end
  m.setCursorPos(2,2)
  m.setTextColor(colors.red)
  m.write("[x] Mode : ")
  m.setTextColor(ctitre)
  if mode == "0" then
    m.write("Manuel")
  else
    m.write(" Auto ")
  end
  m.setTextColor(colors.red)
  m.write(" - [x] ")
  m.setTextColor(ctitre)
  m.write(theme)
  m.write(texte)
end

--Fonction de gnration de l'ecran
function genString(titre,ligne,texte)
  m.setTextColor(ctitre)
  m.setCursorPos(2,ligne)
  m.write(titre)
  m.setTextColor(ctexte)
  m.setCursorPos(mx-string.len(texte)-1)
end
--fonction de verifications
function verEnergie()
  local stock = r.getEnergyStored()
  local actif = r.getActive()
  if stock >= maxE and actif == true then
    r.setActive(false)
  elseif stock <= minE and actif == false then
    r.setActive(true)
  end
end

--Function principale (engine)
function autoMain()
 ecran(mode)
	if mode == "1" then
      verEnergie()
	end
    sleep(1)
end

function change()
	--Boucle de verification
		event, side, x, y = os.pullEvent("monitor_touch")
		if x <= 3 and x >= 1 and y == 2 then
    if mode == "0" then
			    mode = "1"
    else
      mode = "0"
    end
  elseif x <= 23 and x >= 21 and y == 2 then
    if theme == "J" then
       theme = "N"
       couleur()
    else
      theme = "J"
      couleur()
    end
  end      
		  local h = fs.open("dataR4","w")
		  h.writeLine(mode)
    h.writeLine(theme)
		  h.close()
end

couleur()
while true do
  parallel.waitForAny(autoMain, change)
end
