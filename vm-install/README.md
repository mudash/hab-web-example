# Sample code for integration with HPE OneSphere


Uses the Python language binding package to call HPE OneSphere APIs

## Prerequisites

Python 3.5.2 and above
You can install the latest version from:

```
https://www.python.org/downloads/
```

Install the Requests package

```
http://docs.python-requests.org/en/master/user/install/
```
or
```
sudo pip install requests
```

## Usage

1- Update the configuration for your environment:
  
  a- Copy the onesphere.conf.example to onesphere.conf 
  
  b- Update the onesphere.conf file with your HPE OneSphere and Chef Automate server settings

2- Execute the create-node script
     

     python3.6 create-node demo-webserver -a -v 

   
   The above command will create an AWS VM with name demo-webserver in HPE OneSphere environment
