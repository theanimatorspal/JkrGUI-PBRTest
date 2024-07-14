require "JkrGUIv2.Engine.Engine"
require "JkrGUIv2.Threed"

Validation = true
Engine:Load(Validation)

app = {}
app.window = Jkr.CreateWindow(Engine.i, "Hello", vec2(900, 480), 3)
app.buffer3d = Jkr.CreateShapeRenderer3D(Engine.i, app.window)
app.world3d = Jkr.World3D(app.buffer3d)
app.world3d:AddLight3D(vec4(10, 10, 5, 1), Jmath.Normalize(vec4(-10, -10, 5, 1)))

require("src.CompileShaders")
require("src.Objects")

local oldTime = 0.0
local frameCount = 0
local e = Engine.e
local w = app.window
local mt = Engine.mt

app.WindowClearColor = vec4(1, 1, 1, 1)

local function Update()
          app.world3d:Update(e);
          app.Objects[DamagedHelmetObjectIndex].mRotation = app.Objects[DamagedHelmetObjectIndex].mRotation:Rotate_deg(
                    0.1,
                    vec3(0, 1, 0))
end

local function Dispatch()
end

local function Draw()
          app.world3d:DrawObjectsExplicit(app.window, app.Objects, Jkr.CmdParam.UI)
end

local function MultiThreadedDraws()
end

local function MultiThreadedExecute()
end

while not e:ShouldQuit() do
          oldTime = w:GetWindowCurrentTime()
          e:ProcessEvents()
          w:BeginUpdates()
          Update()
          WindowDimension = w:GetWindowDimension()
          w:EndUpdates()

          w:BeginDispatches()
          Dispatch()
          w:EndDispatches()

          MultiThreadedDraws()
          w:BeginUIs()
          Draw()
          w:EndUIs()

          w:BeginDraws(app.WindowClearColor.x, app.WindowClearColor.y, app.WindowClearColor.z, app.WindowClearColor.w, 1)
          MultiThreadedExecute()
          w:ExecuteUIs()
          w:EndDraws()
          w:Present()
          local delta = w:GetWindowCurrentTime() - oldTime
          if (frameCount % 100 == 0) then
                    w:SetTitle("Samprahar Frame Rate" .. 1000 / delta)
          end
          frameCount = frameCount + 1
          mt:InjectToGate("__MtDrawCount", 0)
end

Engine.mt:Wait()
