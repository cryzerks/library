--[[
      * Beta *
  * Sendiago.Isc *  
  * Coder: Kerin *
]]

-- * script helpers

local helpers_ = {  
    colors_ = {
        black = {
            [0] = color.new(0, 0, 0, 0),
            [120] = color.new(0, 0, 0, 120),
            [255] = color.new(0, 0, 0, 255),
        },
        
        console = {
            [0] = color.new(158, 175, 255, 0),
            [120] = color.new(158, 175, 255, 120),
            [255] = color.new(158, 175, 255, 255),
        },
        
        white = {
            [0] = color.new(255, 255, 255, 0),
            [120] = color.new(255, 255, 255, 120),
            [255] = color.new(255, 255, 255, 255),
        
            other_type = {
              [0] = color.new(155, 155, 155, 255),
              [1] = color.new(225, 225, 225, 255),
            },
        },
    },

    information_script = {
        build = ("%s"):format("beta"),
        name_script = ("%s"):format("sendiago.isc"),
    },
}
-- * end

-- * fonts
local Http = {}

Http.assets = {
    {
        name = "Acta Symbols W95 Arrows.ttf",
        path = "C:\\files\\",
        link = "https://raw.githubusercontent.com/qhouz/Fonts/main/DrainYaw/Acta Symbols W95 Arrows.ttf"
    }
}

local assets = {}

assets.load = function()
    if #Http.assets < 0 then
        return
    end

    for key, value in ipairs(Http.assets) do
        if not value.name and not value.link then
            return
        end

        local current_path = value.path ~= nil and value.path .. value.name or assets_path .. value.name
        local http_data = http.get(value.link)

        if not file.exists(current_path) and http_data ~= nil then
            file.write(current_path, http_data)
        end
    end
end; assets.load()

local fonts_ = {}

fonts_.verdana = {
  [13] = render.setup_font("Verdana", 13),
  [12] = render.setup_font("Verdana", 12)
}

fonts_.smallest = {
  [10] = render.setup_font("smallest_pixel-7", 10)
}

if file.exists("C:\\files\\Acta Symbols W95 Arrows.ttf") then
  fonts_.arrows = render.setup_font("C:/files/Acta Symbols W95 Arrows.ttf", 18)
end
-- * end

-- * anim
local welcome = 0
local time = 12
-- * end

-- * console helper
local console = {
    -- Muliprint
    helpers = {
      -- [Render] Multicmd
      multi_execute = function(self, ...)
        local arguments = {...}
        for _, command in pairs(arguments) do
          if type(command) ~= "string" then
            error("[sendiago_error] {Multicmd} Incorrect command type.", 2) end
  
          console.execute_client_cmd(command)
        end
      end,
    
      -- [Render] Multitext
      multi_color_print = function(self, ...)
        local arguments = {...}
        local length = #arguments
        if length % 2 ~= 0 then
          error("[sendiago_error] {MultiText} Incorrect limit.", 2) end
      
        local half = length /2
        for index = 1, half do
          local text  = arguments[index]
          local color = arguments[half + index]
        
          if type(text) ~= "string" then
            error("[sendiago_error] {MultiText} 1/2: not string type") end
        
          if type(color) ~= "userdata" then
            error("[sendiago_error] {MultiText} 2/2: not userdata/color type") end
        
          console.print_color(text, color)
        end
      end
    },
    string = {
      animation = function(self, text)
        local animation = {""};
      
        for index = 1, #text do
          local slice = text:sub(1, index)
          table.insert(animation, slice)
        end
  
        table.insert(animation, text)
  
        for index = #animation, 1, -1 do
          local slice = animation[index]
          table.insert(animation, slice)
        end
  
        return animation
      end,
    },
    math_helpers = {
      round = function(value, padding)
        if type(value) ~= "number" then
          error("[sendiago_error] {Rounding} Incorrect value type.", 2) end
        
        local multiplier = 10 ^ (padding or 0);
        return math.floor(value * multiplier + 0.5) / multiplier
      end,
    },
  }
-- * end

console.helpers:multi_execute("clear", "con_filter_enable 1")


