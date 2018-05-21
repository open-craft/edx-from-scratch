Vagrant boxes for the "Open edX from Scratch" workshop
======================================================

Thanks for your interest in our workshop!

We will have a few hands-on exercises during the workshop.  If you want to follow along with the
exercises, please download and install the Vagrant boxes as described here.  You won't be able to
download the boxes at the conference, since this would put too much load on the wifi network.

The exercises use virtualized Linux machines running on your Laptop.  You will need a decent laptop
with at least some 4 GB of free memory.  The exercises on horizontal scaling may need even more
memory.  Any operating system should do, as long as you can get Vagrant and Virtualbox working.

You first need to install Hashicorp Vagrant following the [installation instructions in Vagrant's
documentation][1].  Please don't use the Vagrant package from your OS distribution, but rather
download the installer directly from the official homepage.

[1]: https://www.vagrantup.com/docs/installation/

In addition, you will also need to install [Virtualbox][2].  We had no problems using the Virtualbox
version that ships with Ubuntu Artful, but your milage may vary.

[2]: https://www.virtualbox.org/

Next, create a new directory and download the `Vagrantfile`:

    curl -OL https://raw.githubusercontent.com/open-craft/edx-from-scratch/master/release/Vagrantfile

Finally you can run

    vagrant up

to download and start the necessary boxes.  Depending on your hardware and internet connection, this
may take a significant time to finish, and it will download approximately 2 GB of data.
