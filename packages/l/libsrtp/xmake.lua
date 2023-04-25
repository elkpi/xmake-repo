package("libsrtp")
    set_homepage("https://github.com/cisco/libsrtp")
    set_description("Library for SRTP (Secure Realtime Transport Protocol) ")

    add_urls("https://github.com/cisco/libsrtp/archive/refs/tags/$(version).tar.gz",
             "https://github.com/cisco/libsrtp.git")
    add_versions("v2.5.0", "8a43ef8e9ae2b665292591af62aa1a4ae41e468b6d98d8258f91478735da4e09")
    add_versions("v1.6.0", "1a3e7904354d55e45b3c5c024ec0eab1b8fa76fdbf4dd2ea2625dad2b3c6edde")

    on_install(function (package)
        local configs = {}
        local version = package:version()

        if version:ge("2.0") then
            package:add("deps", "cmake");

            table.insert(configs, "-DTEST_APPS=OFF")
            table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
            table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
            import("package.tools.cmake").install(package, configs)
        else
            package:add("deps", "autoconf", "automake", "libtool");

            table.insert(configs, "--enable-shared=" .. (package:config("shared") and "yes" or "no"))
            table.insert(configs, "--enable-static=" .. (package:config("shared") and "no" or "yes"))
            if package:config("pic") ~= false then
                table.insert(configs, "--with-pic")
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
