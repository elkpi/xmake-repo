package("ldns")
    set_homepage("https://nlnetlabs.nl/ldns")
    set_description("LDNS is a DNS library that facilitates DNS tool programming")

    add_urls("https://www.nlnetlabs.nl/downloads/ldns/ldns-$(version).tar.gz",
             "https://github.com/NLnetLabs/ldns/archive/refs/tags/$(version).tar.gz",
             "https://github.com/NLnetLabs/ldns.git")

    add_versions("1.8.3", "c3f72dd1036b2907e3a56e6acf9dfb2e551256b3c1bbd9787942deeeb70e7860")

    add_deps("autoconf", "automake", "libtool")
    add_deps("openssl")

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
        import("package.tools.autoconf").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("ldns_resolver_new", {includes = "ldns/ldns.h"}))
    end)
