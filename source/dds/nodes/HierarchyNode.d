module dds.nodes.HierarchyNode;
public import dds.graphics.Image;
import ShardTools.ExceptionTools;
import std.range;
import std.algorithm;
import std.exception;
import std.conv;
import std.regex;
import std.path;
import std.string;
import dds.nodes.Project;
import dds.nodes.Solution;

/// Represents a character that indicates a separation of a HierarchyNode for a qualified name.
enum char nodeSeparator = '.';

/// Provides the base node in the hierarchy.
/// This class, and any derived classes, are not thread-safe unless otherwise specified.
class HierarchyNode {
	
	/// Creates a new HierarchyNode with the given identifier.
	/// If the identifier is not a valid node name, an exception is thrown.
	this(string name, Image icon) {
		if(!isValidName(name))
			throw new InvalidFormatException("The name of this node was not valid.");
		this._name = name;
		this._children = new NodeCollection(this);
		this._icon = icon;
	}
	
	/// Returns the child nodes that this node contains.
	@property final NodeCollection children() @safe pure nothrow {
		return _children;	
	}
	
	/// Gets an identifier used to represent this node.
	/// For example, a file may return the name of the file (without an extension).
	@property final string name() const @safe pure nothrow {
		return _name;
	}
	
	/// Gets the parent that owns this node.
	@property final HierarchyNode parent() @safe pure nothrow {
		return _parent;
	}

	/// Gets an icon used to represent this node.
	@property final Image icon() @safe pure nothrow {
		return _icon;
	}
	
	@property package final void parent(HierarchyNode node) @safe pure nothrow {
		assert(parent is null);
		assert(node !is null);
		this._parent = node;
	}
	
	/// Gets the node for this HierarchyNode, which is the Solution being used.
	/// If this node is not part of a Solution, null is returned.
	@property final Solution solution() @safe pure nothrow {
		if(parent is null)
			return cast(Solution)this;
		return parent.solution;
	}

	/// Returns the first project that contains this node.
	@property final Project project() @safe pure nothrow {
		auto proj = cast(Project)this;
		if(proj)
			return proj;
		else if(parent is null)
			return null;
		return parent.project;
	}

	/// Finds the child node with the given qualified name within this node.
	final HierarchyNode findChild(string name) {
		auto sepInd = name.indexOf(nodeSeparator);
		string childName = sepInd == -1 ? name : name[0 .. sepInd];
		auto next = children[childName];
		return sepInd == -1 ? next : next.findChild(name[sepInd + 1 .. $]);
	}

	/// Indicates if the given unqualified node name is valid.
	static bool isValidName(string nodeName) @safe pure {
		return nodeName.length > 0 && std.string.indexOf(nodeName, nodeSeparator) < 0 && nodeName.length < 256;
	}

	///
	unittest {
		assert(isValidName("abc"));
		assert(!isValidName(""));
		assert(isValidName("ab00f"));
		assert(!isValidName(null));
		assert(!isValidName("ab" ~ nodeSeparator ~ "cdef"));
	}
	
	/// Splits a qualified name into it's individual parts.
	/// Generally, the first element is the Solution and second is the Project.
	static string[] splitQualifiedName(string qualifiedName) {
		return splitter(qualifiedName, nodeSeparator).array;
	}

	///
	unittest {
		assert(splitQualifiedName("Textures" ~ nodeSeparator ~ "TestTexture") == ["Textures", "TestTexture"]);
		assert(splitQualifiedName("Textures") == ["Textures"]);
	}

	/// Converts the given relative path into the fully qualified name of a HierarchyNode.
	static string nameFromPath(string relativePath) {
		// TODO: A regex for this seems a bit overkill.
		// But no other split method allows us to split on multiple characters.
		string noext = stripExtension(relativePath);
		auto split = std.regex.splitter(noext, regex(`[/\\]`));
		return join(split, nodeSeparator.to!string);
	}

	///
	unittest {
		assert(nameFromPath("dds/HierarchyNode.d") == "dds" ~ nodeSeparator ~ "HierarchyNode");
		assert(nameFromPath("dds\\HierarchyNode.png") == "dds" ~ nodeSeparator ~ "HierarchyNode");
		assert(nameFromPath("HierarchyNode.d") == "HierarchyNode");
		assert(nameFromPath("HierarchyNode") == "HierarchyNode");
	}
	
