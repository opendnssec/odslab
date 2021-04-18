"""Extract instance DNS RRs"""

import boto3

ec2 = boto3.client(service_name="ec2")

filters = [{"Name": "tag:Type", "Values": ["signer", "resolver"]}]
response = ec2.describe_instances(Filters=filters)

for r in response.get("Reservations"):
    for i in r.get("Instances"):
        public_ip_address = i.get("PublicIpAddress")

        instance_type = None
        instance_id = None

        for t in i.get("Tags"):
            if t.get("Key") == "Type":
                instance_type = t.get("Value")
            if t.get("Key") == "ID":
                instance_id = t.get("Value")

        if instance_id is not None:
            if instance_type == "teacher":
                print(f"teacher{instance_id} IN A {public_ip_address}")
            elif instance_type == "resolver":
                print(f"resolver{instance_id} IN A {public_ip_address}")
            elif instance_type == "signer":
                print(f"ns{instance_id} IN A {public_ip_address}")
                print(f"group{instance_id} IN NS ns{instance_id}")
