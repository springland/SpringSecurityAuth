# SpringSecurityAuth

1. [A SpringBoot server running on https](#A-SpringBoot-server-running-on-https)

2. [Web security configuration](#web-security-configuration)

3. [Encrpypt Password](#Encrypt-Password)

4. [Password encoder](#Password-Encoder)  
5. [Multi Factor Authentication](#Multi-Factor-Authentication)
7. [OIDC](#OIDC)
7. [Authorization](#Authorization)



### A SpringBoot server running on https

To setup a https server. Needs to get an certification signed by CA instead of using
self signed

[letssencrypt](https://letsencrypt.org/how-it-works/)

[certbot](https://github.com/certbot/certbot)



***Create certification***

1. create the EC2 instance
2. ssh to it
3. sudo certbot certonly --standalone
4. copy certification to s3 bucket.
5. empty s3 bucket
6. destroy the EC2 instance to save cost


ssh -i key.pem ec2-user@ip


***Renew Certification***

1. create the EC2 instance
2. copy the certification back from s3 to ec2
3. certbot renew --cert-name example.com --webroot-path /path/to/new/location --dry-run
4. certbot renew --cert-name example.com --webroot-path /path/to/new/location --force-renew
5. copy the renewed certification back to s3
6. empty s3 bucket
7. destroy the EC2 instance to 




1. Create A Record for the domain on route 53 map to my PC
2. Setup port forwarding for virtual box 18080 -> 8080 

install certbot
sudo snap install core; sudo snap refresh core
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot

sudo certbot certonly --standalone --preferred-challenges http -d dev.inkuii.com

Successfully received certificate.
Certificate is saved at: /etc/letsencrypt/live/dev.inkuii.com/fullchain.pem
Key is saved at:         /etc/letsencrypt/live/dev.inkuii.com/privkey.pem
This certificate expires on 2022-05-11.
These files will be updated when the certificate renews.
Certbot has set up a scheduled task to automatically renew this certificate in the background.



Use SCP to download the certificate

 1. View it: openssl x509 -in certificate.pem -noout -text
 2. Convert PKCS12 from PEM certificate with Key using openssl : openssl pkcs12 -export -name dev-inkuii -in fullchain.pem -inkey  privkey.pem -out cacerts.p12 
    

update /etc/hosts to add dev.inkuii.com 


### web security configuration


1. Use H2 as user repository 
2. Initialize user list
3. all of the end points requires authenticated user
4. Actuator endpoints are excluded


DaoAuthenticationProvider is using DelegatingPasswordEncoder by default
Logic is  
  1. call JdbcDaoImpl to retrieve User ( bcrypt password) 
  2. get password from UsernamePasswordAuthenticationToken  (plain password)
  3. call passwordEncoder.matches(presentedPassword, userDetails.getPassword()) to compare

InMemoryUserDetailsManager is called by DaoAuthenticationProvider as well

spring encodepassword test
spring encodepassword admin


Using JdbcUserDetailsManager 

curl https://dev.inkuii.com:8443/actuator



### Encrypt Password

Can do the below
1. Use Jaspery
2. Use HashiCorp Valut

### Password Encoder

Use Password Encoder to protect user password
password  + salt , bcrypt

### Multi Factor Authentication
Use google authenticator

### OIDC
Support below OIDC 
- Facebook
- Google
- Github


### Authorization

- method level
- domain object
