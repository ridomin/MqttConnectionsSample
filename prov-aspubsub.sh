client=$1

sub_id=d8560037-8993-40ac-b191-4b2d877a9359
rg=rido-aps-bb
name=rido-pubsub

echo "provisioning client $client into $sub_id / $rg / $name"

#props=
az resource create --id "/subscriptions/$sub_id/resourceGroups/$rg/providers/Microsoft.EventGrid/namespaces/$name/clients/$client" --properties '{
    "state": "Enabled",
    "authentication": {
        "certificateSubject": {
            "commonName": "'$client'"
        }
    },
    "attributes": {},
    "description": "This is a test publisher client"
}'