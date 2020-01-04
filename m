Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4121C1300CD
	for <lists+stable@lfdr.de>; Sat,  4 Jan 2020 05:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbgADEqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 23:46:44 -0500
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:58353 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725883AbgADEqo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 23:46:44 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id AC1635BA1;
        Fri,  3 Jan 2020 23:46:42 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 03 Jan 2020 23:46:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm2; bh=
        HCNaGSPcsG/VXR/ZGc4UfacOoXszeQnffkbWdr31kHI=; b=qG0FRyTkMaLQRw9m
        g5bp6c86hPWSQj0W9bk3Wh4SxyqhqKAVZlDic8BqrgT2JPhf8zk2dAG1KZPCpMvX
        /cttstJYWhJ7GQwqijTdXv1hyOHhdRyzATEYMnp7fgFIKIcxRpQ1IcoqFgpLqBQr
        EcxXXkTGJjVfzRQ6+TgLsp93FLkf54okuGPAOJDY8pccxYQyDyRQvNw63F8Zyy75
        xwUY0Q3VW6JH0X9s/60VNpBs0+mHRCE5EK9tjEp4jqrhq/WFUCkAMlOb27/pVD0s
        1Mppr+ULCAZjPEEy9rRIWCbqVIhzFlx1P2r2AcT/h3yIB7tNJNivRLB9Di1AbaKU
        zw7s+g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=HCNaGSPcsG/VXR/ZGc4UfacOoXszeQnffkbWdr31k
        HI=; b=cSp5GVwmkkxYOdZn67C8+Bok80xWpoVxlaoJUQT5pW9/TpXZf+nf1GORx
        mSjjRBBsTqTv0bWJKKKFI03YZ3Q5VrTey0DRB7W/fWhU040xzp8NaoU4AMzM92Ik
        6bCTUVsQSvQvhrq0M/s4+RaSQ2KxVvVmuI9FmXoRglaiFh08+VKuF76FEX+kRyKm
        GrocRTeX6MzMsGxEyTYNhaYnVoxB1gFuEoOiT6VQuBoMU1P9VNuwiNmY4e0DS4Xx
        z7d8SNmvDsTSnlL4FD4eSNb3gC57Y7ndqjGIVpr2RjWuRlDyw/zYzDyZjgrnToJo
        taAWeYE9X3MEuTXD+i+RPGLQt1DJg==
X-ME-Sender: <xms:sRgQXqxanBeyWRrNr4letrywvC7ntosMK_o68vHd2WdZ7F_ptjT98A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeggedgjeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkffuhffvffgjfhgtfggggfesthejredttderjeenucfhrhhomhepkfgrnhcu
    mfgvnhhtuceorhgrvhgvnhesthhhvghmrgifrdhnvghtqeenucfkphepuddukedrvddtke
    drudeijedrudelieenucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghm
    rgifrdhnvghtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:shgQXtBzXMhriyM9R3VNKCvVTFLebq6cLHz5K54G8kwDdCkETfzUtA>
    <xmx:shgQXuEP3rVENrZWljP5nDPubZlWzsXQy5qM-F9vdabyrUhD37pFtQ>
    <xmx:shgQXsO9Wjr94TOk_xMblTO3fclx4-SExABRp4w4GhZcRqavCvqSow>
    <xmx:shgQXp-UvCH2_DMj9nw8aPXDPcRq7IgrsuRREvFv10iO_cWulS0L-g>
Received: from mickey.themaw.net (unknown [118.208.167.196])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5D4A330600A8;
        Fri,  3 Jan 2020 23:46:37 -0500 (EST)
Message-ID: <fd0b0b12bcdafa0a40fc80f1fc55ed79ec9e6411.camel@themaw.net>
Subject: Re: [PATCH RFC 0/1] mount: universally disallow mounting over
 symlinks
