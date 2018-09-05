#!/usr/bin/env bash

export MINIO_ACCESS_KEY=${AZURE_STORACE_ACCOUNT}
export MINIO_SECRET_KEY=${AZURE_STORAGE_KEY}
minio gateway azure

