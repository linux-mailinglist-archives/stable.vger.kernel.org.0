Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9022913A1D8
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 08:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729334AbgANHZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 02:25:29 -0500
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:34409 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729145AbgANHZ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 02:25:28 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.west.internal (Postfix) with ESMTP id 10B8B588;
        Tue, 14 Jan 2020 02:25:26 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 14 Jan 2020 02:25:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm2; bh=
        /NSb4tftAi/8pTDnCjJ4L9lPoIhmBX5FSwiZPETnwD0=; b=E+ih20sLIVU+JbJh
        GMonwA3D/ZyhFUdpopjO/xWDrjZbqNO8zR9cLwbWeJr22sMl1zKFbETUElpcnVa7
        AZwG1LxxtTO+ko/gqWu80xN7Zbk/PcLuuDF5nrzNxGUeBFUkpEqytNpRR4zj9jgQ
        MwNA4ZaiNwOlduy0avAJJTt28ITICiZQsmwskuDugVgvIoxc/2fhyOpucVwLenD8
        2rzQRanDG6iaiZ/zm3UAwId6Qy/QndsPopAnMpE0XJzDKxmIWC+jR3WChj0eXaSl
        RECfi2W8F9+zXmaU42/RdbEIQ2LN7taoksGTww8VcWjjFAV+lCAoxfzTQP8br7xQ
        s0mDXA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=/NSb4tftAi/8pTDnCjJ4L9lPoIhmBX5FSwiZPETnw
        D0=; b=Qw7ET2JBhGByLUbuhnMGdCt0ocsN4ZJ1W63vM2d0Zj4VYuzMJCZIEqhmz
        zYRBHMx4dCEm4HJ7vzFDuj6t795vci2ZrwsUNL/Jj2lg1ySSC/H+cKBYRJJx1asc
        JUZAoTc57MJSHGBSIZ7vLbAWVMM+ntQmGprAzzvUdqp/F568NcT3cJEtQ57Dz1vh
        oqsDLvCIknSE7wgxh8i2Tzb/mddOiBj+TXBtXYkQXw5O6oLPt8uMZJh9LIfm4fPY
        QxFCroF3EtV1zts0ra0mRLmvjJ+CjNA29Ry7Y/sHRZgaGtQHBLoR9zOPjctKHmeO
        c9EpvMI9Ex3sMQuNAqxPxiL5LcxIQ==
X-ME-Sender: <xms:5GwdXoyDk01dGhrYk-lUgd_o49kcDsWhhmsFBI9wGmXSUGGMEbGmuQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdejuddguddtiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghn
    ucfmvghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecuffhomhgrihhnpehgih
    hthhhusgdrtghomhenucfkphepuddukedrvddtledrudejhedrvdehnecurfgrrhgrmhep
    mhgrihhlfhhrohhmpehrrghvvghnsehthhgvmhgrfidrnhgvthenucevlhhushhtvghruf
    hiiigvpedt
X-ME-Proxy: <xmx:5GwdXqhQh5_xsQeu5Bt4b-uQgEUgv7L0TE_eUIaS5jxLSehm7Cn-jg>
    <xmx:5GwdXjqLQoGkx49VqXhKNW3LwhcJRZVWB3tgbBYVXmPhM_d299SSBg>
    <xmx:5GwdXpg2yG7pEdPaTNZH7UOTmDXi9-7YFtu76zkYqKd9fZx1BCgcIw>
    <xmx:5WwdXhBRnznhTdSbPNsSDY5dRfJ20UAStkRh6FV2Bpj5Vc-4DtjGta3THcU>
Received: from mickey.themaw.net (unknown [118.209.175.25])
        by mail.messagingengine.com (Postfix) with ESMTPA id D37C730602DB;
        Tue, 14 Jan 2020 02:25:19 -0500 (EST)
Message-ID: <7b2b9f81871898d2b6301a74f2bee85943f21cdc.camel@themaw.net>
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
Date:   Tue, 14 Jan 2020 15:25:15 +0800
In-Reply-To: <20200113133047.GR8904@ZenIV.linux.org.uk>
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
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2020-01-13 at 13:30 +0000, Al Viro wrote:
> On Mon, Jan 13, 2020 at 02:03:00PM +0800, Ian Kent wrote:
> 
> > Oh wait, for systemd I was actually looking at:
> > https://github.com/systemd/systemd/blob/master/src/shared/switch-root.c
> > 
> > > Mind you, that's not the actual systemd repo. either I probably
> > > need to look a lot deeper (and at the actual systemd repo) to
> > > work out what's actually being called.
> > > 
> > > > Sigh...  Guess I'll have to dig that Fedora KVM image out and
> > > > try to see what it's about... ;-/  Here comes a couple of hours
> > > > of build...
> 
> D'oh...  And yes, that would've been a bisect hazard - switch to
> path_lookupat() later in the series gets rid of that.  Incremental
> (to be foldede, of course):
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index 1793661c3342..204677c37751 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -2634,7 +2634,7 @@ path_mountpoint(struct nameidata *nd, unsigned
> flags, struct path *path)
>  		(err = lookup_last(nd)) > 0) {
>  		s = trailing_symlink(nd);
>  	}
> -	if (!err)
> +	if (!err && (nd->flags & LOOKUP_RCU))
>  		err = unlazy_walk(nd);
>  	if (!err)
>  		err = handle_lookup_down(nd);

Ok, so I've tested with the updated patch.

The autofs connectathon tests I use function fine.

I also tested sending a SIGKILL to the daemon with about 180 active
mounts and restarted the daemon to test the function of the ioctls
that Al was concerned about.

While the connectathon test expired everything I had 3 mounts left
after allowing sufficient expire time with the SIGKILL test.

Those mounts correspond to one map entry that has a mix of NFS
vers=3 and vers=2 mount options and NFSv2 isn't supported by the
servers I use in testing.

I'm inclined to think this is a bug in the automount mount tree
re-connection code rather than a problem with this patch since
all the other mounts, some simple and others with not so simple
constructs, expired fine after automount re-connected to them.

There are two other map entries that have an NFS vers=2 option but
they are simple mounts that will fail on attempting the automount
because the server doesn't support v2 so they don't end up with
mounts to reconnect to.

This particular map entry, having a mix of NFS vers=3 and vers=2
in the offsets of the entry, will lead to a partial mount of the
map entry which is probably not being handled properly by automount
when re-connecting to the mounts in the tree.

So I think the patch here is fine from an autofs POV.

Ian

