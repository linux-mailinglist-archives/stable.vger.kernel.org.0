Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6AFC1FF899
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 18:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgFRQF1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 12:05:27 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:53213 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726981AbgFRQF1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jun 2020 12:05:27 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 4E9C99D7;
        Thu, 18 Jun 2020 12:05:26 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 18 Jun 2020 12:05:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=3C69NYDnsrih6U9+yPq0D89iUF6
        U8jIigFysxzoWWb4=; b=dRFKPJaeD02AcTH54oXDTe7JuAZ0TVcPJyfK3sZXqNW
        0vPlNd7O/xVBP5WXWQ8h10PaJ+LZn6HB/a1slWG4+SD3WmWa1KZxgKAoCxmX0D73
        jQLb0wZTAwGKk9TZUAYnxls8zejejoLtPgETz5N1Xidz4qWkcpRxOLbohMZ/nyRw
        Y6ZYT2SUQ04Qt4+p8SaSEQYoQCR8/4QrfMzG5n9teBAumcbeQRvjjpAvesxToGst
        Ng8JtAc3M7xYNkn3bS8dpFpL+LFVWrg1BN7S8fbRAm4NUcdrIxAZdllDeNEdmaX7
        5qBq1zk/TG4634V0whCDyijqina6LkiZUUlcGxeDltA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=3C69NY
        Dnsrih6U9+yPq0D89iUF6U8jIigFysxzoWWb4=; b=gU2DuLb1ZO38gJ1/naB6wJ
        wLvxgA9QfEDsaXsdbN8wM4gb5NKQzS5Wnb5fIlp0gG8TKeAiN5iyWldSrgSvKxcv
        Ez+hURBwokCA+7Ud8Y/+HAVnrL+WYrp1EoI0jTjjjOO5tBC6XnbJonWlQaob8K1y
        Aydz+VvV7zrXjAytygDLpUvfiUhbt5VTE6Jpgm4FeV4/OsDgf8/Wkw7mFj08kL0W
        6OYR9hojf1rvFeeaI2LDBrZkCuHQwM713rYy5SDatgiffkviaEBHnZ7JRiC6H8MT
        T6FxlkyYU0fLLtrl9vF1up46QObHRV2yn+JdWhzH6QWB9D8OStugU3c36ljNs+9A
        ==
X-ME-Sender: <xms:xJDrXgHIcKjk68ezi6vR7t2ycH-adK1DdwrbRuyk_csGQ74CJJh3Sg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejgedgleejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeiieeltd
    dtudeluddvueegtedvfedvieefgeeklefftedugeeggfdukedttedvhfenucffohhmrghi
    nhepfihikhhiphgvughirgdrohhrghdpuggrrhhinhhgfhhirhgvsggrlhhlrdhnvghtpd
    hkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:xJDrXpUqmJLeMb8MBDfK3_gUCyUZqeVwEzv5gRILf-4XqMz5cOFH3Q>
    <xmx:xJDrXqJXyI--w-_GdPZiJB-U5EkKrAZVcINXJFroX2yjVJVBUyQ7Qg>
    <xmx:xJDrXiFIRMFd3cryhn6AWitTnZbJdkjFO1lTpXRTA0TXzZU74ySGng>
    <xmx:xZDrXvcG-GcR9YHp1nm7rWVLyajY2A7TAh3kJlIATO4qtYA4Xgccyw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A48F0306218B;
        Thu, 18 Jun 2020 12:05:24 -0400 (EDT)
Date:   Thu, 18 Jun 2020 18:05:14 +0200
From:   Greg KH <greg@kroah.com>
To:     Giuliano Procida <gprocida@google.com>
Cc:     stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] blk-mq: sync the update nr_hw_queues with
 blk_mq_queue_tag_busy_iter
