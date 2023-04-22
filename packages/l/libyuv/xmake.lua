package("libyuv")

    set_homepage("https://chromium.googlesource.com/libyuv/libyuv/")
    set_description("libyuv is an open source project that includes YUV scaling and conversion functionality.")
    set_license("BSD-3-Clause")

    add_urls("https://chromium.googlesource.com/libyuv/libyuv.git", {alias = "chromium"})
    add_urls("https://github.com/lemenkov/libyuv.git",{alias = "github"})

    add_versions("chromium:2023.04.22", "6f4731cdbc7e8b3fae163256dd8a2437508264d4")
    add_versions("github:2023.04.22", "6900494d90ae095d44405cd4cc3f346971fa69c9")

    if is_plat("windows") then
        add_configs("shared", {description = "Build shared library.", default = false, type = "boolean", readonly = true})
    end

    add_deps("cmake", "libjpeg-turbo")

    on_load("windows", "linux", "macosx", function (package)
    end)

    on_install("windows", "linux", "macosx", function (package)
        import("package.tools.cmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cincludes({"libyuv.h"}))
        assert(package:has_cxxincludes({"libyuv.h"}))
    end)
