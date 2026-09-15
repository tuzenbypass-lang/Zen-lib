-- Made by samet
-- Modified by ZenBypass

local Library do 
    local Workspace = game:GetService("Workspace")
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local HttpService = game:GetService("HttpService")
    local RunService = game:GetService("RunService")
    local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
    local TweenService = game:GetService("TweenService")
    local Lighting = game:GetService("Lighting")

    gethui = gethui or function()
        return CoreGui
    end

    local LocalPlayer = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera
    local Mouse = LocalPlayer:GetMouse()

    local FromRGB = Color3.fromRGB
    local FromHSV = Color3.fromHSV
    local FromHex = Color3.fromHex
    local RGBSequence = ColorSequence.new
    local RGBSequenceKeypoint = ColorSequenceKeypoint.new
    local NumSequence = NumberSequence.new
    local NumSequenceKeypoint = NumberSequenceKeypoint.new
    local UDim2New = UDim2.new
    local UDimNew = UDim.new
    local UDim2FromOffset = UDim2.fromOffset
    local Vector2New = Vector2.new
    local Vector3New = Vector3.new
    local MathClamp = math.clamp
    local MathFloor = math.floor
    local MathAbs = math.abs
    local MathSin = math.sin
    local TableInsert = table.insert
    local TableFind = table.find
    local TableRemove = table.remove
    local TableConcat = table.concat
    local TableClone = table.clone
    local TableUnpack = table.unpack
    local StringFormat = string.format
    local StringFind = string.find
    local StringGSub = string.gsub
    local StringLower = string.lower
    local StringLen = string.len
    local InstanceNew = Instance.new
    local RectNew = Rect.new
    local IsMobile = UserInputService.TouchEnabled or false

    Library = {
        Theme = {},
        MenuKeybind = tostring(Enum.KeyCode.Semicolon),
        Flags = {},
        Tween = { Time = 0.3, Style = Enum.EasingStyle.Quad, Direction = Enum.EasingDirection.Out },
        FadeSpeed = 0.2,
        Folders = { Directory = "zenbypass", Configs = "zenbypass/Configs", Assets = "zenbypass/Assets" },
        Pages = {},
        Sections = {},
        Connections = {},
        Threads = {},
        ThemeMap = {},
        ThemeItems = {},
        OpenFrames = {},
        SetFlags = {},
        UnnamedConnections = 0,
        UnnamedFlags = 0,
        Holder = nil,
        NotifHolder = nil,
        UnusedHolder = nil,
        Font = nil
    }

    Library.__index = Library
    Library.Sections.__index = Library.Sections
    Library.Pages.__index = Library.Pages

    local Keys = {
        ["Unknown"] = "Unknown", ["Backspace"] = "Back", ["Tab"] = "Tab", ["Clear"] = "Clear",
        ["Return"] = "Return", ["Pause"] = "Pause", ["Escape"] = "Escape", ["Space"] = "Space",
        ["QuotedDouble"] = '"', ["Hash"] = "#", ["Dollar"] = "$", ["Percent"] = "%",
        ["Ampersand"] = "&", ["Quote"] = "'", ["LeftParenthesis"] = "(", ["RightParenthesis"] = " )",
        ["Asterisk"] = "*", ["Plus"] = "+", ["Comma"] = ",", ["Minus"] = "-", ["Period"] = ".",
        ["Slash"] = "`", ["Three"] = "3", ["Seven"] = "7", ["Eight"] = "8", ["Colon"] = ":",
        ["Semicolon"] = ";", ["LessThan"] = "<", ["GreaterThan"] = ">", ["Question"] = "?",
        ["Equals"] = "=", ["At"] = "@", ["LeftBracket"] = "LeftBracket", ["RightBracket"] = "RightBracket",
        ["BackSlash"] = "BackSlash", ["Caret"] = "^", ["Underscore"] = "_", ["Backquote"] = "`",
        ["LeftCurly"] = "{", ["Pipe"] = "|", ["RightCurly"] = "}", ["Tilde"] = "~",
        ["Delete"] = "Delete", ["End"] = "End", ["Insert"] = "Insert", ["Home"] = "Home",
        ["PageUp"] = "PageUp", ["PageDown"] = "PageDown", ["RightShift"] = "RightShift",
        ["LeftShift"] = "LeftShift", ["RightControl"] = "RightControl", ["LeftControl"] = "LeftControl",
        ["LeftAlt"] = "LeftAlt", ["RightAlt"] = "RightAlt"
    }

    local Themes = {
        ["Preset"] = {
            ["AccentGradient"] = FromRGB(255, 60, 60),
            ["Background 2"] = FromRGB(8, 8, 8),
            ["Background"] = FromRGB(10, 10, 10),
            ["Text"] = FromRGB(235, 235, 235),
            ["Outline"] = FromRGB(40, 12, 12),
            ["Section Top"] = FromRGB(20, 20, 20),
            ["Section Background"] = FromRGB(12, 12, 12),
            ["Section Background 2"] = FromRGB(15, 15, 15),
            ["Accent"] = FromRGB(220, 30, 30),
            ["Element"] = FromRGB(18, 18, 18)
        }
    }

    Library.Theme = TableClone(Themes["Preset"])

    for Index, Value in Library.Folders do 
        if not isfolder(Value) then makefolder(Value) end
    end

    local Tween = {}
    do
        Tween.__index = Tween
        Tween.Create = function(self, Item, Info, Goal, IsRawItem)
            Item = IsRawItem and Item or Item.Instance
            Info = Info or TweenInfo.new(Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction)
            local NewTween = { Tween = TweenService:Create(Item, Info, Goal), Info = Info, Goal = Goal, Item = Item }
            NewTween.Tween:Play()
            setmetatable(NewTween, Tween)
            return NewTween
        end
        Tween.GetProperty = function(self, Item)
            Item = Item or self.Item
            if Item:IsA("Frame") then return { "BackgroundTransparency" }
            elseif Item:IsA("TextLabel") or Item:IsA("TextButton") then return { "TextTransparency", "BackgroundTransparency" }
            elseif Item:IsA("ImageLabel") or Item:IsA("ImageButton") then return { "BackgroundTransparency", "ImageTransparency" }
            elseif Item:IsA("ScrollingFrame") then return { "BackgroundTransparency", "ScrollBarImageTransparency" }
            elseif Item:IsA("TextBox") then return { "TextTransparency", "BackgroundTransparency" }
            elseif Item:IsA("UIStroke") then return { "Transparency" } end
        end
        Tween.FadeItem = function(self, Item, Property, Visibility, Speed)
            local Item = Item or self.Item
            local OldTransparency = Item[Property]
            Item[Property] = Visibility and 1 or OldTransparency
            local NewTween = Tween:Create(Item, TweenInfo.new(Speed or Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction), { [Property] = Visibility and OldTransparency or 1 }, true)
            Library:Connect(NewTween.Tween.Completed, function()
                if not Visibility then task.wait(); Item[Property] = OldTransparency end
            end)
            return NewTween
        end
    end

    local Instances = {}
    do
        Instances.__index = Instances
        Instances.Create = function(self, Class, Properties)
            local NewItem = { Instance = InstanceNew(Class), Properties = Properties, Class = Class }
            setmetatable(NewItem, Instances)
            for Property, Value in NewItem.Properties do NewItem.Instance[Property] = Value end
            return NewItem
        end
        Instances.AddToTheme = function(self, Properties)
            if not self.Instance then return end
            Library:AddToTheme(self, Properties)
        end
        Instances.ChangeItemTheme = function(self, Properties)
            if not self.Instance then return end
            Library:ChangeItemTheme(self, Properties)
        end
        Instances.Connect = function(self, Event, Callback, Name)
            if not self.Instance or not self.Instance[Event] then return end
            if IsMobile then
                if Event == "MouseButton1Down" or Event == "MouseButton1Click" then Event = "TouchTap"
                elseif Event == "MouseButton2Down" or Event == "MouseButton2Click" then Event = "TouchLongPress" end
            end
            return Library:Connect(self.Instance[Event], Callback, Name)
        end
        Instances.Tween = function(self, Info, Goal)
            if not self.Instance then return end
            return Tween:Create(self, Info, Goal)
        end
        Instances.Clean = function(self)
            if not self.Instance then return end
            self.Instance:Destroy()
            self = nil
        end
        Instances.MakeDraggable = function(self)
            if not self.Instance then return end
            local Gui = self.Instance
            local Dragging = false
            local DragStart, StartPosition
            local Set = function(Input)
                local DragDelta = Input.Position - DragStart
                local NewX = StartPosition.X.Offset + DragDelta.X
                local NewY = StartPosition.Y.Offset + DragDelta.Y
                local ScreenSize = Gui.Parent.AbsoluteSize
                local GuiSize = Gui.AbsoluteSize
                NewX = MathClamp(NewX, 0, ScreenSize.X - GuiSize.X)
                NewY = MathClamp(NewY, 0, ScreenSize.Y - GuiSize.Y)
                self:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(0, NewX, 0, NewY)})
            end
            local InputChanged
            self:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true
                    DragStart = Input.Position
                    StartPosition = Gui.Position
                    if InputChanged then return end
                    InputChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Dragging = false
                            InputChanged:Disconnect()
                            InputChanged = nil
                        end
                    end)
                end
            end)
            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Dragging then Set(Input) end
                end
            end)
        end
        Instances.OnHover = function(self, Function)
            if not self.Instance then return end
            return Library:Connect(self.Instance.MouseEnter, Function)
        end
        Instances.OnHoverLeave = function(self, Function)
            if not self.Instance then return end
            return Library:Connect(self.Instance.MouseLeave, Function)
        end
    end

    do
        local SemiBold = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        local Regular = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        local Light = Font.new("rbxassetid://12187365364", Enum.FontWeight.Light, Enum.FontStyle.Normal)
        Library.Fonts = { ["SemiBold"] = SemiBold, ["Regular"] = Regular, ["Light"] = Light }
        Library.Font = SemiBold
    end

    Library.Holder = Instances:Create("ScreenGui", { Parent = gethui(), Name = "\0", ZIndexBehavior = Enum.ZIndexBehavior.Global, DisplayOrder = 2, ResetOnSpawn = false })
    Library.UnusedHolder = Instances:Create("ScreenGui", { Parent = gethui(), Name = "\0", ZIndexBehavior = Enum.ZIndexBehavior.Global, Enabled = false, ResetOnSpawn = false })
    Library.NotifHolder = Instances:Create("Frame", { Parent = Library.Holder.Instance, Name = "\0", BackgroundTransparency = 1, Size = UDim2New(0, 0, 1, 0), BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.X, BackgroundColor3 = FromRGB(255, 255, 255) })

    Instances:Create("UIListLayout", { Parent = Library.NotifHolder.Instance, Name = "\0", Padding = UDimNew(0, 12), SortOrder = Enum.SortOrder.LayoutOrder })
    Instances:Create("UIPadding", { Parent = Library.NotifHolder.Instance, Name = "\0", PaddingTop = UDimNew(0, 12), PaddingBottom = UDimNew(0, 12), PaddingRight = UDimNew(0, 12), PaddingLeft = UDimNew(0, 12) })

    Library.Unload = function(self)
        for Index, Value in self.Connections do
            pcall(function() Value.Connection:Disconnect() end)
        end
        for Index, Value in self.Threads do
            pcall(function() coroutine.close(Value) end)
        end
        if self.Holder then pcall(function() self.Holder.Instance:Destroy() end) end
        if self.UnusedHolder then pcall(function() self.UnusedHolder.Instance:Destroy() end) end
        if self.NotifHolder then pcall(function() self.NotifHolder.Instance:Destroy() end) end
        Library = nil
        if getgenv then getgenv().Library = nil end
    end

    Library.Round = function(self, Number, Float)
        local Multiplier = 1 / (Float or 1)
        return MathFloor(Number * Multiplier) / Multiplier
    end

    Library.Thread = function(self, Function)
        local NewThread = coroutine.create(Function)
        coroutine.wrap(function() coroutine.resume(NewThread) end)()
        TableInsert(self.Threads, NewThread)
        return NewThread
    end

    Library.SafeCall = function(self, Function, ...)
        local Args = { ... }
        local Success, Result = pcall(Function, TableUnpack(Args))
        if not Success then warn(Result); return false end
        return Success
    end

    Library.Connect = function(self, Event, Callback, Name)
        Name = Name or StringFormat("conn_%s_%s", self.UnnamedConnections + 1, HttpService:GenerateGUID(false))
        local NewConnection = { Event = Event, Callback = Callback, Name = Name, Connection = nil }
        Library:Thread(function() NewConnection.Connection = Event:Connect(Callback) end)
        TableInsert(self.Connections, NewConnection)
        return NewConnection
    end

    Library.NextFlag = function(self)
        local FlagNumber = self.UnnamedFlags + 1
        return StringFormat("flag_%s_%s", FlagNumber, HttpService:GenerateGUID(false))
    end

    Library.AddToTheme = function(self, Item, Properties)
        Item = Item.Instance or Item
        local ThemeData = { Item = Item, Properties = Properties }
        for Property, Value in ThemeData.Properties do
            if type(Value) == "string" then Item[Property] = self.Theme[Value]
            else Item[Property] = Value() end
        end
        TableInsert(self.ThemeItems, ThemeData)
        self.ThemeMap[Item] = ThemeData
    end

    Library.ChangeItemTheme = function(self, Item, Properties)
        Item = Item.Instance or Item
        if not self.ThemeMap[Item] then return end
        self.ThemeMap[Item].Properties = Properties
    end

    Library.ChangeTheme = function(self, Theme, Color)
        self.Theme[Theme] = Color
        for _, Item in self.ThemeItems do
            for Property, Value in Item.Properties do
                if type(Value) == "string" and Value == Theme then Item.Item[Property] = Color
                elseif type(Value) == "function" then Item.Item[Property] = Value() end
            end
        end
    end

    Library.IsMouseOverFrame = function(self, Frame)
        Frame = Frame.Instance
        local MousePosition = Vector2New(Mouse.X, Mouse.Y)
        return MousePosition.X >= Frame.AbsolutePosition.X and MousePosition.X <= Frame.AbsolutePosition.X + Frame.AbsoluteSize.X
            and MousePosition.Y >= Frame.AbsolutePosition.Y and MousePosition.Y <= Frame.AbsolutePosition.Y + Frame.AbsoluteSize.Y
    end

    Library.CompareVectors = function(self, A, B) return (A.X < B.X) or (A.Y < B.Y) end
    Library.IsClipped = function(self, Object, Column)
        local Parent = Column
        local BT = Parent.AbsolutePosition
        local BB = BT + Parent.AbsoluteSize
        local T = Object.AbsolutePosition
        local B = T + Object.AbsoluteSize
        return Library:CompareVectors(T, BT) or Library:CompareVectors(BB, B)
    end
    Library.UpdateText = function(self)
        for _, Value in self.Holder.Instance:GetDescendants() do
            if Value:IsA("TextLabel") or Value:IsA("TextButton") or Value:IsA("TextBox") then Value.FontFace = Library.Font end
        end
    end
    Library.EscapePattern = function(self, String)
        if string.match(String, "[%(%)%.%%%+%-%*%?%[%]%^%$]") then
            return StringGSub(String, "[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%1")
        end
        return String
    end

    Library.Notification = function(self, Data)
        local Items = {}
        Items["Notification"] = Instances:Create("Frame", { Parent = Library.NotifHolder.Instance, Name = "\0", BackgroundTransparency = 0.35, BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.XY, BackgroundColor3 = FromRGB(15, 15, 15) })
        Items["Title"] = Instances:Create("TextLabel", { Parent = Items["Notification"].Instance, Name = "\0", FontFace = Library.Font, TextColor3 = FromRGB(255, 255, 255), Text = Data.Title or "", BackgroundTransparency = 1, Size = UDim2New(0, 0, 0, 15), BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.XY, TextSize = 14 })
        Instances:Create("UIPadding", { Parent = Items["Notification"].Instance, Name = "\0", PaddingTop = UDimNew(0, 8), PaddingBottom = UDimNew(0, 8), PaddingRight = UDimNew(0, 8), PaddingLeft = UDimNew(0, 8) })
        Instances:Create("UICorner", { Parent = Items["Notification"].Instance, Name = "\0", CornerRadius = UDimNew(0, 5) })
        Items["Description"] = Instances:Create("TextLabel", { Parent = Items["Notification"].Instance, Name = "\0", FontFace = Library.Font, TextColor3 = FromRGB(255, 255, 255), TextTransparency = 0.3, Text = Data.Description or "", Size = UDim2New(0, 0, 0, 15), BorderSizePixel = 0, BackgroundTransparency = 1, Position = UDim2New(0, 0, 0, 20), AutomaticSize = Enum.AutomaticSize.XY, TextSize = 14 })
        Items["Accent"] = Instances:Create("Frame", { Parent = Items["Notification"].Instance, Name = "\0", Position = UDim2New(0, 0, 0, 50), Size = UDim2New(0, 0, 0, 6), BorderSizePixel = 0, BackgroundColor3 = FromRGB(220, 30, 30) })
        Instances:Create("UICorner", { Parent = Items["Accent"].Instance, Name = "\0", CornerRadius = UDimNew(1, 0) })

        local Size = Items["Notification"].Instance.AbsoluteSize
        Items["Notification"].Instance.Size = UDim2New(0, 0, 0, 0)
        for _, Value in Items do
            if Value.Instance:IsA("Frame") then Value.Instance.BackgroundTransparency = 1
            elseif Value.Instance:IsA("TextLabel") then Value.Instance.TextTransparency = 1 end
        end
        task.wait(0.2)
        Items["Notification"].Instance.AutomaticSize = Enum.AutomaticSize.Y

        Library:Thread(function()
            for _, Value in Items do
                if Value.Instance:IsA("Frame") then Value:Tween(TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
                elseif Value.Instance:IsA("TextLabel") then Value:Tween(TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextTransparency = 0}) end
            end
            Items["Notification"]:Tween(TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2New(0, Size.X, 0, Size.Y)})
            Items["Accent"]:Tween(TweenInfo.new(Data.Duration or 3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Size = UDim2New(1, 0, 0, 6)})
            task.delay((Data.Duration or 3) + 0.15, function()
                for _, Value in Items do
                    if Value.Instance:IsA("Frame") then Value:Tween(nil, {BackgroundTransparency = 1})
                    elseif Value.Instance:IsA("TextLabel") then Value:Tween(nil, {TextTransparency = 1}) end
                end
                Items["Notification"]:Tween(TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2New(0, 0, 0, 0)})
                task.wait(0.5)
                Items["Notification"].Instance:Destroy()
            end)
        end)
    end

    Library.Window = function(self, Data)
        Data = Data or {}
        local Window = {
            Name = Data.Name or "Window",
            SubName = Data.SubName or "By ZenBypass",
            Logo = Data.Logo or "1l20959262762131",
            Pages = {},
            Items = {},
            IsOpen = false,
            Minimized = false
        }

        local Items = {}
        local defaultSize = IsMobile and UDim2New(0, 420, 0, 340) or UDim2New(0, 560, 0, 420)

        Items["MainFrame"] = Instances:Create("Frame", {
            Parent = Library.Holder.Instance,
            Name = "\0",
            AnchorPoint = Vector2New(0.5, 0.5),
            BackgroundTransparency = 0.12,
            Position = UDim2New(0.5, 0, 0.5, 0),
            Size = defaultSize,
            ZIndex = 2,
            BorderSizePixel = 0,
            BackgroundColor3 = FromRGB(10, 10, 10)
        })
        Items["MainFrame"]:AddToTheme({BackgroundColor3 = "Background"})

        local mainCorner = InstanceNew("UICorner")
        mainCorner.CornerRadius = UDimNew(0, 8)
        mainCorner.Parent = Items["MainFrame"].Instance

        Items["LeftTabs"] = Instances:Create("Frame", {
            Parent = Items["MainFrame"].Instance,
            Name = "\0",
            Visible = true,
            AnchorPoint = Vector2New(1, 0),
            BackgroundTransparency = 0.15,
            Size = UDim2New(0, 170, 1, 0),
            ZIndex = 2,
            BorderSizePixel = 0,
            BackgroundColor3 = FromRGB(10, 10, 10)
        })
        Items["LeftTabs"]:AddToTheme({BackgroundColor3 = "Background"})

        Instances:Create("UIListLayout", { Parent = Items["LeftTabs"].Instance, Name = "\0", Padding = UDimNew(0, 8), SortOrder = Enum.SortOrder.LayoutOrder })
        Instances:Create("UIPadding", { Parent = Items["LeftTabs"].Instance, Name = "\0", PaddingTop = UDimNew(0, 50), PaddingBottom = UDimNew(0, 15), PaddingRight = UDimNew(0, 12), PaddingLeft = UDimNew(0, 12) })

        Items["Title"] = Instances:Create("TextLabel", { Parent = Items["MainFrame"].Instance, Name = "\0", FontFace = Library.Font, TextColor3 = FromRGB(240, 240, 240), Text = Window.Name, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2New(0, 0, 0, 15), BackgroundTransparency = 1, Position = UDim2New(0, 20, 0, 13), BorderSizePixel = 0, ZIndex = 3, TextSize = 16 })
        Items["SubTitle"] = Instances:Create("TextLabel", { Parent = Items["MainFrame"].Instance, Name = "\0", FontFace = Library.Font, TextColor3 = FromRGB(240, 240, 240), TextTransparency = 0.4, Text = Window.SubName, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2New(0, 0, 0, 15), BackgroundTransparency = 1, Position = UDim2New(0, 20, 0, 30), BorderSizePixel = 0, ZIndex = 3, TextSize = 13 })

        Items["Content"] = Instances:Create("Frame", { Parent = Items["MainFrame"].Instance, Name = "\0", BackgroundTransparency = 1, Position = UDim2New(0, 0, 0, 55), Size = UDim2New(1, 0, 1, -55), ZIndex = 2, BorderSizePixel = 0 })

        Items["CloseButton"] = Instances:Create("TextButton", {
            Parent = Items["MainFrame"].Instance,
            Name = "\0",
            Text = "X",
            FontFace = Library.Font,
            TextColor3 = FromRGB(220, 30, 30),
            TextSize = 14,
            AutoButtonColor = false,
            AnchorPoint = Vector2New(1, 0),
            BorderSizePixel = 0,
            BackgroundTransparency = 0.2,
            Position = UDim2New(1, -10, 0, 8),
            Size = UDim2New(0, 28, 0, 28),
            ZIndex = 5,
            BackgroundColor3 = FromRGB(25, 25, 25)
        })
        Instances:Create("UICorner", { Parent = Items["CloseButton"].Instance, Name = "\0", CornerRadius = UDimNew(0, 6) })

        Items["MinimizeButton"] = Instances:Create("TextButton", {
            Parent = Items["MainFrame"].Instance,
            Name = "\0",
            Text = "—",
            FontFace = Library.Font,
            TextColor3 = FromRGB(220, 30, 30),
            TextSize = 14,
            AutoButtonColor = false,
            AnchorPoint = Vector2New(1, 0),
            BorderSizePixel = 0,
            BackgroundTransparency = 0.2,
            Position = UDim2New(1, -44, 0, 8),
            Size = UDim2New(0, 28, 0, 28),
            ZIndex = 5,
            BackgroundColor3 = FromRGB(25, 25, 25)
        })
        Instances:Create("UICorner", { Parent = Items["MinimizeButton"].Instance, Name = "\0", CornerRadius = UDimNew(0, 6) })

        Items["SquareButton"] = Instances:Create("TextButton", {
            Parent = Items["MainFrame"].Instance,
            Name = "\0",
            Text = "□",
            FontFace = Library.Font,
            TextColor3 = FromRGB(220, 30, 30),
            TextSize = 14,
            AutoButtonColor = false,
            AnchorPoint = Vector2New(1, 0),
            BorderSizePixel = 0,
            BackgroundTransparency = 0.2,
            Position = UDim2New(1, -78, 0, 8),
            Size = UDim2New(0, 28, 0, 28),
            ZIndex = 5,
            BackgroundColor3 = FromRGB(25, 25, 25)
        })
        Instances:Create("UICorner", { Parent = Items["SquareButton"].Instance, Name = "\0", CornerRadius = UDimNew(0, 6) })

        local Gui = Items["MainFrame"].Instance
        local Dragging, DragStart, StartPosition
        local Set = function(Input)
            if Window.Minimized then return end
            local DragDelta = Input.Position - DragStart
            Items["MainFrame"]:Tween(TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(StartPosition.X.Scale, StartPosition.X.Offset + DragDelta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + DragDelta.Y)})
        end
        Items["MainFrame"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                if Input.Position.Y - Gui.AbsolutePosition.Y <= 41 then
                    Dragging = true
                    DragStart = Input.Position
                    StartPosition = Gui.Position
                    Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then Dragging = false end
                    end)
                end
            end
        end)
        Library:Connect(UserInputService.InputChanged, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                if Dragging then Set(Input) end
            end
        end)

        Items["CloseButton"]:Connect("MouseButton1Down", function()
            if getgenv().ZenBypassUnload then pcall(getgenv().ZenBypassUnload) end
            Library:Unload()
        end)

        Items["MinimizeButton"]:Connect("MouseButton1Down", function()
            Window.Minimized = not Window.Minimized
            if Window.Minimized then
                Window.previousSize = Gui.Size
                Gui:TweenSize(UDim2New(0, 560, 0, 41), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.3, true)
            else
                Gui:TweenSize(Window.previousSize or defaultSize, Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.3, true)
            end
        end)

        Items["SquareButton"]:Connect("MouseButton1Down", function()
            Window.Minimized = false
            Gui:TweenSize(UDim2New(0, 700, 0, 520), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.3, true)
        end)

        local TabFolder = Instance.new("Folder")
        TabFolder.Name = "TabFolder"
        TabFolder.Parent = Items["MainFrame"].Instance

        local tabhold = {}
        local firstTab = true

        function tabhold:Tab(text)
            local TabBtn = Instance.new("TextButton")
            TabBtn.Name = "TabBtn"
            TabBtn.Parent = Items["LeftTabs"].Instance
            TabBtn.BackgroundTransparency = 1
            TabBtn.Size = UDim2New(1, 0, 0, 30)
            TabBtn.Text = ""
            TabBtn.AutoButtonColor = false

            local TabTitle = Instance.new("TextLabel")
            TabTitle.Name = "TabTitle"
            TabTitle.Parent = TabBtn
            TabTitle.BackgroundTransparency = 1
            TabTitle.Size = UDim2New(1, 0, 1, 0)
            TabTitle.FontFace = Library.Font
            TabTitle.Text = text
            TabTitle.TextColor3 = FromRGB(150, 150, 150)
            TabTitle.TextSize = 14
            TabTitle.TextXAlignment = Enum.TextXAlignment.Left

            local TabBtnIndicator = Instance.new("Frame")
            TabBtnIndicator.Name = "TabBtnIndicator"
            TabBtnIndicator.Parent = TabBtn
            TabBtnIndicator.BackgroundColor3 = FromRGB(220, 30, 30)
            TabBtnIndicator.BorderSizePixel = 0
            TabBtnIndicator.Position = UDim2New(0, 0, 0.5, 0)
            TabBtnIndicator.AnchorPoint = Vector2New(0, 0.5)
            TabBtnIndicator.Size = UDim2New(0, 0, 0, 14)
            local indCorner = Instance.new("UICorner")
            indCorner.CornerRadius = UDimNew(0, 2)
            indCorner.Parent = TabBtnIndicator

            local Tab = Instance.new("ScrollingFrame")
            local TabLayout = Instance.new("UIListLayout")
            Tab.Name = "Tab"
            Tab.Parent = TabFolder
            Tab.Active = true
            Tab.BackgroundTransparency = 1
            Tab.BorderSizePixel = 0
            Tab.Position = UDim2New(0, 190, 0, 5)
            Tab.Size = UDim2New(1, -200, 1, -15)
            Tab.CanvasSize = UDim2New(0, 0, 0, 0)
            Tab.ScrollBarThickness = 3
            Tab.Visible = false
            TabLayout.Name = "TabLayout"
            TabLayout.Parent = Tab
            TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
            TabLayout.Padding = UDimNew(0, 6)

            if firstTab then
                firstTab = false
                TabBtnIndicator.Size = UDim2New(0, 3, 0, 14)
                TabTitle.TextColor3 = FromRGB(255, 255, 255)
                Tab.Visible = true
            end

            TabBtn.MouseButton1Click:Connect(function()
                for _, v in next, TabFolder:GetChildren() do
                    if v.Name == "Tab" then v.Visible = false end
                end
                Tab.Visible = true
                for _, v in next, Items["LeftTabs"].Instance:GetChildren() do
                    if v.Name == "TabBtn" then
                        v.TabBtnIndicator:TweenSize(UDim2New(0, 0, 0, 14), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .2, true)
                        TweenService:Create(v.TabTitle, TweenInfo.new(.3), {TextColor3 = FromRGB(150, 150, 150)}):Play()
                    end
                end
                TabBtnIndicator:TweenSize(UDim2New(0, 3, 0, 14), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .2, true)
                TweenService:Create(TabTitle, TweenInfo.new(.3), {TextColor3 = FromRGB(255, 255, 255)}):Play()
            end)

            local tabcontent = {}

            function tabcontent:Button(text, callback)
                local Button = Instance.new("TextButton")
                local ButtonCorner = Instance.new("UICorner")
                local ButtonTitle = Instance.new("TextLabel")
                Button.Name = "Button"
                Button.Parent = Tab
                Button.BackgroundColor3 = FromRGB(18, 18, 18)
                Button.Size = UDim2New(1, 0, 0, 36)
                Button.AutoButtonColor = false
                Button.Text = ""
                ButtonCorner.CornerRadius = UDimNew(0, 5)
                ButtonCorner.Parent = Button
                ButtonTitle.Name = "ButtonTitle"
                ButtonTitle.Parent = Button
                ButtonTitle.BackgroundTransparency = 1
                ButtonTitle.Position = UDim2New(0, 15, 0, 0)
                ButtonTitle.Size = UDim2New(1, -30, 1, 0)
                ButtonTitle.FontFace = Library.Font
                ButtonTitle.Text = text
                ButtonTitle.TextColor3 = FromRGB(240, 240, 240)
                ButtonTitle.TextSize = 14
                ButtonTitle.TextXAlignment = Enum.TextXAlignment.Left
                Button.MouseEnter:Connect(function() TweenService:Create(Button, TweenInfo.new(.2), {BackgroundColor3 = FromRGB(30, 30, 30)}):Play() end)
                Button.MouseLeave:Connect(function() TweenService:Create(Button, TweenInfo.new(.2), {BackgroundColor3 = FromRGB(18, 18, 18)}):Play() end)
                Button.MouseButton1Click:Connect(function() pcall(callback) end)
                Tab.CanvasSize = UDim2New(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
            end

            function tabcontent:Toggle(text, default, callback)
                local toggled = default or false
                local Toggle = Instance.new("TextButton")
                local ToggleCorner = Instance.new("UICorner")
                local ToggleTitle = Instance.new("TextLabel")
                local FrameToggle1 = Instance.new("Frame")
                local FrameToggle1Corner = Instance.new("UICorner")
                local FrameToggleCircle = Instance.new("Frame")
                local FrameToggleCircleCorner = Instance.new("UICorner")
                Toggle.Name = "Toggle"
                Toggle.Parent = Tab
                Toggle.BackgroundColor3 = FromRGB(18, 18, 18)
                Toggle.Size = UDim2New(1, 0, 0, 36)
                Toggle.AutoButtonColor = false
                Toggle.Text = ""
                ToggleCorner.CornerRadius = UDimNew(0, 5)
                ToggleCorner.Parent = Toggle
                ToggleTitle.Name = "ToggleTitle"
                ToggleTitle.Parent = Toggle
                ToggleTitle.BackgroundTransparency = 1
                ToggleTitle.Position = UDim2New(0, 15, 0, 0)
                ToggleTitle.Size = UDim2New(1, -70, 1, 0)
                ToggleTitle.FontFace = Library.Font
                ToggleTitle.Text = text
                ToggleTitle.TextColor3 = FromRGB(240, 240, 240)
                ToggleTitle.TextSize = 14
                ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
                FrameToggle1.Name = "FrameToggle1"
                FrameToggle1.Parent = Toggle
                FrameToggle1.BackgroundColor3 = FromRGB(45, 45, 45)
                FrameToggle1.Position = UDim2New(1, -55, 0.5, -9)
                FrameToggle1.Size = UDim2New(0, 40, 0, 18)
                FrameToggle1Corner.CornerRadius = UDimNew(1, 0)
                FrameToggle1Corner.Parent = FrameToggle1
                FrameToggleCircle.Name = "FrameToggleCircle"
                FrameToggleCircle.Parent = FrameToggle1
                FrameToggleCircle.BackgroundColor3 = FromRGB(200, 200, 200)
                FrameToggleCircle.Position = UDim2New(0, 3, 0.5, -7)
                FrameToggleCircle.Size = UDim2New(0, 14, 0, 14)
                FrameToggleCircleCorner.CornerRadius = UDimNew(1, 0)
                FrameToggleCircleCorner.Parent = FrameToggleCircle
                local function SetState(s)
                    toggled = s
                    if toggled then
                        TweenService:Create(FrameToggle1, TweenInfo.new(.3), {BackgroundColor3 = FromRGB(220, 30, 30)}):Play()
                        TweenService:Create(FrameToggleCircle, TweenInfo.new(.3), {BackgroundColor3 = FromRGB(255, 255, 255)}):Play()
                        FrameToggleCircle:TweenPosition(UDim2New(1, -17, 0.5, -7), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .2, true)
                    else
                        TweenService:Create(FrameToggle1, TweenInfo.new(.3), {BackgroundColor3 = FromRGB(45, 45, 45)}):Play()
                        TweenService:Create(FrameToggleCircle, TweenInfo.new(.3), {BackgroundColor3 = FromRGB(200, 200, 200)}):Play()
                        FrameToggleCircle:TweenPosition(UDim2New(0, 3, 0.5, -7), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .2, true)
                    end
                    pcall(callback, toggled)
                end
                Toggle.MouseButton1Click:Connect(function() SetState(not toggled) end)
                if default then SetState(true) end
                Tab.CanvasSize = UDim2New(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
            end

            function tabcontent:Slider(text, min, max, start, callback)
                local dragging = false
                local Slider = Instance.new("TextButton")
                local SliderCorner = Instance.new("UICorner")
                local SliderTitle = Instance.new("TextLabel")
                local SliderValue = Instance.new("TextLabel")
                local SlideFrame = Instance.new("Frame")
                local CurrentValueFrame = Instance.new("Frame")
                local SlideCircle = Instance.new("ImageButton")
                Slider.Name = "Slider"
                Slider.Parent = Tab
                Slider.BackgroundColor3 = FromRGB(18, 18, 18)
                Slider.Size = UDim2New(1, 0, 0, 55)
                Slider.AutoButtonColor = false
                Slider.Text = ""
                SliderCorner.CornerRadius = UDimNew(0, 5)
                SliderCorner.Parent = Slider
                SliderTitle.Name = "SliderTitle"
                SliderTitle.Parent = Slider
                SliderTitle.BackgroundTransparency = 1
                SliderTitle.Position = UDim2New(0, 15, 0, 5)
                SliderTitle.Size = UDim2New(0.6, 0, 0, 20)
                SliderTitle.FontFace = Library.Font
                SliderTitle.Text = text
                SliderTitle.TextColor3 = FromRGB(240, 240, 240)
                SliderTitle.TextSize = 14
                SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
                SliderValue.Name = "SliderValue"
                SliderValue.Parent = Slider
                SliderValue.BackgroundTransparency = 1
                SliderValue.Position = UDim2New(1, -55, 0, 5)
                SliderValue.Size = UDim2New(0, 40, 0, 20)
                SliderValue.FontFace = Library.Font
                SliderValue.Text = tostring(start or 0)
                SliderValue.TextColor3 = FromRGB(220, 30, 30)
                SliderValue.TextSize = 14
                SliderValue.TextXAlignment = Enum.TextXAlignment.Right
                SlideFrame.Name = "SlideFrame"
                SlideFrame.Parent = Slider
                SlideFrame.BackgroundColor3 = FromRGB(45, 45, 45)
                SlideFrame.BorderSizePixel = 0
                SlideFrame.Position = UDim2New(0, 15, 1, -15)
                SlideFrame.Size = UDim2New(1, -30, 0, 3)
                CurrentValueFrame.Name = "CurrentValueFrame"
                CurrentValueFrame.Parent = SlideFrame
                CurrentValueFrame.BackgroundColor3 = FromRGB(220, 30, 30)
                CurrentValueFrame.BorderSizePixel = 0
                CurrentValueFrame.Size = UDim2New((start or 0) / max, 0, 0, 3)
                SlideCircle.Name = "SlideCircle"
                SlideCircle.Parent = SlideFrame
                SlideCircle.BackgroundTransparency = 1
                SlideCircle.Position = UDim2New((start or 0) / max, -6, -1.3, 0)
                SlideCircle.Size = UDim2New(0, 11, 0, 11)
                SlideCircle.Image = "rbxassetid://3570695787"
                SlideCircle.ImageColor3 = FromRGB(220, 30, 30)
                local function move(input)
                    local pos = UDim2New(math.clamp((input.Position.X - SlideFrame.AbsolutePosition.X) / SlideFrame.AbsoluteSize.X, 0, 1), -6, -1.3, 0)
                    local pos1 = UDim2New(math.clamp((input.Position.X - SlideFrame.AbsolutePosition.X) / SlideFrame.AbsoluteSize.X, 0, 1), 0, 0, 3)
                    CurrentValueFrame:TweenSize(pos1, "Out", "Sine", 0.1, true)
                    SlideCircle:TweenPosition(pos, "Out", "Sine", 0.1, true)
                    local value = math.floor(((pos.X.Scale * max) / max) * (max - min) + min)
                    SliderValue.Text = tostring(value)
                    pcall(callback, value)
                end
                SlideCircle.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
                end)
                SlideCircle.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then move(input) end
                end)
                Tab.CanvasSize = UDim2New(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
            end

            function tabcontent:Label(text)
                local Label = Instance.new("TextButton")
                local LabelCorner = Instance.new("UICorner")
                local LabelTitle = Instance.new("TextLabel")
                Label.Name = "Label"
                Label.Parent = Tab
                Label.BackgroundColor3 = FromRGB(15, 15, 15)
                Label.Size = UDim2New(1, 0, 0, 30)
                Label.AutoButtonColor = false
                Label.Text = ""
                LabelCorner.CornerRadius = UDimNew(0, 5)
                LabelCorner.Parent = Label
                LabelTitle.Name = "LabelTitle"
                LabelTitle.Parent = Label
                LabelTitle.BackgroundTransparency = 1
                LabelTitle.Size = UDim2New(1, -30, 1, 0)
                LabelTitle.Position = UDim2New(0, 15, 0, 0)
                LabelTitle.FontFace = Library.Font
                LabelTitle.Text = text
                LabelTitle.TextColor3 = FromRGB(220, 30, 30)
                LabelTitle.TextSize = 14
                LabelTitle.TextXAlignment = Enum.TextXAlignment.Left
                Tab.CanvasSize = UDim2New(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
            end

            function tabcontent:Dropdown(text, list, callback)
                local droptog = false
                local framesize = 0
                local itemcount = 0
                local Dropdown = Instance.new("Frame")
                local DropdownCorner = Instance.new("UICorner")
                local DropdownBtn = Instance.new("TextButton")
                local DropdownTitle = Instance.new("TextLabel")
                local ArrowImg = Instance.new("ImageLabel")
                local DropItemHolder = Instance.new("ScrollingFrame")
                local DropLayout = Instance.new("UIListLayout")
                Dropdown.Name = "Dropdown"
                Dropdown.Parent = Tab
                Dropdown.BackgroundColor3 = FromRGB(18, 18, 18)
                Dropdown.ClipsDescendants = true
                Dropdown.Size = UDim2New(1, 0, 0, 36)
                DropdownCorner.CornerRadius = UDimNew(0, 5)
                DropdownCorner.Parent = Dropdown
                DropdownBtn.Name = "DropdownBtn"
                DropdownBtn.Parent = Dropdown
                DropdownBtn.BackgroundTransparency = 1
                DropdownBtn.Size = UDim2New(1, 0, 1, 0)
                DropdownBtn.Text = ""
                DropdownTitle.Name = "DropdownTitle"
                DropdownTitle.Parent = Dropdown
                DropdownTitle.BackgroundTransparency = 1
                DropdownTitle.Position = UDim2New(0, 15, 0, 0)
                DropdownTitle.Size = UDim2New(1, -50, 1, 0)
                DropdownTitle.FontFace = Library.Font
                DropdownTitle.Text = text
                DropdownTitle.TextColor3 = FromRGB(240, 240, 240)
                DropdownTitle.TextSize = 14
                DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
                ArrowImg.Name = "ArrowImg"
                ArrowImg.Parent = Dropdown
                ArrowImg.BackgroundTransparency = 1
                ArrowImg.Position = UDim2New(1, -35, 0.5, -8)
                ArrowImg.Size = UDim2New(0, 16, 0, 16)
                ArrowImg.Image = "rbxassetid://10709790948"
                ArrowImg.ImageColor3 = FromRGB(220, 30, 30)
                DropItemHolder.Name = "DropItemHolder"
                DropItemHolder.Parent = Dropdown
                DropItemHolder.Active = true
                DropItemHolder.BackgroundTransparency = 1
                DropItemHolder.BorderSizePixel = 0
                DropItemHolder.Position = UDim2New(0, 5, 1, 0)
                DropItemHolder.Size = UDim2New(1, -10, 0, 0)
                DropItemHolder.CanvasSize = UDim2New(0, 0, 0, 0)
                DropItemHolder.ScrollBarThickness = 3
                DropLayout.Name = "DropLayout"
                DropLayout.Parent = DropItemHolder
                DropLayout.SortOrder = Enum.SortOrder.LayoutOrder
                DropLayout.Padding = UDimNew(0, 2)
                DropdownBtn.MouseButton1Click:Connect(function()
                    if droptog == false then
                        Dropdown:TweenSize(UDim2New(1, 0, 0, 46 + framesize), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .2, true)
                        TweenService:Create(ArrowImg, TweenInfo.new(.3), {Rotation = 180}):Play()
                        droptog = true
                    else
                        Dropdown:TweenSize(UDim2New(1, 0, 0, 36), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .2, true)
                        TweenService:Create(ArrowImg, TweenInfo.new(.3), {Rotation = 0}):Play()
                        droptog = false
                    end
                    wait(.2)
                    Tab.CanvasSize = UDim2New(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
                end)
                for i, v in next, list do
                    itemcount = itemcount + 1
                    framesize = framesize + 26
                    DropItemHolder.Size = UDim2New(1, -10, 0, framesize)
                    local Item = Instance.new("TextButton")
                    local ItemCorner = Instance.new("UICorner")
                    Item.Name = "Item"
                    Item.Parent = DropItemHolder
                    Item.BackgroundColor3 = FromRGB(25, 25, 25)
                    Item.ClipsDescendants = true
                    Item.Size = UDim2New(1, 0, 0, 24)
                    Item.AutoButtonColor = false
                    Item.FontFace = Library.Font
                    Item.Text = v
                    Item.TextColor3 = FromRGB(240, 240, 240)
                    Item.TextSize = 13
                    ItemCorner.CornerRadius = UDimNew(0, 4)
                    ItemCorner.Parent = Item
                    Item.MouseEnter:Connect(function() TweenService:Create(Item, TweenInfo.new(.2), {BackgroundColor3 = FromRGB(40, 40, 40)}):Play() end)
                    Item.MouseLeave:Connect(function() TweenService:Create(Item, TweenInfo.new(.2), {BackgroundColor3 = FromRGB(25, 25, 25)}):Play() end)
                    Item.MouseButton1Click:Connect(function()
                        droptog = false
                        DropdownTitle.Text = text .. " - " .. v
                        pcall(callback, v)
                        Dropdown:TweenSize(UDim2New(1, 0, 0, 36), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .2, true)
                        TweenService:Create(ArrowImg, TweenInfo.new(.3), {Rotation = 0}):Play()
                        wait(.2)
                        Tab.CanvasSize = UDim2New(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
                    end)
                    DropItemHolder.CanvasSize = UDim2New(0, 0, 0, DropLayout.AbsoluteContentSize.Y)
                end
                Tab.CanvasSize = UDim2New(0, 0, 0, TabLayout.AbsoluteContentSize.Y)

                return {
                    Refresh = function(newList)
                        for _, child in ipairs(DropItemHolder:GetChildren()) do
                            if child:IsA("TextButton") then child:Destroy() end
                        end
                        framesize = 0
                        itemcount = 0
                        for i, v in next, newList do
                            itemcount = itemcount + 1
                            framesize = framesize + 26
                            DropItemHolder.Size = UDim2New(1, -10, 0, framesize)
                            local Item = Instance.new("TextButton")
                            local ItemCorner = Instance.new("UICorner")
                            Item.Name = "Item"
                            Item.Parent = DropItemHolder
                            Item.BackgroundColor3 = FromRGB(25, 25, 25)
                            Item.Size = UDim2New(1, 0, 0, 24)
                            Item.AutoButtonColor = false
                            Item.FontFace = Library.Font
                            Item.Text = v
                            Item.TextColor3 = FromRGB(240, 240, 240)
                            Item.TextSize = 13
                            ItemCorner.CornerRadius = UDimNew(0, 4)
                            ItemCorner.Parent = Item
                            Item.MouseButton1Click:Connect(function()
                                droptog = false
                                DropdownTitle.Text = text .. " - " .. v
                                pcall(callback, v)
                                Dropdown:TweenSize(UDim2New(1, 0, 0, 36), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .2, true)
                                TweenService:Create(ArrowImg, TweenInfo.new(.3), {Rotation = 0}):Play()
                                wait(.2)
                                Tab.CanvasSize = UDim2New(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
                            end)
                            DropItemHolder.CanvasSize = UDim2New(0, 0, 0, DropLayout.AbsoluteContentSize.Y)
                        end
                    end
                }
            end

            return tabcontent
        end

        return tabhold
    end
end

getgenv().Library = Library
return Library
