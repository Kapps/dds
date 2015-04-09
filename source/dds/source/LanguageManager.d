module dds.source.LanguageManager;
/+
import dds.source.Language;
import std.uni;
import std.string;
import std.algorithm;
import std.range;
import std.path;
import dds.source.DefaultLanguage;
import std.stdio;

/// A static helper used to manage languages recognized by DDS.
/// This class is thread-safe. 
public static shared class LanguageManager {

	/// Registers the given language for the specified extension.
	static void registerLanguage(Language language, string[] extensions...) {
		synchronized(typeid(typeof(this))) {
			foreach(extension; extensions)
				_languages[getFixedKey(extension)] = language;
		}
	}

	/// Attempts to guess the language of a file by looking at the file path and possibly the contents of the file.
	/// If no guess is possible, an instance of DefaultLanguage will be returned.
	static Language guessLanguage(string filePath) {
		string extension = filePath.extension;
		while(extension.length > 0 && extension[0] == '.')
			extension = extension[1..$];
		Language result = getLanguage(extension);
		if(result is null)
			result = new DefaultLanguage(extension);
		return result;
	}

	/// Returns the language that matches the given extension.
	/// If no language is registered that matches the extension, an instance of DefaultLanguage will be returned.
	static Language getLanguage(string extension) {
		synchronized(typeid(typeof(this))) {
			return _languages.get(getFixedKey(extension), new DefaultLanguage(extension));
		}
	}

	/// Attempts to guess the language of a source file by scanning the contents of the file.
	/// This method does not need the full contents of the file, and most guesses use only the first few lines.
	/// It is possible for a language to attempt to use an entire file to perform a guess, so more contents may help in rare situations.
	@disable static Language guessLanguageByContents(string contents) {
		// TODO: Consider implementing this.
		// Realistically, for an IDE it's not too important...
		// Would be a method on Language, and go through each one.
		// Each language can return a confidence level.
		throw new Error("Not implemented.");
	}

	private static pure string getFixedKey(string key) {
		return strip(std.string.toLower(key));
	}

	static __gshared Language[string] _languages;
}

+/