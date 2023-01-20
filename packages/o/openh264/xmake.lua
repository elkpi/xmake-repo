package("openh264")

    set_homepage("http://www.openh264.org/")
    set_description("OpenH264 is a codec library which supports H.264 encoding and decoding.")
    set_license("BSD-2-Clause")

    add_urls("https://github.com/cisco/openh264/archive/refs/tags/$(version).tar.gz")
    add_versions("v2.1.1", "af173e90fce65f80722fa894e1af0d6b07572292e76de7b65273df4c0a8be678")

    add_deps("meson", "ninja", "nasm")
    if is_plat("linux") then
        add_syslinks("pthread", "rt")
    end
    on_install("windows", "linux", function (package)
        import("package.tools.meson").build(package, {"-Dtests=disabled"}, {buildir = "out"})
        import("package.tools.ninja").install(package, {}, {buildir = "out"})
        if package:config("shared") then
            os.tryrm(path.join(package:installdir("lib"), "libopenh264.a"))
        else
            os.tryrm(path.join(package:installdir("lib"), "libopenh264.so*"))
            os.tryrm(path.join(package:installdir("lib"), "openh264.lib"))
            os.tryrm(path.join(package:installdir("bin"), "openh264-*.dll"))
        end
        if package:is_plat("windows") then
            os.trymv(path.join(package:installdir("lib"), "libopenh264.a"), path.join(package:installdir("lib"), "openh264.lib"))
        end
    end)

    on_install("android", function (package)
        local buildenvs = import("package.tools.autoconf").buildenvs(package)
        import("core.tool.toolchain")
        local ndk = toolchain.load("ndk", {plat = package:plat(), arch = package:arch()})
        local configs = {
            OS = "android",
            NDKROOT = ndk:config("ndk"),
            TARGET = "android-" .. ndk:config("ndk_sdkver"),
            NDK_TOOLCHAIN_VERSION = "clang",
            APP_STL = "c++_shared",
        }
        local target_arch = "arm"
        if package:is_arch("x86_64") then
            target_arch = "x86_64"
        elseif package:is_arch("x86") then
            target_arch = "x86"
        elseif package:is_arch("arm64-v8a") then
            target_arch = "arm64"
        end
        configs.ARCH = target_arch
        buildenvs.NDK_TOOLCHAIN_VERSION = "clang"
        buildenvs.APP_STL = configs.APP_STL
        print(configs)
        print(buildenvs)
        -- print("ndk_cxxstl: " ..ndk:config("ndk_cxxstl"))
        import("package.tools.make").build(package, configs, {envs = buildenvs})
    end)

    on_test(function (package)
        assert(package:has_cxxfuncs("WelsGetCodecVersion", {includes = "wels/codec_api.h"}))
    end)
