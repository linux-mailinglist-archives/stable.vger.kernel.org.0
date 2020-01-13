Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10FF213898A
	for <lists+stable@lfdr.de>; Mon, 13 Jan 2020 04:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733020AbgAMC7r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Jan 2020 21:59:47 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:54045 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732866AbgAMC7q (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Jan 2020 21:59:46 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id 31E9661D0;
        Sun, 12 Jan 2020 21:59:45 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sun, 12 Jan 2020 21:59:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm2; bh=
        1bZIV+rpNOzTMwIXXxXsvQ8lODr3Ka/3YHY8+jRb82M=; b=Chdyz1apP3+e+cvC
        12aEBQuzaBuUsr490yXbRKDwuJQqpmiucNgh7JAC3pjt6pSnzzTqHjKEBTyB3pMK
        Uyubl9r3in8KUqB8e/QscLtof+F27nwjv3CkZiWxou0C3eKddaUcHDNyoCdF+ANJ
        BcnATrLPwsqbyX5HUep542iVEjUzjWuIhEtcr0tPe1SwXb0bExZAU+pgkT2RbDbj
        biKg7v5uuWYwcEZT2Lm6jGSWau/nQAXXLz0wEigo+tbUUMpS8hULCvM4MNdqhZIn
        AFpJtcipI8lLJAm26CIrSAW+FgyoeyXaAmQOoDUXkjkuNjZZfnL4zec+Co/9k9oS
        +cnbOQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=1bZIV+rpNOzTMwIXXxXsvQ8lODr3Ka/3YHY8+jRb8
        2M=; b=mlXiWZX+hzo6o3irGpo+NQ+g8lfrJ7Ti9i1bbhCxhI0PTKCrJCt1O9AJ+
        Dcob9Ryi56n1/foM3JDt0GksH9zLbF2nrE797jbRBUv3lNfgSk4h38wMoNxOL+L7
        om/b1QmonhbTHAqjhqnh27skjmfOkb+4zxD4wHh2YHm3fyT1J/bGaICzNP3aXAsN
        4bO0mjTLOSu9h3pv/dYIOMEHiLeEE2xjWduaBNSE1RpP02YaY879RmAZ6mak6Clz
        nARboLl4YPJVKG6A+LQqjGal8mc14SF/F8uftv/UU0H7Ut98S0smKb5dAIcLR4ie
        0bCejvZLzV+CascUJKgH4fZV9b/FQ==
X-ME-Sender: <xms:IN0bXqpJZMdycaxtq8DflaUIlVAcdgY8qii7_bEkMLTyWW-vkPu3GQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeiledgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkffuhffvffgjfhgtfggggfesthejredttderjeenucfhrhhomhepkfgrnhcu
    mfgvnhhtuceorhgrvhgvnhesthhhvghmrgifrdhnvghtqeenucfkphepuddukedrvddtle
    drudejhedrvdehnecurfgrrhgrmhepmhgrihhlfhhrohhmpehrrghvvghnsehthhgvmhgr
    fidrnhgvthenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:IN0bXpYiDZYm43p1cZ9X963meTdsWuboqzvZqQXeeOYEX4fxGA9Nkw>
    <xmx:IN0bXoGtt9SOYbvyGZZrtTABWy9PH0ynRCUoujPEnvcqfZRXfN19hQ>
    <xmx:IN0bXhxcoa5ThcqQk8WSAE3wTYg7XVsgfLQUO7JYFysZUh6CrjnoIg>
    <xmx:Id0bXqSuGLGpBQhL54tMHL4QgVWrj3dmeqqwdWwYWNFL_evTzS6ORg>
Received: from mickey.themaw.net (unknown [118.209.175.25])
        by mail.messagingengine.com (Postfix) with ESMTPA id E44DA30600A8;
        Sun, 12 Jan 2020 21:59:39 -0500 (EST)
Message-ID: <800d36a0dccd43f1b61cab6332a6252ab9aab73c.camel@themaw.net>
Subject: Re: [PATCH RFC 0/1] mount: universally disallow mounting over
 symlinks
From:   Ian Kent <raven@themaw.net>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Aleksa Sarai <cyphar@cyphar.com>,
        David Howells <dhowells@redhat.com>,
        Eric Biederman <ebiederm@xmission.com>,
        stable <stable@vger.kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Serge Hallyn <serge@hallyn.com>, dev@opencontainers.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Mon, 13 Jan 2020 10:59:36 +0800
In-Reply-To: <20200112213352.GP8904@ZenIV.linux.org.uk>
References: <20200101144407.ugjwzk7zxrucaa6a@yavin.dot.cyphar.com>
         <20200101234009.GB8904@ZenIV.linux.org.uk>
         <20200102035920.dsycgxnb6ba2jhz2@yavin.dot.cyphar.com>
         <20200103014901.GC8904@ZenIV.linux.org.uk>
         <20200108031314.GE8904@ZenIV.linux.org.uk>
         <CAHk-=wgQ3yOBuK8mxpnntD8cfX-+10ba81f86BYg8MhvwpvOMg@mail.gmail.com>
         <20200108213444.GF8904@ZenIV.linux.org.uk>
         <CAHk-=wiq11+thoe60qhsSHk_nbRF2TRL1Wnf6eHcYObjhJmsww@mail.gmail.com>
         <20200110041523.GK8904@ZenIV.linux.org.uk>
         <979cf680b0fbdce515293a3449d564690cde6a3f.camel@themaw.net>
         <20200112213352.GP8904@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 2020-01-12 at 21:33 +0000, Al Viro wrote:
> On Fri, Jan 10, 2020 at 02:20:55PM +0800, Ian Kent wrote:
> 
> > Yeah, autofs ->d_automount() doesn't return -EISDIR, by the time
> > we get there it's not relevant any more, so that check looks
> > redundant. I'm not aware of any other fs automount implementation
> > that needs that EISDIR pass-thru function.
> > 
> > I didn't notice it at the time of the merge, sorry about that.
> > 
> > While we're at it that:
> >    if (!path->dentry->d_op || !path->dentry->d_op->d_automount)
> >        return -EREMOTE;
> > 
> > at the top of follow_automount() isn't going to be be relevant
> > for autofs because ->d_automount() really must always be defined
> > for it.
> > 
> > But, at the time of the merge, I didn't object to it because
> > there were (are) other file systems that use the VFS automount
> > function which may accidentally not define the method.
> 
> OK...
> 
> > > Unfortunately, there are other interesting questions related to
> > > autofs-specific bits (->d_manage()) and the timezone-related fun
> > > is, of course, still there.  I hope to sort that out today or
> > > tomorrow, at least enough to do a reasonable set of backportable
> > > fixes to put in front of follow_managed()/step_into() queue.
> > > Oh, well...
> > 
> > Yeah, I know it slows you down but I kink-off like having a chance
> 
> Nice typo, that ;-)
> 
> > to look at what's going and think about your questions before
> > trying
> > to answer them, rather than replying prematurely, as I usually do
> > ...
> > 
> > It's been a bit of a busy day so far but I'm getting to look into
> > the questions you've asked.
> 
> Here's a bit more of those (I might've missed some of your replies on
> IRC; my apologies if that's the case):
> 
> 1) AFAICS, -EISDIR from ->d_manage() actually means "don't even try
> ->d_automount() here".  If its effect can be delayed until the
> decision
> to call ->d_automount(), the things seem to get simpler.  Is it ever
> returned in situation when the sucker _is_ overmounted?

