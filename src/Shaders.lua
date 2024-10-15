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
    .uSamplerCubeMap(20, "samplerCubeMap", 0)
    .uSampler2D(23, "samplerBRDFLUT", 0)
    .uSamplerCubeMap(24, "irradianceCube", 0)
    .uSamplerCubeMap(25, "prefilteredCube", 0)
    .Push()
    .GlslMainBegin()
    .Indent()
    .Append([[
            outFragColor = texture(prefilteredCube, vVertUV) * 0.5;
            outFragColor = texture(irradianceCube, vVertUV) * 0.5;
            outFragColor = texture(samplerCubeMap, vVertUV) * 1;
        ]])
    .GlslMainEnd()
    .NewLine().str
