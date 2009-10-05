# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_distroaulas_session',
  :secret      => 'd1e4867c01148a8ed9eab10c4558d3f9e455bd6c614dc6fff3e8e4f3fceab605d1b77810a13fa3f0e5b336e19da095adb03b9b4100405c2cb7da1b5565662d80'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
