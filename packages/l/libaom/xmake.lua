package("libaom")
    set_homepage("https://github.com/elkpi/aom")
    set_description("AV1 Codec Library")

    add_urls("https://github.com/elkpi/aom/archive/refs/tags/$(version).tar.gz",
            "https://github.com/elkpi/aom.git")
    -- add_versions("2022.01.12", "402e264b94fd74bdf66837da216b6251805b4ae4")
    add_versions("v3.6.0", "2ba213822cb1528b5558d6727125654e14d1b2d7505bd1fc8afa36c2e9e9f94a")

    add_deps("cmake")

    on_install(function (package)
        local configs = {
            "-DENABLE_TESTDATA=OFF",
            "-DENABLE_TESTS=OFF",
            "-DENABLE_TOOLS=OFF",
            "-DENABLE_DOCS=OFF"
        }
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        import("package.tools.cmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("aom_codec_version", {includes = "aom/aom.h"}))
    end)
