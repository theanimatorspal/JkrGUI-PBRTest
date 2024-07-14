require("JkrGUIv2.Engine.Shader")

app.Skybox3dV = Engine.Shader()
    .Header(450)
    .NewLine()
    .VLayout()
    .Out(0, "vec3", "vVertUV")
    .Push()
    .Ubo()
    .GlslMainBegin()
    .Indent()
    .Append([[
                vec3 position = mat3(Ubo.view * Push.model) * inPosition.xyz;
                gl_Position = (Ubo.proj * vec4(position, 0.0)).xyzz;
                vVertUV = inPosition.xyz;
        ]]).InvertY()
    .NewLine()
    .GlslMainEnd()
    .NewLine().str

app.Skybox3dF = Engine.Shader()
    .Header(450)
    .NewLine()
    .In(0, "vec3", "vVertUV")
    .outFragColor()
    .Ubo()
    .uSamplerCubeMap(21, "irradianceCube", 0)
    .uSamplerCubeMap(22, "prefilteredCube", 0)
    .Push()
    .uSamplerCubeMap(20, "samplerCubeMap", 1)
    .GlslMainBegin()
    .Indent()
    .Append([[
            outFragColor = texture(prefilteredCube, vVertUV) * 0.5;
            outFragColor = texture(irradianceCube, vVertUV) * 0.5;
            outFragColor = texture(samplerCubeMap, vVertUV) * 0.5;
        ]])
    .GlslMainEnd()
    .NewLine().Print().str
