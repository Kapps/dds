module dds.semantics.SemanticServer;
version(none) {
import ShardTools.AsyncAction;
import ShardIO.OutputSource;
import ShardIO.InputSource;

enum SemanticCommand {

}

/// Provides access to an external source to retrieve semantic data from.
/// This allows language-agnostic access to semantic data, while being
/// resilient to crashes, hangs, and other undesired behaviours.
class SemanticConnection {
	AsyncAction sendCommand(SemanticCommand command) {
		throw new Error("Not implemented.");
	}

protected:

private:
	InputSource _input;
	OutputSource _output;
}
}