In theory it shouldn't need to be returned when there is an
actual mount there.

If there is a real mount at this point that should be enough to
prevent walks into that mount until it's mount is complete.

The whole idea of -EISDIR is to prevent processes from walking
into a directory tree that "doesn't have a real mount at its
base" (the so called multi-mount map construct).

> 
> 2) can autofs_d_automount() ever be called for a daemon?  Looks like
> it
> shouldn't be...

Can't do that, it will lead to deadlock very quickly.

> 
> 3) is _anything_ besides root directory ever created in direct autofs
> superblocks by anyone?  If not, why does autofs_lookup() even bother
> to
> do anything there?  IOW, why not have it return ERR_PTR(-ENOENT)
> immediately
> for direct ones?  Or am I missing something and it is, in fact,
> possible
> to have the daemon create something in those?

Short answer is no, longer answer is directories "shouldn't" ever
be created inside direct mount points.

The thing is that the multi-mount map construct can be used with
direct mounts too, but they must always have a real mount at the
base because they are direct mounts. So processes should not be
able to walk into them while they are being mounted (constructed).

But I'm pretty sure it's rare (maybe not done at all) that this
map construct is used with direct mounts.

> 
> 4) Symlinks look like they should qualify for parent being non-empty;
> at least autofs_d_manage() seems to think so (simple_empty() use).
> So shouldn't we remove the trap from its parent on symlink/restore on
> unlink if parent gets empty?  For version 4 or earlier, that is.  Or
> is
> it simply that daemon only creates symlinks in root directory?

Yes, they have to be empty.

If a symlink is to be used (based on autofs config or map option)
and the "browse" option is used for the indirect mount (browse
only makes sense for indirect autofs managed mounts) then the
mount point directory has to be removed and a symlink created
so it must be empty to for this to make sense.

If it's a "nobrowse" autofs mount then nothing should already
exist, it just gets created.

The catch is that a map entry for which a symlink is to be used
instead of a mount can't be a multi-mount. I'm pretty sure I don't
have sufficient error checking for that in the daemon but I also
haven't had reports of problems with it either.

For a very long time the use of symlinks was not common but when
the amd format map parser was added it made sense to use symlinks
in some cases for those. That was partly to reduce the number of
mounts needed and because I deliberately don't support amd map
entries that provide the multi-mount construct. The way amd did
this looked ugly to me, very much a hack to add a Sun format
mount feature.

As far as keeping the trap flags up to date, I don't.

It seemed so much simpler to just leave the flags in place but,
at that time, symlinks were not used (although it was possible to
do so), now that's changed fiddling with the flags might now make
sense.

