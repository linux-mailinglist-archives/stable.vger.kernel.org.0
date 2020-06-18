Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 032371FF91B
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 18:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731419AbgFRQUV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 12:20:21 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:43765 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731272AbgFRQUT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jun 2020 12:20:19 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 5BFCE9DC;
        Thu, 18 Jun 2020 12:20:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 18 Jun 2020 12:20:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=bKAgU9Oxq8QXVJcTScdmwec0q1r
        e2i5vvyKAFg1zaOY=; b=CGmAvFXCyPsAXG4DcJTxKLca3vc8IDFHWH8w+1KQnsq
        y7KExA1WXy6uWNaqDtrMHDHw9/EDyLqAIXHn55h0N9MCinb332GvNGxo5lUr9aMd
        Uqg3NS2Cks350y0ID9dt2MkuFxOsqh2993yeh5HW4V02QfHzGFCKLUosjzQZEXc2
        3WVH2EMNpL2AkAojSwkXMEbX+sghr+v5JFsDvF+1mtSSaH5L2qCYDrxsJ1lgkGz/
        D5lD7rJPSVdvXGGYUHNLoeJ26+htywqg7OSkf3zmVaXZp7zX9i0dkCLly8d+4MyQ
        RwgE5orYPe4xL5XvLYaVhhXtWfk4ZYDH8lxWiiekVIA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=bKAgU9
        Oxq8QXVJcTScdmwec0q1re2i5vvyKAFg1zaOY=; b=Ider3twNqsbBTaiqPksemc
        wEcIOXL517wHPrulXRTpwtgVRqFGXBM+9vK+P+pzLt39SV4TYA0Een1cAyKJ+dHI
        faqZiAgThe6V8gJiDwakJZfA+hRsY23Vp0369r6gQO+W17wtlxaQQD8teY5GRDn7
        0QHITkcnV+y/74Mr3Gc3LHPl8jURcxPReo9wzIcquKUEIp1V0Ui0w7yZyOFeyBLN
        l5FRNKrc2jGLvGRNWn1bV1hL5i/WBBqrf5vFbfPLejeOfLaeZEGPMUkN+7OHLPSM
        n6sjdqj3zMhDzvppbNTh4n2p/ETCDChXo4pAwVWP5RhigzJRpfOguPgv/tAHWRtg
        ==
X-ME-Sender: <xms:QZTrXmsapkNplypIxy2EUaHI3Uuu6o1BOAdNaw-9hxJ5dXILawOF9w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejgedguddttdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepieeile
    dttdduleduvdeugeetvdefvdeifeegkeelffetudeggefgudektdetvdfhnecuffhomhgr
    ihhnpeifihhkihhpvgguihgrrdhorhhgpdgurghrihhnghhfihhrvggsrghllhdrnhgvth
    dpkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:QZTrXrd9D3aKRQ2GkLdekt8pdTYtCBx48Rf5vpD6UaTf-J9TZnslkA>
    <xmx:QZTrXhxJn72nWTtx8oaBhHA9c97TxtND-SwHI8GKwqQ2oMfJ6zKtIg>
    <xmx:QZTrXhO1NMv0WA8VDMr46QgQ1biShs1LZ0Rs0ww7DGoutwkRH3Yrjg>
    <xmx:QpTrXrHtSX3CBv8SOa1x6JA39chmHD3Y_TAgUkx49BFvf2a_alO-JQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5BEC73280063;
        Thu, 18 Jun 2020 12:20:17 -0400 (EDT)
Date:   Thu, 18 Jun 2020 18:20:07 +0200
From:   Greg KH <greg@kroah.com>
To:     Giuliano Procida <gprocida@google.com>
Cc:     stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] blk-mq: sync the update nr_hw_queues with
 blk_mq_queue_tag_busy_iter
Message-ID: <20200618162007.GA4099492@kroah.com>
References: <20200608093950.86293-1-gprocida@google.com>
 <CAGvU0HmbWA5aKZ-8jnYgaQGbfcVzGsGo7pm2Rf+ZfG8dHro_Bw@mail.gmail.com>
 <CAGvU0H=Gd5CUMMW35wBFV=ZaE4u6aiu3VKPCiJNujGcwOvy3WA@mail.gmail.com>
 <20200618073258.GA3856402@kroah.com>
 <CAGvU0HmmV9+bkavHqB7TPbGwgUWvygLfWrCCmLmJ0uVOSHXoQQ@mail.gmail.com>
 <20200618145904.GB3017232@kroah.com>
 <CAGvU0HkAXae67ABKZQfjyc99u1ojeTmDTcykQa1O4jJ4B9iC4A@mail.gmail.com>
 <20200618160514.GA3539988@kroah.com>
 <CAGvU0HkDEecRdZgYwQJOcj7DM+cU4i-OQ+oxTV+Lbq_6X+YATw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGvU0HkDEecRdZgYwQJOcj7DM+cU4i-OQ+oxTV+Lbq_6X+YATw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 18, 2020 at 05:14:23PM +0100, Giuliano Procida wrote:
