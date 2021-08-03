# love2d-save-load-demo

##SUMMARY
Seeds decide which random values you generate, and this can be used to share a randomly generated level for example. We can also use LÖVE's math module. When removing items from a list we should loop through the table in reverse to prevent items from being skipped. We can create a save file by adding important data to a table, then turn that table into a string and write that string to a file with love.filesystem.write(filename). We can load a save file by reading the file with love.filesystem.read(filename), deserializing the data and applying the data to our objects. We can remove a file with love.filesystem.remove(filename) and restart the game with love.event.quit("restart").
