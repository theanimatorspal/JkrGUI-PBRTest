require("src.Shaders")
require("JkrGUIv2.Engine.Shader")

function CompileShaders()
          app.Simple3Ds = {}
          app.Simple3Ds.ShouldLoad = false

          -- app.Simple3Ds.pbribl_brdflut = {
          --           index = app.world3d:AddSimple3D(Engine.i, app.window),
          --           fname = "cache2/pbribl_brdflut",
          --           vs = PBR.GenBrdfLutV.str,
          --           fs = PBR.GenBrdfLutF.str,
          --           cs = PBR.BasicCompute.str
          -- }

          -- app.Simple3Ds.pbribl_filtercube = {
          --           index = app.world3d:AddSimple3D(Engine.i, app.window),
          --           fname = "cache2/pbribl_filtercube",
          --           vs = PBR.FilterCubeV.str,
          --           fs = PBR.PreFilterEnvMapF.str,
          --           cs = PBR.BasicCompute.str
          -- }

          -- app.Simple3Ds.pbribl_irradiancecube = {
          --           index = app.world3d:AddSimple3D(Engine.i, app.window),
          --           fname = "cache2/pbribl_irradiancecube",
          --           vs = PBR.FilterCubeV.str,
          --           fs = PBR.IrradianceCubeF.str,
          --           cs = PBR.BasicCompute.str
          -- }

          app.Simple3Ds.simple_skybox = {
                    index = app.world3d:AddSimple3D(Engine.i, app.window),
                    fname = "cache2/simple3d_skybox",
                    vs = app.Skybox3dV,
                    fs = app.Skybox3dF,
                    cs = ""
          }

          app.Simple3Ds.pbribl_pbribl = {
                    index = app.world3d:AddSimple3D(Engine.i, app.window),
                    fname = "cache2/pbribl_skybox.glsl",
                    vs = PBR.IBLV.str,
                    fs = PBR.IBLF.str,
                    cs = ""
          }

          app.Simple3Ds.deferredBasic = {
                    index = app.world3d:AddSimple3D(Engine.i, app.window),
                    fname = "cache2/deferredBasic.glsl",
                    vs = Deferred.BasicVertex.Print().str,
                    fs = Deferred.BasicFragment.Print().str,
                    cs = ""
          }


          function app.Simple3Ds.Compile(this)
                    this.handle = app.world3d:GetSimple3D(math.floor(this.index))
                    this.handle:Compile(
                              Engine.i,
                              app.window,
                              this.fname,
                              this.vs,
                              this.fs,
                              this.cs,
                              app.Simple3Ds.ShouldLoad)
          end

          app.Simple3Ds.Compile(app.Simple3Ds.pbribl_pbribl)
          app.Simple3Ds.Compile(app.Simple3Ds.simple_skybox)
end

CompileShaders()
