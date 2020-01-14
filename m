Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6FC13A0CF
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 06:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgANF7y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 00:59:54 -0500
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:50999 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725936AbgANF7x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 00:59:53 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id 94EAB808C;
        Tue, 14 Jan 2020 00:59:52 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 14 Jan 2020 00:59:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm2; bh=
        hfX/vQq29sm8h9CFPcu58VExDE6jtSKXUcX35KAhkgc=; b=TX7kp1INE+5wqoGG
        2dS8Lci3evRXmsaBr6Pqfc/H7NeZ8j8WAB99WrrirX0VSl9pDySJ40pejgfyv6tR
        Pf4L1DG5vWZYst91xX8cOqLpNLvqGl7dILUHJ/mJSyG/LYRznKZqT47vYOVtHzYK
        ErzWGITiDIrzs6Oh2iT/FaR7h/fsJ0sVbOvehKm1cJB+1XqX+WkO0vcCrbBP6HQp
        ueiXgLWqufjOM4f5dY2ZmHJc50L3U7vlT+Akdg84nXRczEj5Vx8hLNAfLTvcjwVg
        I5Fd7XQjMcS1yaBfQuTUc54czgaFiMqELjboKY/RoAFw+tLGO4Q3lR+49C8ASh8+
        8+1Z4w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=hfX/vQq29sm8h9CFPcu58VExDE6jtSKXUcX35KAhk
        gc=; b=pfC2hgW1S6aGHeRRLZh50FI6XFlxAz/YvH23cZs1FKkoVMqfRxx+zeJEg
        buE2AveXYsJSs61U0VuDhAz5yPde8bHsc5pmyjvO9OyHN6DrRNUDKJbBJ95WqMV3
        9QsRp6ECp/BXJ6iZi6WoFvnMhV+fcPQ1wIGRnnGa+CUbiWHXq75PwV3zsMV1fxfC
        hwvfXsabduveumYMVHvLSfSe4ysxldZYGqEwHdunaFyUbplSA2n3Dd2vQZLNZ8aI
        0K4xrB3ksaFoizMdo/5tQeFktvOuOZgUJUiwkqbKB31fFWU7r3vgBcB9hXtj7dwC
        FzUF9Mqf4F7vb2XFOiX0xWRixQRiw==
X-ME-Sender: <xms:11gdXvIE27K_H38S--vhJQc-RtpSE7kWUNrBl-BjvnjjiRRYgGdtow>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdejuddgkeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkffuhffvffgjfhgtfggggfesthejredttderjeenucfhrhhomhepkfgrnhcu
    mfgvnhhtuceorhgrvhgvnhesthhhvghmrgifrdhnvghtqeenucfkphepuddukedrvddtle
    drudejhedrvdehnecurfgrrhgrmhepmhgrihhlfhhrohhmpehrrghvvghnsehthhgvmhgr
    fidrnhgvthenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:11gdXrgfD8N45aCScFuMVLwL5wUuHYNxfbvItm6sOV3Cqko4bCcDlw>
    <xmx:11gdXp4pVJxMEp1kK4N-dDTpndGxZSlJblpzjv1RtvTZWFsANIKfoA>
    <xmx:11gdXgPeP4AE5dG4mr9SOxe2VSBxgjhVnFlpTAMJKQZUqXKtxDlQXQ>
    <xmx:2FgdXp-gxBJS0lsQH1Uzf2yCm1XjTMjjcpT8mxhqXnouo-SfN1wwxw>
Received: from mickey.themaw.net (unknown [118.209.175.25])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9CC6C80061;
        Tue, 14 Jan 2020 00:59:46 -0500 (EST)
Message-ID: <1fb8a0e4a763219f0f6cde6023ba89c1774cb854.camel@themaw.net>
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
Date:   Tue, 14 Jan 2020 13:59:42 +0800
In-Reply-To: <d6cad1552171da1eb38c55d1d7b1ff45902b101f.camel@themaw.net>
References: <20200103014901.GC8904@ZenIV.linux.org.uk>
         <20200108031314.GE8904@ZenIV.linux.org.uk>
         <CAHk-=wgQ3yOBuK8mxpnntD8cfX-+10ba81f86BYg8MhvwpvOMg@mail.gmail.com>
         <20200108213444.GF8904@ZenIV.linux.org.uk>
         <CAHk-=wiq11+thoe60qhsSHk_nbRF2TRL1Wnf6eHcYObjhJmsww@mail.gmail.com>
         <20200110041523.GK8904@ZenIV.linux.org.uk>
         <979cf680b0fbdce515293a3449d564690cde6a3f.camel@themaw.net>
         <20200112213352.GP8904@ZenIV.linux.org.uk>
         <800d36a0dccd43f1b61cab6332a6252ab9aab73c.camel@themaw.net>
         <19fa114ef619057c0d14dc1a587d0ae9ad67dc6d.camel@themaw.net>
         <20200114043924.GV8904@ZenIV.linux.org.uk>
         <d6cad1552171da1eb38c55d1d7b1ff45902b101f.camel@themaw.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2020-01-14 at 13:01 +0800, Ian Kent wrote:
> On Tue, 2020-01-14 at 04:39 +0000, Al Viro wrote:
> > On Tue, Jan 14, 2020 at 08:25:19AM +0800, Ian Kent wrote:
> > 
> > > This isn't right.
> > > 
> > > There's actually nothing stopping a user from using a direct map
> > > entry that's a multi-mount without an actual mount at its root.
> > > So there could be directories created under these, it's just not
> > > usually done.
> > > 
> > > I'm pretty sure I don't check and disallow this.
> > 
> > IDGI...  How the hell will that work in v5?  Who will set _any_
> > traps outside the one in root in that scenario?  autofs_lookup()
> > won't (there it's conditional upon indirect mount).  Neither
> > will autofs_dir_mkdir() (conditional upon version being less
> > than 5).  Who will, then?
> > 
> > Confused...
> 
> It's easy to miss.
> 
> For autofs type direct and offset mounts the flags are set at fill
> super time.
> 
> They have to be set then because they are direct mounts and offset
> mounts behave the same as direct mounts so they need to be set then
> too. So, like direct mounts, offset mounts are each distinct autofs
> (trigger) mounts.
> 
> I could check for this construct and refuse it if that's really
> needed. I'm pretty sure this map construct isn't much used by
> people using direct mounts.

Ok, once again I'm not exactly accurate is some of what I said.

It turns out that the autofs connectathon tests, one of the tests
that I use, does test direct mounts with offsets both with and
without a real mount at the base of the mount.

Based on that, I have to say this map construct is meant to be
supported with Sun format maps of autofs (even though I think it's
probably not used much).

So not allowing it is probably the wrong thing to do.

OTOH initial testing with the #work.namei branch shows these are
functioning as required.

Ian

