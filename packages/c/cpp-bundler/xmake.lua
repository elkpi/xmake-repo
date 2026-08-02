package("cpp-bundler")
    set_kind("binary")

    add_urls("git@code.elkpi.com:inf/cpp-bundler.git")

    on_install(function (package)
        import("core.base.option")
        os.vrunv("sh", {"./build.sh"})
        os.cp(path.join("output", "cpp-bundler"), package:installdir("bin"))
    end)

    on_test(function (package)
        -- cpp-bundler -h prints usage to stderr and (on older builds) exits 2
        -- via flag.ErrHelp; treat a runnable binary with usage output as pass.
        local stderr
        try
        {
            function()
                _, stderr = os.iorunv("cpp-bundler", {"-h"})
            end,
            catch
            {
                function(errors)
                    stderr = errors and (errors.stderr or errors.errors) or nil
                end
            }
        }
        assert(stderr and stderr:find("Usage", 1, true), "cpp-bundler -h produced no usage output")
    end)
