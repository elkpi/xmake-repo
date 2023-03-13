package("sofia-sip")
    set_homepage("https://github.com/freeswitch/sofia-sip")
    set_description("Sofia-SIP is an open-source SIP User-Agent library, compliant with the IETF RFC3261 specification.")
    set_license("LGPL-2.1")

    add_urls("https://github.com/freeswitch/sofia-sip/archive/refs/tags/$(version).tar.gz",
             "https://github.com/freeswitch/sofia-sip.git")

    add_versions("v1.13.14", "a517e31c6a406af3d7ec8cb0154e46ad12fbcb54dadfc3deada5d97bdbd9cc5a")
    add_versions("v1.13.9",  "3e7bfe9345e7d196bb13cf2c6e758cec8d959f1b9dbbb3bd5459b004f6f65c6c")

    add_includedirs("include", "include/sofia-sip-1.13")

    add_deps("autoconf", "automake", "libtool")
    add_deps("openssl")
    if is_plat("android") then
        add_syslinks("z")
        add_patches("v1.13.9", path.join(os.scriptdir(), "patches", "v1.13.9", "android-ndk-r25b-compile.patch"), "f1ddf591da1a6fa3583ca577f20dc40043e3e3768584c5b1160d0a396415343e")
    else
        add_deps("zlib")
    end

    on_install(function (package)
        local configs = {}

        table.insert(configs, "--enable-shared=" .. (package:config("shared") and "yes" or "no"))
        if package:debug() then
            table.insert(configs, "--enable-debug")
        end
        if package:is_plat("linux") and package:config("pic") ~= false then
            table.insert(configs, "--with-pic")
        end

        local buildenvs = import("package.tools.autoconf").buildenvs(package)
        print(buildenvs)
        if is_plat("android") then
            import("core.tool.toolchain")
            local ndk = toolchain.load("ndk", {plat = package:plat(), arch = package:arch()})
            local bin = ndk:bindir()
            local sysroot  = path.join(path.directory(bin), "sysroot")
            table.insert(configs, "--with-sysroot=" .. sysroot)
            buildenvs.LDFLAGS = buildenvs.LDFLAGS .. " -L" .. sysroot .. "/usr/lib/arm-linux-androideabi"

            print("cflags: ")
            print(ndk:get("cflags"))
            print("cxxflags: ")
            print(ndk:get("cxxflags"))
            print("cppflags: ")
            print(ndk:get("cppflags"))
            print("ldflags: ")
            print(ndk:get("ldflags"))
            print("shflags: ")
            print(ndk:get("shflags"))

            buildenvs.LDFLAGS = nil
            buildenvs.CPPFLAGS = buildenvs.CXXFLAGS
        else
            table.insert(configs, "LIBS=-lpthread -ldl")
        end
        import("package.tools.autoconf").install(package, configs, {envs = buildenvs})
    end)

    on_test(function (package)
        assert(package:has_cfuncs("nua_create", {includes = "sofia-sip-1.13/sofia-sip/nua.h"}))
    end)
