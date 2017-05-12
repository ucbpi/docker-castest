# castest
This straightforward Docker container for CAS builds on Apereo's samples:
https://github.com/apereo/cas-overlay-template
https://github.com/apereo/cas-webapp-docker

## Notable Additions

  * Creates and uses a non-root user account (castest) within the container
  * Bypasses the cas-overlay-template build.sh script, so the Maven build and packaging occurs during the final `docker build` step, and running the container involves Java executing the cas.war file
  * Ready for SSL on port 8443 (supply your own java keystore)
  * Sets up a volume, so an external directory can be used to persist the configuration under `/etc/cas`
  * Now includes a pom.xml modified from cas-overlay-template to inject an additional depedency (SAML)
    
    **IMPACT**: This container will no longer build the latest CAS release noted in cas-overlay-template until the override pom.xml is updated to change the `cas.version` value.

## Sample Configuration
The **sampleconfig** directory contains a basic set of configuration files that will launch the CAS application and get it listening on ports 8080 and 8443. None of this is suitable as-is for non-testing use. No real data sources should be configured with this setup, especially not until you replace the publicly available sample encryption bits:

  * A sample Java keystore, `thekeystore`, contains a self-signed "localhost" testing certificate for Tomcat to use to initialize its TLS listener.
  * `cas.properties` contains sample encryptions keys self-generated by a run of CAS

## Build
`docker build -t ucb/castest .`

## Run
`docker run -d -p 8080:8080 -p 8443:8443 -v /srv/castest/data:/etc/cas:z --restart=on-failure:1 --name="castest" ucb/castest`

## Possible Changes

If you need to persist service configurations, you may want to add the second dependency below to the pom.xml that is used from cas-overlay-template.

```
<dependencies>
    <dependency>
        <groupId>org.apereo.cas</groupId>
        <artifactId>cas-server-webapp</artifactId>
        <version>${cas.version}</version>
        <type>war</type>
        <scope>runtime</scope>
    </dependency>
    <dependency>
        <groupId>org.apereo.cas</groupId>
        <artifactId>cas-server-support-json-service-registry</artifactId>
        <version>${cas.version}</version>
    </dependency>
</dependencies>
```
