module dds.source.Language;
/+
public import dds.source.SourceFile;
import dds.source.CompletionProvider;

/// A base class used to provide support for language features, such as syntax highlighting and auto-completion.
abstract class Language {

	/// Gets the name of this language, such as D.
	@property abstract string name();

	/// Returns the completion provider that should be used for this language.
	/// This is expected to generally return the same instance.
	@property CompletionProvider completionProvider();

	/// Returns the standard file extensions used by this language, such as (c, h) for C, or (d, di) for D.
	/// The user may override these values, but this provides the default settings to use.
	@property abstract string[] defaultExtensions();


	/+ Language shouldn't control extensions, as could be set in preferences.


	/// Gets the primary extension for this language, such as cpp for C++ or d for D.
	@property string primaryExtension();+/

	/+/// Returns a SourceLanguage that can be used to perform SourceBuffer highlighting for this language with the given file.
	/// This is used to perform basic syntax highlighting.
	/// More advanced operations, such as semantic highlighting, can be done using performSemanticHighlighting.
	SourceLanguage getSourceLanguage(SourceFile file);

	/// Creates a SourceCompletionProvider for a given SourceFile.
	/// Each SourceCompletionProvider is allowed on exactly one SourceFile, and cannot be shared.
	/// Completion providers are used to generate auto-complete options for a given language.
	/// This method will only create the completion provider, not register it.
	SourceCompletionProvider createCompletionProvider(SourceFile file);+/

	// TODO: getCompletionRecommendations -> Done in background.
	// TODO: performSemanticHighlighting : takes in a TokenStream of the visible tokens. Probably just the ones that have updated. -> Done in background.
}

+/