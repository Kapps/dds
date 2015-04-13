module dds.settings.SettingsAnnotations;

/// Indicates that this property should use a default value if no value is set specifically or inherited.
struct DefaultValue(T) {

	/// Gets the value that should be used as the default.
	@property T value() {
		return _value;
	}

	/// Creates a new DefaultValueAttribute with the specified value set as default.
	this(T value) {
		this._value = value;
	}

	private T _value;
}

/// Ditto
auto defaultValue(T)(T val) {
	return DefaultValue!T(val);
}