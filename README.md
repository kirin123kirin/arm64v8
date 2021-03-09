# python3_on_arm64
This container will create a wheel file for the Pypi upload.

Batch python3 package build with arm64crosscompiler.
Only arm64v8 (aarch64) compile is supported.

# Usage1:
  default wheel platformname = manylinux2014_aarch64
  
```bash
$ ls
setup.py hoge.pyx foo.c
$ docker run --rm -e UID=`id -u` -e GID=`id -g` -v $PWD:/app kirin123kirin/python3_on_arm64:latest
$ ls dist
hoge-0.0.8-cp36-cp36m-manylinux2014_aarch64.whl  hoge-0.0.8-cp37-cp37m-manylinux2014_aarch64.whl
hoge-0.0.8-cp38-cp38-manylinux2014_aarch64.whl   hoge-0.0.8-cp39-cp39-manylinux2014_aarch64.whl
$ twine upload -u username -p password dist/*.whl
```

# Usage2:
  other platformname is `manylinux2010_aarch64`

```bash
$ ls
setup.py hoge.pyx foo.c
$ docker run --rm -e PLAT_NAME=manylinux2010_aarch64 -e UID=`id -u` -e GID=`id -g` -v $PWD:/app kirin123kirin/python3_on_arm64:latest
$ ls dist
hoge-0.0.8-cp36-cp36m-manylinux2010_aarch64.whl  hoge-0.0.8-cp37-cp37m-manylinux2010_aarch64.whl
hoge-0.0.8-cp38-cp38-manylinux2010_aarch64.whl   hoge-0.0.8-cp39-cp39-manylinux2010_aarch64.whl
$ twine upload -u username -p password dist/*.whl
```


## python version.
 * 3.9.2
 * 3.8.8
 * 3.7.9
 * 3.6.13

### python installed library
 * pip
 * setuptools
 * wheel
 * cython

## OS
  ubuntu 20.04 focal-20210217, focal

## compiler
 * crossbuild-essential-arm64
 * GCC version 9.3.0 (Ubuntu 9.3.0-17ubuntu1~20.04) Target: aarch64-linux-gnu
