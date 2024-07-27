package("libyuv")
    set_homepage("https://chromium.googlesource.com/libyuv/libyuv/")
    set_description("libyuv is an open source project that includes YUV scaling and conversion functionality.")
    set_license("BSD-3-Clause")

    add_urls("https://code.elkpi.com/third_party/libyuv.git", {alias = "elkpi"})
    add_urls("https://chromium.googlesource.com/libyuv/libyuv.git", {alias = "chromium"})
    add_urls("https://github.com/lemenkov/libyuv.git", {alias = "github"})

    add_versions("elkpi:2023.11.10", "4aaf0f22fd75e21dbb344394185eab198237029d")
    add_versions("elkpi:2023.05.27", "dfee0d31e055b6a5d6b3fb26e861735d1b518c82")
    add_versions("chromium:2023.04.22", "6f4731cdbc7e8b3fae163256dd8a2437508264d4")
    add_versions("chromium:2023.10.27", "31e1d6f896615342d5d5b6bde8f7b50b3fd698dc")
    add_versions("github:2023.04.22", "6900494d90ae095d44405cd4cc3f346971fa69c9")

    add_configs("shared", {description = "Build shared library.", default = false, type = "boolean"})

    add_deps("cmake", "libjpeg-turbo")

    on_load("windows", "linux", "macosx", function (package)
    end)

    on_install("windows", "linux", "macosx", "android", "cross", "bsd", "mingw", function (package)
        local configs = {"-DTEST=OFF", "-DUNIT_TEST=OFF"}
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        io.replace("CMakeLists.txt", "INSTALL ( PROGRAMS ${CMAKE_BINARY_DIR}/yuvconvert			DESTINATION bin )", "", {plain = true})
        import("package.tools.cmake").install(package, configs)
        
        if package:is_plat("macosx", "linux", "android") then
            if package:config("shared") then 
                os.tryrm(package:installdir("lib", "*.a"))
            else 
                os.tryrm(package:installdir("lib", "*.so"))
            end
        end

        if package:config("shared") then
            package:add("defines", "LIBYUV_USING_SHARED_LIBRARY")
        end
    end)

    on_install("!cross", function (package)
        if package:is_plat("iphoneos") then
            io.replace("CMakeLists.txt",
                [[STRING(TOLOWER "${CMAKE_SYSTEM_PROCESSOR}" arch_lowercase)]],
                [[set(arch_lowercase "]] .. package:arch() .. [[")]], {plain = true})
        end

        local configs = {"-DCMAKE_CXX_STANDARD=14"}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:is_debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        table.insert(configs, "-DLIBYUV_WITH_JPEG=" .. (package:config("jpeg") and "ON" or "OFF"))
        table.insert(configs, "-DBUILD_TOOLS=" .. (package:config("tools") and "ON" or "OFF"))
        import("package.tools.cmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cincludes({"libyuv.h"}))
        assert(package:has_cxxincludes({"libyuv.h"}))
        assert(package:has_cfuncs("I420Rotate", {includes = "libyuv/rotate.h"}))
    end)
