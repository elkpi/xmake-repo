package("libks")
    set_homepage("https://github.com/signalwire/libks")
    set_description("Foundational support for signalwire C products")

    add_urls("https://github.com/signalwire/libks.git")
    add_versions("v1.8.0", "bccc2f394855500c8f6f488b441d6fb94343491b")
    add_patches("v1.8.0", path.join(os.scriptdir(), "patches", "v1.8.0", "cmake.patch"), "cff709c74e77c1a57694f856c327cc5b93896ea8e53c318d087b2a6f2c88a674")

    add_deps("cmake")
    add_deps("libuuid", "openssl")

    on_install(function (package)
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

        table.insert(configs, "-DCMAKE_C_FLAGS=" .. table.concat(cflags, " "))
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        table.insert(configs, "-DKS_STATIC=" .. (package:config("shared") and "OFF" or "ON"))
        import("package.tools.cmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("ks_init", {includes = "libks/ks.h"}))
    end)
