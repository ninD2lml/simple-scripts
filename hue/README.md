<div align="center" markdown="1">

 <b><a href="#installation">📁 Installation</a> | <a href="#usage">Usage 💻</a> | <a href="#example">Example 📂</a></b>
 
 # HTML & URL encoder
 **&lt; A minimal encoder via pipe &gt;**

</div>

## Installation

### Requeriments
- xclip
- sed

### Linux

```bash
git clone https://raw.githubusercontent.com/ninD2lml/simple-scripts/refs/heads/main/hue/hue.sh
```
```bash
chmod 755 hue.sh
```
```bash
echo "alias hue='$PWD/hue.sh'" >> ~/.bashrc
```
```bash
hue --help
```

## Usage

Pipe output from echo or cat for fast conversion
```bash
echo '<?php system($_GET["cmd"])' ?> | hue -lsc
```
```bash
cat file.php | hue -su -o file_convert.php
```

## Example

[![asciicast](https://asciinema.org/a/zHFwm4qcmsLFB0KXYDyInZ5s3.svg)](https://asciinema.org/a/zHFwm4qcmsLFB0KXYDyInZ5s3)
