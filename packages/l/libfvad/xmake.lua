package("libfvad")
    set_homepage("https://github.com/dpirch/libfvad")
    set_description("Voice activity detection (VAD) library, based on WebRTC's VAD engine")
    set_license("BSD-3-Clause")

    add_urls("https://github.com/dpirch/libfvad/archive/refs/tags/$(version).tar.gz",
             "https://github.com/dpirch/libfvad.git")

    add_versions("v1.0", "8c8a1e4911a454b1a8e3ed062abbce4865eea3fc794417e2c96373309174215c")

    add_deps("autoconf", "automake", "libtool")

    on_install(function (package)
        local configs = {}
        table.insert(configs, "--enable-shared=" .. (package:config("shared") and "yes" or "no"))
        if package:is_debug() then
            table.insert(configs, "--enable-debug")
        end
        import("package.tools.autoconf").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("fvad_new", {includes = "fvad.h"}))
    end)
