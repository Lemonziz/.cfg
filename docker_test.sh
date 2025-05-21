#!/bin/bash
docker build -t cfg-install-test . && docker run -it cfg-install-test
