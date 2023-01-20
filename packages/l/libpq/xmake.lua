package("libpq")
    set_homepage("https://www.postgresql.org/docs/14/libpq.html")
    set_description("Postgres C API library")
    set_license("PostgreSQL")

    add_urls("https://github.com/postgres/postgres/archive/refs/tags/REL_$(version).tar.gz", {alias = "github", version = function (version)
        return version:gsub("%.", "_")
    end})
    add_versions("14.1", "14809c9f669851ab89b344a50219e85b77f3e93d9df9e255b9781d8d60fcfbc9")
    add_versions("13.8", "12e37368e8f56efe4155a0152d8ed10bde898426d4a519bf0a83bbb2e4efd235")

    add_deps("krb5", "openssl")
    if is_plat("linux") then
        add_deps("flex", "bison")
    end
    if is_plat("android") then
        -- add_deps("zlib", {configs = {shared = true}})
    else
        add_deps("zlib")
    end

    on_install("macosx", "linux", "android", function (package)
        local configs = {"--with-openssl", "--without-readline"}
        table.insert(configs, "--enable-shared=" .. (package:config("shared") and "yes" or "no"))
        table.insert(configs, "--enable-static=" .. (package:config("shared") and "no" or "yes"))
        if package:is_plat("macosx") then
            table.insert(configs, "--with-gssapi")
        end
        if package:debug() then
            table.insert(configs, "--enable-debug")
        end
        if package:config("pic") ~= false then
            table.insert(configs, "--with-pic")
        end

        if package:version_str() == "13.8" then
            table.insert(configs, "LIBS=-lpthread -ldl")
        end

        import("package.tools.autoconf").install(package, configs, {packagedeps = {"openssl", "zlib"}})
    end)

    on_test(function (package)
        assert(package:has_cfuncs("PQconnectdb", {includes = "libpq-fe.h"}))
    end)
