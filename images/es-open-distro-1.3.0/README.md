## Open Distro 1.3.0

The primary purpose of difference between this image and the stock Opendistro Images is that this image allows you to pre-set the administrator's password.  OpenDistro ships with `admin/admin` as the defualt password.  This image accepts an environmental variable called:
`ES_ADMIN_PASSWORD`
 that, if it is set, will automatically set the admin password to this value.

