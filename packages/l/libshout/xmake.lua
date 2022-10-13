package("libshout")
    set_homepage("https://icecast.org/")
    set_description("Library which can be used to write a source client like ices")

    add_urls("https://downloads.xiph.org/releases/libshout/libshout-$(version).tar.gz")

    add_versions("2.4.6", "39cbd4f0efdfddc9755d88217e47f8f2d7108fa767f9d58a2ba26a16d8f7c910")

    add_deps("autoconf", "automake", "libtool")
    add_deps("libogg")

    if is_plat("linux") then
        add_syslinks("pthread")
    end

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
        assert(package:has_cfuncs("shout_init", {includes = "shout/shout.h"}))
    end)
