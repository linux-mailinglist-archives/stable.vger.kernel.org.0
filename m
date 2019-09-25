Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF7BBD875
	for <lists+stable@lfdr.de>; Wed, 25 Sep 2019 08:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436805AbfIYGoS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Sep 2019 02:44:18 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:44149 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2436692AbfIYGoR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Sep 2019 02:44:17 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 31639223EF;
        Wed, 25 Sep 2019 02:44:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 25 Sep 2019 02:44:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=2+gI/NO57QZb736M/M0qQqUAPIt
        4kBg1heeu+qDGG24=; b=ObfjFGBIEAunww/dPvprrCdWYu9d4f3zpgvwIJGmioF
        pUrNJQSWyguHehKRdAhvoOBdVESCTB0cP9qkKFdIbhviHn8avv/f2bbXXcQmaT9D
        IwiMpmlUdyOxdX7GwERT+7bO8q0Eo8aSXQYOj97JstyPYzb1+Cp9nC6TjVf5r7nn
        2vifSv9sOv0Rovrvp755APQbZH55MCllHf9Hh+xTrR/AhxSDnVIqtgni3Y3FXdln
        Y5rac96YTZKW+NiVUnJG0GfVOD6n4aVvLprg9+HL3a9F1GrC3C+Vy8ZZxxErDO/g
        yivE6P0I7Zyfgu/EKKu07dZ518uXqJaLU6LwILBBIFw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=2+gI/N
        O57QZb736M/M0qQqUAPIt4kBg1heeu+qDGG24=; b=1Hr8/t+HNegpCb65vTxPoq
        GGyoSMMjyOq0VmSlga7YooOSGreMnJ+khjfg2ZHr60xjLE26na9dzG/W5kXVKesi
        UuoEOZFQxsmNfzTzq4tJow595iy4vLuxZNB24q6hFpdafrTi5O1glXZ88EFktSeE
        291aUOdjoC7ercz9f9xrAfMFY4A/o5CwuEFltbn+blPE3yS38PsQBPzCVlsl+I+x
        L/RYI8xp0jpEy25mn7XjeMDZwNbqPN4Ly6uauEqYGguKGLidFsrMC99vJ5++rBC2
        IBSISdCiTBBCpm9hKsYpcfpbGCjwNhfDAyji8eNdGcaju6DSfMFl37R1wgrUKFYQ
        ==
X-ME-Sender: <xms:wAyLXT_qKT0k6R-K6iR1_RO7jgUyXCQgyO_f1orBvwrFphsThQg-QA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrfedugdduudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuffhomhgrihhnpehlkhhmlhdroh
    hrghdpghhithhhuhgsrdgtohhmnecukfhppeekgedrvdeguddrvddttddrieelnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvg
    hrufhiiigvpedt
X-ME-Proxy: <xmx:wAyLXbjVg1aCb44FFUv4gC_w7wBj0R9b8BeB1jLNOt4-LzQjAxUPGQ>
    <xmx:wAyLXYV9ohgQo8ykKGKIF-F8yFTTgDqf4lkF8VJx4Jp29t32iiFmEg>
    <xmx:wAyLXSvTG4Rlf0cLuli4rgH6fDiCaxZmwQu5JlJQfRzm7A750DknIQ>
    <xmx:wAyLXTqSp_h1Eljkc2ag1C5_dGXN12UNSfNc99T4luR1ZhwCuj4wNA>
Received: from localhost (unknown [84.241.200.69])
        by mail.messagingengine.com (Postfix) with ESMTPA id A712DD6005A;
        Wed, 25 Sep 2019 02:44:15 -0400 (EDT)
Date:   Wed, 25 Sep 2019 08:44:14 +0200
From:   Greg KH <greg@kroah.com>
To:     Dave Chiluk <chiluk+linux@indeed.com>
Cc:     stable@vger.kernel.org
Subject: Re: Please backport de53fd7aedb1 : sched/fair: Fix low cpu usage
 with high throttling by removing expiration of cpu-local slices
Message-ID: <20190925064414.GA1449297@kroah.com>
References: <CAC=E7cUXpUDgpvsmMaMU6sAydbfD0FEJiK25R1r=e9=YtcPjGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC=E7cUXpUDgpvsmMaMU6sAydbfD0FEJiK25R1r=e9=YtcPjGw@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 25, 2019 at 12:53:48AM -0500, Dave Chiluk wrote:
> Commit de53fd7aedb1 ("sched/fair: Fix low cpu usage with high
> throttling by removing expiration of cpu-local slices") fixes a major
> performance issue for containerized clouds such as Kubernetes.
> 
> Commit de53fd7aedb1 Fixes commit : 512ac999d275 ("sched/fair: Fix
> bandwidth timer clock drift condition").
> 
> This should be applied to all stable kernels that applied commit
> 512ac999d275, and should probably be applied to all others as well.

As this commit isn't in a released kernel just yet, we should wait to
see what happens when it hits people's machines, right?

Also, always cc: all of the people involved in the patch you are asking
for, so as to get their opinion.  For some reason this patch did not
have a cc: stable tag on it, was that because the developers did not
think it was relevant for stable kernels?

> The issues introduced by these pathes can be read about on the
> Kubernetes github.
> https://github.com/kubernetes/kubernetes/issues/67577
> 
> It may also be prudent to also apply the not yet accepted patch that
> fixes some introduced compiler warnings discussed here.
> https://lkml.org/lkml/2019/9/18/925

So we should wait for this to hit Linus's tree too, right?

thanks,

greg k-h
