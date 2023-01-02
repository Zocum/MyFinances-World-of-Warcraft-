local options = {

    ["level"] = UnitLevel("player"),
    ["class"] = UnitClass("player")
};

print('You are level ' .. options["level"]);
print('You are a ' .. options["class"]);