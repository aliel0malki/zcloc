# zcloc

Yet another lines of code counter.

[![GITHUB LICENSE](https://img.shields.io/badge/license-MIT-brightgreen.svg)](https://github.com/aliel0malki/zcloc/blob/main/LICENSE)
![TESTS](https://github.com/aliel0malki/zcloc/actions/workflows/tests.yml/badge.svg?branch=main)

## Features

- **COUNT LINES OF CODE**
- **COUNT COMMENTS**
- **COUNT BLANK LINES**
- **WORK WITH NESTED DIRECTORIES**
- **and of course, *Blazingly Fast***


## Installation

### From Releases

1. Go to the [Releases](https://github.com/aliel0malki/zcloc/releases) page of this repository.
2. Download the appropriate archive for your operating system (e.g., `zcloc-x86_64-linux-gnu.tar.gz`).
3. Extract the archive:
   ```bash
   tar -xzf zcloc-x86_64-linux-gnu.tar.gz
   ```
4. Move the extracted binary to a directory in your PATH (e.g., `/usr/local/bin`):
   ```bash
   sudo mv zcloc /usr/local/bin/
   ```
5. You can now run `zcloc` from the command line.

### From Source Code

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/zcloc.git
   cd zcloc
   ```
2. Build the project:
   ```bash
   zig build
   ```
3. The built binary will be located in the `zig-out/(architecture)` directory. You can run it directly:
   ```bash
   ./zig-out/x86_64-linux-gnu/zcloc <directory>
   ```

## Usage

Run `zcloc` with the directory you want to analyze:
```bash
zcloc <directory>
```
For example:
```bash
zcloc src
```

## License

This project is licensed under the MIT License.
