tex = require "tex";

function _print(...)
  tex.print(...);
  --print(...);
end

local directoryTree = {
  exclude = "^%.%l";
}

directoryTree.label = function (attr, path)
  local label = "\\textit{WARNING: NO LABEL}";
  label = path:gsub(".*/","");
  if attr.mode == "directory" then
    label = label .. '/';
  end
  label = label:gsub("_","\\_");
  return label;
end

directoryTree.style = function (attr, path)
  local style = "";
  if attr.mode == "directory" then
    style = "directory";
  else
    style = "file";
  end
  return style;
end

directoryTree.printNode = function (path,level)
  local node_cnt = 0;
  if not level then level = 0; end
  local attr, msg = lfs.attributes(path);
  if (not attr) and msg then
    tex.error(msg);
  else
    local label = directoryTree.label(attr, path);
    local style = directoryTree.style(attr, path);
    if label:find(directoryTree.exclude) then
      return node_cnt;
    end
    if level == 0 then
      _print("\\node[" .. style .. "] {" .. label .. "}");
    else
      _print("child{ node[" .. style .. "] {" .. label .. "}");
    end
    if attr.mode == "directory" then
      for entry in lfs.dir(path) do
        if entry ~= "." and entry ~= ".." then
          node_cnt = node_cnt + directoryTree.printNode(path .. '/' .. entry, level+1);
        end
      end
    end
    if level == 0 then
      _print(";");
    else
      _print("}");
      for _=1,node_cnt do
        _print("child[missing] {}");
      end
    end
  end
  return node_cnt+1;
end

return directoryTree;
