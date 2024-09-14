package("protoc")

    set_kind("binary")
    set_homepage("https://developers.google.com/protocol-buffers/")
    set_description("Google's data interchange format compiler")

    if is_host("windows") then
        if is_arch("x64") then
            add_urls("https://github.com/protocolbuffers/protobuf/releases/download/v$(version)/protoc-$(version)-win64.zip")
            add_versions("3.8.0", "ac07cd66824f93026a796482dc85fa89deaf5be1b0e459de9100cff2992e6905")
        else
            add_urls("https://github.com/protocolbuffers/protobuf/releases/download/v$(version)/protoc-$(version)-win32.zip")
            add_versions("3.8.0", "93c5b7efe418b539896b2952ab005dd81fa418b76abee8c4341b4796b391999e")
        end
    elseif is_host("macosx") then
        if is_arch("x86_64") then
            add_urls("https://github.com/protocolbuffers/protobuf/releases/download/v$(version)/protoc-$(version)-osx-x86_64.zip")
            add_versions("3.8.0", "8093a79ca6f22bd9b178cc457a3cf44945c088f162e237b075584f6851ca316c")
        else
            add_urls("https://github.com/protocolbuffers/protobuf/releases/download/v$(version)/protoc-$(version)-osx-x86_32.zip")
            add_versions("3.8.0", "14376f58d19a7579c43ee95d9f87ed383391d695d4968107f02ed226c13448ae")
        end
    elseif is_host("linux") then
        if is_arch("x86_64") then
            add_urls("https://github.com/protocolbuffers/protobuf/releases/download/v$(version)/protoc-$(version)-linux-x86_64.zip")
            add_versions("3.19.4", "058d29255a08f8661c8096c92961f3676218704cbd516d3916ec468e139cbd87")
            add_versions("23.4", "0502f286ac9ed860b629a7965a14527b1f2dd131e4283fa23c2d7f184672aa9a")
        elseif is_arch("i386") then
            add_urls("https://github.com/protocolbuffers/protobuf/releases/download/v$(version)/protoc-$(version)-linux-x86_32.zip")
            add_versions("3.19.4", "06aff080f7c275f6cae3dabd54f7f819cbcc495d79f9d3c2d6c268991551342b")
            add_versions("23.4", "354a4b2bfd7a82dd813107ada8cc83e04f678691f436ae9e55924ced535bd32a")
        elseif is_arch("arm64*") then
            add_urls("https://github.com/protocolbuffers/protobuf/releases/download/v$(version)/protoc-$(version)-linux-aarch_64.zip")
            add_versions("3.19.4", "95584939e733bdd6ffb8245616b2071f565cd4c28163b6c21c8f936a9ee20861")
            add_versions("23.4", "1c7750b6e038305b5a7fc3d0cda1ebefdf106a4f30a787bf826ed2fc47c3967d")
        end
    else
        add_urls("https://github.com/protocolbuffers/protobuf/releases/download/v$(version)/protobuf-cpp-$(version).zip")
        add_versions("3.8.0", "91ea92a8c37825bd502d96af9054064694899c5c7ecea21b8d11b1b5e7e993b5")
    end

    on_install("@windows", "@msys", "@cygwin", "@macosx", "@linux", function (package)
        os.cp("bin", package:installdir())
        os.cp("include", package:installdir())
    end)

    -- on_install("@linux", function (package)
    --     import("package.tools.autoconf").install(package, {"--enable-shared=no", "--enable-static=no"})
    -- end)

    on_test(function (package)
        io.writefile("test.proto", [[
            syntax = "proto3";
            package test;
            message TestCase {
                string name = 4;
            }
            message Test {
                repeated TestCase case = 1;
            }
        ]])
        os.vrun("protoc test.proto --cpp_out=.")
    end)
