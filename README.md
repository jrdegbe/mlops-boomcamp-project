
# Used Car Price Prediction (MLOps Zoomcamp Project)

![](images/banner.png)

## Problem Statement


The primary goal of this project is to create an end-to-end machine learning solution that covers various stages, 
including feature engineering, model training, validation, tracking, model deployment, production hosting, 
and adherence to general engineering best practices.

The task at hand involves modeling the selling price of used cars based on the features provided in the datasets. 
The resulting model will be utilized by the client to predict the price of their desired car.

## Dataset

The Kaggle dataset 
[derek560/craigslist-carstrucks-data](https://www.kaggle.com/datasets/derek560/craigslist-carstrucks-data) 
is a collection of data on used car prices in Austin,
Texas, scraped from Craigslist. The dataset contains information on various car models, years, and prices, as well
as additional features such as mileage, fuel type, and transmission type.

The Kaggle dataset 
[derek560/craigslist-carstrucks-data](https://www.kaggle.com/datasets/derek560/craigslist-carstrucks-data) 
compiles data on used car prices in Austin, Texas, obtained by scraping Craigslist. 
The dataset comprises details about different car models, years, and prices, along with additional 
features such as mileage, fuel type, and transmission type.

Here's a breakdown of the dataset's structure:

* The dataset contains 426,880 entries and 26 columns.
* The variables include:
  * `id`: a unique identifier for each car listing
  * `manufacturer`: the make of the vehicle
  * `model`: the model of the vehicle
  * `year`: the year of the vehicle
  * `price`: the listing price of the vehicle
  * `odometer`: the mileage on the vehicle
  * `fuel`: the fuel method of the vehicle (e.g., gasoline, diesel, hybrid)
  * `transmission`: the car's transmission type (e.g., automatic, manual)
  * `posting_date`: the listing date of the vehicle on Craiglist

## Design & flow architecture

The architecture below depicts the system design:

:x: Section to complete.

## Repository Organization

Our repository organization is shown below. 

* The `notebooks` folder contains ...
* The `infrastructure` folder contains ...
* The `eval` folder contains all ...
* The `inference` folder contains ...

```
mlops-project
├── terraform
│   ├── modules 
│   │   ├── ec2

```

:x: Section to complete.

## Instructions

Here are the instructions for set up an AWS EC2 instance and executing the code on it.

### Step 1: Create an AWS Account

Go to the [AWS Management Console](https://aws.amazon.com/console/). 
Click on **Create an AWS Account** and follow the provided steps to create your AWS account.

Once you have created your account, log in to the **AWS Management Console**.

Select your **Default Region** from the available options. For example, if you are in the UK, you can 
choose `eu-north-1` as your default region.

If you are uncertain about the specific region to select, you can refer to 
the [AWS Regions and Availability zones](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html) 
documentation to find your region name based on your location.

### Step 2: Create a user

Navigate to the **IAM** section, access the **IAM dashboard**, and click on the number displayed under **Users** in the **IAM resources** section.

![s16](images/s16.png)

Click the **Add users** button, input `mlops-boomcamp` as the **User name**, click **Next**, proceed by clicking **Next** again, and finally, click the **Create user** button.

<table>
    <tr>
        <td>
            <img src="images/s17.png">
        </td>
        <td>
            <img src="images/s18.png">
        </td>
    </tr>
</table>

Choose the `mlops-boomcamp` user, and you should see something similar to the following.

![s19](images/s19.png)

Click on the **Permissions** tab, and then click the **Add permissions** button.
Choose **Attach policies directly**.
Search for and select **AdministratorAccess**.
Next, click on the **Next** button, and finally, click the **Add permissions** button.

### Step 3: Create AWS credentials

In the AWS console, choose the `mlops-boomcamp` user.
Click on the **Security credentials** tab, and then click the **Create access key** button.
Select **Command Line interface (CLI)**, confirm your selection, click **Next**, and finally, click the **Create access key** button.

<table>
    <tr>
        <td>
            <img src="images/s20.png">
        </td>
        <td>
            <img src="images/s21.png">
        </td>
    </tr>
</table>

You should see something like this.

![s22](images/s22.png)

Please make sure to write down your **Access key** and **Secret access key** and store them in a secure location.
If you happen to lose them, it's important to note that they cannot be recovered. In such a case, you will need to generate a new API key.

### Step 4: Install and configure AWS CLI

Terraform requires the AWS CLI to be installed for making API calls. 
Follow [these instructions](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) 
to install the AWS CLI and configure it with your access key and secret key.

Please verify the installation.

```bash
$ which aws
/usr/local/bin/aws
$ aws --version
aws-cli/2.13.0 Python/3.11.4 Darwin/22.5.0 exe/x86_64 prompt/off
```

Configure AWS CLI with your AWS **Access key** and **Secret access key**.

```bash
$ aws configure
AWS Access Key ID [None]: xxxxxxxxxxxxxxxxxxxx
AWS Secret Access Key [None]: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
Default region name [ca-central-1]: 
Default output format [None]:
```

Verify the AWS configuration.

```bash
$ aws sts get-caller-identity
{
    "UserId": "xxxxxxxxxxxxxxxxxxxxx",
    "Account": "xxxxxxxxxxxx",
    "Arn": "arn:aws:iam::xxxxxxxxxxxx:user/mlops"
}
```

Make sure to write down your **ARN** (Amazon Resource Name) associated with the 
calling identity, as you will need it later for configuring your AWS S3 bucket.

### Step 5: Create S3 Bucket

We need to create an S3 bucket manually because Terraform won't create it automatically for us.

To create an S3 bucket manually, follow these steps:

1. Go to the [AWS Console](https://aws.amazon.com/console/) and navigate to the **S3** section.
2. If you don't have any existing S3 Buckets, click on **Create bucket** to initiate the creation process.
3. Enter `tf-state-mlops` as the **Bucket name** and, if needed, select the appropriate **AWS Region**.
4. Click on **Create bucket** to create the S3 bucket.

<table>
    <tr>
        <td>
            <img src="images/s23.png">
        </td>
        <td>
            <img src="images/s24.png">
        </td>
    </tr>
</table>

Click on the newly created bucket in the AWS S3 console. Select the **Permissions** tab.
Click on **Edit** under the **Bucket policy** section.

Add the following bucket policy:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "<your_user_arn>"
            },
            "Action": "s3:ListBucket",
            "Resource": "<your_bucket_arn>"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "<your_user_arn>"
            },
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": "<your_bucket_arn>/*"
        }
    ]
}
```

Ensure to replace `<your_user_arn>` and `<your_bucket_arn>` with the correct values.

Replace `<your_user_arn>` with the `UserId` obtained earlier by running `aws sts get-caller-identity`.

Replace `<your_bucket_arn>` with the **Bucket ARN** available in the **Properties** tab of the S3 bucket (e.g., `arn:aws:s3:::tf-state-mlops-zoomcamp`).

![s25](images/s25.png)

You should see something like this.

![s26](images/s26.png)

Click on the **Save changes** button after making the necessary modifications to the Bucket policy in the AWS S3 console.

### Step 6: Create key pair using Amazon EC2

To create a key pair using Amazon EC2, execute the following command to generate 
the key pair and save the private key to a `.pem` file. Afterwards, adjust 
the file permissions to safeguard it against accidental overwriting.

To create a key pair using Amazon EC2, execute the following command to generate 
the key pair and save the private key to a `.pem` file. Afterward, modify the 
file permissions to grant read-only access to the file owner while denying 
any access to the group and others.

```bash
aws ec2 create-key-pair \
    --key-name razer \
    --key-type rsa \
    --key-format pem \
    --query "KeyMaterial" \
    --output text > ~/.ssh/razer.pem
chmod 400 ~/.ssh/razer.pem
```

> [!NOTE]  
> If you get an error, you can decode the encoded AWS error message with the following command: <br>
> `aws sts decode-authorization-message --encoded-message`<br>
> See [decode-authorization-message](https://docs.aws.amazon.com/cli/latest/reference/sts/decode-authorization-message.html).

### Step 7: Install Terraform CLI

Download and install Terraform CLI from the [official website](https://www.terraform.io/downloads.html).

To install Terraform on macOS, run this command.

```bash
$ brew install terraform
$ terraform --version
Terraform v1.5.4
on darwin_arm64
```

### Step 8: Clone repository

Clone this [repository](https://github.com/boisalai/mlops-zoomcamp-project.git) on your local machine.

```bash
git clone 
cd mlops-project
```

### Step 9: Adjust Terraform settings

Adjust Terraform settings as follows:

1. In the `infrastructure/variables.tf`, update the `aws_region` variable with your default region.
2. In the `infrastructure/main.tf`, modify the region setting for the S3 bucket.
3. In the `infrastructure/modules/ec2/variables.tf`, update the `ingress_cidr_blocks` variable with your public IP address followed by `/32`.

If you are uncertain about your public IP address, open a web browser and type "what is my IP address" 
into the browser's address bar. The browser will display your public IP address. 
Now, adjust the variable setting to include a subnet mask of `/32` like this: `1.2.3.4/32`.

### Step 10: Create AWS resources

Run the `terraform init` command to initialize the Terraform configuration and 
download any required plugins or modules specified in the configuration files. 

```bash
cd infrastructure
terraform init
```

You should see this.

![s27](images/s27.png)

Run `terraform validate` to validate the AWS provisioning code.

```bash
terraform validate
```

Run `terraform plan` to check the current state of your infrastructure and review the changes that Terraform will apply. 

```bash
terraform plan 
```

If you are satisfied with the plan summary, you can proceed to apply the configuration 
using the `terraform apply` command. Terraform will prompt you to confirm if you want to execute the planned actions. 
Respond with a `yes` to allow Terraform to carry out the changes.

```bash
terraform apply
```

This command may take a few minutes to complete as it not only creates the EC2 instance 
but also installs conda, docker, make, clones the repository, creates a conda environment, 
and installs the necessary packages.

Next, go to the [AWS Management Console](https://aws.amazon.com/console/) and navigate to the **EC2** section. 
Under **Resources**, click on **Instances (running)**. Select the `mlops-zoomcamp-ec2` instance, and 
then copy the **Public IPv4 address**. You will need it to connect to the instance.

### Step 11: Connect to EC2 instance

To connect to your EC2 instance, follow these 
[instructions](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstancesLinux.html) 
to use an SSH client, AWS CLI, or SCP client.

Use the following command to SSH into your EC2 instance:

```bash
ssh -i ~/.ssh/razer.pem ubuntu@your-ec2-public-ip
```

Replace `your-ec2-public-ip` with the public IP address of your EC2 instance.
When prompted, answer `yes` to continue connecting.

We are now connected to the remote service.
You should see this.

![MLOps](images/s07.png)

Enter `logout` to close the connection.

```bash
logout
```

You don't need to run the previous command every time. Simply create a configuration file `~/.ssh/config` with the following content.
Replace `your-ec2-public-ip` with the public IP address of your EC2 instance.

```bash
Host mlops-zoomcamp
    HostName your-ec2-public-ip
    User ubuntu
    IdentityFile ~/.ssh/razer.pem
    StrictHostKeyChecking no
```

Now, you can connect to your instance using this command.

```bash
ssh mlops-zoomcamp
```

Please note that every time you stop and restart the instance, the public IP address may change. 
Therefore, you should ensure that you use the updated public IP address when connecting to the instance after each restart.

### Step 12: Connect VS Code to your instance (optional)

To connect Visual Studio Code (VS Code) to your instance:

1. Open VS Code on your local machine.
2. Find and install the **Remote - SSH** extension in VS Code.
3. Open the **Command Palette** using `Shift+Cmd+P` (on macOS) or `Shift+Ctrl+P` (on Windows/Linux).
4. Select **Remote-SSH: Connect to Host**​ from the options.
5. Choose the configured SSH host named `mlops-boomcamp`.
6. Open the `mlops-boomcamp-project` folder in VS Code and click on **OK** to establish the connection.

We should see this.

![s08](images/s08.png)

### Step 13: Start Jupyter notebook (optional)

Use the following command to SSH into your EC2 instance. 
Replace `your-ec2-public-ip` with the public IP address of your EC2 instance. 
Answer `yes` to the question.

```bash
ssh -i ~/.ssh/razer.pem -L localhost:8888:localhost:8888 ubuntu@your-ec2-public-ip
```

On the remote instance, execute the following commands:

```bash
cd mlops-project
conda activate mlops-zoomcamp
sudo chown -R ubuntu /home/
sudo chown -R ubuntu ~/.local/share/jupyter/
jupyter notebook
```

Copy and paste the second URL, starting with `http://127.0.0.1:8888/tree?token=`, 
to your local browser to access Jupyter notebook on your EC2 instance.

You should see this.

:x: Section to complete. Insert an image.

You could have opened port 8888 using VS Code.

To do this:

1. In VS Code connected to your instance, open a terminal by using either **Terminal > New Terminal** or **View > Terminal** from the menu.
2. Select **PORTS**, click on **Forward a Port**, and open port `8888`.

![s09](images/s09.png)

Now, copy and paste one of the URLs (for example, `http://localhost:8888/?token=c8de56fa...`) 
into your web browser. You should see that Jupyter notebook is up and running.

![s10](images/s10.png)

### Step 14: Authentication to use the Kaggle's public API

The `kaggle.json` file serves as authentication for API requests to the Kaggle service, containing the necessary credentials for interacting with Kaggle datasets, competitions, and other resources programmatically.

To obtain the `kaggle.json` file, follow these steps:

1. Navigate to https://www.kaggle.com and log in.
2. Go to the [Account tab of your user profile](https://www.kaggle.com/me/account) and select "Create API Token." This action will trigger the download of the `kaggle.json` file, which contains your API credentials.

Once you have the `kaggle.json` file downloaded, load it to your instance using the following command, after modifying the **Public IPv4 DNS** with your instance's value.

```bash
scp -i ~/.ssh/razer.pem ~/downloads/kaggle.json ubuntu@ec2-3-99-132-220.ca-central-1.compute.amazonaws.com:~/mlops-zoomcamp
```

This command will copy the `kaggle.json` file from your local machine to the `mlops-zoomcamp` directory on your instance.

### Step 15: Start Prefect

Start a local Prefect server by running the following.

```bash
conda activate mlops-zoomcamp
prefect server start
```

You should see this.

```txt
 ___ ___ ___ ___ ___ ___ _____ 
| _ \ _ \ __| __| __/ __|_   _| 
|  _/   / _|| _|| _| (__  | |  
|_| |_|_\___|_| |___\___| |_|  

Configure Prefect to communicate with the server with:

    prefect config set PREFECT_API_URL=http://127.0.0.1:4200/api

View the API reference documentation at http://127.0.0.1:4200/docs

Check out the dashboard at http://127.0.0.1:4200
```

Open another terminal window and run the following commands to set the Prefect API URL.

```bash
$ conda activate mlops
$ prefect config set PREFECT_API_URL=http://localhost:4200/api
```

You should see this.

```txt
Set 'PREFECT_API_URL' to 'http://127.0.0.1:4200/api'.
Updated profile 'default'.
```

Open the Prefect Dashboard at http://127.0.0.1:4200. You should see this.

![s11](images/s11.png)

### Step 16: Start MLflow UI

```bash
$ mlflow ui --backend-store-uri sqlite:///mlflow.db
```

Then, open the MLflow UI on http://127.0.0.1:5000/. You should see this.

![s12](images/s12.png)

### Step 17: Train the model

In another terminal, run the following commands.

```bash
$ conda activate mlops
$ make train
```

This step involves the following tasks:

* Downloading the data from Kaggle.
* Performing feature engineering on the data.
* Preparing the datasets for training.
* Training the model using multiple hyperparameter combinations.
* Re-training the model using the best hyperparameters.
* Registering the model in the MLFlow staging area.
* All of these tasks are orchestrated using Prefect.
  
You should see something like this.

<table>
    <tr>
        <td>
            <b>Terminal<b><br>
            <img src="images/s13.png">
        </td>
        <td>
            <b>Prefect Dashboard<b><br>
            <img src="images/s14.png">
        </td>
        <td>
            <b>Prefect Dashboard<b><br>
            <img src="images/s15.png">
        </td>
    </tr>
</table>

### Step 13: Test

```bash
$ make test
```

TODO

### Step 18: Deploy the model

```bash
$ make deploy 
```

### Step 19: Destroy your image

Avoid unnecessary charges in your AWS account by destroying your instance in Terraform.

```bash
terraform destroy -auto-approve
```