#AWS


## create an EC2 and connect to AWS remote server

1. setup an EC2 instance

2. download a keypar.pem

3. locate the keypar.pem in your aws working direcotry

4. select EC2 intance > connect > a standlone ssh client

5. cd your aws working direcotry
```bash
cd aws
```

6. change the permission of keypar.pem
```bash
chmod 400 keypar.pem
```

7. connect to the aws remote server
```bash
ssh -i "keypar.pem" ec2-user@xxxxxxx.eu-central-1.compute.amazonaws.com
```

8. create index.html

```bash
[ec2-user@ip-172-31-37-29 ~]$ mkdir code
[ec2-user@ip-172-31-37-29 ~]$ vim index.html
```



```html
<h1>HELLO WORLD</h1>
    <h2>External morphology</h2>
        <h3>Head</h3>
            <h4>Mouthparts</h4>
        <h3>Thorax</h3>
            <h4>Prothorax</h4>
            <h4>Pterothorax</h4>
```


8. run python  server

```bash
python -m SimpleHTTPServer 80
```

9. change the security setup to see the result in the browser

EC2 instance > security groups > edit inbound rules > add rule 

- Tpye: "HTTP"
- Source: 0.0.0.0/0

10. save rule

11. open the URL 

ec2-3-120-157-198.eu-central-1.compute.amazonaws.com


~                                    



