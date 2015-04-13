module dds.nodes.Project;
import dds.nodes.HierarchyNode;
import dds.nodes.Solution;
import dds.nodes.NodeTemplate;
import std.exception;
import std.path;

/// The base class for a project that provides a logical grouping of child nodes.
/// Unlike other FileNodes, which may not necessarily be backed by a file, a Project file must always be on disk
/// even if all properties and files within it are loaded from an alternative source.
class Project : DiskFileNode {

	/// Creates a new project with the given name, directory, extension, and icon.
	/// The base directory must be absolute.
	this(string baseDirectory, string name, string extension, Image icon) {
		super(name, extension, icon);

		enforce(isRooted(baseDirectory));
		this._baseDirectory = baseDirectory;
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

	/// Returns the base directory that contains this project.
	final @property string baseDirectory() {
		return _baseDirectory;
	}

	/// Builds this project, ignoring dependencies.
	void build() {

	}

protected:

	/// Override to implement building of this project, excluding dependencies.
	abstract void performBuild();

private:
	NodeTemplate[] _templates;
	string _baseDirectory;
}