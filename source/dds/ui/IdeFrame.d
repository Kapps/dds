module dds.ui.IdeFrame;
import dlangui.platforms.common.platform;
import dlangui.widgets.appframe;
import dlangui.widgets.tabs;
import dlangui.widgets.styles;
import dlangui.widgets.docks;
import dlangui.widgets.widget;

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

		auto widg = new TabWidget("tabSourceFiles");
		widg.hiddenTabsVisibility = Visibility.Gone;
		widg.setStyles(STYLE_DOCK_HOST_BODY, STYLE_TAB_UP_DARK, STYLE_TAB_UP_BUTTON_DARK, STYLE_TAB_UP_BUTTON_DARK_TEXT);

		_dockHost.bodyWidget = widg;

		return _dockHost;
	}

private:
	DockHost _dockHost;
}