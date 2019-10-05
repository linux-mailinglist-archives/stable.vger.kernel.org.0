Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1266DCC74F
	for <lists+stable@lfdr.de>; Sat,  5 Oct 2019 04:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbfJECEq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 22:04:46 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:41867 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726215AbfJECEq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 22:04:46 -0400
Received: by mail-io1-f68.google.com with SMTP id n26so17477640ioj.8;
        Fri, 04 Oct 2019 19:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dKFFeqNEIfC6bfYX2MCvoQDPGT0qQ00+CPFZGAhucyY=;
        b=XBe5Lfr1WO/ehyz2z39XQtwaT6/KSwCbVEkv+2+0BqSdThjVgBjDT1cuh1+asCPLPx
         7QTCbGMiz4NzONlXxyuS+vu/g3czW4Fyux9aI/D8wbAdKY+FTdHb/l+Dimq5bdZeEzYD
         4PjV2HAXhU3I46PSY0ygDCaTG+Ru7LcYyB6UX2Am/0LP7qsksngNjNGyBQyIMySnfFN1
         726mZeM8PEajpVSZxXtpNoNmFFOwjt1cIweKDUr1Ruq9U/VrEnc87f0/bqTjY1C9PjRL
         CvHxOHCgL0RXpJQPyzDv17vfNua7aQ2gBTO64mLIXl0NIDm8B29bBrZMGg41IB64Hpze
         Hm2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dKFFeqNEIfC6bfYX2MCvoQDPGT0qQ00+CPFZGAhucyY=;
        b=mjzsRr4SWmviCrF0sh+PRQSqmFbRjNK7kYT2kzNmQj5JqvyhLlrVf7LBeyN3jhS1AL
         DeoUqWbAyNiJKKTtvxhJx56o1hOFGUCsOThIDyVo5dTitoOQRG5tgrhz0F+JiStxMPZ6
         AmPRjasswn86AHBo+I/Qt809pN3/DrKSZbuX9rH7cKN/oOSEtjKOz0TFItuuxCFC1QrH
         7jd+RrCAe67m2XigCBC3W+pY63i6BJPW3dK+/sxaqn1X+b2QwCDEZBaGaojox8kt50Sc
         BjUyeWaWEpXIReBr5wnsO8HvAPCFxeEWmwaLI2oca8yaDmtM6pHKcB0J4H8/l3wVV7rH
         0OBQ==
X-Gm-Message-State: APjAAAXEU5nyCk8HT/pQsQ4iRMDPRrIpOxqM6iVh8XnLJMplcj341cY/
        fz0+p9XccNF0ucDSTry6xFF2BOONymnSDF9TQBw=
X-Google-Smtp-Source: APXvYqwBIAoHkqwaCUKDOqze9cchvM+P00vkTrkL1lxkk2uirCl29/HUsptcngeC6wh302S1+9ApJXpS9WjXydrEuD0=
X-Received: by 2002:a5d:8f02:: with SMTP id f2mr8826897iof.272.1570241084953;
 Fri, 04 Oct 2019 19:04:44 -0700 (PDT)
MIME-Version: 1.0
References: <20191004140503.9817-1-christian.brauner@ubuntu.com>
 <20191004142748.GG26530@ZenIV.linux.org.uk> <20191004143301.kfzcut6a6z5owfee@wittgenstein>
 <20191004151058.GH26530@ZenIV.linux.org.uk> <20191004152526.adgg3a7u7jylfk4a@wittgenstein>
 <20191004160219.GI26530@ZenIV.linux.org.uk> <20191004165428.GA28597@ZenIV.linux.org.uk>
In-Reply-To: <20191004165428.GA28597@ZenIV.linux.org.uk>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 4 Oct 2019 21:04:33 -0500
Message-ID: <CAH2r5msU43=Nc=Az05y9mXwKSpe5YC1gL1KHYiu7eowP+sYZog@mail.gmail.com>
Subject: Re: [cifs] semantics of IPC$ shares (was Re: [PATCH] devpts: Fix NULL
 pointer dereference in dcache_readdir())
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Will Deacon <will@kernel.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amir Goldstein <amir73il@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Varad Gautam <vrd@amazon.de>, Stable <stable@vger.kernel.org>,
        Jan Glauber <jglauber@marvell.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Your questions are interesting and rarely asked.

On Fri, Oct 4, 2019 at 11:57 AM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Fri, Oct 04, 2019 at 05:02:20PM +0100, Al Viro wrote:
>
> >       * (possibly) cifs hitting the same on eviction by memory pressure alone
> > (no locked inodes anywhere in sight).  Possibly == if cifs IPC$ share happens to
> > show up non-empty (e.g. due to server playing silly buggers).
> >       * (possibly) cifs hitting *another* lovely issue - lookup in one subdirectory
> > of IPC$ root finding an alias for another subdirectory of said root, triggering
> > d_move() of dentry of the latter.  IF the name happens to be long enough to be
> > externally allocated and if dcache_readdir() on root is currently copying it to
> > userland, Bad Things(tm) will happen.  That one almost certainly depends upon the
> > server playing silly buggers and might or might not be possible.  I'm not familiar
> > enough with CIFS to tell.
>
> BTW, I would really appreciate somebody familiar with CIFS giving a braindump on
> that.  Questions:
>
> 1) What's normally (== without malicious/broken server) seen when you mount
> an IPC$ share?

IPC$ is for "inter process communication" so is basically an
abstraction for named pipes (used
for remote procedure call queries using the old DCE/RPC standard).

To Windows it is possible to mount IPC$, to Samba you can connect to
the share but
due to a Samba server bug you can't do a query info on "." (the 'root'
of the IPC$ share).


> 2) Does it ever have subdirectories (i.e. can we fail a lookup in its root if it
> looks like returning a subdirectory)?

In Samba you can't query subdirectories on IPC$ because even open of "."
fails, but to Windows the query directory would get "STATUS_INVALID_INFO_CLASS"

An interesting question, and one that I will bring up with the spec
writers is whether
there are info level which would be allowed for query directory (probably not).

Another interesting question this brings up is ... "should we allow
enumerating the 'services' under IPC$
via readdir"?   You could imagine a case where mounting IPC$ would
allow you to see the 'services'
exported by the server over remote procedure call ("server service"
and "workstation server" and "netlogon service"
and the global name space (DFS) service and  perhaps "witness protocol
services" and "branch cache service" etc.)

And then thinking about Dave Howell's changes to the mount API -
should this be a mechanism that is allowed to be
used to either browse the valid shares or better access the root of
the (DFS) global name space.

But the short answer is "no you can't query the directory contents
under IPC$" (at least not without changing the
abstraction that we export on the client) but I am open to ideas if
this would fit with Dave Howell's changes to the
mount API or other ideas.
> 3) If it can be non-empty, is there way to ask the server about its contents?
> Short of "look every possible name up", that is...
>
> As it is, the thing is abusing either cifs_lookup() (if it really shouldn't
> have any files in it) or dcache_readdir().  Sure, dcache_readdir() can (and
> should) pin a dentry while copying the name to userland, but WTF kind of
> semantics it is?  "ls will return the things you'd guessed to look up, until
> there's enough memory pressure to have them forgotten, which can happen at
> any point with no activity on server"?

Server's realistically must expose a share "IPC$" so in theory it can be mounted
(despite Samba server's current bug there) and there were some experiments
that Shirish did a few years ago opening well known services under mounts
to IPC$ (to allow doing remote procedure calls over SMB3 mounts which has
some value) but AFAIK you would never do a readdir over IPC$ and no
current users would ever mount IPC$

-- 
Thanks,

Steve