> Hi.
> 
> On Thu, 18 Jun 2020 at 17:05, Greg KH <greg@kroah.com> wrote:
> >
> > On Thu, Jun 18, 2020 at 04:35:03PM +0100, Giuliano Procida wrote:
> > > Hi.
> > >
> > > On Thu, 18 Jun 2020 at 15:59, Greg KH <greg@kroah.com> wrote:
> > > >
> > > > On Thu, Jun 18, 2020 at 10:16:45AM +0100, Giuliano Procida wrote:
> > > > > Hi.
> > > > >
> > > > > On Thu, 18 Jun 2020 at 08:33, Greg KH <greg@kroah.com> wrote:
> > > > > >
> > > > > >
> > > > > > A: http://en.wikipedia.org/wiki/Top_post
> > > > > > Q: Were do I find info about this thing called top-posting?
> > > > > > A: Because it messes up the order in which people normally read text.
> > > > > > Q: Why is top-posting such a bad thing?
> > > > > > A: Top-posting.
> > > > > > Q: What is the most annoying thing in e-mail?
> > > > > >
> > > > > > A: No.
> > > > > > Q: Should I include quotations after my reply?
> > > > > >
> > > > > > http://daringfireball.net/2007/07/on_top
> > > > > >
> > > > > > :)
> > > > >
> > > > > I'm well aware of the above.
> > > > > Alas, I haven't used mutt properly in about 15 years and I'm still
> > > > > doing everything with Gmail.
> > > >
> > > > gmail can handle proper quoting, if you are stuck with that :)
> > > >
> > > > > Given that I was referring to the entire email thread, I punted on
> > > > > finding a place to insert a comment.
> > > > > BTW, there's a typo in the Q&A above. s/Were/Where/
> > > >
> > > > Ah, nice catch, first one to notice that in years!
> > > >
> > > > > > On Thu, Jun 18, 2020 at 08:27:55AM +0100, Giuliano Procida wrote:
> > > > > > > Hi Greg.
> > > > > > >
> > > > > > > Is this patch (and the similar one for 4.9) queued?
> > > > > >
> > > > > > f5bbbbe4d635 ("blk-mq: sync the update nr_hw_queues with
> > > > > > blk_mq_queue_tag_busy_iter") is in the following stable releases:
> > > > > >         4.4.224 4.9.219 4.14.176 4.19
> > > > > >
> > > > > > Do you not see it there?
> > > > >
> > > > > We are referring to different "it"s.
> > > > >
> > > > > Yours: f5bbbbe4d635 is the upstream patch that went into v4.19-rc1 and
> > > > > which you back-ported to at least some of these kernels. This is
> > > > > clearly there.
> > > >
> > > > Great.
> > > >
> > > > > Mine: the commit sent earlier in this email thread - it's a
> > > > > re-back-port, as I think the original back-port for 4.14 (and
> > > > > similarly for 4.9) is incorrect. This has clearly not reached public
> > > > > git, hence my question about whether the change was queued.
> > > >
> > > > I don't know what the git commit id you are looking for here, sorry.  I
> > > > don't have the whole thread anywhere.
> > > >
> > > > > These are the ids of messages containing my commits:
> > > > >
> > > > > 4.14: 20200608093950.86293-1-gprocida@google.com
> > > > > 4.9: 20200608094030.87031-1-gprocida@google.com
> > > >
> > > > Pointers to this on lore.kernel.org perhaps?
> > > >
> > >
> > > I wasn't aware stable was publicly archived. Here you go:
> > >
> > > 4.14: https://lore.kernel.org/stable/20200608093950.86293-1-gprocida@google.com/
> > > 4.9: https://lore.kernel.org/stable/20200608094030.87031-1-gprocida@google.com/
> >
> > As per the git commit id in those emails, you should be able to
> > determine the same thing that I can, namely that that patch is in the
> > following stable releases:
> >         4.4.224 4.9.219 4.14.176 4.19
> 
> Both those commits contain the text:
> 
> "Backporting Notes
> 
> This is a re-backport, landing synchronize_rcu in the right place."
> 
> If there's a special procedure for fixing back-ports, let me know,
> 'cos I haven't found one!

Ah, I missed that, as it was not obvious.

I can't take a patch that is a redo of a previous patch as it will not
apply, right?

Send a patch saying, specifically, something like "This fixes a broken
backport that was commit XXX which was commit YYY upstream..." and so
on.

otherwise it gets lost in the noise as you are seeing here...

thansk,

greg k-h
