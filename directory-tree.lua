tex = require "tex";

local directoryTree = { }

directoryTree.label = function (attr, path)
  local label = "\\textit{WARNING: NO LABEL}";
  if attr.mode == "directory" then
    label = path .. '/';
  else
    label = path;
  end
  label = label:gsub("_","\_");
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
  if not level then level = 0; end
  local attr, msg = lfs.attributes(path);
  if (not attr) and msg then
    print(msg);
  else
    local label = directoryTree.label(attr, path);
    local style = directoryTree.style(attr, path);
    if level == 0 then
      tex.print("\\node[" .. style .. "] {" .. label .. "}");
    else
      tex.print("child{ node[" .. style .. "] {" .. label .. "}");
    end
    if attr.mode == "directory" then
      for entry in lfs.dir(path) do
        if entry ~= "." and entry ~= ".." then
          directoryTree.printNode(entry, level+1);
        end
      end
    end
    if level == 0 then
      tex.print(";");
    else
      tex.print("}");
    end
  end
end

return directoryTree;
