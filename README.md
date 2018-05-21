# MFA Test

This is a proof-of-concept application designed to test a 2FA (two factor
authentication) system in Rails using the bare minimum, in a "roll your own"
style.

It uses three specific gems, one to create and verify OTP tokens, another to
convert the token to base32, and the last one to join it all together,
generating a QR Code so the user can read the token in his mobile phone.

## Main Requirements:

* Ruby 2.5
* Rails 5.2
* [base32](https://github.com/stesla/base32) gem
* [rotp](https://github.com/mdp/rotp) gem
* [rqrcode](https://github.com/whomwah/rqrcode) gem
* [bootstrap](https://github.com/twbs/bootstrap-rubygem) (for styling only)

## How to get started:

1. Download or clone this repository
2. Install Ruby and run `bundler`
3. Create database with `rails db:setup`
4. If needed, run `rails db:seed`
5. Run the `rails server` and log in as `admin` using the password `admin`
6. Go to `/users/1` (the show view) and activate 2FA
7. Read the QR Code using Google Authenticator or other similar app
8. Copy the given nonce tokens in case you lose access to your phone.

## Features:

There is a `User` model, which only has basic name/password columns, along with
the `mfa_secret` column that stores the 2FA token, if present. If this column
is null, it means the user is not using 2FA, so it won't prompt for this on
login.

Once the user decides to activate the 2FA functionality, a random 32-byte hex
string is generated and stored in the `mfa_secret` column. 10 nonce tokens are
also created at this time, erasing all tokens that might previously exist for
that user. Each nonce token is also a 32-byte random hex string.

The `base32` gem is used to convert this `mfa_secret` to base32, which is
generally required for the TOTP protocol. The `rotp` gem is used to generate
the TOTP URI, which is then used by the `rqrcode` gem to create an SVG image of
the QR Code representing this URI.

When the user logs in, he will need to provide his name and password, and if
those are correct, it will prompt for his 2FA token, which is a time based
token. If the user loses access to this token, he can use one of the 10 nonce
tokens. Once one of these tokens is used, it cannot be reused, so if the user
loses his 2FA access and uses up all of his nonces, he cannot access his account
anymore. Obviously a "production-ready" app will have ways to prevent this.

The `rotp` gem is not only used to generate the TOTP URI, but is also used to
verify the token when the user is logging in. Although this app does not make
use of this feature, `rotp` also allows for time drift (when the system clock
of the server is different from the system clock of the mobile phone).

If the user doesn't want to use 2FA anymore, he can disable it from his user's
show page. The `mfa_secret` token will be erased, along with all of his nonce
tokens.
