# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

server config_yml(:host), user: config_yml(:user), roles: %w{app}
