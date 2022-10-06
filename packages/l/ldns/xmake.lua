package("ldns")
    set_homepage("https://nlnetlabs.nl/ldns")
    set_description("LDNS is a DNS library that facilitates DNS tool programming")

    add_urls("https://www.nlnetlabs.nl/downloads/ldns/ldns-$(version).tar.gz",
             "https://github.com/NLnetLabs/ldns/archive/refs/tags/$(version).tar.gz",
             "https://github.com/NLnetLabs/ldns.git")

    add_versions("1.8.3",  "c3f72dd1036b2907e3a56e6acf9dfb2e551256b3c1bbd9787942deeeb70e7860")
    add_versions("1.7.1",  "8ac84c16bdca60e710eea75782356f3ac3b55680d40e1530d7cea474ac208229")
    add_versions("1.6.17", "8b88e059452118e8949a2752a55ce59bc71fa5bc414103e17f5b6b06f9bcc8cd")

    add_deps("autoconf", "automake", "libtool")

    on_load(function (package)
        if package:version():lt("1.7") then
            package:add("deps", "openssl 1.0.2u")
        else
            package:add("deps", "openssl")
        end
    end)

    on_install(function (package)
        local configs = {}

        table.insert(configs, "--enable-shared=" .. (package:config("shared") and "yes" or "no"))
        if package:debug() then
            table.insert(configs, "--enable-debug")
        end
        if package:is_plat("linux") and package:config("pic") ~= false then
            table.insert(configs, "--with-pic")
        end

        local openssl_dir
        local openssl = package:dep("openssl"):fetch()
        if openssl then
            for _, linkdir in ipairs(openssl.linkdirs) do
                if path.filename(linkdir) == "lib" then
                    openssl_dir = path.directory(linkdir)
                    if openssl_dir then
                        table.insert(configs, "--with-ssl=" .. openssl_dir)
                        break
                    end
                end
            end
        end

	    os.vrunv("autoreconf", {"-fi"})
        if package:version():lt("1.7") then
            import("package.tools.autoconf").build(package, configs)
            import("package.tools.make").make(package, {"install-h", "install-lib"})
        else
            import("package.tools.autoconf").install(package, configs)
        end
    end)

    on_test(function (package)
        assert(package:has_cfuncs("ldns_resolver_new", {includes = "ldns/ldns.h"}))
    end)
