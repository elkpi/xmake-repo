package("vertc-token")
    set_kind("library")
    set_homepage("https://www.volcengine.com/docs/6348/70121")
    set_description("Volcengine Real Time Communication RTC-TOKEN")

    add_urls("https://portal.volccdn.com/obj/volcfe/cloud-universal-doc/upload_$(version).zip", {version = function (version)
        if version:ge("2023.07.20") then
            return "ccae25c6c1d359ee6c0645aaad3bdf8a"
        end
    end})
    add_versions("2023.07.20", "189dd3a7626b33d678dbbc994918b5412bb2bd9e88c83102622560e8ff9966d8")

    add_deps("openssl")

    on_install(function (package)
        io.writefile("xmake.lua", [[
            includes("@builtin/check")
            add_rules("mode.debug", "mode.release")
            target("vertc-token")
                set_kind("$(kind)")
                add_files("cpp/src/Packer.cpp")
                add_headerfiles("cpp/src/*.h")
        ]])
        import("package.tools.xmake").install(package)
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
#include <AccessToken.h>
        ]]}, {configs = {languages = "cxx11"}}))
    end)
