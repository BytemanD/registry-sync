IMAGES_LIST=$1

logInfo(){
  echo $(date +'%F %T') INFO $@
}
logError(){
  echo $(date +'%F %T') ERROR $@
}

while read line
do
  if [[ "${line}" == "" ]]; then
    continue
  fi
  IMAGE=${line}
  REGISTRY=$(dirname $IMAGE)
  IMAGE_NAME=$(basename $IMAGE)
  TAG=registry.cn-hangzhou.aliyuncs.com/byteman-base/${IMAGE_NAME}

  logInfo "拉取镜像 <--" $IMAGE
  docker pull $IMAGE
  if [[ $? != 0 ]]; then
    logError "拉取失败"
    continue
  fi
  docker tag $IMAGE $TAG
  logInfo "推送镜像 -->" $TAG
  docker push $TAG
  if [[ $? != 0 ]]; then
    logError "推送失败"
  fi
done < ${IMAGES_LIST}
