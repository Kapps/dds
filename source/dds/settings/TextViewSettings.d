module dds.settings.SourceViewSettings;

import dds.settings.SettingsAnnotations;

/// Indicates whether to use tabs or spaces when pressing the tab key.
public enum SpaceType {
	tabs = 0,
	spaces = 1
}

/// Provides basic settings for viewing text or source code.
public class SourceViewSettings {

	/// Gets or sets a value indicating how to handle the user pressing the tab key.
	@defaultValue(SpaceType.tabs)
	public SpaceType spaceType() const {
		return _spaceType;
	}

	/// ditto
	@property void spaceType(SpaceType value) {
		_spaceType = value;
	}

	private SpaceType _spaceType = SpaceType.tabs;
}

