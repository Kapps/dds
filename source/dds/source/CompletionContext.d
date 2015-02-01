module dds.source.CompletionContext;
import dds.source.CompletionSource;
import std.range.primitives;
import dlangui.widgets.editors;
import std.container.array;

/// Contains information about a single auto-completion session, such as the sources used and proposals available.
class CompletionContext {


	/// Adds the given proposal for this completion context.
	void addProposal(CompletionItem proposal) {
		_proposals ~= proposal;
	}

	/// Adds a collection of proposals to this context.
	void addProposals(RangeType)(RangeType proposals) if(isInputRange!RangeType && is(ElementType!RangeType == CompletionItem)) {
		// TODO: Can later on optimize if needed.
		// Also need to build proper tree of 
		static if(is(typeof(proposals.length)))
			this._proposals.reserve(this._proposals.length + proposals.length);
		foreach(proposal; proposals)
			addProposal(proposal);

		/++
		 + RadixTree Approach:
		 + Variable number of elements per letter.
		 + Each letter starts a new subtree.
		 + Completions stored in each node.
		 + However, handle capital letters differently by including permutations of the word at each non-sequential capital.
		 + 	Non-sequential because IFoo would already have been stored as IFoo by the initial one.
		 + 	However IFooProvider should be stored as IFooProvider as well as IFProvider or IFP.
		 + Then for getting completions, it returns an array that iterates over the prefix.
		 + However when using something like IFP, IFooProvider should be considered an excellent match.
		 + Calculate the likelihood of a match dynamically
		 +/
	}

	private CompletionSource[] _sources;
	private TextPosition _position;
	private Array!CompletionItem _proposals;
}

