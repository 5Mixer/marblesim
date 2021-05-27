let debug = true;
let project = new Project('Marblerun');

project.addSources('Sources');
project.addLibrary('nape');
project.addLibrary('hxWebSockets');
project.addAssets('Assets')

if (!debug) {
    project.addLibrary('closure');
    project.addDefine('closure_overwrite')
    project.addParameter('-dce full');
    project.addDefine('NAPE_RELEASE_BUILD')
}

resolve(project);
