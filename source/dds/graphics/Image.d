module dds.graphics.Image;

import dlangui.graphics.drawbuf;
import dlangui.graphics.images;

/// Represents a 2D static image.
class Image {

final {

	/// Creates a new Image from the given buffer.
	this(ColorDrawBuf buffer) {
		this._buffer = buffer;
	}

	this(string filePath) {
		this(loadImage(filePath));
	}

	/// Gets the width or height of this image, in pixels.
	size_t width() {
		return _buffer is null ? 0 : cast(size_t)_buffer.width;
	}

	/// Ditto
	size_t height() {
		return _buffer is null ? 0 : cast(size_t)_buffer.height;
	}

	/// Gets the buffer containing the color data for this image.
	ColorDrawBuf buffer() {
		return _buffer;
	}
}

private:
	ColorDrawBuf _buffer;
}

