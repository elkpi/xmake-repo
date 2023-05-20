set_project("pffft")

add_rules("mode.debug", "mode.release")

target("pffft")
    set_kind("static")
    add_files("src/pffft.c")
    add_cflags("-Wno-shadow")
    add_includedirs("src")
    on_load(function (target)
        if target:is_plat("windows") then
            target:add("defines", "_USE_MATH_DEFINES")
        end
    end)

