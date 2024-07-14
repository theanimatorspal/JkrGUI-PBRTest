app.Uniforms = {}

app.Uniforms.SimpleSkyboxUniform = { index = app.world3d:AddUniform3D(Engine.i, app.window) }
app.Uniforms.SimpleSkyboxUniform.handle = app.world3d:GetUniform3D(app.Uniforms.SimpleSkyboxUniform.index)

-- app.Uniforms.PBR = { index = app.world3d:AddUniform3D(Engine.i, app.window), }
-- app.Uniforms.PBR.handle = app.world3d:GetUniform3D(app.Uniforms.PBR.index)


app.camera = Jkr.Camera3D()
app.camera:SetAttributes(vec3(0, 0, 0), vec3(0, 5, -10))
app.camera:SetPerspective(0.3, 16 / 9, 0.1, 10000)
app.world3d:AddCamera(app.camera)
app.world3d:AddLight3D(vec4(-10, 5, -10, 1),
          Jmath.Normalize(vec4(0, 0, 0, 0) - vec4(10, 10, -10, 1)))

app.Objects = app.world3d:MakeExplicitObjectsVector()
local Skybox = Jkr.Generator(Jkr.Shapes.Cube3D, vec3(1, 1, 1))
local skyboxId = app.buffer3d:Add(Skybox, vec3(0, 0, 0))
Engine.AddObject(app.Objects, skyboxId, -1, app.Uniforms.SimpleSkyboxUniform.index, app.Simple3Ds.simple_skybox.index,
          nil,
          0)

local skyboxBindingIndex = 20
app.Uniforms.SimpleSkyboxUniform.handle:Build(app.Simple3Ds.simple_skybox.handle)
app.world3d:AddWorldInfoToUniform3D(app.Uniforms.SimpleSkyboxUniform.index)
app.world3d:AddSkyboxToUniform3D(Engine.i, "res/textures/skybox1/", math.floor(app.Uniforms.SimpleSkyboxUniform.index),
          1)



app.Uniforms.SimpleSkyboxUniform.handle:AddGenerateIrradianceCube(
          Engine.i, app.window, app.buffer3d, math.floor(skyboxId), app.world3d:GetSkyboxImageBase(0),
          app.world3d,
          "cache2/irradiancecube.glsl", PBR.FilterCubeV.str,
          PBR.IrradianceCubeF.str, PBR.BasicCompute.str, false, 21, 0
)

app.Uniforms.SimpleSkyboxUniform.handle:AddGeneratePrefilteredCube(
          Engine.i, app.window, app.buffer3d, math.floor(skyboxId), app.world3d:GetSkyboxImageBase(0), app.world3d,
          "cache2/GeneratePrefilteredCube.glsl", PBR.FilterCubeV.str, PBR.PreFilterEnvMapF.str,
          PBR.BasicCompute.str,
          false, 22, 0
)


-- app.Uniforms.PBR.handle:Build(app.Simple3Ds.pbribl_pbribl.handle)
-- app.SphereGLTFIndex = app.world3d:AddGLTFModel("res/models/sphere.gltf")
-- local sphereindex = app.buffer3d:Add(app.world3d:GetGLTFModel(math.floor(app.SphereGLTFIndex)))
-- local SphereObjectIndex = Engine.AddObject(app.Objects, sphereindex, math.floor(app.SphereGLTFIndex),
--           math.floor(app.Uniforms.PBR.index),
--           math.floor(app.Simple3Ds.pbribl_pbribl.index),
--           app.world3d:GetGLTFModel(math.floor(app.SphereGLTFIndex)), 0)
-- app.Objects[SphereObjectIndex].mMatrix2 = mat4(vec4(0.2, 2, 1, 0), vec4(1.0, 0.765557, 0.336057, 1), vec4(0), vec4(0))

app.DamagedHelmetGLTFIndex = app.world3d:AddGLTFModel("res/models/DamagedHelmet/DamagedHelmet.gltf")
local damagedHelmet = app.buffer3d:Add(app.world3d:GetGLTFModel(math.floor(app.DamagedHelmetGLTFIndex)))
local damagedHelmetGLTF = app.world3d:GetGLTFModel(math.floor(app.DamagedHelmetGLTFIndex))
Engine.GetGLTFInfo(damagedHelmetGLTF, true)

local Material0 = Engine.CreatePBRShaderByGLTFMaterial(damagedHelmetGLTF, 0)
app.Simple3Ds.DamagedHelmetMaterial0 = {
          index = app.world3d:AddSimple3D(Engine.i, app.window),
          fname = "cache2/pbribl_skybox.glsl",
          vs = Material0.vShader.str,
          fs = Material0.fShader.str,
          cs = PBR.BasicCompute.str
}
app.Simple3Ds.handle = app.world3d:GetSimple3D(app.Simple3Ds.DamagedHelmetMaterial0.index)
app.Simple3Ds.Compile(app.Simple3Ds.DamagedHelmetMaterial0)

app.Uniforms.DamagedHelmetUniform = { index = app.world3d:AddUniform3D(Engine.i, app.window) }
app.Uniforms.DamagedHelmetUniform.handle = app.world3d:GetUniform3D(app.Uniforms.DamagedHelmetUniform.index)


local nodeIndex = damagedHelmetGLTF:GetNodeIndexByMeshIndex(0)[1]
app.Uniforms.DamagedHelmetUniform.handle:Build(app.Simple3Ds.handle,
          damagedHelmetGLTF, nodeIndex, false, true, true)

app.Uniforms.DamagedHelmetUniform.handle:BuildByMaterial(app.Simple3Ds.handle, damagedHelmetGLTF, 0)

app.Uniforms.DamagedHelmetUniform.handle:AddGenerateBRDFLookupTable(Engine.i, app.window,
          "cache2/AddGenerateBRDFLookupTable.glsl",
          PBR.GenBrdfLutV.str,
          PBR.GenBrdfLutF.str,
          PBR.BasicCompute.str,
          false,
          10,
          1)

DamagedHelmetObjectIndex = Engine.AddObject(app.Objects, damagedHelmet, math.floor(app.DamagedHelmetGLTFIndex),
          math.floor(app.Uniforms.DamagedHelmetUniform.index),
          math.floor(app.Simple3Ds.DamagedHelmetMaterial0.index),
          app.world3d:GetGLTFModel(math.floor(app.DamagedHelmetGLTFIndex)), 0)

app.Objects[DamagedHelmetObjectIndex].mMatrix2 = mat4(vec4(0.2, 2, 1, 0), vec4(1.0, 0.765557, 0.336057, 1), vec4(0),
          vec4(0))
app.Objects[DamagedHelmetObjectIndex].mRotation = app.Objects[DamagedHelmetObjectIndex].mRotation:Rotate_deg(140,
          vec3(0, 1, 0))

-- app.Objects[DamagedHelmetObjectIndex].mRotation = app.Objects[DamagedHelmetObjectIndex].mRotation:Rotate_deg(-60,
--           vec3(0, 0, 1))
