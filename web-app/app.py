from flask import Flask, render_template, json, request, redirect, session, flash ,url_for
import os
from datetime import datetime
import subprocess



app = Flask(__name__)
app.secret_key = os.urandom(24)


@app.route('/', methods = ['GET', 'POST'])
def index():
    return render_template('home.html')

@app.route('/compute', methods = ['GET', 'POST'])
def compute():
    region = request.form['inputRegion']
    project = request.form['inputProject']
    name = request.form['inputVPC']
    credentials     = "credentials.json"
    subnet_cidr     = "10.10.0.0/24"
    with open("variables.tfvars","w") as f:
    	f.write("region = "+ "\""+ region + "\"\n")
    	f.write("project = "+ "\""+ project + "\"\n")
    	f.write("name = "+ "\""+ name + "\"\n")
    	f.write("credentials= "+ "\""+ credentials + "\"\n")
    	f.write("subnet_cidr= "+ "\""+ subnet_cidr + "\"\n")


    return redirect('/test')


@app.route('/test', methods = ['GET', 'POST'])
def test():
	# subprocess.call('dir')
	os.system("terraform init")
	os.system("terraform plan")
	return "Terraform Initialized and Planned \n Please run terraform APPLY"


if __name__ == "__main__":
    app.run(debug=True,port=5000)