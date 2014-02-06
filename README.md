# meteor-vagrant

This project creates (by default) a Ubuntu VM with Vagrant to run [`meteor`](http://meteor.com) projects from.

Meteor projects can live under the `meteor` dir, which is a [sync-ed folder](http://docs.vagrantup.com/v2/synced-folders/basic_usage.html) with the VM.

## Provisioning
A `provision-post.sh` file in the `provision` dir, if exists, will run after the main provisioning is done.

Example `provision-post` script:

```sh
echo "Installing node modules"
npm install -g bower meteorite meteor-npm

# clone/ update meteor projects
if [ -d /home/vagrant/meteor/a-project ]; then
	cd a-project && git pull
else
	git clone git@github.com:username/a-project.git
fi
```

## Run meteor
Once your project is pulled down and updated, you can run it with the following steps

```sh
$ vagrant ssh
$ cd meteor/a-project
$ mrt install 	# optional
$ export MONGO_URL=mongodb://localhost:27017/a-db 	# optional
$ meteor
```