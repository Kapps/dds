module dds.semantics.DParserClient;

/// A client used to connect to an instance of a DParserServer executable.
class DParserClient {

	/// Creates a new DParserClient with no connection yet established.
	this() {
		// Constructor code
	}

	enum MessageType {
		None = 0,
		ParseModule = 1
	}
}

