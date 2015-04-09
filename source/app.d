module app;

import std.experimental.logger;
import dlangui.core.logger;
import dlangui.platforms.common.platform;
import dlangui.core.files;
import dds.ui.IdeFrame;

mixin APP_ENTRY_POINT;

extern(C) int UIAppMain(string[] args) {
	string[] resourceDirs = [
		appendPath(exePath, "res/")
	];
	Platform.instance.resourceDirs = resourceDirs;
	Platform.instance.uiLanguage = "en";
	Platform.instance.uiTheme = "theme_default";
	Window window = Platform.instance.createWindow("ShardStudio", null);
	auto frame = new IdeFrame();
	window.mainWidget = frame;
	window.show();
	return Platform.instance.enterMessageLoop();
}