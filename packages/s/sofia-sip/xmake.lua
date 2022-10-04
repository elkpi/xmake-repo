package("sofia-sip")
    set_homepage("https://github.com/freeswitch/sofia-sip")
    set_description("Sofia-SIP is an open-source SIP User-Agent library, compliant with the IETF RFC3261 specification.")
    set_license("LGPL-2.1")

    add_urls("https://github.com/freeswitch/sofia-sip/archive/refs/tags/$(version).tar.gz",
             "https://github.com/freeswitch/sofia-sip.git")
    add_versions("v1.13.9", "3e7bfe9345e7d196bb13cf2c6e758cec8d959f1b9dbbb3bd5459b004f6f65c6c")

    add_includedirs("include", "include/sofia-sip-1.13")

    add_deps("autoconf", "automake", "libtool")
    add_deps("openssl", "zlib")
    add_syslinks("pthread", "dl")

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
        assert(package:has_cfuncs("nua_create", {includes = "sofia-sip-1.13/sofia-sip/nua.h"}))
    end)
