module dds.semantics.d.DLanguage;
/+
import dds.source.Language;
import gsv.SourceLanguageManager;
import gsv.SourceCompletionProvider;
import dds.ui.SourcePad;
import gsv.SourceCompletionWords;
import dds.source.SourceFile;
import gsv.SourceLanguage;
import gsvc.gsv;
import glib.Str;

/// Implements Language to provide support for the D Programming Language.
class DLanguage : Language {
	this() {
		// Constructor code
	}

	override @property SourceLanguage getSourceLanguage(SourceFile file) {
		return SourceLanguageManager.getDefault().getLanguage("d");
	}

	override SourceCompletionProvider createCompletionProvider(SourceFile file) {
		GtkSourceCompletionWords* w = gtk_source_completion_words_new(Str.toStringz("D Test"), null);
		gtk_source_completion_words_register(w, cast(GtkTextBuffer*)file.buffer.getSourceBufferStruct());
		auto result = new SourceCompletionProvider(cast(GtkSourceCompletionProvider*)w);
		return result;
	}
}+/