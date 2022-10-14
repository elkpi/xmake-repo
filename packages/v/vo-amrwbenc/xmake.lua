package("vo-amrwbenc")
    set_homepage("https://opencore-amr.sourceforge.io")
    set_description("Library of VisualOn implementation of Adaptive Multi Rate Wideband (AMR-WB) encoder")

    add_urls("https://sourceforge.net/projects/opencore-amr/files/vo-amrwbenc/vo-amrwbenc-$(version).tar.gz")

    add_versions("0.1.3", "5652b391e0f0e296417b841b02987d3fd33e6c0af342c69542cbb016a71d9d4e")

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
        assert(package:has_cfuncs("E_IF_init", {includes = "vo-amrwbenc/enc_if.h"}))
    end)
