# How to modify and run the project

1. Choose your branch (do not touch `master`) eg. `git checkout -b feature-name`
2. install less `npm install -g less` and run `npm install -g less-watch-compiler` if you want watches folders(and subfolders)for file changes and automatically compile the less css files into css.
3. cd `static` folder and run `less-watch-compiler less css`

   - syntax: `less-watch-compiler [options] <source_dir> <destination_dir>`

4. Install elm
5. Run `elm make src/Main.elm --output dist/Main.js` ( run it also for every new change in `Main.elm` )
6. Run the server with `elm reactor`. Otherwise ff you are linux using python2 run `python -m SimpleHTTPServer` under the root folder then go on `http://localhost:8000/src/` after you have compiled less in css.

7. tips: use grep! eg. `history | grep elm`

[live here!](http://localhost:8000/src/)

## Resources and references

- [Command Line Usage](http://lesscss.org/usage/)
- [Less Official Documentation](http://lesscss.org/)
- [less-watch-compiler](https://www.npmjs.com/package/less-watch-compiler)
