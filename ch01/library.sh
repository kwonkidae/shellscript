#!/bin/bash

echo `dirname "$(readlink -f "${BASH_SOURCE[0]}")"`
