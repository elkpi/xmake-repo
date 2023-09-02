package("libks")
    set_homepage("https://github.com/signalwire/libks")
    set_description("Foundational support for signalwire C products")

    add_urls("https://github.com/signalwire/libks.git")
    add_versions("v1.8.3", "607b4b34251400d9531e02a6612c32d2ab66ca95")
    add_versions("v1.8.0", "bccc2f394855500c8f6f488b441d6fb94343491b")

    add_patches("v1.8.3", path.join(os.scriptdir(), "patches", "v1.8.3", "cmake.patch"), "a3a4c0614d2fb74a92a87eb46bc2a31fe73f98a2a59b2cc8bf9f917b98415a8b")
    add_patches("v1.8.0", path.join(os.scriptdir(), "patches", "v1.8.0", "cmake.patch"), "8a7021401aa25af82623a455331ee48de6b90bb2fad6611fb7ee17a51a593e20")

    add_deps("cmake")
    add_deps("pkg-config")
    add_deps("libuuid", "openssl")

    on_install(function (package)
        import("package.tools.cmake")

        local configs = {}
        local cflags = {}
        local PKG_CONFIG_PATH = {}
        
        for _, dep in ipairs(package:orderdeps()) do
            local fetchinfo = dep:fetch()
            if fetchinfo then
                for _, includedir in ipairs(fetchinfo.includedirs or fetchinfo.sysincludedirs) do
                    table.insert(cflags, "-I" .. includedir)
                end
            end
        end

        local envs = cmake.buildenvs(package)

        local libuuid = package:dep("libuuid"):fetch()
        if libuuid then
            for _, dir in ipairs(libuuid.linkdirs) do
                table.insert(PKG_CONFIG_PATH, path.join(dir, "pkgconfig"))
                table.insert(PKG_CONFIG_PATH, path.join(dir, "share", "pkgconfig"))
            end
        end

        envs.PKG_CONFIG_PATH = path.joinenv(table.join(PKG_CONFIG_PATH, envs.PKG_CONFIG_PATH))

        table.insert(configs, "-DCMAKE_C_FLAGS=" .. table.concat(cflags, " "))
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        table.insert(configs, "-DKS_STATIC=" .. (package:config("shared") and "OFF" or "ON"))
        if is_plat("android") then
            table.insert(configs, "-DWITH_KS_TEST=OFF")
            local openssl = package:dep("openssl"):fetch()
            if openssl then
                for _, includedir in ipairs(openssl.includedirs or openssl.sysincludedirs) do
                    table.insert(configs, "-DOPENSSL_INCLUDE_DIR=" .. includedir)
                    break
                end
                for _, libfile in ipairs(openssl.libfiles) do
                    if string.find(libfile, "libssl") then
                        table.insert(configs, "-DOPENSSL_SSL_LIBRARY=" .. libfile)
                    elseif  string.find(libfile, "libcrypto") then
                        table.insert(configs, "-DOPENSSL_CRYPTO_LIBRARY=" .. libfile)
                    end
                end
            end
        end
        cmake.install(package, configs, {envs = envs})
    end)

    on_test(function (package)
        assert(package:has_cfuncs("ks_init", {includes = "libks/ks.h"}))
    end)
