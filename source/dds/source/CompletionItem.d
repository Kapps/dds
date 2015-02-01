module dds.source.CompletionItem;

/// An immutable struct representing basic information about a single proposal in a completion context.
struct CompletionItem {
	/// The contents that should be entered if this item is selected.
	const string contents;
	/// The name to display to the user for this item.
	const string displayName;
	/// A description of this item.
	/// Some providers may allow special formatting of this description, such as DDoc for the DCompletionProvider.
	const string description;
}

