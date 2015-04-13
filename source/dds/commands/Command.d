module dds.commands.Command;
import std.variant;

/// Represents a command that can execute an action in the IDE when triggered.
/// This class is immutable but the action may execute mutable code.
final class Command {
	/// Creates a new Command with the given name, description, and action.
	this(string name, string description, Variant delegate() action) {
		this._name = name;
		this._description = description;
		this._action = action;
	}

	/// The name of this command, used to index the command and displayed to the user.
	@property string name() const {
		return _name;
	}

	/// The description of this command, primarily used for user hints.
	@property string description() const {
		return _description;
	}

	/// Invokes this command, returning the result of the command or null 
	Variant invoke() {
		return _action();
	}


	string _name;
	string _description;
	Variant delegate() _action;
}