From:   Ian Kent <raven@themaw.net>
To:     Al Viro <viro@zeniv.linux.org.uk>, Aleksa Sarai <cyphar@cyphar.com>
Cc:     David Howells <dhowells@redhat.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Serge Hallyn <serge@hallyn.com>, dev@opencontainers.org,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Sat, 04 Jan 2020 12:46:33 +0800
In-Reply-To: <20200103014901.GC8904@ZenIV.linux.org.uk>
References: <20191230052036.8765-1-cyphar@cyphar.com>
         <20191230054413.GX4203@ZenIV.linux.org.uk>
         <20191230054913.c5avdjqbygtur2l7@yavin.dot.cyphar.com>
         <20191230072959.62kcojxpthhdwmfa@yavin.dot.cyphar.com>
         <20200101004324.GA11269@ZenIV.linux.org.uk>
         <20200101005446.GH4203@ZenIV.linux.org.uk>
         <20200101030815.GA17593@ZenIV.linux.org.uk>
         <20200101144407.ugjwzk7zxrucaa6a@yavin.dot.cyphar.com>
         <20200101234009.GB8904@ZenIV.linux.org.uk>
         <20200102035920.dsycgxnb6ba2jhz2@yavin.dot.cyphar.com>
         <20200103014901.GC8904@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


It may be a bit off-topic here but, in autofs symlinks can be used
in place of mounts. That mechanism can be used (mostly nowadays) with
amd map format maps.

If I'm using symlinks instead of mounts (where I can) I definitely
don't want these to be over mounted by a mount.

I haven't seen problems like that happening but if it did happen
that would be a bug in automount or user mis-use of some sort.

