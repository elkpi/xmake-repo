package("libks")
    set_homepage("https://github.com/signalwire/libks")
    set_description("Foundational support for signalwire C products")

    add_urls("https://github.com/signalwire/libks.git")

    add_versions("v2.0.2", "423c68c92d1871e2c9cb83d974eac7830ddcdcf5")
    add_versions("v1.8.3", "607b4b34251400d9531e02a6612c32d2ab66ca95")
    add_versions("v1.8.0", "bccc2f394855500c8f6f488b441d6fb94343491b")

    add_patches("v2.0.2", path.join(os.scriptdir(), "patches", "v2.0.2", "cmake.patch"), "a4387b707d32b8ba6976ab626fa983ef03bfa8d54885cdbffc2d70970a0c17ef")
    add_patches("v1.8.3", path.join(os.scriptdir(), "patches", "v1.8.3", "cmake.patch"), "a3a4c0614d2fb74a92a87eb46bc2a31fe73f98a2a59b2cc8bf9f917b98415a8b")
    add_patches("v1.8.0", path.join(os.scriptdir(), "patches", "v1.8.0", "cmake.patch"), "8a7021401aa25af82623a455331ee48de6b90bb2fad6611fb7ee17a51a593e20")

    add_deps("cmake")
    add_deps("pkg-config")
    add_deps("libuuid", "openssl")

    on_load(function (package)
        if package:version():major() == 2 then
            package:add("includedirs", "include/libks2")
        end
    end)

    on_install(function (package)
        import("package.tools.cmake")

        local configs = {}
        local cflags = {}
        
        for _, dep in ipairs(package:orderdeps()) do
            local fetchinfo = dep:fetch()
            if fetchinfo then
                for _, includedir in ipairs(fetchinfo.includedirs or fetchinfo.sysincludedirs) do
                    table.insert(cflags, "-I" .. includedir)
                end
            end
        end

        if package:is_plat("cross") then
            import("core.tool.toolchain")
            local cross = toolchain.load("cross")
            local dir = path.join(cross:sdkdir(), cross:cross():sub(1, string.len(cross:cross()) - 1))
            table.insert(configs, "-DLIBM_INCLUDE_DIRS=" .. path.join(dir, "include"))
            table.insert(configs, "-DLIBM_LIBRARIES="..  path.join(dir, "lib", "libm.a"))
        end
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
