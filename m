Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F59A1FF5F5
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 16:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbgFRO7P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 10:59:15 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:51435 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726382AbgFRO7O (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jun 2020 10:59:14 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 1594C8D4;
        Thu, 18 Jun 2020 10:59:13 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 18 Jun 2020 10:59:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=nKFTbjl5ChmuW47gp9PYsbDBII9
        L6MXY5u74A8/YFMA=; b=ggBp5vK14RIWAbjW8lpetsmh3770pvj3e4qFATTGgPF
        51N1cs+quSfRbR/+JNoGBs9l197KylJ7BQMKCIspIhIxVzS+2ICSC5VNtHddyAMo
        ipgqLdvQs9C+lGjinAhX8x6mnVGpFNQhe+kTGXTUjS8TNvwoebeYb6iQdyGdhHH8
        kR2eXkNB9eEV1ynWyWK1kp87smimigQUXGl2MXqmiC2HOwvc9zcZOjmnnG7ZJr1G
        mMOrBCTf9t4Q0HAH7ZQPGGAGsNUVYKIHgWKDOd9d6TUACyXbQ1oaOM8LgVi3aTbK
        f5wPb3Jiyg9tFMKp/E28h2Q5PlUlf5s98aCn+e+IGTA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=nKFTbj
        l5ChmuW47gp9PYsbDBII9L6MXY5u74A8/YFMA=; b=YR6VLoVkHIHKI7KIP5e0Q8
        fC+avlZmd3jQMH991Hfd6GU4xAcGXO3AIhgHtT0EzkSlrAQJ6dw/l5kmUHQJcIPu
        HtaZw6lL4XLlZodiZqTbtlk5aP98mkIPVMevV3JNROfwzBbRv/qvJfQEAzv+FlfT
        oU4dM0zoU+ySm8FwgC1PWabjB6VyTa/MjysytnyMO79BNSJGWyOomRPOn9AF/LWL
        1th5xu7vjjXIHEk5djRo5il08DRNIyBDB8QPjzhlE43h++BOfTdHtSW2yyybauKI
        yhNWCq3VovMw0pAciLbd5oWqmp9o1PtbIEbSjmWnYgphpxxmpsqeAwXfucf2LBFg
        ==
X-ME-Sender: <xms:QIHrXiYuqs0hPec3dYLqCVkjx5Evac4WJXNjFGjKHOZmoaY--8wc5Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejgedgkeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeiieeltd
    dtudeluddvueegtedvfedvieefgeeklefftedugeeggfdukedttedvhfenucffohhmrghi
    nhepfihikhhiphgvughirgdrohhrghdpuggrrhhinhhgfhhirhgvsggrlhhlrdhnvghtpd
    hkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:QIHrXlbm6T3gdVnRrv3-s4Yi4WH7-o1dihcknldmZ2tsw0jQ_sHbiA>
    <xmx:QIHrXs-uMGQSnppt4LvJf7GoevFdyg_VWL_71HOZJXfz9EM84yVY-w>
    <xmx:QIHrXkrUf1MV4siJdAfwoddAlpTecLPa2BzkSBdG0lZJkWgUwScjbQ>
    <xmx:QIHrXsQ2ESSvXI1MA0eNMNQuvox2Xz-jCPy-tdpBzyrjIcui6SCPvg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B506C3280060;
        Thu, 18 Jun 2020 10:59:11 -0400 (EDT)
Date:   Thu, 18 Jun 2020 16:59:04 +0200
From:   Greg KH <greg@kroah.com>
To:     Giuliano Procida <gprocida@google.com>
Cc:     stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] blk-mq: sync the update nr_hw_queues with
 blk_mq_queue_tag_busy_iter
Message-ID: <20200618145904.GB3017232@kroah.com>
References: <20200608093950.86293-1-gprocida@google.com>
 <CAGvU0HmbWA5aKZ-8jnYgaQGbfcVzGsGo7pm2Rf+ZfG8dHro_Bw@mail.gmail.com>
 <CAGvU0H=Gd5CUMMW35wBFV=ZaE4u6aiu3VKPCiJNujGcwOvy3WA@mail.gmail.com>
 <20200618073258.GA3856402@kroah.com>
 <CAGvU0HmmV9+bkavHqB7TPbGwgUWvygLfWrCCmLmJ0uVOSHXoQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGvU0HmmV9+bkavHqB7TPbGwgUWvygLfWrCCmLmJ0uVOSHXoQQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 18, 2020 at 10:16:45AM +0100, Giuliano Procida wrote:
> Hi.
> 
> On Thu, 18 Jun 2020 at 08:33, Greg KH <greg@kroah.com> wrote:
> >
> >
> > A: http://en.wikipedia.org/wiki/Top_post
> > Q: Were do I find info about this thing called top-posting?
> > A: Because it messes up the order in which people normally read text.
> > Q: Why is top-posting such a bad thing?
> > A: Top-posting.
> > Q: What is the most annoying thing in e-mail?
> >
> > A: No.
> > Q: Should I include quotations after my reply?
> >
> > http://daringfireball.net/2007/07/on_top
> >
> > :)
> 
> I'm well aware of the above.
> Alas, I haven't used mutt properly in about 15 years and I'm still
> doing everything with Gmail.

gmail can handle proper quoting, if you are stuck with that :)

> Given that I was referring to the entire email thread, I punted on
> finding a place to insert a comment.
> BTW, there's a typo in the Q&A above. s/Were/Where/

Ah, nice catch, first one to notice that in years!

> > On Thu, Jun 18, 2020 at 08:27:55AM +0100, Giuliano Procida wrote:
> > > Hi Greg.
> > >
> > > Is this patch (and the similar one for 4.9) queued?
> >
> > f5bbbbe4d635 ("blk-mq: sync the update nr_hw_queues with
> > blk_mq_queue_tag_busy_iter") is in the following stable releases:
> >         4.4.224 4.9.219 4.14.176 4.19
> >
> > Do you not see it there?
> 
> We are referring to different "it"s.
> 
> Yours: f5bbbbe4d635 is the upstream patch that went into v4.19-rc1 and
> which you back-ported to at least some of these kernels. This is
> clearly there.

Great.

> Mine: the commit sent earlier in this email thread - it's a
> re-back-port, as I think the original back-port for 4.14 (and
> similarly for 4.9) is incorrect. This has clearly not reached public
> git, hence my question about whether the change was queued.

I don't know what the git commit id you are looking for here, sorry.  I
don't have the whole thread anywhere.

> These are the ids of messages containing my commits:
> 
> 4.14: 20200608093950.86293-1-gprocida@google.com
> 4.9: 20200608094030.87031-1-gprocida@google.com

Pointers to this on lore.kernel.org perhaps?

Remember, some of us get thousands of patches a week to handle,
remembering old email thread, or even keeping them around, is
impossible...

thanks,

greg k-h
