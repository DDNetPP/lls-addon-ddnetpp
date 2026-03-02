# lls-addon-ddnetpp

This is a [addon](https://github.com/LuaLS/luarocks-build-addon) for the [luals](https://github.com/luals/lua-language-server)
language server. It includes meta files with [LuaCATS](https://luals.github.io/wiki/annotations/) type annotations for the
[DDNet++ lua plugin api](https://github.com/DDNetPP/DDNetPP/blob/master/docs/lua_plugins.md)

![typehint preview](https://raw.githubusercontent.com/DDNetPP/cdn/refs/heads/master/typehints.gif)

## Quickstart

If you want to write a DDNet++ lua plugin and have proper type hints and autocompletion this is what you need.
You need lua, luarocks and an editor with language server support that has [luals](https://luals.github.io/#install) installed.


```
mkdir myplugin
cd myplugin
luarocks init
luarocks install lls-addon-ddnetpp
```

Thats it. You should now have type completions.
