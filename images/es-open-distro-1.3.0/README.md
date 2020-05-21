The primary purpose of using this image rather than the stock Opendistro Images is that this image allows you to pre-set the administrators password.  OpenDistro ships with admin/admin as the defualt password.  This image accepts an environmental variable called:
`ES_ADMIN_PASSWORD`
 that, if it is set, will automatically set the admin password to this value.

