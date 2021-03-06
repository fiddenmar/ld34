Globals = {};
 
local _instance;
 
function Globals.getInstance()
    if not _instance then
        _instance = Globals;
        _instance.getType = function()
        	return "Globals";
	    end
	    _instance.getTranslation = function()
	    	return 8
	    end
        _instance.getTileSize = function()
            return 16
        end
        _instance.getLevels = function()
            return {"level1",
                    "level2",
                    "level3",
                    "level4",
                    "level5"
                    }
        end
    end
 
    return _instance
end
 
function Globals:new()
    print('Globals cannot be instantiated - use getInstance() instead');
end