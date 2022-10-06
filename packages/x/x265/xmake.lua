package("x265")

    set_homepage("http://x265.org")
    set_description("A free software library and application for encoding video streams into the H.265/MPEG-H HEVC compression format.")

    add_urls("https://github.com/videolan/x265/archive/$(version).tar.gz",
             "https://github.com/videolan/x265.git")

    add_versions("3.4", "544d147bf146f8994a7bf8521ed878c93067ea1c7c6e93ab602389be3117eaaf")

    add_deps("cmake", "nasm")

    if is_plat("macosx") then
        add_syslinks("c++")
    elseif is_plat("linux") then
        add_syslinks("pthread", "dl")
    end

    on_install("linux", "macosx", function (package)
        os.cd("build/linux")
        os.vrunv("./multilib.sh", {}, {envs = { MAKEFLAGS="-j 6" }})
        import("package.tools.make").make(package, {"-C", "8bit", "install", "DESTDIR=./" })
        os.vrun("sed -i 's#^prefix=.*#prefix=" .. package:installdir() .. "#g' 8bit/usr/local/lib/pkgconfig/x265.pc")
        os.cp("8bit/usr/local/*", package:installdir())
    end)

    on_test(function (package)
        assert(package:has_cfuncs("x265_api_get", {includes = "x265.h"}))
    end)
