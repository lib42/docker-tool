#!/bin/bas
PREFIX=lib42/tool
set -e

for tool in tools/* ; do
  PRE=true
  EXTRACT=false
  TEMP=$(mktemp -d)

  source $tool
  echo
  echo Building Tool Container for $NAME

  cd $TEMP
  wget -nv -O $NAME-dl $URL

  if [ "$EXTRACT" != 'false' ] ; then
    $EXTRACT $NAME-dl
  else
    BIN=$NAME-dl
  fi
  chmod +x $BIN

	cat > Dockerfile << EOF
FROM scratch
COPY $BIN /$NAME
CMD [ "/$NAME" ]
EOF

	docker build . -t $PREFIX:$NAME
  docker push $PREFIX:$NAME

  cd -
  rm -rf $TEMP
done
