module dds.source.CompletionSource;
/+
import dds.source.CompletionContext;

/// Provides a single source of auto-complete data within a `CompletionProvider`.
abstract class CompletionSource {

	/// Creates a new `CompletionSource` with the given name.
	this(string name) {
		this._name = name;
	}

	/// Gets the name of this `CompletionSource`, case insensitive.
	@property final string name() const {
		return _name;
	}

	/// Indicates if this `CompletionSource` should be considered valid and used for the given `CompletionContext`.
	abstract bool isSourceValid(CompletionContext context);

	/// Populates the given context with auto-complete information from this source.
	abstract void populateContext(CompletionContext context);

	private string _name;
}

+/