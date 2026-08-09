package("idl_elkpi")
    set_description("The idl_elkpi package")
    add_deps("protobuf-cpp")

    add_urls("git@code.elkpi.com:idl/services.git")

    set_policy("package.install_always", true)

    on_download(function (package, opt)
        import("devel.git")

        local sourcedir = opt.sourcedir
        local packagedir = path.join(sourcedir, package:name())
        local longpaths = package:policy("platform.longpaths")
        os.tryrm(sourcedir)
        os.mkdir(sourcedir)

        local commit = package:commit()
        if commit then
            git.clone(opt.url, {treeless = true, checkout = false, longpaths = longpaths, outputdir = packagedir})
            git.checkout(commit, {repodir = packagedir})
            if os.isfile(path.join(packagedir, ".gitmodules")) then
                git.submodule.update({init = true, recursive = true, longpaths = longpaths, repodir = packagedir})
            end
        else
            git.clone(opt.url, {depth = 1, recursive = true, shallow_submodules = true, longpaths = longpaths, branch = "main", outputdir = packagedir})
        end
    end)

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
