function Objects()
          app.Uniforms = {}

          app.Uniforms.SimpleSkyboxUniform = { index = app.world3d:AddUniform3D(Engine.i, app.window) }
          app.Uniforms.SimpleSkyboxUniform.handle = app.world3d:GetUniform3D(app.Uniforms.SimpleSkyboxUniform.index)

          -- app.Uniforms.PBR = { index = app.world3d:AddUniform3D(Engine.i, app.window), }
          -- app.Uniforms.PBR.handle = app.world3d:GetUniform3D(app.Uniforms.PBR.index)

          app.ObjectsStorage = {}

          app.camera = Jkr.Camera3D()
          app.camera:SetAttributes(vec3(0, 0, 0), vec3(0, 5, -10))
          app.camera:SetPerspective(0.3, 16 / 9, 0.1, 10000)
          app.world3d:AddCamera(app.camera)
          app.world3d:AddLight3D(vec4(-10, 5, -10, 1),
                    Jmath.Normalize(vec4(0, 0, 0, 0) - vec4(10, 10, -10, 1)))

          app.Objects = app.world3d:MakeExplicitObjectsVector()
          local Skybox = Jkr.Generator(Jkr.Shapes.Cube3D, vec3(1, 1, 1))
          local skyboxId = app.buffer3d:Add(Skybox, vec3(0, 0, 0))
          Engine.AddObject(app.ObjectsStorage, app.Objects, skyboxId, -1, app.Uniforms.SimpleSkyboxUniform.index,
                    app.Simple3Ds.simple_skybox.index,
                    nil,
                    0)

          local skyboxBindingIndex = 20
          app.Uniforms.SimpleSkyboxUniform.handle:Build(app.Simple3Ds.simple_skybox.handle)
          app.world3d:AddWorldInfoToUniform3D(app.Uniforms.SimpleSkyboxUniform.index)

          local file = Jkr.FileJkr("CacheFile.jkr");

          Jkr.SetupPBR(Engine.i,
                    app.window,
                    app.Uniforms.SimpleSkyboxUniform.handle,
                    app.world3d,
                    app.buffer3d, -- shape 3d
                    math.floor(skyboxId),
                    file,
                    "DamagedHelmet",
                    PBR.GenBrdfLutV.str,
                    PBR.GenBrdfLutF.str,
                    PBR.FilterCubeV.str,
                    PBR.IrradianceCubeF.str,
                    PBR.FilterCubeV.str,
                    PBR.PreFilterEnvMapF.str,
                    PBR.EquirectangularMapToMultiVShader.str,
                    PBR.EquirectangularMapToMultiFShader.str,
                    "res/textures/hdris/beach.hdr");

          app.DamagedHelmetGLTFIndex = app.world3d:AddGLTFModel("res/models/DamagedHelmet/DamagedHelmet.gltf")
          local damagedHelmet = app.buffer3d:Add(app.world3d:GetGLTFModel(math.floor(app.DamagedHelmetGLTFIndex)))
          local damagedHelmetGLTF = app.world3d:GetGLTFModel(math.floor(app.DamagedHelmetGLTFIndex))
          print("damagedHelmetGLTF:", damagedHelmetGLTF)
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


          local nodeIndex = damagedHelmetGLTF:GetNodeIndexByMeshIndex(0)
          app.Uniforms.DamagedHelmetUniform.handle:Build(app.Simple3Ds.handle,
                    damagedHelmetGLTF, nodeIndex, false, true)

          app.Uniforms.DamagedHelmetUniform.handle:BuildByMaterial(app.Simple3Ds.handle, damagedHelmetGLTF, 0)


          DamagedHelmetObjectIndex = Engine.AddObject(app.ObjectsStorage, app.Objects, damagedHelmet,
                    math.floor(app.DamagedHelmetGLTFIndex),
                    math.floor(app.Uniforms.DamagedHelmetUniform.index),
                    math.floor(app.Simple3Ds.DamagedHelmetMaterial0.index),
                    app.world3d:GetGLTFModel(math.floor(app.DamagedHelmetGLTFIndex)), 0)

          app.Objects[DamagedHelmetObjectIndex].mMatrix2 = mat4(vec4(0.2, 2, 1, 0), vec4(1.0, 0.765557, 0.336057, 1),
                    vec4(0),
                    vec4(0))
          app.Objects[DamagedHelmetObjectIndex].mRotation = app.Objects[DamagedHelmetObjectIndex].mRotation:Rotate_deg(
                    140,
                    vec3(0, 1, 0))

          -- app.Objects[DamagedHelmetObjectIndex].mRotation = app.Objects[DamagedHelmetObjectIndex].mRotation:Rotate_deg(
          --           -60,
          --           vec3(0, 0, 1))
          app.buffer3d = Jkr.CreateShapeRenderer3D(Engine.i, app.window)
          app.world3d = Jkr.World3D(app.buffer3d)
          local WorldShapeFile = Jkr.FileJkr("WorldShapeFile.jkr");
          Jkr.SerializeDeserializeShape3D(Engine.i, "pbr_shape->", WorldShapeFile, app.buffer3d)
          Jkr.SerializeDeserializeWorld3D(Engine.i, app.window, "pbr_world->", WorldShapeFile, app.world3d)
end

Objects()
