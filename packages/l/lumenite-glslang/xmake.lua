-- repo: https://github.com/KhronosGroup/glslang
package("lumenite-glslang")
    set_homepage("https://github.com/KhronosGroup/glslang")
    set_description("Pinned glslangValidator CLI for Lumenite GLSL to SPIR-V compilation.")
    set_license("Apache-2.0")

    add_urls("https://github.com/KhronosGroup/glslang.git")
    add_versions("1.4.350+1", "275822a6261ee689aadb1da5f09a0ec2f058685c")

    add_deps("cmake", "ninja")
    add_deps("python 3.x", {kind = "binary"})

    if is_plat("windows") then
        set_policy("platform.longpaths", true)
    end

    on_load(function (package)
        package:set("kind", "binary")
    end)

    on_install("windows", "linux", "macosx", "mingw", function (package)
        io.replace("CMakeLists.txt", 'set(CMAKE_DEBUG_POSTFIX "d")', [[
            message(WARNING "Disabled CMake Debug Postfix for xmake package generation")
        ]], {plain = true})

        local configs = {
            "-DENABLE_CTEST=OFF",
            "-DGLSLANG_TESTS=OFF",
            "-DBUILD_EXTERNAL=OFF",
            "-DENABLE_PCH=OFF",
            "-DBUILD_SHARED_LIBS=OFF",
            "-DENABLE_EXCEPTIONS=OFF",
            "-DENABLE_HLSL=ON",
            "-DENABLE_RTTI=OFF",
            "-DENABLE_GLSLANG_BINARIES=ON",
            "-DENABLE_OPT=OFF",
            "-DCMAKE_BUILD_TYPE=" .. (package:is_debug() and "Debug" or "Release")
        }
        import("package.tools.cmake").install(package, configs, {cmake_generator = "Ninja"})

        local bindir = package:installdir("bin")
        local validator = path.join(bindir, "glslangValidator" .. (is_host("windows") and ".exe" or ""))
        if not os.isfile(validator) then
            os.trycp(path.join(bindir, "glslang" .. (is_host("windows") and ".exe" or "")), validator)
        end
        package:addenv("PATH", "bin")
    end)

    on_test(function (package)
        os.vrunv(path.join(package:installdir("bin"), "glslangValidator" .. (is_host("windows") and ".exe" or "")), {"--version"})
    end)
