module dds.semantics.HistoryCompletionSource;
import dds.source.CompletionSource;
import dds.source.CompletionContext;

/// Provides a CompletionSource that uses previously completed words in the file.
class HistoryCompletionSource : CompletionSource {
	this() {
		super("History");
	}

	override bool isSourceValid(CompletionContext context) {
		return true;
	}
}

