module dds.nodes.Project;
import dds.nodes.HierarchyNode;
import dds.nodes.Solution;
import dds.nodes.NodeTemplate;

/// The base class for a project that provides a logical grouping of child nodes.
class Project : HierarchyNode {

	/// Creates a new project with the given name.
	this(string name, Image icon) {
		super(name, icon);
	}

	/// Returns a range containing the item templates that can be created for this project.
	final @property auto itemTemplates() {
		return _templates;
	}

	/// Adds the given template to the allowed templates for this project.
	final void registerTemplate(NodeTemplate temp) {
		synchronized(this)
			_templates ~= temp;
	}


	abstract void buildProject();

private:
	NodeTemplate[] _templates;
}

