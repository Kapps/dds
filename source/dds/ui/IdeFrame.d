module dds.ui.IdeFrame;
import dlangui.platforms.common.platform;
import dlangui.widgets.appframe;
import dlangui.widgets.tabs;
import dlangui.widgets.styles;
import dlangui.widgets.docks;
import dlangui.widgets.widget;
import dds.ui.EditWindow;
import dds.ui.SourceWindow;
import std.stdio;
import std.conv;

/// The main frame for the IDE.
class IdeFrame : AppFrame {
	this() {

	}

	override protected void init() {
		this._appName = "ShardStudio";
		super.init();
	}

	override protected Widget createBody() {
		this._dockHost = new DockHost();
		auto sln = new Solution(`F:\dev\src\dds\`, "dds", null);
		auto proj = new Project(`F:\dev\src\dds\`, "dds", "sdproj", null);
		sln.children.add(proj);
		auto nodeFile = proj.children.add(new ContainerNode("source", null)).add(new ContainerNode("dds", null)).add(new ContainerNode("nodes", null)).add(new DiskFileNode("HierarchyNode", "d", null));
		writeln(nodeFile.qualifiedName);
		auto widg = new TabWidget("tabSourceFiles");
		widg.hiddenTabsVisibility = Visibility.Gone;
		widg.setStyles(STYLE_DOCK_HOST_BODY, STYLE_TAB_UP_DARK, STYLE_TAB_UP_BUTTON_DARK, STYLE_TAB_UP_BUTTON_DARK_TEXT);
		auto tw = new SourceWindow(nodeFile);
		widg.addTab(tw.widget, tw.node.name.dtext, null, true);
		size_t idx = widg.tabIndex(tw.node.qualifiedName);
		writeln(idx);
		auto tab = widg.tab(tw.node.qualifiedName);
		writeln(tab);
		widg.selectTab(tw.node.qualifiedName);
		writeln("selected");
		_dockHost.bodyWidget = widg;

		return _dockHost;
	}

private:
	DockHost _dockHost;
}