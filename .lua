local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Slime RNG - マリン",
   ScriptID = "sid_8sjmcfk70kuj",
   LoadingTitle = "Slime RNG Script",
   LoadingSubtitle = "By マリン",
   ShowText = "マリン",

   ToggleUIKeybind = "K",

   ConfigurationSaving = {
      Enabled = true,
      FolderName = "Slime RNG",
      FileName = "Slime RNG Config"
   },

   Discord = {
      Enabled = true,
      Invite = "zHFNDBRWZB",
      RememberJoins = true
   },
   
})

Rayfield:LoadConfiguration()