As I said on IRC:
"DCACHE_NEED_AUTOMOUNT is set on symlink dentries because, when
->lookup() is called the dentry may trigger a callback to the
daemon that will either create a directory (since, in this case,
one does not already exist) and attempt to mount on it or create
a symlink if the autofs config/map requires it.

I didn't think there would be potential simplification by setting
and clearing the DCACHE_NEED_AUTOMOUNT flag based on it being a
directory (mountpoint) or a symlink so the flag is always left set.
Although, as you point out, symlinks won't actually trigger mounts
so the flag being left set when the dentry is a symlink is due to
lazyness, since there's nothing to gain. If you can see potential
simplification in the VFS code by managing this flag better then
that would be worth while."

> 
> 
> Anyway, intermediate state of the series is in #work.namei right now,
> and some _very_ interesting possibilities open up.  It definitely
> needs more massage around __follow_mount_rcu() (as it is, the
> fastpath in there is still too twisted).  Said that
> 	* call graph is less convoluted
> 	* follow_managed() calls are folded into
> step_into().  Interface:
> int step_into(nd, flags, dentry, inode, seq), with inode/seq used
> only
> if we are in RCU mode.
> 	* ".." still doesn't use that; it probably ought to.
> 	* lookup_fast() doesn't take path - nd, &inode, &seq and
> returns dentry
> 	* lookup_open() and fs/namei.c:atomic_open() get similar
> treatment
> - don't take path, return dentry.
> 	* calls of follow_managed()/step_into() combination returning 1
> are always followed by get_link(), and very shortly, at that.  So
> much
> that we can realistically merge pick_link() (in the end of
> step_into()) with get_link().  That merge is NOT done in this branch
> yet.
> 
> The last one promises to get rid of a rather unpleasant group of
> calling
> conventions.  Right now we have several functions (step_into()/
> walk_component()/lookup_last()/do_last()) with the following calling
> conventions:
> 	-E...	=> error
> 	0	=> non-symlink or symlink not followed; nd->path points to it
> 	1	=> picked a symlink to follow; its mount/dentry/seq has been
> pushed on nd->stack[]; its inode is stashed into nd->link_inode for
> subsequent get_link() to pick.  nd->path is left unchanged.
> 
> That way all of those become
> 	ERR_PTR(-E...)	=> error
> 	NULL		=> non-symlink, symlink not followed or a
> pure
> jump (bare "/" or procfs ones); nd->path points to where we end up
>         string		=> symlink being followed; the sucker's
> pushed
> to stack, initial jump (if any) has been handled and the string
> returned
> is what we need to traverse.
> 
> IMO it's less arbitrary that way.  More importantly, the separation
> between
> step_into() committing to symlink traversal and (inevitably
> following)
> get_link() is gone - it's one operation after that change.  No nd-
> >link_inode
> either - it's only needed to carry the information from pick_link()
> to the
> next get_link().
> 
> Loops turn into
> 	while (!(err = link_path_walk(nd, s)) &&
> 	       (s = lookup_last(nd)) != NULL)
> 		;
> and
> 	while (!(err = link_path_walk(nd, s)) &&
> 	       (s = do_last(nd, file, op)) != NULL)
> 		;
> 
> trailing_symlink() goes away (folded into pick_link()/get_link()
> combo,
> conditional upon nd->depth at the entry).  And in link_path_walk()
> we'll
> have
>                 if (unlikely(!*name)) {
>                         /* pathname body, done */
>                         if (!nd->depth)
>                                 return 0;
>                         name = nd->stack[nd->depth - 1].name;
>                         /* trailing symlink, done */
>                         if (!name)
>                                 return 0;
>                         /* last component of nested symlink */
>                         s = walk_component(nd, WALK_FOLLOW);
>                 } else {
>                         /* not the last component */
>                         s = walk_component(nd, WALK_FOLLOW |
> WALK_MORE);
>                 }
>                 if (s) {
>                         if (IS_ERR(s))
>                                 return PTR_ERR(s);
> 			/* a symlink to follow */
> 			nd->stack[nd->depth - 1].name = name;
>                         name = s;
>                         continue;
>                 }
> 
> Anyway, before I try that one I'm going to fold path_openat2() into
> that series - that step is definitely going to require some massage
> there; it's too close to get_link() changes done in Aleksa's series.
> 
> If we do that, we get a single primitive for "here's the result of
> lookup; traverse mounts and either move into the result or, if
> it's a symlink that needs to be traversed, start the symlink
> traversal - jump into the base position for it (if needed) and
> return the pathname that needs to be handled".  As it is, mainline
> has that logics spread over about a dozen locations...
> 
> Diffstat at the moment:
>  fs/autofs/dev-ioctl.c |   6 +-
>  fs/internal.h         |   1 -
>  fs/namei.c            | 460 ++++++++++++++------------------------
> ------------
>  fs/namespace.c        |  97 +++++++----
>  fs/nfs/nfstrace.h     |   2 -
>  fs/open.c             |   4 +-
>  include/linux/namei.h |   3 +-
>  7 files changed, 197 insertions(+), 376 deletions(-)
> 
> In the current form the sucker appears to work (so far - about 30%
> into the usual xfstests run) without visible slowdowns...

Ok, I'll have a look at that branch, ;)

Ian