On Fri, 2020-01-03 at 01:49 +0000, Al Viro wrote:
> On Thu, Jan 02, 2020 at 02:59:20PM +1100, Aleksa Sarai wrote:
> > On 2020-01-01, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > > On Thu, Jan 02, 2020 at 01:44:07AM +1100, Aleksa Sarai wrote:
> > > 
> > > > Thanks, this fixes the issue for me (and also fixes another
> > > > reproducer I
> > > > found -- mounting a symlink on top of itself then trying to
> > > > umount it).
> > > > 
> > > > Reported-by: Aleksa Sarai <cyphar@cyphar.com>
> > > > Tested-by: Aleksa Sarai <cyphar@cyphar.com>
> > > 
> > > Pushed into #fixes.
> > 
> > Thanks. One other thing I noticed is that umount applies to the
> > underlying symlink rather than the mountpoint on top. So, for
> > example
> > (using the same scripts I posted in the thread):
> > 
> >   # ln -s /tmp/foo link
> >   # ./mount_to_symlink /etc/passwd link
> >   # umount -l link # will attempt to unmount "/tmp/foo"
> > 
> > Is that intentional?
> 
> It's a mess, again in mountpoint_last().  FWIW, at some point I
> proposed
> to have nd_jump_link() to fail with -ELOOP if the target was a
> symlink;
> Linus asked for reasons deeper than my dislike of the semantics, I
> looked
> around and hadn't spotted anything.  And there hadn't been at the
> time,
> but when four months later umount_lookup_last() went in I failed to
> look
> for that source of potential problems in it ;-/
> 
> I've looked at that area again now.  Aside of usual cursing at
> do_last()
> horrors (yes, its control flow is a horror; yes, it needs serious
> massage;
> no, it's not a good idea to get sidetracked into that right now),
> there
> are several fun questions:
> 	* d_manage() and d_automount().  We almost certainly don't
> want those for autofs on the final component of pathname in umount,
> including the trailing symlinks.  But do we want those on usual
> access
> via /proc/*/fd/*?  I.e. suppose somebody does open() (O_PATH or not)
> in autofs; do we want ->d_manage()/->d_automount() called when
> resolving /proc/self/fd/<whatever>/foo/bar?  We do not; is that
> correct from autofs point of view?  I suspect that refusing to
> do ->d_automount() is correct, but I don't understand ->d_manage()
> purpose well enough to tell.

Yes, we don't want those on the final component of the path in
umount. The following of a symlink will give use a new path of
some sort so the rules would change to the usual ones for the
new path.

The semantics of following a symlink, be the source a proc entry
or not (I think) should always be the same. If the follow takes
us to an autofs file system (be it a trigger mount or an indirect
mount in an autofs file system) the behaviour should be that of
the autofs file system when we arrive there, from an auto-mount
POV.

The original intent of ->d_manage() was to prevent walks into an
under construction mount and that might not be as simple as mounting
a source on a mount point.

For example take the case of an automount indirect mount map entry
like this:

test    /some/path/one  server:/source/path1 \
        /some/path/two  server2:/source/path2 \
        /some/other/path server:/source/path3 \
        /some/other/path/three server:/source/path4

This entry has no mount at the root of the tree (so called root-less
multi-mount) but walks need to block when it's under construction as
the topology isn't known until the directory tree and any associated
mounts (usually trigger mounts) have been completed.

In this case it's needed to go to ref-walk mode and block until it's
done.

The other (perhaps not so obvious) use of ->d_manage() is to detect
expire to mount races. When an automount is expiring at the same time
a process (that would cause an automount) is traversing the path. The
base (I'll not say root, since the root of the expire might not be the
root of the tree) needs to block the walk until the expire is done.

These multi-mounts are meant to provide a "mount as you go" mechanism
so that only portions of the tree of mounts are mounted or expired at
any one time.

For example, the offsets in the above entry are /some/path/one,
/some/path/two, /some/other/path and /some/other/path/three.

On access to <autofs mount>/test automount is meant to mount trigger
mounts for offsets /some/path/one, /some/path/two and /some/other/path
and mount an offset trigger for /some/other/path/three into the mount
for /some/other/path when it's accessed and that might not happen
during the initial mount of the tree. The reverse being done on umount
in sub-trees of mounts when a nesting point like /some/other/path is
encountered.

But that's something of an aside because in all cases below the root
there will be an actual mount preventing walks into the tree under
nesting point mounts being constructed or expired.

Anyway, returning to the topic at hand, the answer to whether we want
->d_manage()/->d_automount() after a symlink has been followed is
yes, I think, because at that point we could be within a file system
that has automounts of some sort.

But perhaps I'm missing something about the description of the case
above ...

> 	* I really hope that the weird "trailing / forces automount
> even in cases when we normally wouldn't trigger it" (stat /mnt/foo
> vs. stat /mnt/foo/) is not meant to extend to umount.  I'd like
> Ian's confirmation, though.

I can't see any way that the trailing "/" can realte to umount.

It has always been meant to be used to trigger a mount on something
that would otherwise not be mounted and that's the only case I'm
aware of.

> 	* do we want ->d_manage() on following .. into overmounted
> directory?  Again, autofs question...

I think that amounts to asking "can the target of the ../ be in the
process of being constructed or expired at this time" and that's
probably yes. A root-less multi-mount would be one case where this
could happen (although it's not strictly an over-mounted directory).

> 
> 	The minimal fix to mountpoint_last() would be to have
> follow_mount() done in LAST_NORM case.  However, I'd like to
> understand
> (and hopefully regularize) the rules for
> follow_mount()/follow_managed().
> Additional scary question is nfsd iterplay with automount.  For nfs4
> exports it's potentially interesting...

I'm not sure about nfs (and other cross mounting file systems). The
automounting in file systems other than autofs always have a real
mount as the target (AFAIK) so there's an implied blocking that occurs
on crossing the mount point. That's always made the nfs automounting
case simpler to my thinking anyway.

The real problem with nfs automount trees is when the topology of
the exports tree changes while parts of it are in use. People that
have any idea of how nfs cross mounting (and mount dependencies in
general) work shouldn't do that but they do it and then wonder why
things go wrong ...

> 
> 	Ian, could you comment on the autofs questions above?
> I'd rather avoid doing changes in that area without your input -
> it's subtle and breakage in automount-related behaviour can be
> mysterious as hell.

Thanks for the heads up.

As always I can run tests on changes you want to do.
Fortunately that's generally worked out ok for us in the past.

Ian

