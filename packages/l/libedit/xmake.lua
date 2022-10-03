package("libedit")

    set_homepage("https://www.thrysoee.dk/editline/")
    set_description("BSD editline and history libraries")

    add_urls("https://www.thrysoee.dk/editline/libedit-$(version).tar.gz")
    add_versions("20210910-3.1", "6792a6a992050762edcca28ff3318cdb7de37dccf7bc30db59fcd7017eed13c5")

    add_deps("autoconf", "automake", "libtool")
    add_deps("ncurses")

    on_install(function (package)
        local configs = {}
        local cflags = {}
        local ldflags = {}

        table.insert(configs, "--enable-shared=" .. (package:config("shared") and "yes" or "no"))
        table.insert(configs, "--enable-static=" .. (package:config("shared") and "no" or "yes"))
        if package:debug() then
            table.insert(configs, "--enable-debug")
        end
        if package:config("pic") ~= false then
            table.insert(configs, "--with-pic")
        end
        
        for _, dep in ipairs(package:orderdeps()) do
            local fetchinfo = dep:fetch()
            if fetchinfo then
                for _, includedir in ipairs(fetchinfo.includedirs or fetchinfo.sysincludedirs) do
                    table.insert(cflags, "-I" .. includedir)
                end
                for _, linkdir in ipairs(fetchinfo.linkdirs) do
                    table.insert(ldflags, "-L" .. linkdir)
                end
                for _, link in ipairs(fetchinfo.links) do
                    table.insert(ldflags, "-l" .. link)
                end
            end
        end

        import("package.tools.autoconf").install(package, configs, {cflags = cflags, ldflags = ldflags})
    end)

    on_test(function (package)
        assert(package:has_cfuncs("el_init", {includes = "histedit.h"}))
    end)
