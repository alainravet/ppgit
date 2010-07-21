[ppgit](http://rubygems.org/gems/ppgit)
=======

For Git-friendly Pair-Programming sessions.    
Sign your commits with your pair 2-part name and email : andy\_john / andy\_john@acme.com    
When you're done, restore your local git config in a snap.

Quick Usage :
-------------

		$ ppgit john andy
		$ ppgit john andy andy_john@acme.com

		$ ppgit clear
		$ ppgit --email_root *@acme.com

remark : 'ppgit' is a synonym of 'git pp' => you can write

		$ git pp john andy
		$ git pp clear


Usage :
-------

#### 1 - When the pairing session starts, quickly set user.name and user.email to the pair values :

		$ ppgit john andy  andy_john@mycompany.com

=> this will update ~/.gitconfig to

		[user]
			name = andy_john
			email = andy_john@mycompany.com
		[user-before-ppgit]
			name = Your Name
			email = your_email@address.com


#### 2 - When the session is finished, restore ~/.gitconfig to your original local values :

		$ ppgit clear

=> will restore your ~/.gitconfig to :

		[user]
			name = Your Name
			email = your_email@address.com

#### 3 - If your team pairs share a common email pattern (ex: ann_bob@acme.com, cid_dan@acme.com), you can specify it once and for all :

		$ ppgit --email_root   *@acme.com

=> you can now use the short syntax :

		$ ppgit bob al
		$ ppgit dan cid

are now equivalent to :

		$ ppgit bob al   al_bob@acme.com
		$ ppgit dan cid  cid_dan@acme.com


#### Tip : use 1 gmail address + n aliases, so you can choose 1 unique gravatar for each pair :

		$ ppgit --email_root   mycompany+*@gmail.com

=> you'll get
        mycompany+ann_bob@gmail.com
        mycompany+bob_cid@gmail.com
        etc..
      for free, and each can have a unique gravatar.


#### Installation :

		$ gem install ppgit

#### Report bugs to <http://github.com/alainravet/ppgit/>

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