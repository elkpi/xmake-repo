package("libvpx")

    set_homepage("https://github.com/webmproject/libvpx")
    set_description("Welcome to the WebM VP8/VP9 Codec SDK!.")
    set_license("BSD-3-Clause")

    add_urls("https://github.com/webmproject/libvpx.git", {alias = "github"})

    add_versions("github:v1.8.1", "8ae686757b708cd8df1d10c71586aff5355cfe1e")
    add_versions("github:v1.13.0", "d6eb9696aa72473c1a11d34d928d35a3acc0c9a9")
    add_deps("nasm", "libyuv")

    on_load("windows", "linux", "macosx", function (package)
    end)

    on_install(function (package)
        local configs = {
            "--enable-vp8", "--enable-vp9", "--enable-libyuv", "--enable-pic",
            "--disable-examples", "--disable-tools", "--disable-docs",
            "--disable-install-bins", "--disable-install-srcs",
            "--size-limit=16384x16384"
        }
        local cflags = {}
        local ldflags = {}

        if package:config("shared") then
            table.insert(configs, "--enable-shared")
        else
            table.insert(configs, "--enable-static")
        end
        if package:debug() then
            table.insert(configs, "--enable-debug")
        end
        if package:config("pic") ~= false then
            table.insert(configs, "--enable-pic")
        end

        table.insert(configs, "--target=x86_64-linux-gcc")

        import("package.tools.autoconf").install(package, configs, {cflags = cflags, ldflags = ldflags})
    end)

    on_test(function (package)
        assert(package:has_cxxincludes({"vpx/vpx_codec.h", "vpx/vpx_decoder.h", "vpx/vpx_encoder.h"}))
    end)
