---
title: OpenSSH / OpenSSL snippets, the stuff you forget
tags:
- openssh
- snippets
---

{% include toc %}

There are times when you can't remember everything, this post is for those times, when it involves OpenSSH / OpenSSL.

## Adding password to an existing ssh key
```
ssh-keygen -p -f {file_name}
```

## Generating SSL key (RSA 2048-bit SHA2)

```
openssl req -utf8 -nodes -sha256 -newkey rsa:2048 -keyout private.key -out signing_req.csr
```

## Adding password to an existing SSL key (AES256 encryption)

```
openssl rsa -aes256 -in private.key -out private_encrypted.key
```

Remember to (securely) delete the unencrypted `private.key` file!


## Remove password from existing SSL key

```
openssl rsa -in private_encrypted.key -out private.key
```

That's it for now, will add more as I come across them.
