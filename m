Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 734C847222F
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 09:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232797AbhLMIOT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 03:14:19 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:58675 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232799AbhLMIOS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 03:14:18 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id AAC713200583;
        Mon, 13 Dec 2021 03:14:17 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 13 Dec 2021 03:14:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=soQ3ilTPrERLLwBQar8iQeC7XCR
        VdB9rnOUTHZRl9Ks=; b=FD1GTdXMI0g3UCWXjJRTUcwJ8fJckWusUL+UY48LppS
        l4oj8IckVEPdh7qtWWEJ/bIWblAmq+mv9vUauQsNJ3BhnHwo81sjeTDK54J7KuCr
        d5685G/zt+6iG8mBkHqrQm74TwlV+AGPVbfNvzSJ4x+wID6SRNntSxffhbPszXLW
        hOc/Rz0dbFWEF1Zne0UCMRfYiVv1OBvO9a+0bxmrZmd54Rm12+d2ZB9iFnl9kQon
        R9e9wj/KwGhjOHr4jz61SbQshSXR4fV2eSYhYkDXspFX2QTqhK5T4VkdO7PuINTH
        K2BaWraCYhkUCAQzNQVB8Pi50MECndEZwWPdPA/ZMOg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=soQ3il
        TPrERLLwBQar8iQeC7XCRVdB9rnOUTHZRl9Ks=; b=RBodKUEbnZZhq27sw4bVnh
        IYn+oQjYP/CwzNtm3KZ1LFAPtcosgkbBGdB5BpLMMUoTwuLQ8uT7Pec9fcxFG3WG
        QqlZx3vuXSfARif37/BzrP3ziPJNaaDlysnGYLGQiXo+Xzi8gkk4eqPPxAK7zO1X
        JO4sqVgpJU1RwZQs1do/xx6Nj0xhtIBq06KTYJkd38f8teul4TxnO3i7ClCcMgqo
        jAgzbXc5hreG82DGgfwgPxzAZK4zb64jp4aPvI5jWQuXog03MdexK/WBf9dPVuOK
        AO0QVxcf8BTSHmw1RJ7/DeKR8wexxU/WIx1QuUqud4Yab5CwKZQgLSOkzbFPjc3A
        ==
X-ME-Sender: <xms:2QC3YcJskT2rnmW9gzH4lgsYEm-3FNs7jfME48YC5apJ6zHR83vD3A>
    <xme:2QC3YcK2b6UyS3qdsIAVv23CqGUSn9ny9VfFWwHowpXA3u1t85HLfhtPfmSZcyuKa
    0JNdC2NBZwx8A>
X-ME-Received: <xmr:2QC3Yct0-3yr2402yi-KmJYjHqxjMBIpcaX_9HdUHQ6yZYQllUrOAEpFXhswqJ_jPlnsL78zIpsfQ3eSZTAccRXLHWFJQvqv>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrkeejgdduudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:2QC3YZaIBhyWxWOPrNKGCsXVLwS2X2KRzQqBDFwWn-vxx7QyGk-mHQ>
    <xmx:2QC3YTawCgiLexdUYQ1HNCIKGHvySDow5L64Tx6SewNvN1X-6_EatA>
    <xmx:2QC3YVAnjM2u8ls2tz-54qPAB_TPtNxqrZ5i6xiLP2EHVO2mHHmk_w>
    <xmx:2QC3YSW6cAd7aTmZqrYekRN7dj6YrLpQcwYBbIlA5toSrsq1Sv_0mg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 13 Dec 2021 03:14:16 -0500 (EST)
Date:   Mon, 13 Dec 2021 09:14:13 +0100
From:   Greg KH <greg@kroah.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.10 0/5] aio poll fixes for 5.10
Message-ID: <YbcA1RRqrnup6IN+@kroah.com>
References: <20211210234805.39861-1-ebiggers@kernel.org>
 <YbX/JVz768WuoiXd@kroah.com>
 <YbZRe5163BRzb2Vx@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YbZRe5163BRzb2Vx@sol.localdomain>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 12, 2021 at 11:46:03AM -0800, Eric Biggers wrote:
> On Sun, Dec 12, 2021 at 02:54:45PM +0100, Greg KH wrote:
> > On Fri, Dec 10, 2021 at 03:48:00PM -0800, Eric Biggers wrote:
> > > Backport the aio poll fixes to 5.10.  This resolves a conflict in
> > > aio_poll_wake() in patch 4.  It's a "trivial" conflict, but I'm sending
> > > this to make sure it doesn't get dropped.
> > > 
> > > Eric Biggers (5):
> > >   wait: add wake_up_pollfree()
> > >   binder: use wake_up_pollfree()
> > >   signalfd: use wake_up_pollfree()
> > >   aio: keep poll requests on waitqueue until completed
> > >   aio: fix use-after-free due to missing POLLFREE handling
> > > 
> > >  drivers/android/binder.c        |  21 ++--
> > >  fs/aio.c                        | 184 ++++++++++++++++++++++++++------
> > >  fs/signalfd.c                   |  12 +--
> > >  include/linux/wait.h            |  26 +++++
> > >  include/uapi/asm-generic/poll.h |   2 +-
> > >  kernel/sched/wait.c             |   7 ++
> > >  6 files changed, 195 insertions(+), 57 deletions(-)
> > > 
> > > -- 
> > > 2.34.1
> > > 
> > 
> > Thanks for all of the backports, much appreciated and now queued up.
> > 
> > greg k-h
> 
> Thanks!  Can you apply the following commit to 5.15-stable too?  I missed that
> it's needed in 5.15:
> 
> 	commit 4b3749865374899e115aa8c48681709b086fe6d3
> 	Author: Xie Yongji <xieyongji@bytedance.com>
> 	Date:   Mon Sep 13 19:19:28 2021 +0800
> 
> 	    aio: Fix incorrect usage of eventfd_signal_allowed()

Now queued up, thanks.

greg k-h
