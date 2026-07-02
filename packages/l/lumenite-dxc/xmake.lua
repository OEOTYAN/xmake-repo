-- repo: https://github.com/microsoft/DirectXShaderCompiler
package("lumenite-dxc")
    set_homepage("https://github.com/microsoft/DirectXShaderCompiler")
    set_description("Pinned DirectX Shader Compiler binary package for Lumenite.")
    set_license("LLVM")

    add_urls("https://github.com/microsoft/DirectXShaderCompiler/releases/download/v1.9.2602.24/dxc_2026_05_27.zip")
    add_versions("1.9.2602+24", "cf658aacf070d3045e31b8f1f8a696c2945f37c1095019481ef7c513368db3b4")

    add_configs("shared", {description = "Use the packaged DXC shared binaries.", default = true, type = "boolean", readonly = true})

    on_load(function (package)
        package:set("kind", "binary")
    end)

    on_install("windows|x64", function (package)
        os.cp("bin/x64/*", package:installdir("bin"))
        os.cp("inc/*", package:installdir("include"))
        os.cp("lib/x64/*", package:installdir("lib"))
        package:addenv("PATH", "bin")
    end)

    on_test(function (package)
        os.vrunv(path.join(package:installdir("bin"), "dxc.exe"), {"-help"})
        assert(os.isfile(path.join(package:installdir("bin"), "dxcompiler.dll")))
        assert(os.isfile(path.join(package:installdir("bin"), "dxil.dll")))
    end)
