module dds.source.SourceFile;
import std.range;
import std.file;
import core.atomic;
import ShardTools.Untyped;
import ShardTools.Event;
import core.sync.mutex;
import std.typecons;
import ShardTools.Initializers;
import dds.source.Language;
import ShardTools.ExceptionTools;
import std.stdio;
import std.algorithm;
import std.conv;
import core.thread;
import dds.source.Language;
import dds.source.CompletionProvider;
import vibe.d;

/// Provides the contents of a single file containing source code.
/// Though the name implies files, that is simply the most common usage.
/// All load and save actions operate on DataSources, meaning files can be replaced with network requests, or any other DataSource.
/// SourceFiles may be loaded asynchronously, but are in a read-only state during this.
/// Multiple SourceFiles may be open at a time, and a SourceFile may be used by multiple widgets at the same time.
/// Each of these widgets will share the same buffer, and thus when one is updated the rest will be.
final class SourceFile {

	/// Gets an Event raised when a load action begins.
	@property final Event!(void, SourceFile, AsyncAction) loadStarted() {
		return _loadStarted;
	}
	
	/// Gets an Event called when a load action is complete, whether cancelled or successful.
	@property final Event!(void, SourceFile, AsyncAction, CompletionType) loadComplete() {
		return _loadComplete;
	}
	
	/// Gets an Event called when a save operation begins.
	@property final Event!(void, SourceFile, AsyncAction) saveStarted() {
		return _saveStarted;
	}
	
	/// Gets an Event called when a save operation is completed, whether successful or cancelled.
	@property final Event!(void, SourceFile, AsyncAction, CompletionType) saveComplete() {
		return _saveComplete;
	}
	
	/// Gets an Event called when the readOnly property of this SourceFile is changed.
	@property final Event!(void, SourceFile) readOnlyChanged() {
		return _readOnlyChanged;
	}
	
	/// Gets an Event called when the title property of this SourceFile is changed.
	@property final Event!(void, SourceFile) titleChanged() {
		return _titleChanged;
	}

	/// Gets an Event called when the language property of this SourceFile is changed.
	@property final Event!(void, SourceFile) languageChanged() {
		return _languageChanged;
	}

	/// Creates a new SourceFile with an empty SourceBuffer.
	/// The user can then input text into the buffer, or load can be called to insert text.
	this(string title) {
		this._title = title;
		constructNew(_ioMutex, _loadStarted, _loadComplete, _saveStarted, 
		             _saveComplete, _readOnlyChanged, _titleChanged, _languageChanged);
		// Some basic defaults.
		// TODO: Load these from settings. But that may be language-dependent.
		// So perhaps should move this below stuff into Language.
		/+auto tagTable = new TextTagTable();
		this._buffer = new SourceBuffer(tagTable);
		buffer.setHighlightSyntax(true);
		buffer.setHighlightMatchingBrackets(true);
		buffer.addOnChanged((buffer) => onTextChanged());
		// Create a tag we can use to make the entire buffer readonly.
		TextTag tag = new TextTag(readOnlyTagName);
		tag.setProperty(userEditableTagPropertyName, false);
		tagTable.add(tag);+/
		
	}

	/// Creates a new SourceFile and immediately loads data from the given InputSource.
	/// This is equivalent to creating a new SourceFile and then calling load on it.
	this(string title, InputSource input) {
		this(title);
		load(input);
	}

	/// Gets the SourceBuffer that's used to edit the contents of this SourceFile.
	@property final SourceBuffer buffer() {
		return _buffer;
	}

	/// Indicates if there is currently a load operation being performed.
	@property final bool loadInProgress() const {
		return _loadInProgress;
	}

	/// Gets or sets the title of this SourceFile.
	@property final string title() const {
		return _title;
	}

	/// ditto
	@property final void title(string value) {
		_title = value;
		titleChanged.Execute(this);
	}

	/// Gets or sets the language that's being used for this SourceFile.
	/// This is allowed to be null, but generally a DefaultLanguage instance would be used instead.
	/// Setting a Language on a SourceFile will result in a SourceCompletionProvider being created for the buffer.
	@property Language language() {
		return _language;
	}

	/// ditto
	@property void language(Language value) {
		if(_language == value)
			return;
		_language = value;
		/+buffer.setLanguage(value is null ? null : value.getSourceLanguage(this));+/
		_completionProvider = value.createCompletionProvider(this);
		languageChanged.Execute(this);
	}

	/// Gets the SourceCompletionProvider that should be used for this buffer.
	/// If no language is set, this will be null.
	@property final SourceCompletionProvider completionProvider() {
		return _completionProvider;
	}

	/// Gets or sets a value indicating whether the SourceFile should be modifiable by the user.
	@property bool readOnly() const {
		return _readOnly;
	}

	/// ditto
	@property void readOnly(bool value) {
		if(value == _readOnly)
			return;
		_readOnly = value;
		/+auto iters = getStartAndEndIters();
		iters.end.forwardChar(); // Otherwise we can append.
		writefln("Making {%s, %s} read-only.", iters.start.getOffset(), iters.end.getOffset());
		writefln("Total length is %s.", buffer.getText().length);
		if(value)
			buffer.applyTagByName(readOnlyTagName, iters.start, iters.end);
		else
			buffer.removeTagByName(readOnlyTagName, iters.start, iters.end);+/
		readOnlyChanged.Execute(this);
	}

