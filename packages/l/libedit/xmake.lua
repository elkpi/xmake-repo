package("libedit")

    set_homepage("https://www.thrysoee.dk/editline/")
    set_description("BSD editline and history libraries")

    add_urls("https://www.thrysoee.dk/editline/libedit-$(version).tar.gz")

    add_versions("20250104-3.1", "23792701694550a53720630cd1cd6167101b5773adddcb4104f7345b73a568ac")
    add_versions("20240808-3.1", "5f0573349d77c4a48967191cdd6634dd7aa5f6398c6a57fe037cc02696d6099f")
    add_versions("20230828-3.1", "4ee8182b6e569290e7d1f44f0f78dac8716b35f656b76528f699c69c98814dad")
    add_versions("20210910-3.1", "6792a6a992050762edcca28ff3318cdb7de37dccf7bc30db59fcd7017eed13c5")

    add_deps("autoconf", "automake", "libtool")
    add_deps("ncurses", {configs = {widec = false}})

    add_includedirs("include", "include/editline")

    on_install(function (package)
        local configs = {"--disable-examples"}
        local cxflags = {}
        local ldflags = {}

        table.insert(configs, "--enable-shared=" .. (package:config("shared") and "yes" or "no"))
        table.insert(configs, "--enable-static=" .. (package:config("shared") and "no" or "yes"))
        if package:debug() then
            table.insert(configs, "--enable-debug")
        end
        if package:config("pic") ~= false then
            table.insert(configs, "--with-pic")
        end

        if package:is_plat("cross") then
            for _, dep in ipairs(package:orderdeps()) do
                local fetchinfo = dep:fetch()
                if fetchinfo then
                    for _, includedir in ipairs(fetchinfo.includedirs or fetchinfo.sysincludedirs) do
                        table.insert(cxflags, "-I" .. includedir)
                    end
                    for _, linkdir in ipairs(fetchinfo.linkdirs) do
                        table.insert(ldflags, "-L" .. linkdir)
                    end
                end
            end
        end

        import("package.tools.autoconf").install(package, configs, {cxflags = cxflags, ldflags = ldflags})
    end)

    on_test(function (package)
        assert(package:has_cfuncs("el_init", {includes = "histedit.h"}))
    end)
