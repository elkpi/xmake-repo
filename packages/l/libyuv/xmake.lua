package("libyuv")

    set_homepage("https://chromium.googlesource.com/libyuv/libyuv/")
    set_description("libyuv is an open source project that includes YUV scaling and conversion functionality.")
    set_license("BSD-3-Clause")

    add_urls("https://code.elkpi.com/third_party/libyuv.git", {alias = "elkpi"})
    add_urls("https://chromium.googlesource.com/libyuv/libyuv.git", {alias = "chromium"})
    add_urls("https://github.com/lemenkov/libyuv.git", {alias = "github"})

    add_versions("elkpi:2023.05.27", "dfee0d31e055b6a5d6b3fb26e861735d1b518c82")
    add_versions("chromium:2023.04.22", "6f4731cdbc7e8b3fae163256dd8a2437508264d4")
    add_versions("github:2023.04.22", "6900494d90ae095d44405cd4cc3f346971fa69c9")

    add_configs("shared", {description = "Build shared library.", default = false, type = "boolean", readonly = true})

    add_deps("cmake", "libjpeg-turbo")

    on_load("windows", "linux", "macosx", function (package)
    end)

    on_install("windows", "linux", "macosx", function (package)
        local configs = {}
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        import("package.tools.cmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cincludes({"libyuv.h"}))
        assert(package:has_cxxincludes({"libyuv.h"}))
    end)
