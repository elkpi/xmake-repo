package("speexdsp")
    set_homepage("https://speex.org")
    set_description("Speex audio processing library - THIS IS A MIRROR, DEVELOPMENT HAPPENS AT https://gitlab.xiph.org/xiph/speexdsp")

    add_urls("https://github.com/xiph/speexdsp/archive/refs/tags/$(version).tar.gz",
             "https://github.com/xiph/speexdsp.git")
    add_versions("SpeexDSP-1.2.1", "d17ca363654556a4ff1d02cc13d9eb1fc5a8642c90b40bd54ce266c3807b91a7")

    add_deps("autoconf", "automake", "libtool")

    on_install(function (package)
        local configs = {}
        table.insert(configs, "--enable-shared=" .. (package:config("shared") and "yes" or "no"))
        if package:debug() then
            table.insert(configs, "--enable-debug")
        end
        if package:is_plat("linux") and package:config("pic") ~= false then
            table.insert(configs, "--with-pic")
        end
        import("package.tools.autoconf").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("speex_resampler_process_int", {includes = "speex/speex_resampler.h"}))
    end)
