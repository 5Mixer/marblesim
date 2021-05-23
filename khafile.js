let debug = false;
let project = new Project('Marblerun');

project.addSources('Sources');
project.addLibrary('haxeui-core');
project.addLibrary('haxeui-kha');
project.addLibrary('nape');
project.addAssets('Assets')

if (!debug) {
    project.addLibrary('closure');
    project.addDefine('closure_overwrite')
    project.addParameter('-dce full');
    project.addDefine('NAPE_RELEASE_BUILD')
}

resolve(project);
