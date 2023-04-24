package("libsrtp")
    set_homepage("https://github.com/cisco/libsrtp")
    set_description("Library for SRTP (Secure Realtime Transport Protocol) ")

    add_urls("https://github.com/cisco/libsrtp/archive/refs/tags/$(version).tar.gz",
             "https://github.com/cisco/libsrtp.git")
    add_versions("v2.5.0", "8a43ef8e9ae2b665292591af62aa1a4ae41e468b6d98d8258f91478735da4e09")

    add_deps("cmake")

    on_install(function (package)
        local configs = {}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        import("package.tools.cmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("srtp_init", {includes = "srtp2/srtp.h"}))
    end)