local offset = 5
local lerp = function(a, b, percentage) return a + (b - a) * percentage;end
local print = function(...)local data = {...};local current_table_with_strings = {};if #data == 0 then current_table_with_strings[#current_table_with_strings + 1] = "No values selected to debug.";else for index = 1, #data do local current_element = data[index];if type(current_element) == "function" then current_table_with_strings[index] = ("function %s: %s"):format((tostring(current_element)):gsub("function: ", ""), current_element() or "nil");elseif type(current_element) == "table" then for additional_elements = 1, #current_element do if type(current_element[additional_elements]) == "function" then current_element[additional_elements] = ("function %s: %s"):format((tostring(current_element[additional_elements])):gsub("function: ", ""), current_element[additional_elements]() or "nil");elseif type(current_element[additional_elements]) == "string" then current_element[additional_elements] = ("\"%s\""):format(current_element[additional_elements]);else current_element[additional_elements] = tostring(current_element[additional_elements]);end;end;current_table_with_strings[index] = ("{%s}"):format(table.concat(current_element, ", "));else current_table_with_strings[index] = tostring(current_element);end;end;end;console.print_color("[Necron] ", color.new(255, 192, 118));console.print(table.concat(current_table_with_strings, " ") .. "\n");end


-- * render helpers
render.measure_multitext = function(_table)
    local a = 0

    for b, c in pairs(_table) do
        if not c.font then
            return
        end

        a = a + render.get_text_width(c.font, c.text)
    end

    return a
end

render.multitext = function(x, y, _table)
    for a, b in pairs(_table) do
        if not b.font then
            return
        end

        b.shadow = b.shadow or false
        b.outline = b.outline or false
        b.color = b.color or color.new(255, 255, 255, 255)

        render.text(b.font, x, y, b.color, b.text, b.shadow, b.outline)

        x = x + render.get_text_width(b.font, b.text)
    end
end
-- * end

-- * ui
ui.add_button("load sendiago")
-- * end

-- * on load
local global_ = {}
local visual_functions = {}
local antiaim_functions = {}

