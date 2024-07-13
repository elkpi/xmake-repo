package("idl_elkpi")
    set_description("The idl_elkpi package")
    add_deps("protobuf-cpp")

    add_urls("git@code.elkpi.com:idl/services.git")
    add_versions("main", "2c65526fc5f9277ce86ae53feda43ed10b2a6041")

    on_install(function (package)
        local configs = {}
        if package:config("shared") then
            configs.kind = "shared"
        end
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        -- TODO check includes and interfaces
        -- assert(package:has_cfuncs("foo", {includes = "foo.h"})
    end)
