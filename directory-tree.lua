tex = require "tex";

local directoryTree = { }

directoryTree.printNode = function (path,level)
  if not level then level = 0; end
  local attr, msg = lfs.attributes(path);
  if (not attr) and msg then
    print(msg);
  else
    if attr.mode == "directory" then
      label = path .. '/';
    else
      label = path;
    end
    label = label:gsub("_","\_");
    if level == 0 then
      tex.print("\\node{" .. label .. "}");
    else
      tex.print("child{ node{" .. label .. "}");
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
