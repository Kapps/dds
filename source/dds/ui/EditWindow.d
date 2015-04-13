module dds.ui.EditWindow;
public import dds.nodes.Solution;
public import dlangui.widgets.widget;

/// The base class for a window that can be used to edit or view a file.
class EditWindow {

	// TODO: EditWindow should not rely on FileNode; you should be able to do things like open a Window containing a View of another File.
	// For example, open a module and edit a single class within it.
	// And then should be able to do things like show imports in grey at the top, or definitions (di file?) for everything besides the class.

	/// Creates an EditWindow for the given node.
	this(FileNode node) {
		this._node = node;
		this._widget = createBody();
	}

	/// Returns the node that this window is operating on.
	@property final FileNode node() {
		return _node;
	}

	/// Returns the main widget that is used by this EditWindow.
	@property Widget widget() {
		return _widget;
	}

protected:

	/// Override to create the body of this window containing the main editing area.
	abstract Widget createBody();

private:
	FileNode _node;
	Widget _widget;
}