Message-ID: <20200618160514.GA3539988@kroah.com>
References: <20200608093950.86293-1-gprocida@google.com>
 <CAGvU0HmbWA5aKZ-8jnYgaQGbfcVzGsGo7pm2Rf+ZfG8dHro_Bw@mail.gmail.com>
 <CAGvU0H=Gd5CUMMW35wBFV=ZaE4u6aiu3VKPCiJNujGcwOvy3WA@mail.gmail.com>
 <20200618073258.GA3856402@kroah.com>
 <CAGvU0HmmV9+bkavHqB7TPbGwgUWvygLfWrCCmLmJ0uVOSHXoQQ@mail.gmail.com>
 <20200618145904.GB3017232@kroah.com>
 <CAGvU0HkAXae67ABKZQfjyc99u1ojeTmDTcykQa1O4jJ4B9iC4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGvU0HkAXae67ABKZQfjyc99u1ojeTmDTcykQa1O4jJ4B9iC4A@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 18, 2020 at 04:35:03PM +0100, Giuliano Procida wrote:
> Hi.
> 
> On Thu, 18 Jun 2020 at 15:59, Greg KH <greg@kroah.com> wrote:
> >
> > On Thu, Jun 18, 2020 at 10:16:45AM +0100, Giuliano Procida wrote:
> > > Hi.
> > >
> > > On Thu, 18 Jun 2020 at 08:33, Greg KH <greg@kroah.com> wrote:
> > > >
> > > >
> > > > A: http://en.wikipedia.org/wiki/Top_post
> > > > Q: Were do I find info about this thing called top-posting?
> > > > A: Because it messes up the order in which people normally read text.
> > > > Q: Why is top-posting such a bad thing?
> > > > A: Top-posting.
> > > > Q: What is the most annoying thing in e-mail?
> > > >
> > > > A: No.
> > > > Q: Should I include quotations after my reply?
> > > >
> > > > http://daringfireball.net/2007/07/on_top
> > > >
> > > > :)
> > >
> > > I'm well aware of the above.
> > > Alas, I haven't used mutt properly in about 15 years and I'm still
> > > doing everything with Gmail.
> >
> > gmail can handle proper quoting, if you are stuck with that :)
> >
> > > Given that I was referring to the entire email thread, I punted on
> > > finding a place to insert a comment.
> > > BTW, there's a typo in the Q&A above. s/Were/Where/
> >
> > Ah, nice catch, first one to notice that in years!
> >
> > > > On Thu, Jun 18, 2020 at 08:27:55AM +0100, Giuliano Procida wrote:
> > > > > Hi Greg.
> > > > >
> > > > > Is this patch (and the similar one for 4.9) queued?
> > > >
> > > > f5bbbbe4d635 ("blk-mq: sync the update nr_hw_queues with
> > > > blk_mq_queue_tag_busy_iter") is in the following stable releases:
> > > >         4.4.224 4.9.219 4.14.176 4.19
> > > >
> > > > Do you not see it there?
> > >
> > > We are referring to different "it"s.
> > >
> > > Yours: f5bbbbe4d635 is the upstream patch that went into v4.19-rc1 and
> > > which you back-ported to at least some of these kernels. This is
> > > clearly there.
> >
> > Great.
> >
> > > Mine: the commit sent earlier in this email thread - it's a
> > > re-back-port, as I think the original back-port for 4.14 (and
> > > similarly for 4.9) is incorrect. This has clearly not reached public
> > > git, hence my question about whether the change was queued.
> >
> > I don't know what the git commit id you are looking for here, sorry.  I
> > don't have the whole thread anywhere.
> >
> > > These are the ids of messages containing my commits:
> > >
> > > 4.14: 20200608093950.86293-1-gprocida@google.com
> > > 4.9: 20200608094030.87031-1-gprocida@google.com
> >
> > Pointers to this on lore.kernel.org perhaps?
> >
> 
> I wasn't aware stable was publicly archived. Here you go:
> 
> 4.14: https://lore.kernel.org/stable/20200608093950.86293-1-gprocida@google.com/
> 4.9: https://lore.kernel.org/stable/20200608094030.87031-1-gprocida@google.com/

As per the git commit id in those emails, you should be able to
determine the same thing that I can, namely that that patch is in the
following stable releases:
	4.4.224 4.9.219 4.14.176 4.19

thanks,

greg k-h
