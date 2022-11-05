#!/bin/bash

sudo -u jenkins -s \
docker login \
  --username oauth \
  --password $YC_TOKEN \
  cr.yandex