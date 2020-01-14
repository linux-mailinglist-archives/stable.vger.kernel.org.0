Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1008813A914
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 13:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728951AbgANMRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 07:17:23 -0500
Received: from wnew2-smtp.messagingengine.com ([64.147.123.27]:47799 "EHLO
        wnew2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726053AbgANMRW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 07:17:22 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.west.internal (Postfix) with ESMTP id 2C2F0490;
        Tue, 14 Jan 2020 07:17:21 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 14 Jan 2020 07:17:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm2; bh=
        +K5zOwuA3yoK1vVndKd2rxLD6c5mO4R3lTKJDznfHvY=; b=iOjCeWYW/AOKr6/l
        nFe/fZ1IwZOV7Su2bT+ZpGLtytwHVRYwJzYO2gizPrFw2kTTbYQd2FqPk/EWTBD5
        tKboXMoUqma3amQF+2NdJRuhl+eExruEsGNf6hja4QELlVh794i2XD0VjvmPCkXi
        MLSiqn8J7P+lmbpGSGQ0qct5Uv9SgrTna62ZWVhej+/TnrkgmQyIYAnAqFDJHNPC
        gAlAwxxTZJGtEANZp4ET+oGlk4WQbOjuFK5ndHqE/CNoP8pu59o9PMi6SdDgpfm2
        UHCGCGnvUlDsPrGh0Vul6dotGtmwv3HMxrNd26ubusXoHORNs0kmM8bouvf7OYXD
        y2bVqg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=+K5zOwuA3yoK1vVndKd2rxLD6c5mO4R3lTKJDznfH
        vY=; b=dNaC0snjmT4LFwdJgfWG/mDnfqdD2bT7g3Udvejc5lqpKQtmPXbzJr9u1
        Enf5uWo0WjHIWSjcitpl/FsyoW8LkG8Xlf31FoUFu93IpbmrzHH6Ck4Eeje+BhBT
        7ykN47zL7TcpDF4LjcmMuZINH7RMwXTRczFyS9e0hvHeOrgKpGA7jify4DMJUQLo
        CsfcgJ9/MBbUCaMGYEMX6wduvEXKEw3PhV3c0ZrJbUcpsYArqmjJ5g7zqcNVNLup
        tZIZo/aTF9TLuGCgrl2c47kyte2lTfxg3de9CRkRjFT+HEFWWoFFi4n6cWNjyjVO
        6NYMdUoU/gQoAc3wwEvtJXsGzuOBA==
X-ME-Sender: <xms:T7EdXhVR0KrPiTTyYHiyHzMr38Po4BGhVuVJpfaZtEd0y9BvJUSbrg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrtddtgddvtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecuffhomhgrihhnpehgihhthh
    husgdrtghomhenucfkphepuddukedrvddtledrudejhedrvdehnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehrrghvvghnsehthhgvmhgrfidrnhgvthenucevlhhushhtvghrufhiii
    gvpedt
X-ME-Proxy: <xmx:T7EdXtbiCejVvLL8f1StPI3zBSwiLot6NUA_4WcZiSQ19z21CX8pJQ>
    <xmx:T7EdXksHJ5qbraTsOpGI96KSOTwciwNOfQGAnsDg1HOTJT1wROx0pA>
    <xmx:T7EdXnlg2nPqIfq4tqrfKbOSaid7xoT1Qemjc43hgD1xM2OaCmsJtg>
    <xmx:ULEdXgj8R3gSgmf6jhpRvKCtkXy98KvP7tfO-Jdk4EGQE3Xu6TIaq5IlyXE>
Received: from mickey.themaw.net (unknown [118.209.175.25])
        by mail.messagingengine.com (Postfix) with ESMTPA id 36C4E80063;
        Tue, 14 Jan 2020 07:17:14 -0500 (EST)
Message-ID: <fca18b4b9e9b5b5bc8610970dfb605458c3acaa0.camel@themaw.net>
Subject: Re: [PATCH RFC 0/1] mount: universally disallow mounting over
 symlinks
From:   Ian Kent <raven@themaw.net>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Aleksa Sarai <cyphar@cyphar.com>,
        David Howells <dhowells@redhat.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Serge Hallyn <serge@hallyn.com>, dev@opencontainers.org,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 14 Jan 2020 20:17:11 +0800
In-Reply-To: <7b2b9f81871898d2b6301a74f2bee85943f21cdc.camel@themaw.net>
References: <20200101030815.GA17593@ZenIV.linux.org.uk>
         <20200101144407.ugjwzk7zxrucaa6a@yavin.dot.cyphar.com>
         <20200101234009.GB8904@ZenIV.linux.org.uk>
         <20200102035920.dsycgxnb6ba2jhz2@yavin.dot.cyphar.com>
         <20200103014901.GC8904@ZenIV.linux.org.uk>
         <20200110231945.GL8904@ZenIV.linux.org.uk>
         <aea0bc800b6a1e547ca1944738ff9db4379098ba.camel@themaw.net>
         <20200113035407.GQ8904@ZenIV.linux.org.uk>
         <41c535d689530f3715f21cd25074eb61e825a5f6.camel@themaw.net>
         <58f9894e51a00ad2a4ac3d4122bf29e7cb6c0d54.camel@themaw.net>
         <20200113133047.GR8904@ZenIV.linux.org.uk>
         <7b2b9f81871898d2b6301a74f2bee85943f21cdc.camel@themaw.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2020-01-14 at 15:25 +0800, Ian Kent wrote:
> On Mon, 2020-01-13 at 13:30 +0000, Al Viro wrote:
> > On Mon, Jan 13, 2020 at 02:03:00PM +0800, Ian Kent wrote:
> > 
> > > Oh wait, for systemd I was actually looking at:
> > > https://github.com/systemd/systemd/blob/master/src/shared/switch-root.c
> > > 
> > > > Mind you, that's not the actual systemd repo. either I probably
> > > > need to look a lot deeper (and at the actual systemd repo) to
> > > > work out what's actually being called.
> > > > 
> > > > > Sigh...  Guess I'll have to dig that Fedora KVM image out and
> > > > > try to see what it's about... ;-/  Here comes a couple of
> > > > > hours
> > > > > of build...
> > 
> > D'oh...  And yes, that would've been a bisect hazard - switch to
> > path_lookupat() later in the series gets rid of that.  Incremental
> > (to be foldede, of course):
> > 
> > diff --git a/fs/namei.c b/fs/namei.c
> > index 1793661c3342..204677c37751 100644
> > --- a/fs/namei.c
> > +++ b/fs/namei.c
> > @@ -2634,7 +2634,7 @@ path_mountpoint(struct nameidata *nd,
> > unsigned
> > flags, struct path *path)
> >  		(err = lookup_last(nd)) > 0) {
> >  		s = trailing_symlink(nd);
> >  	}
> > -	if (!err)
> > +	if (!err && (nd->flags & LOOKUP_RCU))
> >  		err = unlazy_walk(nd);
> >  	if (!err)
> >  		err = handle_lookup_down(nd);
> 
> Ok, so I've tested with the updated patch.
> 
> The autofs connectathon tests I use function fine.
> 
> I also tested sending a SIGKILL to the daemon with about 180 active
> mounts and restarted the daemon to test the function of the ioctls
> that Al was concerned about.
> 
> While the connectathon test expired everything I had 3 mounts left
> after allowing sufficient expire time with the SIGKILL test.
> 
> Those mounts correspond to one map entry that has a mix of NFS
> vers=3 and vers=2 mount options and NFSv2 isn't supported by the
> servers I use in testing.
> 
> I'm inclined to think this is a bug in the automount mount tree
> re-connection code rather than a problem with this patch since
> all the other mounts, some simple and others with not so simple
> constructs, expired fine after automount re-connected to them.
> 
> There are two other map entries that have an NFS vers=2 option but
> they are simple mounts that will fail on attempting the automount
> because the server doesn't support v2 so they don't end up with
> mounts to reconnect to.
> 
> This particular map entry, having a mix of NFS vers=3 and vers=2
> in the offsets of the entry, will lead to a partial mount of the
> map entry which is probably not being handled properly by automount
> when re-connecting to the mounts in the tree.
> 
> So I think the patch here is fine from an autofs POV.

Umm ... unfortunately further testing shows an autofs problem.

It appears to be present in the current kernel (so far I've only
been able to check the current git head and an earlier kernel
but can't remember the version and can't check) so I must have
missed it.

I'm attempting to bisect now but managed to trash the root
file system on my VM. I'll get this done as quickly as I can.

Ian

