package("idl_elkpi")
    set_description("The idl_elkpi package")
    add_deps("protobuf-cpp", "protoc")

    add_urls("git@code.elkpi.com:idl/services.git")
    add_versions("main", "dd939014854dadc3f3ce50bd4fc8c353e0290575")

    on_install(function (package)
        local configs = {}
        if package:config("shared") then
            configs.kind = "shared"
        end
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cxxincludes("base/base.pb.h", {configs = {languages = "c++17"}}))
    end)
