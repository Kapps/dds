module dds.nodes.Solution;

import std.algorithm;

import dds.nodes.HierarchyNode;
import dds.nodes.Project;
import dds.nodes.ContextMenu;

/// Represents a solution file, or workspace, within a hierarchy.
/// This is considered the root node within a hierarchy and must always exist when a hierarchy is used.
/// More technically, a Solution is simply a type of Project that contains other projects and solution files as its children.
class Solution : Project {

	/// Creates a new solution with the given name.
	this(string name, Image icon) {
		super(name, icon);
	}

	/// Returns a range that iterates over the projects within this solution.
	@property final auto projects() {
		return children.byNode.map!(c=>cast(Project)c).filter!(c=>c);
	}

private:
}

/// Represents a single node within a solution.
/// As well as the base HierarchyNode properties, this includes data such as context actions and properties.
class SolutionNode : HierarchyNode {
	/// Creates a new SolutionNode with the given name and icon.
	this(string name, Image icon) {
		super(name, icon);
		this._contextMenu = new ContextMenu();
	}
	
private:
	ContextMenu _contextMenu; 
}