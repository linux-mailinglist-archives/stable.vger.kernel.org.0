Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCD8BFF3C
	for <lists+stable@lfdr.de>; Fri, 27 Sep 2019 08:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbfI0Gix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Sep 2019 02:38:53 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:38609 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725804AbfI0Gix (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Sep 2019 02:38:53 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id AD3032226D;
        Fri, 27 Sep 2019 02:38:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 27 Sep 2019 02:38:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=1aZeLAWInMIiKyf7kTSsof3IyEI
        cP7Tn/QYIL41mt9Q=; b=HtX+b0ybLLF44UzbnscSVjF/Ic/bzSW51T95GlcyYRw
        ayZhJ5nia+HZv9z+G0bhbk85HhX40Dv6CyRGA20b68sddftiZ1ddCMa0rl1XbwVt
        0PLo90kGen0D6pEkcsFlXDZUMRFoJuzffTonO/reM6MVCfXpcv+U1QIyo1mM4vrI
        aLFQIf3X2GUHvt5ZR0j+nl1rKO450C5FiJVOf2O7PesXDbY/CKqR0QYLQ8IQ50dg
        mBe4zJsGI6F/LRcOVGPpJf88O2nxkcTh3yq+Y1KUvpZ1XPEmY3rDLVM239rt3/Nt
        JOmXAuDooZFhYqUHy2++bhW8nOoE4zOo0NFb+bz2IuQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=1aZeLA
        WInMIiKyf7kTSsof3IyEIcP7Tn/QYIL41mt9Q=; b=NrI7t9m90xRRTTkdFpGAgX
        DzgLqjQuq72H3LPtY299AETij5ZQUMPemCkarQvEPZEwoGeMAWCAKb2yKtbTYBFp
        zZBBDoPXHF4F0GoJ7PFA1oeCJlnIXCz8Ps7UKFno7B3bxPHJx3Q2k/Day+qG1xfN
        Q8dDmmMqwHJaT761Rk4ie4d/mqCrMMihk5+tv0YN8si+Qhl2tDFFDYI5bGScJBo9
        J/nBYaUqgz8+r5/bSqzrcknQrfzUVp51r19BlETnja53CVFQRUshnlGmcnImzhr+
        +cjFAk8J1iCBmLTgHX/eJUcnAdAxoNUZZkhAIFLZbfzRvZC3ROCCGfTgVeQCShKA
        ==
X-ME-Sender: <xms:e66NXWCK4oi3PjfpHDmzIZyegKi0L2HiomUQGR8HFXuTxjrmGbqrSA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrfeehgdduuddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuffhomhgrihhnpehlkhhmlhdroh
    hrghdpghhithhhuhgsrdgtohhmnecukfhppeeivddrudduledrudeiiedrleenucfrrghr
    rghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrh
    fuihiivgeptd
X-ME-Proxy: <xmx:e66NXUwgbEJlqgrg-j1akpjtXfOJrv-pisu-5JAAMw4NV519Jm3rqA>
    <xmx:e66NXUn1yNyd51TsIGb5Kae86obp6RLkRdx0us-KKwugOu-d3_YLWw>
    <xmx:e66NXZEPOwo0Y1wPiAghNtLLD3K78ed3ZlYiqILYKK8Q_6BjXy4U7Q>
    <xmx:e66NXbAKuqxDBl6NOuzHD3ON63hVdJSOhv0B6Ee9HJBqJKbSQgickw>
Received: from localhost (unknown [62.119.166.9])
        by mail.messagingengine.com (Postfix) with ESMTPA id BA25ED60057;
        Fri, 27 Sep 2019 02:38:49 -0400 (EDT)
Date:   Fri, 27 Sep 2019 08:24:40 +0200
From:   Greg KH <greg@kroah.com>
To:     Dave Chiluk <chiluk+linux@indeed.com>
Cc:     Ben Segall <bsegall@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Phil Auld <pauld@redhat.com>, stable@vger.kernel.org
Subject: Re: Please backport de53fd7aedb1 : sched/fair: Fix low cpu usage
 with high throttling by removing expiration of cpu-local slices
Message-ID: <20190927062440.GA1786098@kroah.com>
References: <CAC=E7cUXpUDgpvsmMaMU6sAydbfD0FEJiK25R1r=e9=YtcPjGw@mail.gmail.com>
 <20190925064414.GA1449297@kroah.com>
 <CAC=E7cXcujmbwMnmXeH2=80Lkki+j_b=WE4KCWaM1mYafDaWSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC=E7cXcujmbwMnmXeH2=80Lkki+j_b=WE4KCWaM1mYafDaWSA@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 27, 2019 at 01:12:40AM -0500, Dave Chiluk wrote:
> On Wed, Sep 25, 2019 at 1:44 AM Greg KH <greg@kroah.com> wrote:
> >
> > On Wed, Sep 25, 2019 at 12:53:48AM -0500, Dave Chiluk wrote:
> > > Commit de53fd7aedb1 ("sched/fair: Fix low cpu usage with high
> > > throttling by removing expiration of cpu-local slices") fixes a major
> > > performance issue for containerized clouds such as Kubernetes.
> > >
> > > Commit de53fd7aedb1 Fixes commit : 512ac999d275 ("sched/fair: Fix
> > > bandwidth timer clock drift condition").
> > >
> > > This should be applied to all stable kernels that applied commit
> > > 512ac999d275, and should probably be applied to all others as well.
> >
> > As this commit isn't in a released kernel just yet, we should wait to
> > see what happens when it hits people's machines, right?
> 
> I think waiting till 5.4 is released would be irresponsible on this
> one.  512ac999 was recently pushed back into many of the distro
> kernels via the stable streams.  Additionally every major container
> running cloud provider (public and private), is likely hitting this
> whether they've noticed or not.  Before 512ac999 we would hit the
> issue that resolved once every 10000 application deployments or so *(I
> admit some providers appear to have been hit by that more often).
> However, the fix implemented by 512ac999 is guaranteed to affect 100%
> of cgroup cpu bandwidth constrained applications.
> 
> Our java applications are particularly hard hit as java tends to be
> very thread happy.   Doing some napkin math, given the roughly 9000
> applications we have running in our clouds we've had to over-allocate
> each one's CPU quota by roughly .5 cpu to account for this behavior
> change (worst case scenario is actually .01 cpu * cores in machine,
> but not all of our applications are affected equally).
> 9000 applications * .5 CPU = 4500 cores
> 4500 Cores / 88 cores per node = 51 additional machines required to
> satisfy the inflated quota requirements.
> Given each 88 core machine costs roughly $30k that equates to $1.5M
> that this issue is costing us.
> We have been able to alleviate this somewhat of this by turning on CPU
> overcommit on in the container scheduler. (Deploying more applications
> per host than the CPU would generally allow for).  This however leads
> to occasional overloaded machines, and regular high response
> times/wide response time distributions for applications.
> 
> If you have a java or golang application running on a containerized
> cloud anywhere chances are you are either paying extra to get the CPU
> you need or your application is being throttled before using the quota
> you've paid for.  I'm sure other languages could be affected, but
> these are the two we've seen that by default generate enough threads
> to regularly hit this issue.
> 
> All of these problems are leading the kubernetes community to change
> the defaulrs away from the cfs bandwidth scheduling mechanisms and
> towards other mechanisms or hackish workarounds. *(adjusting periods,
> turning off cfs bandwidth, moving to only soft limits).
> https://github.com/kubernetes/kubernetes/issues/67577
> https://github.com/kubernetes/kubernetes/issues/70585
> https://github.com/kubernetes/kubernetes/issues/51135
> 
> I appreciate your reluctance to accept this patch, but I strongly
> believe pulling this sooner than later is the right thing to do.

I'll defer to the scheduler developers/maintainers here as to when to
take this patch, it's their decision.

> > Also, always cc: all of the people involved in the patch you are asking
> > for, so as to get their opinion.
> Fixed.  I'll submit a change to stable-kernel-rules.rst upon my return
> from vacation.

Great!

> > For some reason this patch did not
> > have a cc: stable tag on it, was that because the developers did not
> > think it was relevant for stable kernels?
> 
> This was my fault, I was unaware I could simply cc: stable to have it
> auto-submitted.  I promise I'll be better in the future.

Even if this was "auto-submitted", it would not show up in a kernel
until it hit a release of Linus's tree (i.e. 5.4-rc1.)  So we would
still be having this discussion :)

> > > It may also be prudent to also apply the not yet accepted patch that
> > > fixes some introduced compiler warnings discussed here.
> > > https://lkml.org/lkml/2019/9/18/925
> >
> > So we should wait for this to hit Linus's tree too, right?
> 
> This patch contributes nothing materially to de53fd7aedb1, and only
> eliminates compiler warnings for unused variables *(which likely get
> optimized out anyway).  I'm not sure what the stable policy is with
> introduced compiler warnings, so I included the patch submission in
> this discussion for completeness.

Adding build warnings is a huge no-no as it has the ability to hide real
problems with backports.  Right now the stable trees build for me with
no, or only 1, warnings, depending on the branch.  That is something
that I want to see continue to happen for obvious reasons.  So including
a patch that we know adds warnings is not good.

It's also a huge hint that it didn't get much, if any, testing in
linux-next as the warning would have shown up there, and hopefully fixed
soon, as part of the original merge.  But I digress...

So, I'll be glad to merge this "now" if I get an ACK from the others.
Otherwise I'll have to wait until Monday.

thanks,

greg k-h
