package("protoc")
    set_kind("binary")
    set_homepage("https://developers.google.com/protocol-buffers/")
    set_description("Google's data interchange format compiler")

    on_load(function (package)
        if package:is_cross() then
            package:add("deps", "protobuf-cpp", {host = true, private = true})
        else
            package:add("deps", "protobuf-cpp")
        end
    end)

    on_install(function (package) end)

    on_test(function (package)
        if not package:is_cross() then
            os.vrun("protoc --version")
        end
    end)
