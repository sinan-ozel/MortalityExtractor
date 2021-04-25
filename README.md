# Mortality Rate Extractor

This script obtains state-year level mortality and population data for raw
death files obtained from NBER. It also adds political and economic controls
using additional data files.

It can be used to obtain mortality rates by cause-of-death.

## Basic Usage

On a Windows system, run
```
scripts\get_mortality.py -i raw_data -o mortality_by_state.dta -s 2003 -e 2004 -v
```

after creating and populating the following folder structure under `raw_data`:
```
+
+--BEA
+--NBER
+--PoliticalControls
+--Population
```

The data files required for each folder is in a README.md file in each directory.

## Requirements

* Windows
* Python 3
* Python libraries in `requirements.txt`

You can also use the same file on Linux systems. On any system, you can
install the requirements by running:
```
pip install -r requirements.txt
```
## Advanced Usage

For more help, run:
```
scripts\get_mortality.py --help
```

Also see the `*.bat` files for examples.

### 

## Linux Usage

The main script is compatible with Linux systems. However, the `*.bat` files
are not. You should be able to convert the `*.bat` files to `bash` without
much difficulty, as these are simply wrappers around the main script.
