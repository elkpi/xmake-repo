package("srtp")
    set_homepage("https://github.com/cisco/libsrtp")
    set_description("Library for SRTP (Secure Realtime Transport Protocol)")

    add_urls("https://github.com/cisco/libsrtp/archive/refs/tags/$(version).tar.gz",
             "https://github.com/cisco/libsrtp.git")

    add_versions("v2.6", "f1886f72eff1d8aa82ada40b2fc3d342a3ecaf0f8988cb63d4af234fccf2253d")
    add_versions("v2.5.0", "8a43ef8e9ae2b665292591af62aa1a4ae41e468b6d98d8258f91478735da4e09")
    add_versions("v1.6.0", "1a3e7904354d55e45b3c5c024ec0eab1b8fa76fdbf4dd2ea2625dad2b3c6edde")

    add_configs("openssl", {description = "Enable OpenSSL crypto engine", default = true, type = "boolean"})
    add_configs("mbedtls", {description = "Enable MbedTLS crypto engine", default = false, type = "boolean"})
    add_configs("nss", {description = "Enable NSS crypto engine", default = false, type = "boolean"})
    add_configs("webrtc_dep_hdrs", {description = "Enable webrtc depend headers.", default = false, type = "boolean"})

    on_load(function (package)
        if package:config("openssl") then
            package:add("deps", "openssl")
        end
        if package:version():ge("2.0") then
            package:add("deps", "cmake");
        end
    end)

    on_install(function (package)
        local configs = {}
        local version = package:version()
        local enable_openssl = package:config("openssl")

        if version:ge("2.0") then
            configs =
            {
                "-DLIBSRTP_TEST_APPS=OFF",
                "-DTEST_APPS=OFF",
                "-DBUILD_WITH_WARNINGS=OFF",
                "-DENABLE_WARNINGS=OFF",
                "-DENABLE_WARNINGS_AS_ERRORS=OFF",
            }

            table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
            table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
            for name, enabled in pairs(package:configs()) do
                if not package:extraconf("configs", name, "builtin") then
                    table.insert(configs, "-DENABLE_" .. name:upper() .. "=" .. (enabled and "ON" or "OFF"))
                end
            end
            import("package.tools.cmake").install(package, configs)

            if package:config("webrtc_dep_hdrs") then
                os.cp(path.join("include", "srtp_priv.h"),  path.join(package:installdir("include"), "srtp2"))
                os.cp(path.join(package:buildir(), "config.h"),  path.join(package:installdir("include"), "srtp2"))
                os.cp(path.join("crypto", "include", "*"),  path.join(package:installdir("include"), "srtp2"))
            end
        else
            if package:config("openssl") then
                local openssl = package:dep("openssl"):fetch()
                if openssl then
                    for _, linkdir in ipairs(openssl.linkdirs) do
                        if path.filename(linkdir) == "lib" then
                            local openssl_dir = path.directory(linkdir)
                            if openssl_dir then
                                table.insert(configs, "--enable-openssl=" .. openssl_dir)
                                break
                            end
                        end
                    end
                end
            end
            import("package.tools.autoconf").install(package, configs)
        end
    end)

    on_test(function (package)
        local includes = {}
        if package:version():ge("2.0") then
            table.insert(includes,  "srtp2/srtp.h")
        else
            table.insert(includes,  "srtp/srtp.h")
        end
        assert(package:has_cfuncs("srtp_init", {includes = includes}))
    end)

