module dds.nodes.Solution;

import std.algorithm;

public import dds.nodes.HierarchyNode;
public import dds.nodes.Project;
public import dds.nodes.ContextMenu;

/// Represents a solution file, or workspace, within a hierarchy.
/// This is considered the root node within a hierarchy and must always exist when a hierarchy is used.
/// More technically, a Solution is simply a type of Project that contains other projects and solution files as its children.
class Solution : Project {

	/// Creates a new solution with the given name.
	this(string baseDirectory, string name, Image icon) {
		super(baseDirectory, "ssws", name, icon);
	}

	/// Returns an InputRange that contains the (non-recursive) projects within this solution.
	@property final auto projects() {
		return children.ofType!Project();
	}

	/// Returns a range that contains the files within this solution that are not part of a project.
	@property final auto files() {
		return children.ofType!FileNode();
	}

private:
}