	/// Returns the fully qualified name of this node, with identifiers being separated by `nodeSeparator`.
	/// If parent is null, returns `identifier`.
	@property final string qualifiedName() {
		// TODO: This could be easily optimized if need be. First calculate length, then allocate.
		// Or just cache it.
		string result = this.name;
		for(HierarchyNode node = this.parent; node !is null; node = node.parent) {
			result = node.name ~ nodeSeparator ~ result;
		}
		return result;
	}

	/+/// A shortcut to log a message with the Trace severity.
	final void trace(string details) {
		enforce(solution);
		root.context.logger.trace(details, this);
	}

	/// A shortcut to log a message with the Info severity.
	final void info(string details) {
		enforce(solution);
		root.context.logger.info(details, this);
	}
	
	/// A shortcut to log a message with the Warning severity.
	final void warn(string details) {
		enforce(root);
		root.context.logger.warn(details, this);
	}+/

	/// Returns a string representation of this node containing the qualified name and type.
	override string toString() {
		string type = typeid(this).text;
		size_t index = type.retro.countUntil('.');
		if(index > 0)
			type = type[$ - index .. $];
		return this.qualifiedName ~ " (" ~ type ~ ")";
	}

private:
	string _name;
	HierarchyNode _parent;
	NodeCollection _children;
	Image _icon;
}

/// Provides a collection of HierarchyNodes. This class is not thread-safe.
final class NodeCollection {
	
	// TODO: Consider making this a struct.
	
	/// Creates a new NodeCollection for the given HierarchyNode.
	this(HierarchyNode owner) {
		this._owner = owner;
	}
	
	/// Returns the number of nodes contained in this collection.
	@property size_t length() const {
		return _nodes.length;
	}
	
	/// Gets the node that owns this collection.
	@property HierarchyNode owner() {
		return _owner;	
	}
	
	/// Returns a range that iterates over the nodes contained in this collection.
	/// This result may be invalidated by altering the collection.
	@property auto byNode() {
		return _nodes.byValue;
	}
	
	/// Gets the HierarchyNode with the given name that is contained by this collection.
	HierarchyNode opIndex(string name) {
		auto identifier = fixedKey(name);
		HierarchyNode* result = name in _nodes;
		if(result)
			return *result;
		return null;
	}
	
	/// Implements the foreach operator on this collection.
	int opApply(int delegate(HierarchyNode) dg) {
		int curr = 0;
		foreach(key, value; _nodes) {
			curr = dg(value);	
			if(curr != 0)
				break;
		}
		return curr;
	}
	
	/// Adds the specified node to this collection.
	void add(HierarchyNode node) {
		if(node.parent !is null)
			throw new InvalidOperationException("A node with a parent set may not be added to a new collection.");
		node.parent = this.owner;
		string identifier = fixedKey(node.name);
		if(identifier in _nodes)
			throw new DuplicateKeyException("An item called " ~ identifier ~ " already exists within " ~ this.owner.text ~ ".");
		_nodes[identifier] = node;
	}
	
	/// Removes the specified node from this collection.
	void remove(HierarchyNode node) {
		if(node.parent !is this)
			throw new InvalidOperationException("Unable to remove a node from this collection when it does not exist.");
		string identifier = fixedKey(node.name);
		if(!_nodes.remove(identifier))
			throw new KeyNotFoundException("This node did not contain the specified child.");
	}
	
	protected string fixedKey(string input) pure {
		return input.strip();
	}
	
	// TODO: Consider using HashTable.
	private HierarchyNode[string] _nodes;
	private HierarchyNode _owner;
}

/// Provides a reference to an existing HierarchyNode.
struct NodeReference {

	/// Indicates the fully qualified name of the node that is being referenced.
	const string qualifiedName;

	/// Creates a NodeReference to the given node or one with the specified name.
	this(string qualifiedName) {
		this.qualifiedName = qualifiedName;
	}

	/// Ditto
	this(HierarchyNode node) {
		this(node.qualifiedName);
	}

	/// Evaluates to the node that is being referenced.
	/// If the node is no longer capable of being evaluated, returns null.
	HierarchyNode evaluate(Solution solution) {
		return solution.findChild(qualifiedName);
	}
}