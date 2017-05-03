#amp4e\_ldap\_tool
Ruby command line script to reconcile computers and groups on Cisco's Amp for Endpoints web portal with local LDAP servers.

##Commands
###AMP
`amp4e_ldap_tool amp`

pings the Amp for Endpoints web portal. We must provide flags to tell amp what we want to receive:

- '-c' gets a list of Computers in the AMP system.
- '-g' gets a list of Groups as AMP sees them
- '-p' gets a list of policies
- '-t' provides any of the above options with formatted output.

###LDAP

Gets information from the LDAP server, using credentials provided in your config file. It also requires some flags to tell it what to get from the server:

- '-c' gets computer names
- '-g' gets computer group names
- '-d' gets the fully distinguished name (LDAP)
- '-t' provides any of the above options with formatted output.


###Make_changes

The command `make_changes` is the workhorse. Calling it on its own:

```
amp4e_ldap_tool make_changes
```

Displays the _dry run_, a list of changes that will be changed shown in aggregate. These changes will be formatted in easy-to-read tables as shown below:

```
+---------------------------------+--------------+
|                 Group Creates                  |
+---------------------------------+--------------+
| Group Name                      | Parent Group |
+---------------------------------+--------------+
| Computers.2k8sso.local          | nil          |
| local                           | nil          |
| 2k8sso.local                    | nil          |
| Domain Controllers.2k8sso.local | nil          |
+---------------------------------+--------------+
+---------------------------------+------------+--------------+
|                         Group Moves                         |
+---------------------------------+------------+--------------+
| Group                           | Old Parent | New Parent   |
+---------------------------------+------------+--------------+
| Computers.2k8sso.local          |            | 2k8sso.local |
| 2k8sso.local                    |            | local        |
| Domain Controllers.2k8sso.local |            | 2k8sso.local |
+---------------------------------+------------+--------------+
+----------------+------------+------------------------+
|                    Computer Moves                    |
+----------------+------------+------------------------+
| # of computers | from group | to group               |
+----------------+------------+------------------------+
| 2              | Protect    | Computers.2k8sso.local |
| 2              | Audit      | Computers.2k8sso.local |
+----------------+------------+------------------------+
``` 

applying the -a option will tell the command to apply the changes, it will prompt the user to continue with a y/n after showing the _dry run_.






##Config File

The config file holds our user/password information for the API/LDAP servers. It follows a specific format and a template is provided below:


```
#config.yml
:ldap:
  :host:
  :domain:
  :credentials:
    :un:
    :pw:
  :schema:
    :filter: "computer"
:amp:
  :host:
  :api:
    :third_party:
    :key:
    :version: "v1"
```
