local Games = loadstring(game:HttpGet("https://raw.githubusercontent.com/itsMeArul/NoahHub/main/GameList.lua"))()

if Games[game.PlaceId] then
    loadstring(game:HttpGet(Games[game.PlaceId]))()
else
    game.Players.LocalPlayer:Kick("Game ini tidak ada di Loader")
end