package("h323plus")
    set_homepage("https://www.h323plus.org")

    add_urls("https://github.com/willamowius/h323plus/archive/refs/tags/$(version).tar.gz", {
        version = function (version) return format("%s", version:gsub("%.", "_"), version) end
    })

    add_versions("v1.28.0", "cde10139eb3e5c725185ecec57da9d8fc98f4bdddec7786e1cace7de4ce1ac06")

    add_deps("autoconf", "automake", "libtool")
    add_deps("ptlib", "speex")

    on_install("linux", "macosx", "android", "iphoneos", "bsd", "cross", "mingw", function (package)
        local configs = {}
        table.insert(configs, "--enable-shared=" .. (package:config("shared") and "yes" or "no"))
        if package:debug() then
            table.insert(configs, "--enable-debug")
        end
        if package:is_plat("linux") and package:config("pic") ~= false then
            table.insert(configs, "--with-pic")
        end

        local ldflags = {}
        local ptlib = package:dep("ptlib")
        if ptlib and not ptlib:is_system() then
            local fetchinfo = ptlib:fetch({external = false})
            if fetchinfo then
                local linkdirs = fetchinfo.linkdirs
                if linkdirs and #linkdirs > 0 then
                    local ptlib_dir=path.join(linkdirs[1], "../")
                    table.insert(configs, "PTLIB_CONFIG=" .. path.join(ptlib_dir, "bin", "ptlib-config"))
                    table.insert(configs, "PTLIBDIR=" .. ptlib_dir)
                    table.insert(configs, "PTLIB_LIBS=" .. linkdirs[1])

                    for _, linkdir in ipairs(linkdirs) do
                        table.insert(ldflags, "-L" .. linkdir)
                    end
                end
            end
        end

        import("package.tools.autoconf").install(package, configs, {ldflags = ldflags})
    end)

    on_test(function (package)
        -- assert(package:has_cxxincludes("ptlib.h"))
    end)
