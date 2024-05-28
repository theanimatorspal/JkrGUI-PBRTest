app.Uniforms = {}

app.Uniforms.SimpleSkyboxUniform = { index = app.world3d:AddUniform3D(Engine.i, app.window) }
app.Uniforms.SimpleSkyboxUniform.handle = app.world3d:GetUniform3D(app.Uniforms.SimpleSkyboxUniform.index)

app.Uniforms.PBR = { index = app.world3d:AddUniform3D(Engine.i, app.window), }
app.Uniforms.PBR.handle = app.world3d:GetUniform3D(app.Uniforms.PBR.index)

-- APP.Uniforms.PBR.handle:AddGenerateBRDFLookupTable(Engine.i, APP.w, "cache2/AddGenerateBRDFLookupTable.glsl",
--           PBR.GenBrdfLutV,
--           PBR.GenBrdfLutF,
--           PBR.BasicCompute,
--           false,
--           3,
--           1)

app.camera = Jkr.Camera3D()
app.camera:SetAttributes(vec3(0, 0, 0), vec3(0, 5, -10))
app.camera:SetPerspective(0.7, 16 / 9, 0.1, 10000)
app.world3d:AddCamera(app.camera)
app.world3d:AddLight3D(vec4(10, 10, -10, 1),
          Jmath.Normalize(vec4(0, 0, 0, 0) - vec4(10, 10, -10, 1)))

app.Objects = app.world3d:MakeExplicitObjectsVector()
local Skybox = Jkr.Generator(Jkr.Shapes.Cube3D, vec3(1, 1, 1))
local skyboxId = app.buffer3d:Add(Skybox, vec3(0, 0, 0))
Engine.AddObject(app.Objects, skyboxId, -1, app.Uniforms.SimpleSkyboxUniform.index, app.Simple3Ds.simple_skybox.index,
          nil,
          0)

local skyboxBindingIndex = 20
local set = 1
app.Uniforms.SimpleSkyboxUniform.handle:Build(app.Simple3Ds.simple_skybox.handle)
app.world3d:AddWorldInfoToUniform3D(app.Uniforms.SimpleSkyboxUniform.index)
app.world3d:AddSkyboxToUniform3D(Engine.i, "res/textures/skybox1/", math.floor(app.Uniforms.SimpleSkyboxUniform.index),
          1)

app.Uniforms.PBR.handle:Build(app.Simple3Ds.pbribl_pbribl.handle)
app.Uniforms.PBR.handle:AddGenerateBRDFLookupTable(
          Engine.i,
          app.window,
          "cache2/brdflut.glsl",
          PBR.GenBrdfLutV.str,
          PBR.GenBrdfLutF.str,
          PBR.BasicCompute.str,
          false,
          3,
          1
)


app.Uniforms.PBR.handle:AddGeneratePrefilteredCube(
          Engine.i, app.window, app.buffer3d, math.floor(skyboxId), app.world3d:GetSkyboxImageBase(0), app.world3d,
          "cache2/GeneratePrefilteredCube.glsl", PBR.FilterCubeV.str, PBR.PreFilterEnvMapF.str,
          PBR.BasicCompute.str,
          false, 21, 1
)

app.Uniforms.PBR.handle:AddGenerateIrradianceCube(
          Engine.i, app.window, app.buffer3d, math.floor(skyboxId), app.world3d:GetSkyboxImageBase(0),
          app.world3d,
          "cache2/irradiancecube.glsl", PBR.FilterCubeV.str,
          PBR.IrradianceCubeF.str, PBR.BasicCompute.str, false, 20, 1
)

app.SphereGLTFIndex = app.world3d:AddGLTFModel("res/models/sphere.gltf")
local sphereindex = app.buffer3d:Add(app.world3d:GetGLTFModel(math.floor(app.SphereGLTFIndex)))
local SphereObjectIndex = Engine.AddObject(app.Objects, sphereindex, math.floor(app.SphereGLTFIndex),
          math.floor(app.Uniforms.PBR.index),
          math.floor(app.Simple3Ds.pbribl_pbribl.index),
          app.world3d:GetGLTFModel(math.floor(app.SphereGLTFIndex)), 0)

app.Objects[SphereObjectIndex].mMatrix2 = mat4(vec4(0.2, 2, 1, 0), vec4(1.0, 0.765557, 0.336057, 1), vec4(0), vec4(0))


--[[
1: #version 450
2: #extension GL_EXT_debug_printf : enable
3: layout( location = 0 ) out vec4 outFragColor;
4: layout(push_constant, std430) uniform pc {
5:     mat4 model;
6:     mat4 m2;
7: } Push;
8: layout (location = 0) in vec3 vUVW;
9:     struct {
10:           float deltaPhi;
11:           float deltaTheta;
12:     } consts;
13:
14: layout(set = 1, binding = 20) uniform samplerCube samplerEnv;
15: const float PI = 3.14159;
16: void GlslMain()
17: {
18:     consts.deltaPhi = Push.m2[0].x;
19:     consts.deltaTheta = Push.m2[0].y;
20:     vec3 N = normalize(vUVW);
21:     vec3 up = vec3(0.0, 1.0, 0.0);
22:     vec3 right = normalize(cross(up, N));
23:     up = cross(N, right);
24:     const float TWO_PI = PI * 2.0;
25:     const float HALF_PI = PI * 0.5;
26:     vec3 color = vec3(0.0);
27:     uint sampleCount = 0u;
28:     for (float phi = 0.0; phi < TWO_PI; phi += consts.deltaPhi) {
29:             for (float theta = 0.0; theta < HALF_PI; theta += consts.deltaTheta) {
30:                     vec3 tempVec = cos(phi) * right + sin(phi) * up;
31:                     vec3 sampleVector = cos(theta) * N + sin(theta) * tempVec;
32:                     color += texture(samplerEnv, sampleVector).rgb * cos(theta) * sin(theta);
33:                     sampleCount++;
34:             }
35:     }
36:     outFragColor = vec4(PI * color / float(sampleCount), 1.0);
37:
38: }
]]
