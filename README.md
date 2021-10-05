# Installation / Run

## 1. Environment

```cp .env.example .env``` and fill it with your own repository credentials

## 2. SSH

```ssh-keygen -f githosting_rsa``` and add the githosting_rsa.pub it to your GitHub / GitLab SSH settings

## 3. Run the provision (master)

```vagrant provision```

## 4. Run (infra)

```vagrant up```