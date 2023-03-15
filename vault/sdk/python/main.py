import hvac
import sys

# Authentication
client = hvac.Client(
    url='http://127.0.0.1:8200',
    token='dev-only-token',
)

label="password_hashicorp"

# Writing a secret
for x in range(6):
    create_response = client.secrets.kv.v2.create_or_update_secret(
        path=f'my-secret-password-{x}',
        secret=dict(password=f'{label}_{x}'),
    )

print("Secret written successfully.\n")

# Reading a secret
for x in range(6):
    scret_num = f"SECRET {x}"
    print(scret_num.center(100, "*"),"\n")
    read_response = client.secrets.kv.read_secret_version(path=f'my-secret-password-{x}')
    password = read_response['data']['data']['password']
    print(f"SECRET_NAME: my-secret-password-{x} | PASSWORD: {password} \n")