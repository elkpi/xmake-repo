package("rnnoise")
    set_homepage("https://github.com/xiph/rnnoise")
    set_description("Recurrent neural network for audio noise reduction")

    add_urls("https://github.com/xiph/rnnoise.git")
    add_versions("2021.01.22", "1cbdbcf1283499bbb2230a6b0f126eb9b236defd")

    add_deps("autoconf", "automake", "libtool")

    on_install(function (package)
        local configs = {}
        table.insert(configs, "--enable-shared=" .. (package:config("shared") and "yes" or "no"))
        if package:debug() then
            table.insert(configs, "--enable-debug")
        end
        import("package.tools.autoconf").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("foo", {includes = "foo.h"}))
    end)
