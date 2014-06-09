tomcat Cookbook
===============
Installs and configures Tomcat, Java servlet engine and webserver.


Requirements
------------
### Platforms
- Debian, Ubuntu (OpenJDK, Oracle)
- CentOS 6+, Red Hat 6+, Fedora, Amaxon (OpenJDK, Oracle), Scientific Linux 6

### Dependencies
- java
- openssl


Attributes
----------
* `node["tomcat"]["base_version"]` - The version of tomcat to install, default `6`.
* `node["tomcat"]["port"]` - The network port used by Tomcat's HTTP connector, default `8080`.
* `node["tomcat"]["proxy_port"]` - if set, the network port used by Tomcat's Proxy HTTP connector, default nil.
* `node["tomcat"]["ssl_port"]` - The network port used by Tomcat's SSL HTTP connector, default `8443`.
* `node["tomcat"]["ssl_proxy_port"]` - if set, the network port used by Tomcat's Proxy SSL HTTP connector, default nil.
* `node["tomcat"]["ajp_port"]` - The network port used by Tomcat's AJP connector, default `8009`.
* `node["tomcat"]["catalina_options"]` - Extra options to pass to the JVM only during start and run commands, default "".
* `node["tomcat"]["java_options"]` - Extra options to pass to the JVM, default `-Xmx128M -Djava.awt.headless=true`.
* `node["tomcat"]["use_security_manager"]` - Run Tomcat under the Java Security Manager, default `false`.
* `node["tomcat"]["loglevel"]` - Level for default Tomcat's logs, default `INFO`.
* `node["tomcat"]["deploy_manager_apps"]` - whether to deploy manager apps, default `true`.
* `node["tomcat"]["authbind"]` - whether to bind tomcat on lower port numbers, default `no`.
* `node["tomcat"]["max_threads"]` - maximum number of threads in the connector pool.
* `node["tomcat"]["tomcat_auth"]` -
* `node["tomcat"]["user"]` -
* `node["tomcat"]["group"]` -
* `node["tomcat"]["home"]` -
* `node["tomcat"]["base"]` -
* `node["tomcat"]["config_dir"]` -
* `node["tomcat"]["log_dir"]` -
* `node["tomcat"]["tmp_dir"]` -
* `node["tomcat"]["work_dir"]` -
* `node["tomcat"]["context_dir"]` -
* `node["tomcat"]["webapp_dir"]` -
* `node["tomcat"]["lib_dir"]` -
* `node["tomcat"]["endorsed_dir"]` -

### Attributes for SSL
* `node["tomcat"]["ssl_cert_file"]` - SSL certificate file
* `node["tomcat"]["ssl_chain_files"]` - SSL CAcert chain files used for generating the SSL certificates
* `node["tomcat"]["ssl_max_threads"]` - maximum number of threads in the ssl connector pool, default `150`.
* `node["tomcat"]["keystore_file"]` - Location of the file where the SSL keystore is located
* `node["tomcat"]["keystore_password"]` - Generated by the `secure_password` method from the openssl cookbook; if you are using Chef Solo, set this attribute on the node
* `node["tomcat"]["truststore_password"]` - Generated by the `secure_password` method from the openssl cookbook; if you are using Chef Solo, set this attribute on the node
* `node["tomcat"]["truststore_file"]` - location of the file where the SSL truststore is located
* `node["tomcat"]["certificate_dn"]` - DN for the certificate
* `node["tomcat"]["keytool"]` - path to keytool, used for generating the certificate, location varies by platform


Usage
-----
Simply include the recipe where you want Tomcat installed.

Due to the ways that some system init scripts call the configuration, you may wish to set the java options to include `JAVA_OPTS`. As an example for a java app server role:

```ruby
name "java-app-server"
run_list("recipe[tomcat]")
override_attributes(
  'tomcat' => {
    'java_options' => "${JAVA_OPTS} -Xmx128M -Djava.awt.headless=true"
  }
)
```


Managing Tomcat Users
---------------------
The recipe `tomcat::users` included in this cookbook is used for managing Tomcat users. The recipe adds users and roles to the `tomcat-users.xml` conf file.

Users are defined by creating a `tomcat_users` data bag and placing [Encrypted Data Bag Items](http://docs.opscode.com/chef/essentials_data_bags.html) in that data bag. Each encrypted data bag item requires an 'id', 'password', and a 'roles' field. The data bag key is retrieved from the default location `/etc/chef/encrypted_data_bag_secret`.

```javascript
{
  "id": "reset",
  "password": "supersecret",
  "roles": [
    "manager",
    "admin"
  ]
}
```

If you are a Chef Solo user the data bag items are not required to be encrypted and should not be.


License & Authors
-----------------
- Author: Seth Chisamore (<schisamo@opscode.com>)
- Author: Jamie Winsor (<jamie@vialstudios.com>)
- Author: Phillip Goldenburg (<phillip.goldenburg@sailpoint.com>)
- Auther: Mariano Cortesi (<mariano@zauberlabs.com>)
- Author: Brendan O'Donnell (<brendan.james.odonnell@gmail.com>)

```text
Copyright:: 2010-2013, Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
