package("speex")
    set_homepage("https://www.speex.org/")
    set_description("Speex voice codec mirror - THIS IS A MIRROR, DEVELOPMENT HAPPENS AT https://gitlab.xiph.org/xiph/speex")

    add_urls("https://github.com/xiph/speex/archive/refs/tags/Speex-$(version).tar.gz", {alias = "github"})
    add_urls("https://github.com/xiph/speex.git", {alias = "git"})

    add_versions("github:1.2.1", "beaf2642e81a822eaade4d9ebf92e1678f301abfc74a29159c4e721ee70fdce0")
    add_versions("git:1.2.1", "Speex-1.2.1")

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
        assert(package:has_cfuncs("speex_encoder_init", {includes = "speex/speex.h"}))
    end)
