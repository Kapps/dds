module dds.ui.SourceWindow;
import dds.ui.EditWindow;
import dlangui.widgets.srcedit;
import dlangui.widgets.widget;
import dlangui.widgets.editors;
import vibe.core.stream;
import vibe.stream.operations;
import std.conv;

/// An EditWindow that allows the user to edit source code with language selection determined by the file extension.
class SourceWindow : EditWindow {
	this(FileNode node) {
		super(node);
	}

	override Widget createBody() {
		auto res = new SourceEditor(node.qualifiedName);
		res.load("source/dds/nodes/HierarchyNode.d");
		auto stream = node.createInputStream();
		scope(exit) stream.finalize();
		string text = stream.readAllUTF8();
		res.text = text.dtext;
		return res;
	}
}

/// An EditBox extended to be used within a SourceWindow, integrating language provider information.
class SourceEditor : EditBox {
	this(string id) {
		super(id);
		this.minFontSize = 6;
		this.maxFontSize = 72;
		this.fontFamily = FontFamily.MonoSpace;
		this.fontFace = "Consolas,DejaVuSansMono,Lucida Sans Typewriter,Courier New,Lucida Console";
		this.layoutWidth = FILL_PARENT;
		this.layoutHeight = FILL_PARENT;
		this.showModificationMarks = true;
		this.showLineNumbers = true;
	}
}