	/// Saves the contents of the buffer at the time of this call to the given OutputSource.
	/// Further modifications to the buffer are allowed during this time, but will not be saved to the OutputSource.
	/// This method may not be called during a load.
	/// Returns the IOAction used to handle the save.
	void save(OutputStream output) {
		synchronized(_ioMutex) {
			writeln("Beginning save method.");
			//string bufferContents = this.buffer.getText();
			string bufferContents = null;
			MemoryInput mi = new MemoryInput(cast(ubyte[])bufferContents, true);
			IOAction action = new IOAction(mi, output);
			action.NotifyOnComplete(Untyped.init, &onSaveCompleteCallback);
			action.Start();
			saveStarted.Execute(this, action);
			assert(0);
			//return action;
		}
	}



	/// Replaces the contents of this SourceFile with data from the given InputSource.
	/// Contents will be loaded in chunks if possible, but modification will not be allowed until the file is fully loaded.
	/// Returns the IOAction used to perform this load. If this action is cancelled, the contents will not be cleared and the buffer will remain readonly.
	IOAction load(InputSource inputSource) {
		synchronized(_ioMutex) {
			if(loadInProgress)
				throw new InvalidOperationException("Unable to load while an existing load is in progress.");
			writefln("Beginning load method.");
			_loadInProgress = true;
			/+// TODO: IMPORTANT: Fix below two lines!
			//this.readOnly = true;
			buffer.beginNotUndoableAction();
			buffer.setText("");+/
			CallbackOutput outputSource = new CallbackOutput(null, &onWriteCallback);
			// TODO: IMPORTANT: Fix the below chunk size!
			// IOAction seems extremely broken suddenly...
			IOAction.DefaultChunkSize = 16384000;
			IOAction action = new IOAction(inputSource, outputSource);
			action.NotifyOnComplete(Untyped.init, &onLoadCompleteCallback);
			action.Start();
			loadStarted.Execute(this, action);
			return action;
		}
	}

	/// Called when the text of the buffer is changed.
	/// The default implementation should be called.
	protected void onTextChanged() {
		synchronized(_ioMutex) {
			writeln("Text changed.");
			if(readOnly) {
				writefln("Total length is %s.", buffer.getText().length);
				auto iters = getStartAndEndIters();
				buffer.applyTagByName(readOnlyTagName, iters.start, iters.end);
			}
		}
	}

	private void onWriteCallback(void* state, ubyte[] buffer) {
		/+synchronized(_ioMutex) {
			string bufferText = cast(string)buffer;
			writeln("Received buffer of " ~ buffer.length.text ~ ".");
			size_t start = 0;
			while(start < bufferText.length) {
				string contents = bufferText[start..min(bufferText.length, start + 100000)];
				start += 100000;
				Idle.add(&writeCallbackIdleCallback, cast(void*)new Tuple!(SourceFile, string)(this, contents));
			}
		}+/
		string bufferText = cast(string)buffer;
		Idle.add(&writeCallbackIdleCallback, cast(void*)new Tuple!(SourceFile, string)(this, bufferText));
	}

	extern(C) static int writeCallbackIdleCallback(void* state) {
		auto tup = cast(Tuple!(SourceFile, string)*)state;
		SourceFile file = (*tup)[0];
		synchronized(file._ioMutex) {
			writefln("Writing contents.");
			auto iters = file.getStartAndEndIters();
			file.buffer.insert(iters.end, (*tup)[1]);
			return false;
		}
	}

	private Tuple!(TextIter, "start", TextIter, "end") getStartAndEndIters() {
		synchronized(_ioMutex) {
			TextIter start = new TextIter(), end = new TextIter();
			buffer.getStartIter(start);
			buffer.getEndIter(end);
			writeln("{", start.getOffset(), ", ", end.getOffset(), "}");
			return cast(typeof(return))tuple(start, end);
		}
	}

	private void onLoadCompleteCallback(Untyped state, AsyncAction action, CompletionType completionType) {
		synchronized(_ioMutex) {
			writeln("Load complete!");
			assert(loadInProgress);
			_loadInProgress = false;
			buffer.endNotUndoableAction();
			readOnly = false;
			loadComplete.Execute(this, action, completionType);
		}
	}

	private void onSaveCompleteCallback(Untyped state, AsyncAction action, CompletionType completionType) {
		synchronized(_ioMutex) {
			saveComplete.Execute(this, action, completionType);
		}
	}

private:
	Event!(void, SourceFile, AsyncAction, CompletionType) _onSave;
	Event!(void, SourceFile) _readOnlyChanged;
	Event!(void, SourceFile) _titleChanged;
	Event!(void, SourceFile) _languageChanged;
	bool _readOnly;
	Language _language;
	string _title;
	CompletionProvider _completionProvider;
}

