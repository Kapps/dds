module dds.ui.ViewWindow;
/+
import gtk.MainWindow;
import gtk.ScrolledWindow;
import gsv.SourceView;
import core.sys.windows.windows;
import gsv.SourceLanguageManager;
import gsv.SourceLanguage;
import gtk.Widget;
import pango.PgFontDescription;
import gtk.Style;
import gtk.StyleContext;
import std.stdio;
import gtk.RcStyle;
import gdk.RGBA;
import gdk.Color;
import dds.ui.SourcePad;
import ShardIO.FileInput;
import dds.source.SourceFile;
import dds.source.LanguageManager;
import dds.ui.SourcePadContainer;
import core.memory;
import dds.semantics.d.DLanguage;

/// Provides a window that's capable of storing views.
/// Each view can then further be separated into it's own ViewWindow as appropriate.
class ViewWindow : MainWindow {

	/// Creates a new ViewWindow with the given title.
	this(string title) {
		// TODO: Give it a view.
		super(title);
		this.setBorderWidth(5);
		add(createView());
		setDefaultSize(1280, 1024);
		createMenuItems();
		showAll();
	}

	private void createMenuItems() {
		//this.add
	}

	private Widget createView() {
		SourcePadContainer padContainer = new SourcePadContainer();
		padContainer.openFile(loadFile(`/Users/kapps/test.d`));
		//padContainer.openFile(loadFile(`C:\test2.cs`));
		return padContainer;
	}

	private SourceFile loadFile(string filePath) {
		//FileInput input = new FileInput(filePath);
		SourceFile file = new SourceFile(filePath);
		file.buffer.setText(cast(string)std.file.read(filePath));
		//SourceFile file = new SourceFile(std.path.baseName(filePath), input);
		file.language = new DLanguage();
		return file;
	}
}

+/