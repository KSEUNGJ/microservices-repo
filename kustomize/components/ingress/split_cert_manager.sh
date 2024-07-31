#!/bin/bash

# 현재 디렉토리에 cert-manager.yaml 파일이 있다고 가정합니다

# cert-manager 디렉토리가 없으면 생성
mkdir -p cert-manager

# cert-manager.yaml 파일을 개별 YAML 파일로 분리
csplit -s -z cert-manager.yaml '/^---$/' '{*}' -f cert-manager/resource- -b '%03d.yaml'

# 분리된 파일들의 이름을 리소스 종류에 따라 변경
for file in cert-manager/resource-*.yaml; do
  kind=$(grep -m1 'kind:' "$file" | awk '{print tolower($2)}')
  name=$(grep -m1 'name:' "$file" | awk '{print tolower($2)}')
  mv "$file" "cert-manager/${kind}-${name}.yaml"
done

echo "cert-manager.yaml has been split into multiple files in the cert-manager directory."
