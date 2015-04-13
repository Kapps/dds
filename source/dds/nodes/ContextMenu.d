module dds.nodes.ContextMenu;
import dds.nodes.HierarchyNode;
import dlangui.core.events;
import dds.nodes.Solution;

/// A callback invoked to handle a context action.
alias ContextAction = void delegate(ContextNode, SolutionNode);

/// Represents a node that contains information about context menu based actions.
class ContextNode : HierarchyNode {

	/// Creates a ContextNode with the given name and icon.
	this(string name, Image icon, ContextAction action) {
		super(name, icon);
		this._action = action;
	}

	/// Gets or sets the accelerator key associated with this node.
	@property final Accelerator accelerator() const {
		return _accelerator;
	}
	/// Ditto
	@property final void accelerator(Accelerator val) {
		this._accelerator = val;
	}

	/// Gets the action associated with this node.
	@property final ContextAction action() {
		return _action;
	}

private:
	Accelerator _accelerator;
	ContextAction _action;
}

/// A context menu that allows selecting from a list of ContextNodes to execute on a SolutionNode.
final class ContextMenu {
	/// Gets the nodes contained within this collection.
	@property NodeCollection nodes() {
		return _nodes;
	}
private:
	NodeCollection _nodes;
}