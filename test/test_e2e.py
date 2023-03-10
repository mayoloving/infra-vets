import requests
import json
# import pytest

#======================================================================================================

base_url = "http://13.40.17.82:5000"

#==============================/===============================
def test_get_request():
    response = requests.get(base_url + "/")
    assert response.status_code == 200
    # print(response.content)
    
#==============================/pet===============================
def test_get_pet_request():
    response = requests.get(base_url + "/pet")
    assert response.status_code == 200
    json_response = json.loads(response.text)
    print(json_response)
    # print(response.content)
    
def test_post_pet_request():
    file = open("./create.json", "r")
    json_input = file.read()
    request_json = json.loads(json_input)
    print(request_json)

    response = requests.post(base_url + "/pet", request_json)
    print(response.content)
    assert response.status_code == 200
    
#==============================/pet/<id>/===============================
def test_get_petid_request():
    response = requests.get(base_url + "/pet/2")
    assert response.status_code == 200
    print(response.content)

#==============================/update/<id>/===============================
def test_put_petid_request():
    file = open("./update.json", "r")
    json_input = file.read()
    request_json = json.loads(json_input)
    print(request_json)
    
    petid = request_json.get("id")
    print(petid)
    response = requests.post(base_url + "/update/" + str(petid), request_json)
    print(response.content)
    print(response.url)
    assert response.status_code == 200
    
#==============================/delete/<id>/===============================
def test_delete_petid_request():
    file = open("./delete.json", "r")
    json_input = file.read()
    request_json = json.loads(json_input)
    print(request_json)
    
    petid = request_json.get("id")
    print(petid)
    response = requests.post(base_url + "/delete/" + str(petid))
    print(response.status_code)
    assert response.status_code == 200
#/home/yotambenz/Desktop/portfolio-yotambenz/weRvet/test/