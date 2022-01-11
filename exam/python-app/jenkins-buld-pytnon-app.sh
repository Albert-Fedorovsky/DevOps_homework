echo "-------------------------- Build started --------------------------------"

sudo docker build -t alb271/python_app .
sudo docker images
sudo docker push alb271/python_app
images_to_remove=$(sudo docker images -q alb271/python_app)
sudo docker rmi $images_to_remove
sudo docker images

echo "-------------------------- Build finished -------------------------------"

echo "------------------ Launch remote script started -------------------------"

chmod +x launch-pytnon-app.sh
./launch-pytnon-app.sh

echo "------------------ Launch remote script finished ------------------------"

# For web server 1
echo "-------------------------- Test started ---------------------------------"

sleep 5
search_word="Hello world 1"
website_parsing=$(curl 10.0.10.10)
search_result=$(echo "$website_parsing" | grep -o "${search_word}" | wc -w)
echo $search_result
if [ "${search_result}" -ne "0" ]
then
  echo "Test Passed!"
else
  echo "Test Failed!"
  exit 1
fi

echo "-------------------------- Test finished --------------------------------"

# For web server 2
echo "-------------------------- Test started ---------------------------------"

sleep 5
search_word="Hello world 1"
website_parsing=$(curl 10.0.20.10)
search_result=$(echo "$website_parsing" | grep -o "${search_word}" | wc -w)
echo $search_result
if [ "${search_result}" -ne "0" ]
then
  echo "Test Passed!"
else
  echo "Test Failed!"
  exit 1
fi

echo "-------------------------- Test finished --------------------------------"
