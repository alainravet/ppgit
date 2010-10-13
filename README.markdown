[ppgit](http://rubygems.org/gems/ppgit)
=======

![Alt text](http://github.com/alainravet/ppgit/raw/master/doc/ppgit-img3.png)

For Git-friendly Pair-Programming sessions.    
Sign your commits with your pair 2-part name and email : andy\_john / andy\_john@acme.com    
When you're done, restore your local git config in a snap.

Quick Usage :
-------------

		$ ppgit john andy
		$ ppgit clear
		$ ppgit info

		$ ppgit john andy andy_john@acme.com

		$ ppgit ara nva  --email_root base+*@acme.com    # ==>  user.email  =  base+ara_nva@acme.com
        $ ppgit ara nva  --names_separator _and_         # ==>  user.name   =  ara_and_nva  (default = '+')


remark : 'ppgit' is a synonym of 'git pp' => you can write

		$ git pp john andy
		$ git pp clear


Usage :
-------

![Alt text](http://github.com/alainravet/ppgit/raw/master/doc/ppgit-img1.png)

#### 1 - When the pairing session starts, quickly set user.name and user.email to the pair values :

		$ ppgit john andy  andy_john@mycompany.com

=> this will update the .git/config of your project to

		[user]
			name = andy+john
			email = andy_john@mycompany.com
		[user-before-ppgit]
			name = Your Name
			email = your_email@address.com


#### 2 - When the session is finished, restore .git/config to your original local values :

		$ ppgit clear

=> will restore your .git/config to :

		[user]
			name = Your Name
			email = your_email@address.com


#### 3 - TIP : create unique email addresses for each pair based on a common address pattern
		$ ppgit --email_root   base+*@acme.com

=> you can use the short syntax :

		$ ppgit bob al
		$ ppgit dan cid

are now equivalent to :

		$ ppgit bob al   base+al_bob@acme.com
		$ ppgit dan cid  base+cid_dan@acme.com

This info is stored in ~/.gitconfig => it works for all your projects.


#### Tip : use 1 gmail address + n aliases, so you can choose 1 unique gravatar for each pair (see 1st illustration above) :

        # 1: create the gmail address :
        #         mycompany@gmail.com

        # 2: use it as a base for your PP pairs :
        #
		$ ppgit --email_root   mycompany+*@gmail.com

=> you'll get
        mycompany+ann_bob@gmail.com
        mycompany+bob_cid@gmail.com
        etc..
      for free, and each can have a unique gravatar.


#### Installation :

		$ gem install ppgit


#### Update :

You are warned when a new version is available :

![Alt text](http://github.com/alainravet/ppgit/raw/master/doc/ppgit-img2.png)


#### Report bugs to <http://github.com/alainravet/ppgit/>
test
--------------------------------------------------------------------------------

== Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

== Copyright

Copyright (c) 2010 Alain Ravet. See LICENSE for details.
·