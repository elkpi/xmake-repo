package("libsv")
    set_homepage("https://github.com/uael/sv")
    set_description("libsv - Public domain cross-platform semantic versioning in c99")

    add_urls("https://github.com/uael/sv/archive/refs/tags/v$(version).tar.gz")
    add_urls("https://github.com/uael/sv.git", {alias = "git"})
    add_versions("1.2", "003ca74f3485fd1a4ab809413b1765b91d4314355d244264c98546ad2556cc99")
    add_versions("git:1.2", "v1.2")

    on_install(function (package)
        local configs = {}
        if package:config("shared") then
            configs.kind = "shared"
        end
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("semver(0,0)", {includes = "semver.h"}))
    end)
