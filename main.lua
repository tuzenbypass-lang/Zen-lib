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
        Tween.Get = function(self)
            if not self.Tween then return end
            return self.Tween, self.Info, self.Goal
        end
        Tween.Pause = function(self)
            if not self.Tween then return end
            self.Tween:Pause()
        end
        Tween.Play = function(self)
            if not self.Tween then return end
            self.Tween:Play()
        end
        Tween.Clean = function(self)
            if not self.Tween then return end
            Tween:Pause()
            self = nil
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
        Instances.FadeItem = function(self, Visibility, Speed)
            local Item = self.Instance
            if Visibility == true then Item.Visible = true end
            local Descendants = Item:GetDescendants()
            TableInsert(Descendants, Item)
            local NewTween
            for Index, Value in Descendants do
                local TransparencyProperty = Tween:GetProperty(Value)
                if not TransparencyProperty then continue end
                if type(TransparencyProperty) == "table" then
                    for _, Property in TransparencyProperty do
                        NewTween = Tween:FadeItem(Value, Property, not Visibility, Speed)
                    end
                else
                    NewTween = Tween:FadeItem(Value, TransparencyProperty, not Visibility, Speed)
                end
            end
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
        Instances.Disconnect = function(self, Name)
            if not self.Instance then return end
            return Library:Disconnect(Name)
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
            return Dragging
        end
        Instances.MakeResizeable = function(self, Minimum, Maximum, Window)
            if not self.Instance then return end
            local Gui = self.Instance
            local Resizing = false
            local CurrentSide = nil
            local StartMouse, StartPosition, StartSize
            local EdgeThickness = 2
            local MakeEdge = function(Name, Position, Size)
                local Button = Instances:Create("TextButton", {
                    Name = "\0", Size = Size, Position = Position,
                    BackgroundColor3 = FromRGB(166, 147, 243),
                    BackgroundTransparency = 1, Text = "", BorderSizePixel = 0,
                    AutoButtonColor = false, Parent = Gui, ZIndex = 99999,
                })
                Button:AddToTheme({BackgroundColor3 = "Accent"})
                return Button
            end
            local Edges = {
                {Button = MakeEdge("Left", UDim2New(0, 0, 0, 0), UDim2New(0, EdgeThickness, 1, 0)), Side = "L"},
                {Button = MakeEdge("Right", UDim2New(1, -EdgeThickness, 0, 0), UDim2New(0, EdgeThickness, 1, 0)), Side = "R"},
                {Button = MakeEdge("Top", UDim2New(0, 0, 0, 0), UDim2New(1, 0, 0, EdgeThickness)), Side = "T"},
                {Button = MakeEdge("Bottom", UDim2New(0, 0, 1, -EdgeThickness), UDim2New(1, 0, 0, EdgeThickness)), Side = "B"},
            }
            local BeginResizing = function(Side)
                Resizing = true
                CurrentSide = Side
                StartMouse = UserInputService:GetMouseLocation()
                StartPosition = Vector2New(Gui.Position.X.Offset, Gui.Position.Y.Offset)
                StartSize = Vector2New(Gui.Size.X.Offset, Gui.Size.Y.Offset)
                for Index, Value in Edges do
                    Value.Button:Tween(nil, {BackgroundTransparency = (Value.Side == Side) and 0 or 1})
                end
            end
            local EndResizing = function()
                Resizing = false
                CurrentSide = nil
                for Index, Value in Edges do
                    Value.Button.Instance.BackgroundTransparency = 1
                end
            end
            for Index, Value in Edges do
                Value.Button:Connect("InputBegan", function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then BeginResizing(Value.Side) end
                end)
            end
            Library:Connect(UserInputService.InputEnded, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if Resizing then EndResizing() end
                end
            end)
            Library:Connect(RunService.RenderStepped, function()
                if not Resizing or not CurrentSide then return end
                local MouseLocation = UserInputService:GetMouseLocation()
                local dx = MouseLocation.X - StartMouse.X
                local dy = MouseLocation.Y - StartMouse.Y
                local x, y = StartPosition.X, StartPosition.Y
                local w, h = StartSize.X, StartSize.Y
                if CurrentSide == "L" then
                    x = StartPosition.X + dx
                    w = StartSize.X - dx
                elseif CurrentSide == "R" then
                    w = StartSize.X + dx
                elseif CurrentSide == "T" then
                    y = StartPosition.Y + dy
                    h = StartSize.Y - dy
                elseif CurrentSide == "B" then
                    h = StartSize.Y + dy
                end
                if w < Minimum.X then
                    if CurrentSide == "L" then x = x - (Minimum.X - w) end
                    w = Minimum.X
                end
                if h < Minimum.Y then
                    if CurrentSide == "T" then y = y - (Minimum.Y - h) end
                    h = Minimum.Y
                end
                self:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2FromOffset(x, y)})
                self:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2FromOffset(w, h)})
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

    local CustomFont = {}
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

    Library.GetImage = function(self, Image)
        local ImageData = self.Images[Image]
        if not ImageData then return end
        return getcustomasset(self.Folders.Assets .. "/" .. ImageData[1])
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

    Library.Disconnect = function(self, Name)
        for _, Connection in self.Connections do
            if Connection.Name == Name then
                Connection.Connection:Disconnect()
                break
            end
        end
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

    Library.ToRich = function(self, Text, Color)
        return `<font color="rgb({MathFloor(Color.R * 255)}, {MathFloor(Color.G * 255)}, {MathFloor(Color.B * 255)})">{Text}</font>`
    end

    Library.GetConfig = function(self)
        local Config = {}
        for Index, Value in Library.Flags do
            if type(Value) == "table" and Value.Key then
                Config[Index] = {Key = tostring(Value.Key), Mode = Value.Mode}
            elseif type(Value) == "table" and Value.Color then
                Config[Index] = {Color = "#" .. Value.HexValue, Alpha = Value.Alpha}
            else
                Config[Index] = Value
            end
        end
        return HttpService:JSONEncode(Config)
    end

    Library.LoadConfig = function(self, Config)
        local Decoded = HttpService:JSONDecode(Config)
        for Index, Value in Decoded do
            local SetFunction = Library.SetFlags[Index]
            if SetFunction then
                if type(Value) == "table" and Value.Key then
                    SetFunction(Value)
                elseif type(Value) == "table" and Value.Color then
                    SetFunction(Value.Color, Value.Alpha)
                else
                    SetFunction(Value)
                end
            end
        end
    end

    Library.DeleteConfig = function(self, Config)
        if isfile(Library.Folders.Configs .. "/" .. Config) then
            delfile(Library.Folders.Configs .. "/" .. Config)
        end
    end

    Library.RefreshConfigsList = function(self, Element)
        local CurrentList = {}
        local List = {}
        local ConfigFolderName = StringGSub(Library.Folders.Configs, Library.Folders.Directory .. "/", "")
        for Index, Value in listfiles(Library.Folders.Configs) do
            local FileName = StringGSub(Value, Library.Folders.Directory .. "\\" .. ConfigFolderName .. "\\", "")
            List[Index] = FileName
        end
        local IsNew = #List ~= CurrentList
        if not IsNew then
            for Index = 1, #List do
                if List[Index] ~= CurrentList[Index] then
                    IsNew = true
                    break
                end
            end
        else
            CurrentList = List
            Element:Refresh(CurrentList)
        end
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

    Library.Lerp = function(self, Start, Finish, Time)
        return Start + (Finish - Start) * Time
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

    Library.GetCalculatedRayPosition = function(self, Position, Normal, Origin, Direction)
        local N, D, V = Normal, Direction, Origin - Position
        local Number = (N.x * V.x) + (N.y * V.y) + (N.z * V.z)
        local Den = (N.x * D.x) + (N.y * D.y) + (N.z * D.z)
        local A = -Number / Den
        return Origin + (A * Direction)
    end

    Library.UpdateText = function(self)
        for _, Value in self.UnusedHolder.Instance:GetDescendants() do
            if Value:IsA("TextLabel") or Value:IsA("TextButton") or Value:IsA("TextBox") then Value.FontFace = Library.Font end
        end
        for _, Value in self.Holder.Instance:GetDescendants() do
            if Value:IsA("TextLabel") or Value:IsA("TextButton") or Value:IsA("TextBox") then Value.FontFace = Library.Font end
        end
    end

    Library.MakeBlurred = function(self, Item, Window)
        Item = Item.Instance
        local BlurItem = Item
        local Part = Instances:Create("Part", {
            Material = Enum.Material.Glass, Transparency = 1, Reflectance = 1,
            CastShadow = false, Anchored = true, CanCollide = false, CanQuery = false,
            CollisionGroup = " ", Size = Vector3New(1, 1, 1) * 0.01,
            Color = FromRGB(0,0,0), Parent = Camera
        })
        local BlockMesh = Instances:Create("BlockMesh", {Parent = Part.Instance})
        local DepthOfField = Instances:Create("DepthOfFieldEffect", {
            Parent = Lighting, Enabled = true, FarIntensity = 0,
            FocusDistance = 0, InFocusRadius = 1000, NearIntensity = 1, Name = ""
        })
        Library:Connect(RunService.RenderStepped, function()
            if Window.IsOpen then
                if Item.Visible then
                    DepthOfField:Tween(nil, {NearIntensity = 1})
                    Part:Tween(nil, {Transparency = 0.97})
                    Part:Tween(nil, {Size = Vector3New(1, 1, 1) * 0.01})
                    local Corner0 = BlurItem.AbsolutePosition
                    local Corner1 = Corner0 + BlurItem.AbsoluteSize
                    local Ray0 = Camera.ScreenPointToRay(Camera, Corner0.X, Corner0.Y, 1)
                    local Ray1 = Camera.ScreenPointToRay(Camera, Corner1.X, Corner1.Y, 1)
                    local Origin = Camera.CFrame.Position + Camera.CFrame.LookVector * (0.05 - Camera.NearPlaneZ)
                    local Normal = Camera.CFrame.LookVector
                    local Position0 = Library:GetCalculatedRayPosition(Origin, Normal, Ray0.Origin, Ray0.Direction)
                    local Position1 = Library:GetCalculatedRayPosition(Origin, Normal, Ray1.Origin, Ray1.Direction)
                    Position0 = Camera.CFrame:PointToObjectSpace(Position0)
                    Position1 = Camera.CFrame:PointToObjectSpace(Position1)
                    local Size = Position1 - Position0
                    local Center = (Position0 + Position1) / 2
                    BlockMesh.Instance.Offset = Center
                    BlockMesh.Instance.Scale = Size / 0.0101
                    Part.Instance.CFrame = Camera.CFrame
                else
                    DepthOfField:Tween(nil, {NearIntensity = 0})
                    BlockMesh.Instance.Offset = Vector3New(0, 0, 0)
                    BlockMesh.Instance.Scale = Vector3New(0, 0, 0)
                end
            else
                DepthOfField:Tween(nil, {NearIntensity = 0})
                BlockMesh.Instance.Offset = Vector3New(0, 0, 0)
                BlockMesh.Instance.Scale = Vector3New(0, 0, 0)
            end
        end)
    end

    Library.EscapePattern = function(self, String)
        local ShouldEscape = false
        if string.match(String, "[%(%)%.%%%+%-%*%?%[%]%^%$]") then ShouldEscape = true end
        if ShouldEscape then
            return StringGSub(String, "[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%1")
        end
        return String
    end

    do
        Library.CreateColorpicker = function(self, Data)
            local Colorpicker = {
                Flag = Data.Flag, Hue = 0, Saturation = 0, Value = 0, Alpha = 0,
                Color = FromRGB(0, 0, 0), HexValue = "#000000",
                SavedColors = {}, IsOpen = false
            }
            local Items = {}
            do
                Items["ColorpickerButton"] = Instances:Create("TextButton", {
                    Parent = Data.Parent.Instance, Name = "\0", FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0), BorderColor3 = FromRGB(0, 0, 0),
                    Text = "", AutoButtonColor = false, AnchorPoint = Vector2New(0, 0.5),
                    BackgroundTransparency = 1, BorderSizePixel = 0,
                    Size = UDim2New(0, 100, 0, 20), ZIndex = 2, TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                if not Data.Parent2.Instance:FindFirstChild("nig") then
                    Items["PaletteIcon"] = Instances:Create("ImageLabel", {
                        Parent = Data.Parent2.Instance, ImageColor3 = FromRGB(141, 141, 150),
                        BorderColor3 = FromRGB(0, 0, 0), Size = UDim2New(0, 16, 0, 16),
                        AnchorPoint = Vector2New(0.5, 1), Image = "rbxassetid://92464809279921",
                        Name = "nig", BackgroundTransparency = 1,
                        Position = UDim2New(1, -16, 1, -6), ZIndex = 2, BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })
                    Items["PaletteIcon"]:OnHover(function()
                        Items["PaletteIcon"]:Tween(nil, {ImageColor3 = Library.Theme.Accent})
                    end)
                    Items["PaletteIcon"]:OnHoverLeave(function()
                        Items["PaletteIcon"]:Tween(nil, {ImageColor3 = FromRGB(141, 141, 150)})
                    end)
                end
                Items["Color"] = Instances:Create("Frame", {
                    Parent = Items["ColorpickerButton"].Instance, Name = "\0",
                    Size = UDim2New(0, 15, 0, 15), Position = UDim2New(0, 0, 0, 2),
                    BorderColor3 = FromRGB(0, 0, 0), ZIndex = 2, BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(124, 163, 255)
                })
                Instances:Create("UICorner", { Parent = Items["Color"].Instance, Name = "\0", CornerRadius = UDimNew(1, 0) })
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["ColorpickerButton"].Instance, Name = "\0",
                    FontFace = Library.Font, TextColor3 = FromRGB(240, 240, 240),
                    BorderColor3 = FromRGB(0, 0, 0), Text = "#7842ff",
                    AutomaticSize = Enum.AutomaticSize.X, Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1, Position = UDim2New(0, 25, 0, 2),
                    BorderSizePixel = 0, ZIndex = 2, TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                Items["Text"]:AddToTheme({TextColor3 = "Text"})
                Items["ColorpickerWindow"] = Instances:Create("TextButton", {
                    Parent = Library.UnusedHolder.Instance, AutoButtonColor = false, Text = "",
                    Name = "\0", Visible = false,
                    Position = UDim2New(0.01075268816202879, 0, 0.0336427167057991, 0),
                    BorderColor3 = FromRGB(0, 0, 0), Size = UDim2New(0, 235, 0, 270),
                    BorderSizePixel = 0, BackgroundColor3 = FromRGB(255, 255, 25)
                })
                Items["ColorpickerWindow"]:AddToTheme({BackgroundColor3 = "Background"})
                Instances:Create("UICorner", { Parent = Items["ColorpickerWindow"].Instance, Name = "\0", CornerRadius = UDimNew(0, 6) })
                Items["Palette"] = Instances:Create("TextButton", {
                    Parent = Items["ColorpickerWindow"].Instance, Name = "\0",
                    FontFace = Library.Font, TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0), Text = "", AutoButtonColor = false,
                    Position = UDim2New(0, 15, 0, 10), Size = UDim2New(1, -31, 1, -159),
                    BorderSizePixel = 0, TextSize = 14,
                    BackgroundColor3 = FromRGB(124, 163, 255)
                })
                Items["Saturation"] = Instances:Create("Frame", {
                    Parent = Items["Palette"].Instance, Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0), Size = UDim2New(1, 1, 1, 0),
                    BorderSizePixel = 0, BackgroundColor3 = FromRGB(255, 255, 255)
                })
                Instances:Create("UIGradient", {
                    Parent = Items["Saturation"].Instance, Name = "\0",
                    Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(1, 0)}
                })
                Instances:Create("UICorner", { Parent = Items["Saturation"].Instance, Name = "\0", CornerRadius = UDimNew(0, 4) })
                Items["Value"] = Instances:Create("Frame", {
                    Parent = Items["Palette"].Instance, Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0), Size = UDim2New(1, 1, 1, 1),
                    BorderSizePixel = 0, BackgroundColor3 = FromRGB(0, 0, 0)
                })
                Instances:Create("UIGradient", {
                    Parent = Items["Value"].Instance, Name = "\0", Rotation = 90,
                    Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(1, 0)}
                })
                Instances:Create("UICorner", { Parent = Items["Value"].Instance, Name = "\0", CornerRadius = UDimNew(0, 4) })
                Instances:Create("UICorner", { Parent = Items["Palette"].Instance, Name = "\0", CornerRadius = UDimNew(0, 4) })
                Items["PaletteDragger"] = Instances:Create("Frame", {
                    Parent = Items["Palette"].Instance, Name = "\0",
                    BackgroundTransparency = 1, Position = UDim2New(0, 15, 0, 15),
                    BorderColor3 = FromRGB(0, 0, 0), Size = UDim2New(0, 10, 0, 10),
                    BorderSizePixel = 0, BackgroundColor3 = FromRGB(255, 255, 255)
                })
                Instances:Create("UIStroke", {
                    Parent = Items["PaletteDragger"].Instance, Name = "\0",
                    Color = FromRGB(255, 255, 255), ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })
                Instances:Create("UICorner", { Parent = Items["PaletteDragger"].Instance, Name = "\0" })
                Items["Hue"] = Instances:Create("TextButton", {
                    Parent = Items["ColorpickerWindow"].Instance, Name = "\0",
                    FontFace = Library.Font, TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0), Text = "", AutoButtonColor = false,
                    AnchorPoint = Vector2New(0, 1), Position = UDim2New(0, 15, 1, -131),
                    Size = UDim2New(1, -31, 0, 6), BorderSizePixel = 0,
                    TextSize = 14, BackgroundColor3 = FromRGB(255, 255, 255)
                })
                Instances:Create("UICorner", { Parent = Items["Hue"].Instance, Name = "\0", CornerRadius = UDimNew(1, 0) })
                Items["HueInline"] = Instances:Create("TextButton", {
                    Parent = Items["Hue"].Instance, Name = "\0", FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0), BorderColor3 = FromRGB(0, 0, 0),
                    Text = "", AutoButtonColor = false, Size = UDim2New(1, 0, 1, 0),
                    BorderSizePixel = 0, TextSize = 14, BackgroundColor3 = FromRGB(255, 255, 255)
                })
                Instances:Create("UICorner", { Parent = Items["HueInline"].Instance, Name = "\0", CornerRadius = UDimNew(1, 0) })
                Instances:Create("UIGradient", {
                    Parent = Items["HueInline"].Instance, Name = "\0",
                    Color = RGBSequence{
                        RGBSequenceKeypoint(0, FromRGB(255, 0, 0)),
                        RGBSequenceKeypoint(0.17, FromRGB(255, 255, 0)),
                        RGBSequenceKeypoint(0.33, FromRGB(0, 255, 0)),
                        RGBSequenceKeypoint(0.5, FromRGB(0, 255, 255)),
                        RGBSequenceKeypoint(0.67, FromRGB(0, 0, 255)),
                        RGBSequenceKeypoint(0.83, FromRGB(255, 0, 255)),
                        RGBSequenceKeypoint(1, FromRGB(255, 0, 0))
                    }
                })
                Items["HueDragger"] = Instances:Create("Frame", {
                    Parent = Items["HueInline"].Instance, Name = "\0",
                    AnchorPoint = Vector2New(0, 0.5), Position = UDim2New(0, 15, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0), Size = UDim2New(0, 12, 0, 12),
                    BorderSizePixel = 0, BackgroundColor3 = FromRGB(255, 255, 255)
                })
                Instances:Create("UICorner", { Parent = Items["HueDragger"].Instance, Name = "\0", CornerRadius = UDimNew(1, 0) })
                Items["Alpha"] = Instances:Create("TextButton", {
                    Parent = Items["ColorpickerWindow"].Instance, Name = "\0",
                    FontFace = Library.Font, TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0), Text = "", AutoButtonColor = false,
                    AnchorPoint = Vector2New(0, 1), Position = UDim2New(0, 15, 1, -107),
                    Size = UDim2New(1, -31, 0, 6), BorderSizePixel = 0,
                    TextSize = 14, BackgroundColor3 = FromRGB(124, 163, 255)
                })
                Instances:Create("UICorner", { Parent = Items["Alpha"].Instance, Name = "\0", CornerRadius = UDimNew(1, 0) })
                Instances:Create("UIGradient", {
                    Parent = Items["Alpha"].Instance, Name = "\0",
                    Color = RGBSequence{
                        RGBSequenceKeypoint(0, FromRGB(0, 0, 0)),
                        RGBSequenceKeypoint(1, FromRGB(255, 255, 255))
                    }
                })
                Items["AlphaDragger"] = Instances:Create("Frame", {
                    Parent = Items["Alpha"].Instance, Name = "\0",
                    AnchorPoint = Vector2New(0, 0.5), Position = UDim2New(0, 15, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0), Size = UDim2New(0, 12, 0, 12),
                    BorderSizePixel = 0, BackgroundColor3 = FromRGB(255, 255, 255)
                })
                Instances:Create("UICorner", { Parent = Items["AlphaDragger"].Instance, Name = "\0", CornerRadius = UDimNew(1, 0) })
                Items["SavedColors"] = Instances:Create("ScrollingFrame", {
                    Parent = Items["ColorpickerWindow"].Instance, Name = "\0",
                    AutomaticCanvasSize = Enum.AutomaticSize.Y, AnchorPoint = Vector2New(0, 1),
                    BorderSizePixel = 0, CanvasSize = UDim2New(0, 0, 0, 0),
                    ScrollBarImageColor3 = FromRGB(124, 163, 255),
                    MidImage = "rbxassetid://86870199131153", BorderColor3 = FromRGB(0, 0, 0),
                    ScrollBarThickness = 0, Size = UDim2New(1, -20, 0, 69), Selectable = false,
                    TopImage = "rbxassetid://86870199131153", Position = UDim2New(0, 10, 1, -30),
                    BottomImage = "rbxassetid://86870199131153", BackgroundTransparency = 1,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                Instances:Create("UIGridLayout", {
                    Parent = Items["SavedColors"].Instance, Name = "\0",
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    CellPadding = UDim2New(0, 10, 0, 10), CellSize = UDim2New(0, 25, 0, 25)
                })
                Instances:Create("UIPadding", {
                    Parent = Items["SavedColors"].Instance, Name = "\0",
                    PaddingLeft = UDimNew(0, 5), PaddingTop = UDimNew(0, 5),
                    PaddingRight = UDimNew(0, -125), PaddingBottom = UDimNew(0, 5)
                })
                Items["HEXInput"] = Instances:Create("TextBox", {
                    Parent = Items["ColorpickerWindow"].Instance, Name = "\0",
                    FontFace = Library.Font, TextColor3 = FromRGB(240, 240, 240),
                    BorderColor3 = FromRGB(0, 0, 0), ClearTextOnFocus = false,
                    Text = "#7ca3ff", AnchorPoint = Vector2New(1, 1),
                    Size = UDim2New(0, 140, 0, 20), TextTransparency = 0.5,
                    PlaceholderColor3 = FromRGB(185, 185, 185),
                    Position = UDim2New(1, -8, 1, -8),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0, TextSize = 14,
                    BackgroundColor3 = FromRGB(30, 29, 31)
                })
                Items["HEXInput"]:AddToTheme({BackgroundColor3 = "Outline"})
                Instances:Create("UIPadding", {
                    Parent = Items["HEXInput"].Instance, Name = "\0",
                    PaddingLeft = UDimNew(0, 5),
                })
                Items["HexLabel"] = Instances:Create("TextLabel", {
                    Parent = Items["ColorpickerWindow"].Instance, Name = "\0",
                    FontFace = Library.Font, TextColor3 = FromRGB(240, 240, 240),
                    BorderColor3 = FromRGB(0, 0, 0), Text = "Custom:",
                    TextTransparency = 0.5, AnchorPoint = Vector2New(0, 1),
                    Size = UDim2New(0, 40, 0, 20), Position = UDim2New(0, 10, 1, -8),
                    BorderSizePixel = 0, TextSize = 14, BackgroundTransparency = 1,
                    BackgroundColor3 = FromRGB(30, 29, 31)
                })
                Items["HexLabel"]:AddToTheme({TextColor3 = "Text"})
                Instances:Create("UICorner", { Parent = Items["HEXInput"].Instance, Name = "\0", CornerRadius = UDimNew(0, 4) })
            end
            function Colorpicker:Get() return Colorpicker.Color, Colorpicker.Alpha end
            function Colorpicker:Update(IsFromAlpha)
                local Hue, Saturation, Value = Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value
                Colorpicker.Color = FromHSV(Hue, Saturation, Value)
                Colorpicker.HexValue = Colorpicker.Color:ToHex()
                Library.Flags[Colorpicker.Flag] = { Alpha = Colorpicker.Alpha, Color = Colorpicker.Color, HexValue = Colorpicker.HexValue, Transparency = 1 - Colorpicker.Alpha }
                Items["Color"]:Tween(nil, {BackgroundColor3 = Colorpicker.Color})
                Items["Palette"]:Tween(nil, {BackgroundColor3 = FromHSV(Hue, 1, 1)})
                Items["Text"].Instance.Text = ("#"..Colorpicker.HexValue):upper()
                Items["HEXInput"].Instance.Text = "#"..Colorpicker.HexValue
                if not IsFromAlpha then Items["Alpha"]:Tween(nil, {BackgroundColor3 = Colorpicker.Color}) end
                if Data.Callback then Library:SafeCall(Data.Callback, Colorpicker.Color, Colorpicker.Alpha) end
            end
            local SlidingPalette, SlidingHue, SlidingAlpha = false, false, false
            local PaletteChanged, HueChanged, AlphaChanged
            function Colorpicker:SlidePalette(Input)
                if not Input or not SlidingPalette then return end
                local ValueX = MathClamp(1 - (Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 1)
                local ValueY = MathClamp(1 - (Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 1)
                Colorpicker.Saturation = ValueX
                Colorpicker.Value = ValueY
                local SlideX = MathClamp((Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 0.955)
                local SlideY = MathClamp((Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 0.955)
                Items["PaletteDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(SlideX, 0, SlideY, 0)})
                Colorpicker:Update()
            end
            function Colorpicker:SlideHue(Input)
                if not Input or not SlidingHue then return end
                local ValueX = MathClamp((Input.Position.X - Items["Hue"].Instance.AbsolutePosition.X) / Items["Hue"].Instance.AbsoluteSize.X, 0, 1)
                Colorpicker.Hue = ValueX
                local SlideX = MathClamp((Input.Position.X - Items["Hue"].Instance.AbsolutePosition.X) / Items["Hue"].Instance.AbsoluteSize.X, 0, 0.955)
                Items["HueDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(SlideX, 0, 0.5, 0)})
                Colorpicker:Update()
            end
            function Colorpicker:SlideAlpha(Input)
                if not Input or not SlidingAlpha then return end
                local ValueX = MathClamp((Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X, 0, 1)
                Colorpicker.Alpha = ValueX
                local SlideX = MathClamp((Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X, 0, 0.955)
                Items["AlphaDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(SlideX, 0, 0.5, 0)})
                Colorpicker:Update(true)
            end
            local Debounce = false
            local RenderStepped
            function Colorpicker:SetOpen(Bool)
                if Debounce then return end
                Colorpicker.IsOpen = Bool
                Debounce = true
                if Colorpicker.IsOpen then
                    Items["ColorpickerWindow"].Instance.Visible = true
                    Items["ColorpickerWindow"].Instance.Parent = Library.Holder.Instance
                    RenderStepped = RunService.RenderStepped:Connect(function()
                        Items["ColorpickerWindow"].Instance.Position = UDim2New(0, Items["ColorpickerButton"].Instance.AbsolutePosition.X, 0, Items["ColorpickerButton"].Instance.AbsolutePosition.Y + Items["ColorpickerButton"].Instance.AbsoluteSize.Y + 5)
                    end)
                    if Data.Section.IsSettings ~= true then
                        for Index, Value in Library.OpenFrames do
                            if Value ~= Colorpicker then Value:SetOpen(false) end
                        end
                    end
                    Library.OpenFrames[Colorpicker] = Colorpicker
                else
                    if not Data.Section.IsSettings then
                        if Library.OpenFrames[Colorpicker] then Library.OpenFrames[Colorpicker] = nil end
                    end
                    if RenderStepped then RenderStepped:Disconnect(); RenderStepped = nil end
                end
                local Descendants = Items["ColorpickerWindow"].Instance:GetDescendants()
                TableInsert(Descendants, Items["ColorpickerWindow"].Instance)
                local NewTween
                for Index, Value in Descendants do
                    local TransparencyProperty = Tween:GetProperty(Value)
                    if not TransparencyProperty then continue end
                    if not Value.ClassName:find("UI") then
                        Value.ZIndex = (Colorpicker.IsOpen and Data.Section.IsSettings and 9) or (Colorpicker.IsOpen and not Data.Section.IsSettings and 3) or 1
                    end
                    if type(TransparencyProperty) == "table" then
                        for _, Property in TransparencyProperty do
                            NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                        end
                    else
                        NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                    end
                end
                NewTween.Tween.Completed:Connect(function()
                    Debounce = false
                    Items["ColorpickerWindow"].Instance.Visible = Colorpicker.IsOpen
                    task.wait(0.2)
                    Items["ColorpickerWindow"].Instance.Parent = not Colorpicker.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
                end)
            end
            function Colorpicker:Set(Color, Alpha)
                if type(Color) == "table" then
                    Color = FromRGB(Color[1], Color[2], Color[3])
                    Alpha = Color[4]
                elseif type(Color) == "string" then
                    Color = FromHex(Color)
                end
                Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value = Color:ToHSV()
                Colorpicker.Alpha = Alpha or 0
                local PaletteValueX = MathClamp(1 - Colorpicker.Saturation, 0, 0.955)
                local PaletteValueY = MathClamp(1 - Colorpicker.Value, 0, 0.955)
                local AlphaPositionX = MathClamp(Colorpicker.Alpha, 0, 0.955)
                local HuePositionX = MathClamp(Colorpicker.Hue, 0, 0.955)
                Items["PaletteDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(PaletteValueX, 0, PaletteValueY, 0)})
                Items["HueDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(HuePositionX, 0, 0.5, 0)})
                Items["AlphaDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(AlphaPositionX, 0, 0.5, 0)})
                Colorpicker:Update()
            end
            Items["ColorpickerButton"]:Connect("MouseButton1Down", function()
                Colorpicker:SetOpen(not Colorpicker.IsOpen)
            end)
            Items["Palette"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    SlidingPalette = true
                    Colorpicker:SlidePalette(Input)
                    if PaletteChanged then return end
                    PaletteChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            SlidingPalette = false
                            PaletteChanged:Disconnect()
                            PaletteChanged = nil
                        end
                    end)
                end
            end)
            Items["HueInline"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    SlidingHue = true
                    Colorpicker:SlideHue(Input)
                    if HueChanged then return end
                    HueChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            SlidingHue = false
                            HueChanged:Disconnect()
                            HueChanged = nil
                        end
                    end)
                end
            end)
            Items["Alpha"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    SlidingAlpha = true
                    Colorpicker:SlideAlpha(Input)
                    if AlphaChanged then return end
                    AlphaChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            SlidingAlpha = false
                            AlphaChanged:Disconnect()
                            AlphaChanged = nil
                        end
                    end)
                end
            end)
            function AddColor(Color)
                local SaveIndex = #Colorpicker.SavedColors + 1
                local SavedColor = Instances:Create("TextButton", {
                    Parent = Items["SavedColors"].Instance, Name = "\0",
                    FontFace = Library.Font, TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0), Text = "", AutoButtonColor = false,
                    Size = UDim2New(0, 200, 0, 50), BorderSizePixel = 0, TextSize = 14,
                    BackgroundTransparency = 1, ZIndex = 4, BackgroundColor3 = Color
                })
                Instances:Create("UICorner", { Parent = SavedColor.Instance, Name = "\0", CornerRadius = UDimNew(0, 6) })
                local UIStroke = Instances:Create("UIStroke", {
                    Parent = SavedColor.Instance, Name = "\0",
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Color = FromRGB(255, 255, 255), Thickness = 1.5, Transparency = 1
                })
                SavedColor:OnHover(function() UIStroke:Tween(nil, {Transparency = 0}) end)
                SavedColor:OnHoverLeave(function() UIStroke:Tween(nil, {Transparency = 1}) end)
                Colorpicker.SavedColors[SaveIndex] = { Color = Color, Alpha = Colorpicker.Alpha }
                SavedColor:Connect("MouseButton1Down", function()
                    local NewColorData = Colorpicker.SavedColors[SaveIndex]
                    Colorpicker:Set(NewColorData.Color, NewColorData.Alpha)
                end)
                SavedColor:Tween(nil, {BackgroundTransparency = 0})
            end
            local Colors = {
                ["Orange"] = FromRGB(245, 114, 66), ["Pink"] = FromRGB(245, 66, 191),
                ["Purple"] = FromRGB(124, 54, 245), ["Pink 2"] = FromRGB(202, 110, 255),
                ["Pink 3"] = FromRGB(250, 142, 239), ["Yellow"] = FromRGB(214, 206, 92),
                ["Orange 2"] = FromRGB(255, 93, 48), ["Orange 3"] = FromRGB(255, 169, 56),
                ["Green"] = FromRGB(0, 171, 0), ["Blue"] = FromRGB(0, 116, 224),
                ["Maroon"] = FromRGB(120, 0, 76), ["Whiteish Pink"] = FromRGB(255, 194, 245),
                ["White"] = FromRGB(255, 255, 255), ["Red"] = FromRGB(255, 0, 0),
                ["Sky Blue"] = FromRGB(171, 209, 255),
            }
            AddColor(Colors["Orange"]); AddColor(Colors["Pink"]); AddColor(Colors["Purple"])
            AddColor(Colors["Pink 2"]); AddColor(Colors["Pink 3"]); AddColor(Colors["Yellow"])
            AddColor(Colors["Orange 2"]); AddColor(Colors["Orange 3"]); AddColor(Colors["Green"])
            AddColor(Colors["Blue"]); AddColor(Colors["Maroon"]); AddColor(Colors["Whiteish Pink"])
            AddColor(Colors["White"]); AddColor(Colors["Red"]); AddColor(Colors["Sky Blue"])
            Items["HEXInput"]:Connect("FocusLost", function()
                Colorpicker:Set(tostring(Items["HEXInput"].Instance.Text), Colorpicker.Alpha)
            end)
            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if SlidingPalette then Colorpicker:SlidePalette(Input) end
                    if SlidingHue then Colorpicker:SlideHue(Input) end
                    if SlidingAlpha then Colorpicker:SlideAlpha(Input) end
                end
            end)
            Library:Connect(UserInputService.InputBegan, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    if not Colorpicker.IsOpen then return end
                    if Library:IsMouseOverFrame(Items["ColorpickerWindow"]) or Library:IsMouseOverFrame(Items["PaletteIcon"]) and not Data.Section.IsSettings then return end
                    Colorpicker:SetOpen(false)
                end
            end)
            if Data.Default then Colorpicker:Set(Data.Default, Data.Alpha) end
            Library.SetFlags[Colorpicker.Flag] = function(Value, Alpha)
                Colorpicker:Set(Value, Alpha)
            end
            return Colorpicker, Items
        end

        Library.KeybindList = function(self, Title)
            local KeybindList = {}
            Library.KeyList = KeybindList
            local Items = {}
            do
                Items["KeybindsList"] = Instances:Create("Frame", {
                    Parent = Library.Holder.Instance, Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0), AnchorPoint = Vector2New(0, 0.5),
                    BackgroundTransparency = 0.3, Position = UDim2New(0, 20, 0.5, 20),
                    Size = UDim2New(0, 100, 0, 30), BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY, BackgroundColor3 = FromRGB(27, 25, 29)
                })
                Items["KeybindsList"]:AddToTheme({BackgroundColor3 = "Section Background"})
                Items["KeybindsList"]:MakeDraggable()
                Instances:Create("UICorner", { Parent = Items["KeybindsList"].Instance, Name = "\0" })
                Items["Top"] = Instances:Create("Frame", {
                    Parent = Items["KeybindsList"].Instance, Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0), Size = UDim2New(1, 12, 0, 40),
                    BorderSizePixel = 0, BackgroundColor3 = FromRGB(31, 31, 36)
                })
                Items["Top"]:AddToTheme({BackgroundColor3 = "Section Background 2"})
                Items["Icon"] = Instances:Create("ImageLabel", {
                    Parent = Items["Top"].Instance, Name = "\0",
                    ImageColor3 = FromRGB(255, 255, 255), BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 21, 0, 20), AnchorPoint = Vector2New(0, 0.5),
                    Image = "rbxassetid://81598136527047", BackgroundTransparency = 1,
                    Position = UDim2New(0, 15, 0.5, 0), ZIndex = 2,
                    BorderSizePixel = 0, BackgroundColor3 = FromRGB(255, 255, 255)
                })
                Instances:Create("UIGradient", {
                    Parent = Items["Icon"].Instance, Name = "\0",
                    Color = RGBSequence{
                        RGBSequenceKeypoint(0, FromRGB(131, 131, 131)),
                        RGBSequenceKeypoint(1, FromRGB(255, 255, 255))
                    }
                }):AddToTheme({Color = function()
                    return RGBSequence{
                        RGBSequenceKeypoint(0, Library.Theme.Accent),
                        RGBSequenceKeypoint(1, Library.Theme.AccentGradient)
                    }
                end})
                Items["Title"] = Instances:Create("TextLabel", {
                    Parent = Items["Top"].Instance, Name = "\0",
                    FontFace = Library.Font, TextColor3 = FromRGB(248, 248, 248),
                    BorderColor3 = FromRGB(0, 0, 0), Text = Title,
                    AutomaticSize = Enum.AutomaticSize.X, AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2New(0, 0, 0, 15), BackgroundTransparency = 1,
                    Position = UDim2New(0, 45, 0.5, -1), BorderSizePixel = 0,
                    ZIndex = 2, TextSize = 15, BackgroundColor3 = FromRGB(255, 255, 255)
                })
                Items["Title"]:AddToTheme({TextColor3 = "Text"})
                Instances:Create("UICorner", { Parent = Items["Top"].Instance, Name = "\0" })
                Instances:Create("Frame", {
                    Parent = Items["Top"].Instance, Name = "\0",
                    AnchorPoint = Vector2New(0, 1), Position = UDim2New(0, 0, 1, 0),
                    BorderColor3 = FromRGB(0, 0, 0), Size = UDim2New(0, 10, 0, 5),
                    BorderSizePixel = 0, BackgroundColor3 = FromRGB(31, 31, 36)
                }):AddToTheme({BackgroundColor3 = "Section Background 2"})
                Instances:Create("Frame", {
                    Parent = Items["Top"].Instance, Name = "\0",
                    AnchorPoint = Vector2New(1, 1), Position = UDim2New(1, 0, 1, 0),
                    BorderColor3 = FromRGB(0, 0, 0), Size = UDim2New(0, 10, 0, 5),
                    BorderSizePixel = 0, BackgroundColor3 = FromRGB(31, 31, 36)
                }):AddToTheme({BackgroundColor3 = "Section Background 2"})
                Items["Content"] = Instances:Create("Frame", {
                    Parent = Items["KeybindsList"].Instance, Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0), BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0, 40), Size = UDim2New(1, 12, 0, 0),
                    BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                Instances:Create("UIListLayout", {
                    Parent = Items["Content"].Instance, Name = "\0",
                    Padding = UDimNew(0, 4), SortOrder = Enum.SortOrder.LayoutOrder
                })
                Instances:Create("UIPadding", {
                    Parent = Items["Content"].Instance, Name = "\0",
                    PaddingTop = UDimNew(0, 8), PaddingBottom = UDimNew(0, 8),
                    PaddingRight = UDimNew(0, 8), PaddingLeft = UDimNew(0, 8)
                })
                Instances:Create("UIPadding", {
                    Parent = Items["KeybindsList"].Instance, Name = "\0",
                    PaddingRight = UDimNew(0, 12)
                })
            end
            function KeybindList:SetVisibility(Bool)
                Items["KeybindsList"].Instance.Visible = false
            end
            function KeybindList:Add(Name, Key)
                local NewKey = Instances:Create("TextButton", {
                    Parent = Items["Content"].Instance, Name = "\0",
                    FontFace = Library.Font, TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0), Text = "", AutoButtonColor = false,
                    BackgroundTransparency = 1, Size = UDim2New(1, 0, 0, 20),
                    BorderSizePixel = 0, TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                local NewKeyAccent = Instances:Create("Frame", {
                    Parent = NewKey.Instance, Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0), AnchorPoint = Vector2New(0, 0.5),
                    BackgroundTransparency = 1, Position = UDim2New(0, 0, 0.5, 0),
                    Size = UDim2New(0, 6, 0, 6), BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                Instances:Create("UIGradient", {
                    Parent = NewKeyAccent.Instance, Name = "\0", Rotation = -115,
                    Color = RGBSequence{
                        RGBSequenceKeypoint(0, FromRGB(255, 255, 255)),
                        RGBSequenceKeypoint(1, FromRGB(143, 143, 143))
                    }
                }):AddToTheme({Color = function()
                    return RGBSequence{
                        RGBSequenceKeypoint(0, Library.Theme.Accent),
                        RGBSequenceKeypoint(1, Library.Theme.AccentGradient)
                    }
                end})
                Instances:Create("UICorner", { Parent = NewKeyAccent.Instance, Name = "\0" })
                local NewKeyText = Instances:Create("TextLabel", {
                    Parent = NewKey.Instance, Name = "\0", FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255), TextTransparency = 0.3,
                    Text = Name .. " ["..Key.."]", Size = UDim2New(0, 0, 0, 15),
                    AnchorPoint = Vector2New(0, 0.5), BorderSizePixel = 0,
                    BackgroundTransparency = 1, Position = UDim2New(0, 0, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.X, TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                NewKeyText:AddToTheme({TextColor3 = "Text"})
                function NewKey:Set(Name, Key) NewKeyText.Instance.Text = Name .. " ["..Key.."]" end
                function NewKey:SetStatus(Bool)
                    if Bool then
                        NewKeyText:Tween(nil, {Position = UDim2New(0, 15, 0.5, 0), TextTransparency = 0})
                        NewKeyAccent:Tween(nil, {BackgroundTransparency = 0})
                    else
                        NewKeyText:Tween(nil, {Position = UDim2New(0, 0, 0.5, 0), TextTransparency = 0.3})
                        NewKeyAccent:Tween(nil, {BackgroundTransparency = 1})
                    end
                end
                return NewKey
            end
            return KeybindList
        end

        Library.Notification = function(self, Data)
            local Items = {}
            do
                Items["Notification"] = Instances:Create("Frame", {
                    Parent = Library.NotifHolder.Instance, Name = "\0",
                    BackgroundTransparency = 0.35, BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.XY,
                    BackgroundColor3 = FromRGB(27, 25, 29)
                })
                Items["Title"] = Instances:Create("TextLabel", {
                    Parent = Items["Notification"].Instance, Name = "\0",
                    FontFace = Library.Font, TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0), Text = Data.Title,
                    BackgroundTransparency = 1, Size = UDim2New(0, 0, 0, 15),
                    BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.XY,
                    TextSize = 14, BackgroundColor3 = FromRGB(255, 255, 255)
                })
                Items["Title"]:AddToTheme({TextColor3 = "Text"})
                Instances:Create("UIPadding", {
                    Parent = Items["Notification"].Instance, Name = "\0",
                    PaddingTop = UDimNew(0, 8), PaddingBottom = UDimNew(0, 8),
                    PaddingRight = UDimNew(0, 8), PaddingLeft = UDimNew(0, 8)
                })
                Instances:Create("UICorner", {
                    Parent = Items["Notification"].Instance, Name = "\0",
                    CornerRadius = UDimNew(0, 5)
                })
                Items["Description"] = Instances:Create("TextLabel", {
                    Parent = Items["Notification"].Instance, Name = "\0",
                    FontFace = Library.Font, TextColor3 = FromRGB(255, 255, 255),
                    TextTransparency = 0.3, Text = Data.Description,
                    Size = UDim2New(0, 0, 0, 15), BorderSizePixel = 0,
                    BackgroundTransparency = 1, Position = UDim2New(0, 0, 0, 20),
                    BorderColor3 = FromRGB(0, 0, 0), AutomaticSize = Enum.AutomaticSize.XY,
                    TextSize = 14, BackgroundColor3 = FromRGB(255, 255, 255)
                })
                Items["Description"]:AddToTheme({TextColor3 = "Text"})
                Items["Accent"] = Instances:Create("Frame", {
                    Parent = Items["Notification"].Instance, Name = "\0",
                    Position = UDim2New(0, 0, 0, Items["Description"].Instance.AbsoluteSize.Y + Items["Title"].Instance.AbsoluteSize.Y + 12),
                    BorderColor3 = FromRGB(0, 0, 0), Size = UDim2New(0, 0, 0, 6),
                    BorderSizePixel = 0, BackgroundColor3 = FromRGB(255, 255, 255)
                })
                Instances:Create("UICorner", {
                    Parent = Items["Accent"].Instance, Name = "\0",
                    CornerRadius = UDimNew(1, 0)
                })
                Instances:Create("UIGradient", {
                    Parent = Items["Accent"].Instance, Name = "\0",
                    Color = RGBSequence{
                        RGBSequenceKeypoint(0, FromRGB(255, 255, 255)),
                        RGBSequenceKeypoint(1, FromRGB(143, 143, 143))
                    }
                }):AddToTheme({Color = function()
                    return RGBSequence{
                        RGBSequenceKeypoint(0, Library.Theme.Accent),
                        RGBSequenceKeypoint(1, Library.Theme.AccentGradient)
                    }
                end})
                Items["Icon"] = Instances:Create("ImageLabel", {
                    Parent = Items["Notification"].Instance, Name = "\0",
                    ImageColor3 = FromRGB(255, 255, 255), BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(1, 0), Image = "rbxassetid://"..Data.Icon,
                    BackgroundTransparency = 1, Position = UDim2New(1, 0, 0, 0),
                    Size = UDim2New(0, 16, 0, 16), BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                if not Data.IconColor then
                    Instances:Create("UIGradient", {
                        Parent = Items["Icon"].Instance, Name = "\0", Rotation = -115,
                        Color = RGBSequence{
                            RGBSequenceKeypoint(0, FromRGB(255, 255, 255)),
                            RGBSequenceKeypoint(1, FromRGB(143, 143, 143))
                        }
                    }):AddToTheme({Color = function()
                        return RGBSequence{
                            RGBSequenceKeypoint(0, Library.Theme.Accent),
                            RGBSequenceKeypoint(1, Library.Theme.AccentGradient)
                        }
                    end})
                else
                    Instances:Create("UIGradient", {
                        Parent = Items["Icon"].Instance, Name = "\0", Rotation = -115,
                        Color = RGBSequence{
                            RGBSequenceKeypoint(0, Data.IconColor.Start),
                            RGBSequenceKeypoint(1, Data.IconColor.End)
                        }
                    })
                end
            end
            local Size = Items["Notification"].Instance.AbsoluteSize
            Items["Notification"].Instance.Size = UDim2New(0, 0, 0, 0)
            for Index, Value in Items do
                if Value.Instance:IsA("Frame") then Value.Instance.BackgroundTransparency = 1
                elseif Value.Instance:IsA("TextLabel") then Value.Instance.TextTransparency = 1
                elseif Value.Instance:IsA("ImageLabel") then Value.Instance.ImageTransparency = 1 end
            end
            task.wait(0.2)
            Items["Notification"].Instance.AutomaticSize = Enum.AutomaticSize.Y
            Library:Thread(function()
                for Index, Value in Items do
                    if Value.Instance:IsA("Frame") then
                        Value:Tween(TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false, 0), {BackgroundTransparency = 0})
                    elseif Value.Instance:IsA("TextLabel") then
                        Value:Tween(TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false, 0), {TextTransparency = 0})
                    elseif Value.Instance:IsA("ImageLabel") then
                        Value:Tween(TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false, 0), {ImageTransparency = 0})
                    end
                end
                Items["Notification"]:Tween(TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false, 0), {Size = UDim2New(0, Size.X, 0, Size.Y)})
                Items["Accent"]:Tween(TweenInfo.new(Data.Duration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Size = UDim2New(1, 0, 0, 6)})
                task.delay(Data.Duration + 0.15, function()
                    for Index, Value in Items do
                        if Value.Instance:IsA("Frame") then Value:Tween(nil, {BackgroundTransparency = 1})
                        elseif Value.Instance:IsA("TextLabel") then Value:Tween(nil, {TextTransparency = 1})
                        elseif Value.Instance:IsA("ImageLabel") then Value:Tween(nil, {ImageTransparency = 1}) end
                    end
                    Items["Notification"]:Tween(TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false, 0), {Size = UDim2New(0, 0, 0, 0)})
                    task.wait(0.5)
                    Items["Notification"]:Clean()
                end)
            end)
        end

        Library.Window = function(self, Data)
            Data = Data or {}
            local Window = {
                Name = Data.Name or Data.name or "Window",
                SubName = Data.SubName or Data.subname or "Fine-tuning for sure wins",
                Logo = Data.Logo or Data.logo or "1l20959262762131",
                Pages = {}, Items = {}, IsOpen = false, CurrentAlignment = "LeftTabs"
            }
            local Items = {}
            do
                Items["MainFrame"] = Instances:Create("Frame", {
                    Parent = Library.Holder.Instance, Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0), AnchorPoint = Vector2New(0.5, 0.5),
                    BackgroundTransparency = 0.12, Position = UDim2New(0.5, 0, 0.5, 0),
                    Size = UDim2New(0, IsMobile and 420 or 560, 0, IsMobile and 340 or 420),
                    ZIndex = 2, BorderSizePixel = 0, BackgroundColor3 = FromRGB(27, 25, 29)
                })
                Items["MainFrame"]:AddToTheme({BackgroundColor3 = "Background"})
                if IsMobile then
                    Instances:Create("UIScale", { Parent = Items["MainFrame"].Instance, Name = "\0", Scale = 0.7 })
                end
                Items["MainFrame"]:MakeResizeable(Vector2New(Items["MainFrame"].Instance.AbsoluteSize.X, Items["MainFrame"].Instance.AbsoluteSize.Y), Vector2New(9999, 9999), OriginalSizes)
                Library:MakeBlurred(Items["MainFrame"], Window)
                Items["LeftTabs"] = Instances:Create("Frame", {
                    Parent = Items["MainFrame"].Instance, Name = "\0", Visible = true,
                    BorderColor3 = FromRGB(0, 0, 0), AnchorPoint = Vector2New(1, 0),
                    BackgroundTransparency = 0.15, Size = UDim2New(0, 170, 1, 0),
                    ZIndex = 2, BorderSizePixel = 0, BackgroundColor3 = FromRGB(27, 25, 29)
                })
                Items["LeftTabs"]:AddToTheme({BackgroundColor3 = "Background"})
                Library:MakeBlurred(Items["LeftTabs"], Window)
                local Gui = Items["MainFrame"].Instance
                local Dragging, DragStart, StartPosition
                local Set = function(Input)
                    local DragDelta = Input.Position - DragStart
                    Items["MainFrame"]:Tween(TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        Position = UDim2New(StartPosition.X.Scale, StartPosition.X.Offset + DragDelta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + DragDelta.Y)
                    })
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
                Items["LeftTabs"]:Connect("InputBegan", function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        Dragging = true
                        DragStart = Input.Position
                        StartPosition = Gui.Position
                        Input.Changed:Connect(function()
                            if Input.UserInputState == Enum.UserInputState.End then Dragging = false end
                        end)
                    end
                end)
                Library:Connect(UserInputService.InputChanged, function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                        if Dragging then Set(Input) end
                    end
                end)
                if IsMobile then
                    Items["FloatingButton"] = Instances:Create("TextButton", {
                        Parent = Library.Holder.Instance, Text = "", AutoButtonColor = false,
                        Name = "\0", Position = UDim2New(0.5, 0, 0, 20),
                        AnchorPoint = Vector2New(0.5, 0), Visible = true,
                        BorderColor3 = FromRGB(0, 0, 0), Size = UDim2New(0, 50, 0, 50),
                        BorderSizePixel = 0, BackgroundTransparency = 0.5,
                        ZIndex = 127, BackgroundColor3 = Library.Theme.Background
                    })
                    Items["FloatingButton"]:AddToTheme({BackgroundColor3 = "Background"})
                    local Gui2 = Items["FloatingButton"].Instance
                    local Dragging2, DragStart2, StartPosition2
                    local Set2 = function(Input)
                        local DragDelta = Input.Position - DragStart2
                        Items["FloatingButton"]:Tween(TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                            Position = UDim2New(StartPosition2.X.Scale, StartPosition2.X.Offset + DragDelta.X, StartPosition2.Y.Scale, StartPosition2.Y.Offset + DragDelta.Y)
                        })
                    end
                    Items["FloatingButton"]:Connect("InputBegan", function(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                            Dragging2 = true
                            DragStart2 = Input.Position
                            StartPosition2 = Gui2.Position
                            Input.Changed:Connect(function()
                                if Input.UserInputState == Enum.UserInputState.End then Dragging2 = false end
                            end)
                        end
                    end)
                    Library:Connect(UserInputService.InputChanged, function(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                            if Dragging2 then Set2(Input) end
                        end
                    end)
                    Items["FloatingLogo"] = Instances:Create("ImageLabel", {
                        Parent = Items["FloatingButton"].Instance, BorderColor3 = FromRGB(0, 0, 0),
                        Name = "\0", Image = "rbxassetid://" .. Window.Logo,
                        BackgroundTransparency = 1, AnchorPoint = Vector2New(0.5, 0.5),
                        Position = UDim2New(0.5, 0, 0.5, 0), ZIndex = 127,
                        Size = UDim2New(1, -25, 1, -25), BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })
                    Instances:Create("UICorner", { Parent = Items["FloatingButton"].Instance, CornerRadius = UDimNew(1, 0) })
                    Instances:Create("UIGradient", {
                        Parent = Items["FloatingLogo"].Instance, Name = "\0",
                        Enabled = true, Rotation = -115,
                        Color = RGBSequence{
                            RGBSequenceKeypoint(0, FromRGB(255, 255, 255)),
                            RGBSequenceKeypoint(1, FromRGB(143, 143, 143))
                        }
                    }):AddToTheme({Color = function()
                        return RGBSequence{
                            RGBSequenceKeypoint(0, Library.Theme.Accent),
                            RGBSequenceKeypoint(1, Library.Theme.AccentGradient)
                        }
                    end})
                end
                Instances:Create("UIListLayout", { Parent = Items["LeftTabs"].Instance, Name = "\0", Padding = UDimNew(0, 12), SortOrder = Enum.SortOrder.LayoutOrder })
                Instances:Create("UIPadding", { Parent = Items["LeftTabs"].Instance, Name = "\0", PaddingTop = UDimNew(0, 15), PaddingBottom = UDimNew(0, 15), PaddingRight = UDimNew(0, 12), PaddingLeft = UDimNew(0, 12) })
                Items["Logo"] = Instances:Create("ImageLabel", {
                    Parent = Items["MainFrame"].Instance, Name = "\0",
                    ImageColor3 = FromRGB(255, 255, 255), ScaleType = Enum.ScaleType.Fit,
                    BorderColor3 = FromRGB(0, 0, 0), Size = UDim2New(0, 35, 0, 35),
                    Image = "rbxassetid://"..Window.Logo, BackgroundTransparency = 1,
                    Position = UDim2New(0, 12, 0, 12), ZIndex = 2,
                    BorderSizePixel = 0, BackgroundColor3 = FromRGB(255, 255, 255)
                })
                Instances:Create("UIGradient", {
                    Parent = Items["Logo"].Instance, Name = "\0",
                    Enabled = true, Rotation = -115,
                    Color = RGBSequence{
                        RGBSequenceKeypoint(0, FromRGB(255, 255, 255)),
                        RGBSequenceKeypoint(1, FromRGB(143, 143, 143))
                    }
                }):AddToTheme({Color = function()
                    return RGBSequence{
                        RGBSequenceKeypoint(0, Library.Theme.Accent),
                        RGBSequenceKeypoint(1, Library.Theme.AccentGradient)
                    }
                end})
                Items["Title"] = Instances:Create("TextLabel", {
                    Parent = Items["MainFrame"].Instance, Name = "\0",
                    FontFace = Library.Font, TextColor3 = FromRGB(240, 240, 240),
                    BorderColor3 = FromRGB(0, 0, 0), Text = Window.Name,
                    AutomaticSize = Enum.AutomaticSize.X, Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1, Position = UDim2New(0, 52, 0, 13),
                    BorderSizePixel = 0, ZIndex = 2, TextSize = 16,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                Items["Title"]:AddToTheme({TextColor3 = "Text"})
                Items["SubTitle"] = Instances:Create("TextLabel", {
                    Parent = Items["MainFrame"].Instance, Name = "\0",
                    FontFace = Library.Font, TextColor3 = FromRGB(240, 240, 240),
                    TextTransparency = 0.4, Text = Window.SubName,
                    AutomaticSize = Enum.AutomaticSize.X, Size = UDim2New(0, 0, 0, 15),
                    BorderSizePixel = 0, BackgroundTransparency = 1,
                    Position = UDim2New(0, 52, 0, 30), BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2, TextSize = 14, BackgroundColor3 = FromRGB(255, 255, 255)
                })
                Items["SubTitle"]:AddToTheme({TextColor3 = "Text"})
                Items["Content"] = Instances:Create("Frame", {
                    Parent = Items["MainFrame"].Instance, Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0), BackgroundTransparency = 0.75,
                    Position = UDim2New(0, 0, 0, 55), Size = UDim2New(1, 0, 1, -55),
                    ZIndex = 2, BorderSizePixel = 0, BackgroundColor3 = FromRGB(27, 25, 29)
                })
                Items["Content"]:AddToTheme({BackgroundColor3 = "Background"})

                Items["CloseButton"] = Instances:Create("TextButton", {
                    Parent = Items["MainFrame"].Instance, Name = "\0", Text = "X",
                    FontFace = Library.Font, TextColor3 = FromRGB(220, 30, 30), TextSize = 16,
                    AutoButtonColor = false, AnchorPoint = Vector2New(1, 0),
                    BorderSizePixel = 0, BackgroundTransparency = 0.2,
                    Position = UDim2New(1, -12, 0, 10), Size = UDim2New(0, 28, 0, 28),
                    ZIndex = 10, BackgroundColor3 = FromRGB(27, 25, 29)
                })
                Items["CloseButton"]:AddToTheme({BackgroundColor3 = "Element"})
                Instances:Create("UICorner", { Parent = Items["CloseButton"].Instance, CornerRadius = UDimNew(0, 7) })

                Items["MinimizeButton"] = Instances:Create("TextButton", {
                    Parent = Items["MainFrame"].Instance, Name = "\0", Text = "—",
                    FontFace = Library.Font, TextColor3 = FromRGB(220, 30, 30), TextSize = 18,
                    AutoButtonColor = false, AnchorPoint = Vector2New(1, 0),
                    BorderSizePixel = 0, BackgroundTransparency = 0.2,
                    Position = UDim2New(1, -46, 0, 10), Size = UDim2New(0, 28, 0, 28),
                    ZIndex = 10, BackgroundColor3 = FromRGB(27, 25, 29)
                })
                Items["MinimizeButton"]:AddToTheme({BackgroundColor3 = "Element"})
                Instances:Create("UICorner", { Parent = Items["MinimizeButton"].Instance, CornerRadius = UDimNew(0, 7) })

                Items["SquareButton"] = Instances:Create("TextButton", {
                    Parent = Items["MainFrame"].Instance, Name = "\0", Text = "□",
                    FontFace = Library.Font, TextColor3 = FromRGB(220, 30, 30), TextSize = 14,
                    AutoButtonColor = false, AnchorPoint = Vector2New(1, 0),
                    BorderSizePixel = 0, BackgroundTransparency = 0.2,
                    Position = UDim2New(1, -80, 0, 10), Size = UDim2New(0, 28, 0, 28),
                    ZIndex = 10, BackgroundColor3 = FromRGB(27, 25, 29)
                })
                Items["SquareButton"]:AddToTheme({BackgroundColor3 = "Element"})
                Instances:Create("UICorner", { Parent = Items["SquareButton"].Instance, CornerRadius = UDimNew(0, 7) })

                Instances:Create("UICorner", { Parent = Items["MainFrame"].Instance, Name = "\0", CornerRadius = UDimNew(0, 4) })
                Instances:Create("UICorner", { Parent = Items["LeftTabs"].Instance, Name = "\0", CornerRadius = UDimNew(0, 4) })

                Items["CloseButton"]:Connect("MouseButton1Down", function()
                    if getgenv().ZenBypassUnload then pcall(getgenv().ZenBypassUnload) end
                    Library:Unload()
                end)
                Items["MinimizeButton"]:Connect("MouseButton1Down", function()
                    Window.Minimized = not (Window.Minimized or false)
                    if Window.Minimized then
                        Window._savedSize = Gui.Size
                        Gui:TweenSize(UDim2New(0, 560, 0, 41), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.3, true)
                    else
                        Gui:TweenSize(Window._savedSize or UDim2New(0, 560, 0, 420), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.3, true)
                    end
                end)
                Items["SquareButton"]:Connect("MouseButton1Down", function()
                    Window.Minimized = false
                    Gui:TweenSize(UDim2New(0, 720, 0, 520), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.3, true)
                end)

                Window.Items = Items
            end

            local Debounce = false
            function Window:SetCenter()
                local CP = Items["MainFrame"].Instance.AbsolutePosition
                task.wait()
                Items["MainFrame"].Instance.AnchorPoint = Vector2New(0, 0)
                Items["MainFrame"].Instance.Position = UDim2New(0, CP.X, 0, CP.Y)
            end
            function Window:SetOpen(Bool)
                if Debounce then return end
                Window.IsOpen = Bool
                Debounce = true
                if Window.IsOpen then Items["MainFrame"].Instance.Visible = true end
                local Descendants = Items["MainFrame"].Instance:GetDescendants()
                TableInsert(Descendants, Items["MainFrame"].Instance)
                local NewTween
                for Index, Value in Descendants do
                    local TP = Tween:GetProperty(Value)
                    if not TP then continue end
                    if type(TP) == "table" then
                        for _, Property in TP do NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed) end
                    else
                        NewTween = Tween:FadeItem(Value, TP, Bool, Library.FadeSpeed)
                    end
                end
                NewTween.Tween.Completed:Connect(function()
                    Debounce = false
                    Items["MainFrame"].Instance.Visible = Window.IsOpen
                end)
            end

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
                TabBtnIndicator.BackgroundColor3 = Library.Theme.Accent
                TabBtnIndicator.BorderSizePixel = 0
                TabBtnIndicator.Position = UDim2New(0, 0, 0.5, 0)
                TabBtnIndicator.AnchorPoint = Vector2New(0, 0.5)
                TabBtnIndicator.Size = UDim2New(0, 0, 0, 14)
                local indC = Instance.new("UICorner")
                indC.CornerRadius = UDimNew(0, 2)
                indC.Parent = TabBtnIndicator

                local Tab = Instance.new("ScrollingFrame")
                local TabLayout = Instance.new("UIListLayout")
                Tab.Name = "Tab"
                Tab.Parent = TabFolder
                Tab.Active = true
                Tab.BackgroundTransparency = 1
                Tab.BorderSizePixel = 0
                Tab.Position = UDim2New(0, 185, 0, 5)
                Tab.Size = UDim2New(1, -195, 1, -15)
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
                            TweenService:Create(FrameToggle1, TweenInfo.new(.3), {BackgroundColor3 = Library.Theme.Accent}):Play()
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
                    SliderValue.TextColor3 = Library.Theme.Accent
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
                    CurrentValueFrame.BackgroundColor3 = Library.Theme.Accent
                    CurrentValueFrame.BorderSizePixel = 0
                    CurrentValueFrame.Size = UDim2New((start or 0) / max, 0, 0, 3)
                    SlideCircle.Name = "SlideCircle"
                    SlideCircle.Parent = SlideFrame
                    SlideCircle.BackgroundTransparency = 1
                    SlideCircle.Position = UDim2New((start or 0) / max, -6, -1.3, 0)
                    SlideCircle.Size = UDim2New(0, 11, 0, 11)
                    SlideCircle.Image = "rbxassetid://3570695787"
                    SlideCircle.ImageColor3 = Library.Theme.Accent
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
                    LabelTitle.TextColor3 = Library.Theme.Accent
                    LabelTitle.TextSize = 14
                    LabelTitle.TextXAlignment = Enum.TextXAlignment.Left
                    Tab.CanvasSize = UDim2New(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
                end

                function tabcontent:Dropdown(text, list, callback)
                    local droptog = false
                    local framesize = 0
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
                    ArrowImg.ImageColor3 = Library.Theme.Accent
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
                    local function populate(items)
                        for _, child in ipairs(DropItemHolder:GetChildren()) do
                            if child:IsA("TextButton") then child:Destroy() end
                        end
                        framesize = 0
                        for i, v in next, items do
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
                    end
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
                    populate(list)
                    Tab.CanvasSize = UDim2New(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
                    return {
                        Refresh = function(newList)
                            populate(newList)
                        end
                    }
                end

                return tabcontent
            end

            return tabhold
        end

        Library.Category = function(self, Name)
            local Items = {}
            do
                Items["Category"] = Instances:Create("TextLabel", {
                    Parent = self.Items["LeftTabs"].Instance, Name = "\0",
                    FontFace = Library.Font, TextColor3 = FromRGB(240, 240, 240),
                    TextTransparency = 0.4, Text = Name,
                    AutomaticSize = Enum.AutomaticSize.X, Size = UDim2New(1, 0, 0, 15),
                    BorderSizePixel = 0, BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderColor3 = FromRGB(0, 0, 0), ZIndex = 2,
                    TextSize = 14, BackgroundColor3 = FromRGB(255, 255, 255)
                })
                Items["Category"]:AddToTheme({TextColor3 = "Text"})
            end
        end
    end
end

getgenv().Library = Library
return Library
