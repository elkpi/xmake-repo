package("libvpx")

    set_homepage("https://github.com/webmproject/libvpx")
    set_description("Welcome to the WebM VP8/VP9 Codec SDK!.")
    set_license("BSD-3-Clause")

    add_urls("https://github.com/webmproject/libvpx.git", {alias = "github"})

    add_versions("github:v1.8.1", "8ae686757b708cd8df1d10c71586aff5355cfe1e")
    add_versions("github:v1.13.0", "d6eb9696aa72473c1a11d34d928d35a3acc0c9a9")
    add_deps("yasm", "libyuv")

    on_load("windows", "linux", "macosx", function (package)
    end)

    on_install(function (package)
        local configs = {
            "--enable-vp8", "--enable-vp9", "--enable-libyuv",
            "--disable-examples", "--disable-tools", "--disable-docs",
            "--disable-install-bins", "--disable-install-srcs",
            "--disable-unit-tests", "--disable-decode-perf-tests", "--disable-encode-perf-tests",
            "--size-limit=16384x16384", "--as=yasm"
        }

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

        import("package.tools.autoconf")
        local envs = autoconf.buildenvs(package)
        envs.ASFLAGS = {} -- remove -m64
        autoconf.install(package, configs, {envs = envs})
    end)

    on_test(function (package)
        assert(package:has_cxxincludes({"vpx/vpx_codec.h", "vpx/vpx_decoder.h", "vpx/vpx_encoder.h"}))
    end)
