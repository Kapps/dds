module dds.source.DefaultLanguage;
/+
import gsv.SourceLanguage;
import gsv.SourceLanguageManager;
import dds.source.Language;
import gsv.SourceCompletionProvider;
import dds.ui.SourcePad;
import dds.source.SourceFile;
import gsv.SourceCompletionWords;
import gsvc.gsv;
import glib.Str;

/// An implementation of Language that is used when no language can be detected.
class DefaultLanguage : Language {

	/// Creates a new instance of DefaultLanguage for the given extension.
	this(string extension) {
		SourceLanguageManager slm = SourceLanguageManager.getDefault();
		// The below is extremely hackish. But we may not have an actual filepath...
		_guessedLanguage = slm.guessLanguage("tmp." ~ extension, null);
	}

	/// Gets the SourceLanguage that this instance guessed.
	override SourceLanguage getSourceLanguage(SourceFile file) {
		return _guessedLanguage;
	}

	override SourceCompletionProvider createCompletionProvider(SourceFile file) {
		GtkSourceCompletionWords* w = gtk_source_completion_words_new(Str.toStringz("Default"), null);
		gtk_source_completion_words_register(w, cast(GtkTextBuffer*)file.buffer.getSourceBufferStruct());
		auto result = new SourceCompletionProvider(cast(GtkSourceCompletionProvider*)w);
		return result;
	}

	private string _extension;
	private SourceLanguage _guessedLanguage;
}

+/