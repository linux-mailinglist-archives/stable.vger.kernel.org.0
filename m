Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC499CBA3
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 10:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730679AbfHZIdN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 04:33:13 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:34323 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726401AbfHZIdN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Aug 2019 04:33:13 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 8A374386;
        Mon, 26 Aug 2019 04:33:12 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 26 Aug 2019 04:33:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=kISkBWzgCzpha63VuNZDEN2lJtY
        d2HotB8JNnNLfLJE=; b=TDqRYGt3DyZLw5FyCgnOHlSVhggyHBeg0uDgoz29NjR
        ZnKI5h0PUV1A3bFL0bqbP19MeQieRxRcidck7nfM6y6JPhemOVoCva5QB4c/0KMA
        +NPRqexIHfT7Fg9M5CD3vsyb3l/i5il0+CxRvoYeqE3JZs6JZDx5ekTKjm0uFSbV
        +wXyEuCPGXQNnVh13EBLMDwuD8f8YmYKM0km2O7xE2Zy2sTsnAl+VI49mhZcvkKl
        7ICDEYtxhAr+JMm2UmTZVD3BPFJDsqogfT0XtYKD+PW1qHPmzTIGimH0wTYOG23y
        qAKsE9+OWS0jKn1XgK1uRgmYbb5ayYnLTnI1ZIkLrDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=kISkBW
        zgCzpha63VuNZDEN2lJtYd2HotB8JNnNLfLJE=; b=LzyaEWHYSQekgHItovOPSn
        yMQ/dGn7Nrw2sWt3Rk3RfbVVMeeeQWOwvqgL0A5MD0M6KuVXPnsdx06sfbW1E+kz
        aZ8dHPWuL37TWiH0c65s/g3IplKOKrPTbDBfx2sut6IvhN60RQTWwrVeoWVSIVrO
        ZWUqR10hUNreMmqfMe6qU6Hq28QamJjJ96AjK7UflIl3sZgmbGboKAlAkLJldAJ8
        Qx7CrOEwBQ+5Xs3rA82NkPxfclsulj0Ntr5ybvyYdz8fQk+XElfURV2B90VtAhJy
        W0+5FSf0zXiieEJrLNarGNbi3KLFRWixNF95q6U8dw23UVBRlwZh4g8BKGhLC5mQ
        ==
X-ME-Sender: <xms:SJljXUfoPFE8ISBgoAfdA0_e6qy08tWn-aXpVfFiY8-BsWXU69zAUg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudehgedgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuffhomhgrihhnpehkvghrnhgvlh
    drohhrghenucfkphepkeelrddvtdehrdduvdekrddvgeeinecurfgrrhgrmhepmhgrihhl
    fhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:SJljXTmnkllbza6PSTWBtbgtm8iy6awmBzrLjYVCxC-mjFl60nt7IQ>
    <xmx:SJljXRheHFFLctuix-IKA_VMkEhSN6yMSFKWT2VGsNKrs4FMqSIgPA>
    <xmx:SJljXdoiiDV0oVn30vuow4scn1RoNCn4jUoRl2Wf51qiOqHteUV8tg>
    <xmx:SJljXbIzOTrMUS6AfzFJudOsjq_N7wGtnoPRtdSnVf4I3hQOHcoZew>
Received: from localhost (unknown [89.205.128.246])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9A628D6005B;
        Mon, 26 Aug 2019 04:33:11 -0400 (EDT)
Date:   Mon, 26 Aug 2019 10:33:09 +0200
From:   Greg KH <greg@kroah.com>
To:     Nikolai Kondrashov <Nikolai.Kondrashov@redhat.com>
Cc:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Stable queue: queue-5.2
Message-ID: <20190826083309.GA32549@kroah.com>
References: <cki.FF1370FEA1.W4XGF3MDGN@redhat.com>
 <20190825144122.GA27775@kroah.com>
 <d0567d4e-6bbe-4a93-d657-0ee7f6e4625d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0567d4e-6bbe-4a93-d657-0ee7f6e4625d@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 26, 2019 at 11:23:58AM +0300, Nikolai Kondrashov wrote:
> On 8/25/19 5:41 PM, Greg KH wrote:
> > On Sun, Aug 25, 2019 at 10:37:26AM -0400, CKI Project wrote:
> > > Merge testing
> > > -------------
> > > 
> > > We cloned this repository and checked out the following commit:
> > > 
> > >    Repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
> > >    Commit: f7d5b3dc4792 - Linux 5.2.10
> > > 
> > > 
> > > We grabbed the cc88f4442e50 commit of the stable queue repository.
> > > 
> > > We then merged the patchset with `git am`:
> > > 
> > >    keys-trusted-allow-module-init-if-tpm-is-inactive-or-deactivated.patch
> > 
> > That file is not in the repo, I think your system is messed up :(
> 
> Sorry for the trouble, Greg, but I think it's a race between the changes to
> the two repos.
> 
> The job which triggered this message was started right before the moment this
> commit was made:
> 
>     https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/commit/?id=af2f46e26e770b3aa0bc304a13ecd24763f3b452
> 
> At that moment, the repo was still on this commit, about five hours old:
> 
>     https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/commit/?id=cc88f4442e505e9f1f21c8c119debe89cbf63ab2
> 
> which still had the file. And when the job finished, and the message reached
> you, yes, the repo no longer contained it.
> 
> At the moment the job started, the latest commit to stable/linux.git
> was about 22 minutes old:
> 
>     https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.2.y&id=f7d5b3dc4792a5fe0a4d6b8106a8f3eb20c3c24c
> 
> and the repo already contained the patches from the queue, including the one
> the job tried to merge:
> 
>     https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.2.y&id=f820ecf609cc38676071ec6c6d3e96b26c73b747

How in the world are you seeing such a messed up tree?

The 5.2.10 commit moved things around, in one single atomic move.

> IIRC, we agreed to not start testing both of the repos until the latest
> commits are at least 5 minutes old. In this situation the latest commit was 22
> minutes old, so the system started testing.
> 
> We could increase the window to, say, 30 minutes (or something else), to avoid
> misfires like this, but then the response time would be increased accordingly.
> 
> It's your pick :)

Why is there any race at all?

Why do you not have a local mirror of the repo?  When it updates, then
run the tests.  Every commit in the tree is "stand alone" and things
should work at that point in time.  Don't use a commit as a "time to go
mirror something at a later point in time", as you are ending up with
trees that are obviously not correct at all.

I think you need to rework your systems as no one else seems to have
this "stale random tree state" issue.

Git does commits in an atomic fashion, how you all are messing that up
shows you are doing _way_ more work than you probably need to :)

thanks,

greg k-h