global_.load_script = function()
if ui.get_button("load sendiago") then

  -- * console
  local nickname = engine.get_gamename()
  local build = helpers_.information_script.build

  console.helpers:multi_color_print(
    "sendiago", " >> ", "successfully loaded script\n",
    "sendiago", " >> ", "username: ".. nickname .."\n",
    "sendiago", " >> ", "build: ".. build .."\n",      
      

    helpers_.colors_.console[255], color.new(30, 30, 30), helpers_.colors_.white[255],
    helpers_.colors_.console[255], color.new(30, 30, 30), helpers_.colors_.white[255],
    helpers_.colors_.console[255], color.new(30, 30, 30), helpers_.colors_.white[255]
  )
  -- * end
  
  ui.add_colorpicker("global color")
  ui.add_checkbox("watermark")
  ui.add_checkbox("indicators")
  ui.add_checkbox("table")
  ui.add_checkbox("arrows")
  ui.add_combobox("antiaim preset",{"None", "EXI-MODE"}) 
  ui.add_checkbox("staic leg in air")
  ui.add_checkbox("pitch 0 on land")
    

  -- * notify
  visual_functions.notify = function()
    local width, height = render.get_text_width(fonts_.verdana[12], text) + 239, 50
    local x, y = 510, 750
      
    time = time - globalvars.get_frametime()
    welcome = lerp(welcome, time <= 0 and 0 or 1, globalvars.get_frametime(), 8)
      
    local text = "Welcome back! Script successfully loaded"
    
    render.blur(x, y, width, height, 255 * welcome)
    render.rect_filled(x, y, width, height, color.new(0, 0, 0, 220 * welcome))
    render.gradient(x, y, 120, 2, color.new(0, 0, 0, 0 * welcome), color.new(158, 175, 255, 255 * welcome))
    render.gradient(x + 120, y, 120, 2, color.new(158, 175, 255, 255 * welcome), color.new(0, 0, 0, 0 * welcome))
    render.text(fonts_.verdana[12], x + 13, y + 19, color.new(255, 255, 255, 255 * welcome), text, true)
  end
  -- * end


  -- * watermark
  local anim_ping = 0

  visual_functions.watermark = function()

    if not ui.get_bool("watermark") then
      return
    end

    local r, g, b, a = ui.get_color("global color"):r(), ui.get_color("global color"):g(), ui.get_color("global color"):b(), ui.get_color("global color"):a()


    local ping = globalvars.get_ping()
    local time = globalvars.get_time()
    local name = engine.get_gamename()

    local font = fonts_.verdana[12]

    local build = helpers_.information_script.build
    local script = helpers_.information_script.name_script

    local cheat_name = ("%s [%s] / "):format(script, build)

    anim_ping = lerp(anim_ping, ping, globalvars.get_frametime() * 2)

    text = {
      {font = font, text = cheat_name, color = color.new(r, g, b, 255), shadow = true},
      {font = font, text = name.. " ", color = color.new(70, 70, 70, 255), shadow = true},
      {font = font, text = ping.. " ", color = color.new(r, g, b, 255), shadow = true},
      {font = font, text = "ms ", color = color.new(70, 70, 70, 255), shadow = true},
      {font = font, text = time.. " ", color = color.new(r, g, b, 255), shadow = true},
      {font = font, text = "time", color = color.new(70, 70, 70, 255), shadow = true},
    }

    local width, height = render.get_text_width(fonts_.verdana[12], text) + 269, 20

    local x, y = engine.get_screen_width(), 8
    x = x - width - 10


    render.rect_filled_rounded(x, y, width, height + 4, 60, 5, color.new(0, 0, 0, 255))
    render.rect_rounded(x + 2, y + 2, 265, height, color.new(70, 70, 70, 255), 5)
    render.multitext(x + 6, y + 5, text)
  end
  -- * end

  -- * arrows
  visual_functions.arrows = function()

    if not ui.get_bool("arrows") then
      return
    end

    local Player = entitylist.get_local_player()

    if not Player then
      return
    end

    -- Manaul Arrows

    local r, g, b, a = ui.get_color("global color"):r(), ui.get_color("global color"):g(), ui.get_color("global color"):b(), ui.get_color("global color"):a()
    local font = fonts_.arrows
    local left = "w"
    local right = "x"

    -- Left
    if(ui.get_keybind_state(keybinds.manual_left)) then
      render.text(font, x/2 - 55, y/2 - 11, color.new(r, g, b, 255), left)
      render.text(font, x/2 + 55, y/2 - 11, color.new(0, 0, 0, 150), right)
    end

    -- Right
    if(ui.get_keybind_state(keybinds.manual_right)) then
      render.text(font, x/2 + 55, y/2 - 11, color.new(r, g, b, 255), right)
      render.text(font, x/2 - 55, y/2 - 11, color.new(0, 0, 0, 150), left)
    end
  end
  -- * end

  -- * indicators
  visual_functions.indicators = function()

    if not ui.get_bool("indicators") then
      return
    end

    local Player = entitylist.get_local_player()

    if not Player then
      return
    end

    local x = engine.get_screen_width()
    local y = engine.get_screen_height()

    local r, g, b, a = ui.get_color("global color"):r(), ui.get_color("global color"):g(), ui.get_color("global color"):b(), ui.get_color("global color"):a()
    local rechdt = globalvars.get_dt_recharging()
    local velocity_modifier = entitylist.get_local_player():get_prop_float("CCSPlayer", "m_flVelocityModifier")
  
    -- Title
    local title = "sendiago"

    local w, h = 40, 6
  
    -- Font
    local font = fonts_.smallest[10]

    -- Text title
    render.text(font, x/2 + 1, y/2 + 20, color.new(255, 255, 255, 255), title, false, true)

    -- Rect
    render.rect_filled(x/2 + 0, y/2 + 31, w, h, color.new(0, 0, 0, 255))
    render.gradient(x/2 + 2, y/2 + 33, math.floor( 36 * velocity_modifier), 2, color.new(r, g, b, 255), color.new(0, 0, 0))
  

    if(ui.get_keybind_state(keybinds.double_tap)) then
      render.text(font, x/2 + 1, y/2 + 37, color.new(255, 255, 255, 255), "DOUBLETAP", false, true)
      offset = offset + 10
    end
              
    if rechdt then
      render.text(font, x/2 + 1, y/2 + 37, color.new(255, 0, 0, 255), "DOUBLETAP", false, true)
      offset = offset + 10
    end

    if(ui.get_keybind_state(keybinds.hide_shots)) then
      render.text(font, x/2 + 1, y/2 + 37, color.new(164, 255, 0, 255), "ON-SHOT", false, true)
      offset = offset + 10
    end
  end
  -- * end

  -- * table
  visual_functions.table = function()

    if not ui.get_bool("table") then
      return
    end

    local Player = entitylist.get_local_player()

    if not Player then
      return
    end

    local r, g, b, a = ui.get_color("global color"):r(), ui.get_color("global color"):g(), ui.get_color("global color"):b(), ui.get_color("global color"):a()
  
    local x, y = 20, 450

    local name = engine.get_gamename()

    local font = fonts_.verdana[12]
    local build = helpers_.information_script.build

    render.rect_filled_rounded(x, y - table, 140, 36, 60, 5, color.new(0, 0, 0, 255))
    render.rect_rounded(x + 2, y + 2 - table, 136, 32, color.new(70, 70, 70, 255), 5)

    text = {
      {font = font, text = "sendiago.isc / ", shadow = true},
      {font = font, text = ("[%s]"):format(build), color = color.new(r, g, b, 255), shadow = true},
    }

    text_n = {
      {font = font, text = "user: ", shadow = true},
      {font = font, text = name, color = color.new(r, g, b, 255), shadow = true},
    }

    render.multitext(x + 6, y + 5 - table, text)
    render.multitext(x + 6, y + 17 - table, text_n)
  end
  -- * end


  -- * antiaim
  antiaim_functions.presets = function()

      if ui.get_int("antiaim preset") == 0 then
      end
      if ui.get_int("antiaim preset") == 1 then
        ui.set_int("0Antiaim.inverted_desync_range", 60)
        ui.set_int("0Antiaim.desync_range", 60)
        ui.set_int("0Antiaim.body_lean", 15)
        ui.set_int("0Antiaim.inverted_body_lean", 18)
      end
  end
  -- * end


  -- * static legs
  local bit = {
    band = function(a, b) return a & b end,
    lshift = function(a, b) return a << b end,
    rshift = function(a, b) return a >> b end,
    bor = function(a, b) return a | b end,
    bnot = function(a) return ~a end
  }

  local an_data = {
    grTicks = 1,
   endTime = 0
  }

  local call = {
    ["InitAnimations"] = function(self)
      local m_pLocal = entitylist.get_local_player()
  
      if not m_pLocal:is_alive() then
        return
      end
  
      local m_fl = ui.get_int("Antiaim.fake_lag_limit")
  
      if ui.get_bool("staic leg in air") then
        m_pLocal:m_flposeparameter()[7] = 1
      end
  
      if ui.get_bool("pitch 0 on land") then
        local onGround = bit.band(m_pLocal:get_prop_int("CBasePlayer", "m_fFlags"), 1)
  
        if onGround == 1 then
          an_data.grTicks = an_data.grTicks + 1
        else
          an_data.grTicks = 0
          an_data.endTime = globalvars.get_curtime() + 1
        end
  
        if an_data.grTicks > m_fl + 1 and an_data.endTime > globalvars.get_curtime() then
          m_pLocal:m_flposeparameter()[13] = 0.5
        end
      end
    end
  }
  -- * end
end
end
-- * global end


cheat.RegisterCallback("on_framestage", function()
  call["InitAnimations"]()
end)

cheat.RegisterCallback("on_paint", function()
  global_.load_script()
  visual_functions.watermark()
  visual_functions.table()
  visual_functions.indicators()
  visual_functions.notify()
  visual_functions.arrows()
end)

cheat.RegisterCallback("on_createmove", function()
  antiaim_functions.presets()
end)
  