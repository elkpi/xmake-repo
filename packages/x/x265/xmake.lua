package("x265")

    set_homepage("http://x265.org")
    set_description("A free software library and application for encoding video streams into the H.265/MPEG-H HEVC compression format.")

    add_urls("https://github.com/videolan/x265/archive/$(version).tar.gz",
             "https://github.com/videolan/x265.git")

    add_versions("3.4", "544d147bf146f8994a7bf8521ed878c93067ea1c7c6e93ab602389be3117eaaf")

    add_patches("3.4", path.join(os.scriptdir(), "patches", "3.4", "android_cmake.patch"), "9ad6c4ca45a16a1e6db17048cc827c4ffcb8820c4cf136322722d277e1723120")

    add_deps("cmake", "nasm")

    if is_plat("macosx") then
        add_syslinks("c++")
    elseif is_plat("linux") then
        add_syslinks("pthread", "dl")
    end

    on_install("linux", "macosx", "android", "cross", function (package)
        local configs = {
            "../source",
        }
        if package:is_plat("android") then
            table.insert(configs, "-DNEON_ANDROID=1")
        else
            if package:is_arch("arm.*64.*") then
                table.insert(configs, "-DCROSS_COMPILE_ARM=1")
                table.insert(configs, "-DCMAKE_SYSTEM_PROCESSOR=aarch64")
            elseif package:is_arch("arm.*") then
                table.insert(configs, "-DCROSS_COMPILE_ARM=1")
                table.insert(configs, "-DCMAKE_SYSTEM_PROCESSOR=armv6l")
            end
        end
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        table.insert(configs, "-DENABLE_SHARED=" .. (package:config("shared") and "ON" or "OFF"))
        import("package.tools.cmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("x265_api_get", {includes = "x265.h"}))
    end)
