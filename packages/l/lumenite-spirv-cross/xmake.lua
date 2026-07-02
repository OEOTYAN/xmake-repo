-- repo: https://github.com/KhronosGroup/SPIRV-Cross
package("lumenite-spirv-cross")
    set_homepage("https://github.com/KhronosGroup/SPIRV-Cross")
    set_description("Pinned SPIRV-Cross libraries for Lumenite shader translation.")
    set_license("Apache-2.0")

    add_urls("https://github.com/KhronosGroup/SPIRV-Cross.git")
    add_versions("1.4.350+19", "146679ff8255a6068518685599d7fb8761d1b570")
    add_versions("1.4.350+1", "1a6169566c73d3da552748fc372fe2bbb856e46e")

    add_deps("cmake", "ninja")

    if is_plat("windows") then
        set_policy("platform.longpaths", true)
    end

    on_load(function (package)
        package:set("kind", "library")
        package:add("links", "spirv-cross-hlsl", "spirv-cross-glsl", "spirv-cross-cpp", "spirv-cross-reflect", "spirv-cross-msl", "spirv-cross-util", "spirv-cross-core")
    end)

    on_install("windows", "linux", "macosx", "mingw", function (package)
        local configs = {
            "-DSPIRV_CROSS_CLI=ON",
            "-DSPIRV_CROSS_ENABLE_TESTS=OFF",
            "-DSPIRV_CROSS_SHARED=OFF",
            "-DSPIRV_CROSS_EXCEPTIONS_TO_ASSERTIONS=OFF",
            "-DCMAKE_BUILD_TYPE=" .. (package:is_debug() and "Debug" or "Release")
        }
        local cxflags = {}
        if package:is_plat("windows") and package:has_tool("cxx", "cl", "clang_cl") then
            table.insert(cxflags, "/EHsc")
        end
        import("package.tools.cmake").install(package, configs, {cxflags = cxflags, cmake_generator = "Ninja"})
        package:addenv("PATH", "bin")
    end)

    on_test(function (package)
        os.vrunv(path.join(package:installdir("bin"), "spirv-cross" .. (is_host("windows") and ".exe" or "")), {"--help"})
    end)
