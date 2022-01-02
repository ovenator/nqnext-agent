
if [ -f env.txt ]
then
  export $(cat env.txt | xargs)
fi

if [ -z "$NQ_AUTH" ]
then
  echo "NQ_AUTH is missing"
	exit;
fi

if [ -z "$NQ_HOME" ]
then
  echo "NQ_HOME is missing"
	exit;
fi

if [ -z "$NQ_HOST" ]
then
  echo "NQ_HOST is missing"
	exit;
fi



cd $NQ_HOME || exit 1

# Remove previous output dir and tar
rm -rf $NQ_HOME/agent/out 2> /dev/null
rm -rf $NQ_HOME/agent/out.* 2> /dev/null

mkdir -p $NQ_HOME/agent/out

cd $NQ_HOME/agent/probes || exit 1

echo "Running default probes in $NQ_HOME/agent/probes ..."

run_probes () {

  for file in *
  do
    name=${file%.*}
    sh ./"$file" > $NQ_HOME/agent/out/"$name".out 2>&1
  done

}

run_probes

cd $NQ_HOME/probes || exit 1
echo "Running user probes in $NQ_HOME/probes ..."

run_probes

echo "Creating tar..."
cd $NQ_HOME/agent/out/ || exit 1
tar -czf $NQ_HOME/agent/out.tar.xz ./*

echo "Uploading data..."
cd $NQ_HOME/agent || exit 1

curl -F "file=@out.tar.xz" \
  -H "Authorization: Bearer $NQ_AUTH" \
  --connect-timeout 60 \
  --max-time 120 \
  --insecure \
  $NQ_HOST/servers/api/agent/upload

echo ""
echo "Done."