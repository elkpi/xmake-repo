package("ptlib")
    set_homepage("https:/www.gnugk.org")

    add_urls("https://github.com/willamowius/ptlib/archive/refs/tags/$(version).tar.gz", {
        version = function (version) return format("%s", version:gsub("%.", "_"):gsub("%-", "_"), version) end
    })

    add_versions("v2.10.9-6", "22653cbb7d94ceafea35a9eb0f8f96afe8f0ffc8cd4cb08ce00d6c62d5e11bb8")

    add_patches("v2.10.9-6", path.join(os.scriptdir(), "patches", "v2.10.9-6", "000-Makefile.in.patch"), "0d6e86ce708a28d5e708fac1516df039e897f4f369c6dd13568c67d8453afed0")

    add_deps("autoconf", "automake", "libtool")
    add_deps("openssl", "expat")

    on_install("linux", "macosx", "android", "iphoneos", "bsd", "cross", "mingw", function (package)
        local configs = {}
        table.insert(configs, "--enable-shared=" .. (package:config("shared") and "yes" or "no"))
        if package:debug() then
            table.insert(configs, "--enable-debug")
        end
        if package:is_plat("linux") and package:config("pic") ~= false then
            table.insert(configs, "--with-pic")
        end

        local openssl = package:dep("openssl")
        if openssl and not openssl:is_system() then
            local fetchinfo = openssl:fetch({external = false})
            if fetchinfo then
                local includedirs = fetchinfo.includedirs or fetchinfo.sysincludedirs
                if includedirs and #includedirs > 0 then
                    table.insert(configs, "OPENSSL_CFLAGS=-I" .. includedirs[1])
                end
                local linkdirs = fetchinfo.linkdirs
                if linkdirs and #linkdirs > 0 then
                    table.insert(configs, "OPENSSL_LIBS=-L" .. linkdirs[1])
                end
            end
        end

        local expat = package:dep("expat")
        if expat and not expat:is_system() then
            local fetchinfo = expat:fetch({external = false})
            if fetchinfo then
                local linkdirs = fetchinfo.linkdirs
                if linkdirs and #linkdirs > 0 then
                    table.insert(configs, "--with-expat-dir=" .. path.join(linkdirs[1], ".."))
                end
            end
        end

        import("package.tools.autoconf").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cxxincludes("ptlib.h"))
    end)
