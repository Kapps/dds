module dds.source.CompletionProvider;
import dds.source.SourceFile;
import dds.source.CompletionData;
import std.uni;
import std.string;
import dds.ui.SourcePad;
import dds.source.CompletionSource;

/// Handles managing auto-complete contents for a SourceFile.
abstract class CompletionProvider {

	/// Creates a new CompletionProvider for the given SourcePad.
	this(SourcePad pad) {
		this._pad = pad;
	}

	/// Indicates if the given character, when typed in the buffer, should trigger the auto-completion dialog appearing.
	/// This is in addition to the default completion hotkey being pressed.
	protected abstract bool keyShouldDisplayProposal(CompletionData data, dchar keyChar);

	/// Indicates if the given character, when typed in the buffer, should complete the currently active proposal.
	protected abstract bool keyShouldCompleteProposal(CompletionData data, dchar keyChar);

private:
	CompletionSource[] _completionSources;
	SourcePad _pad;
}

