#!/usr/bin/env python3

from setuptools import find_packages, setup

setup(
    name="suzy",
    version="1.0.0",
    python_requires=">=3.8.0",
    packages=find_packages(exclude=["tests", "*.tests", "*.tests.*", "tests.*"]),
)
