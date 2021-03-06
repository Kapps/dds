﻿module dds.nodes.NodeTemplate;
import dds.nodes.HierarchyNode;
import vibe.core.stream;

/// Provides a base template representing a potential file to be created for a HierarchyNode.
/// One example is new source file templates to add to a project.
abstract class NodeTemplate : HierarchyNode {
	this(string description, string name, Image icon) {
		super(name, icon);
		this._description = description;
	}

	/// Writes the resulting file that should be generated from this template to the given stream.
	/// If any additional variables are allowed, they are included in `variables`.
	/// One variable that is always present is the name property, which is the file name (with extension).
	abstract HierarchyNode generateResult(HierarchyNode parent, string[string] variables, OutputStream stream);

	/// Returns a description of the template generated by this node.
	@property final string description() const {
		return _description;
	}

private:
	string _description;
}