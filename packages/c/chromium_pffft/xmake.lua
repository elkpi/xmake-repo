package("chromium_pffft")

    set_homepage("https://chromium.googlesource.com/chromium/src/third_party/+/refs/heads/main/pffft/")
    set_description("pffft from chromium")

    add_urls("https://code.elkpi.com/third_party/chromium_pffft.git")
    add_versions("2022.10.04", "6ef6aca60f33e7758d8c1c49c114d03265f50acc")

    add_configs("shared", {description = "Build shared library.", default = false, type = "boolean", readonly = true})

    if is_plat("linux") then
        add_syslinks("m")
    end

    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), ".")
        import("package.tools.xmake").install(package)
        os.cp(path.join("src", "pffft.h"), package:installdir("include"))
    end)

    on_test(function (package)
        assert(package:has_cfuncs("pffft_new_setup", {includes = "pffft.h"}))
    end)
