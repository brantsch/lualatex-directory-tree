tex = require "tex";
print = tex.print;

local directoryTree = { }

directoryTree.drawTree = function (dir)
  directoryTree.printNode(dir);
end

directoryTree.printNode = function (path,level)
  if not level then level = 0; end
  local attr = lfs.attributes(path);
  if attr.mode == "directory" then
    label = path .. '/';
  else
    label = path;
  end
  if level == 0 then
    print("\\node{" .. label .. "}");
  else
    print("child{ node{" .. label .. "}");
  end
  if attr.mode == "directory" then
    for entry in lfs.dir(path) do
      if entry ~= "." and entry ~= ".." then
        directoryTree.printNode(entry, level+1);
      end
    end
  end
  if level == 0 then
    print(";");
  else
    print("}");
  end
end

return directoryTree;
