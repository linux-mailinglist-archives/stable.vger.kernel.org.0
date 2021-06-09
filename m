Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 065C63A0DC4
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 09:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237309AbhFIHdb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 03:33:31 -0400
Received: from wnew2-smtp.messagingengine.com ([64.147.123.27]:55205 "EHLO
        wnew2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236964AbhFIHdb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Jun 2021 03:33:31 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id 4392A21EB;
        Wed,  9 Jun 2021 03:31:36 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 09 Jun 2021 03:31:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=G0sZUI0hUbgYWtssu2F3ICijSwk
        9oETvqu/vaqra0Sw=; b=cMMUJKvFnJh1fgVWvYyA4UCJijZGlSNwlBRwEE+C6hK
        AwnQqzUe7rNdljBlZ5/dLlmOzfBW9k93IcyGjGQihimVez+bJQecKXjG4wsC9SJc
        OLNvvHfxWZjonpL7mRgTYlIa/Q4AU/9zjF4bqA781nF9DhtmaHey8vbn9tDVj00X
        MuNbh8lbpypeNC8pdcebQrt5PbmuSkQo3WVGY2j5O7d7cTVk9NCB/X2eO3JzsMiH
        7vz1T9QU0Oif141ZeB/bIWkz51nb7JwRE2Xm6HSMctFwUkiabILH1wu2PKK+tUWm
        8s+4tEmJSSxMpNEF3rnEyiNvAxus8mqKm1u8Uy3N7HA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=G0sZUI
        0hUbgYWtssu2F3ICijSwk9oETvqu/vaqra0Sw=; b=OfDF1G9GGNsbKOBvYBjIEE
        EJBFHGvN6zLVIrO/nf6nP6kithJYt4BtYxAuW8+7SFu87eTbHYnNAO8zMwECqVTe
        G+RQdCAutZXgw1XKcMNw9BPcFfq1cR4FZpnsY7lROe5TlcowZcTO1CESTngsoD6y
        mqz5ELrRESmyFzs9EwHFG7gtYf30rIeZrrJuyvUIz3T8vbDyQ4HGfxc7HhvZIg7P
        qjflny/8d+hGqjswnZRotqhJkWSv0C/1FLVPv+KvHO075hcyEd3KMJPjIDdgxW44
        rcMI9UMM+A5QvqM8j5O1b1ZpSE8/Jy9cMmqriDS1frHhSfTC6MB03vRUyKpmPBcA
        ==
X-ME-Sender: <xms:V27AYPk5dI8oA7fZGKn17NC8ot09mbxCE1cQi0t5XxyC1R4V4TeyPQ>
    <xme:V27AYC2BFCjxqhP8ZG8d1Fg1rhNGQfN7sZQifloxYci01tiMyuvJl0ARwNuNph3ql
    fj32ZGC7XehUQ>
X-ME-Received: <xmr:V27AYFrGpY-2OIYytB3EGhbZtMEfWeZ6eYY8X7pDK43sPCH2QiPiOQZwQ2p3F37exbqrkluXZh7R3GOEbH5U_l-3exV8GE61>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedutddgudduvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuhe
    ejgfffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:V27AYHm8pUWL_IV2GM2X4RxPhtUuzcKniLiR4XmTetCwmfp97vJ_OQ>
    <xmx:V27AYN25tXjSo9iCC0VUWTUK4YsntNkIhKMX_HZGKQTETO1-zxXf7A>
    <xmx:V27AYGtN_yiSQp0CaASDZ7UKHOPK3goYml7bmLwK3z3Zsja9MIa7qQ>
    <xmx:V27AYLNZ8u_21Tt30scgK7pUZXoEI36MSeE7zhRtlrskbJq83ABBrPaPRSg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 9 Jun 2021 03:31:34 -0400 (EDT)
Date:   Wed, 9 Jun 2021 09:31:32 +0200
From:   Greg KH <greg@kroah.com>
To:     Tony Lindgren <tony@atomide.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Keerthy <j-keerthy@ti.com>, Tero Kristo <kristo@kernel.org>
Subject: Re: [Backport for linux-5.4.y PATCH 2/4] ARM: OMAP2+: Prepare timer
 code to backport dra7 timer wrap errata i940
Message-ID: <YMBuVJBzGjm+aVbV@kroah.com>
References: <20210602104625.6079-1-tony@atomide.com>
 <20210602104625.6079-2-tony@atomide.com>
 <YL+lOumPYQ1fNoYw@kroah.com>
 <YMBcIbBPfr6W19j5@atomide.com>
 <YMBeI4aOMmWMRsu/@kroah.com>
 <YMBmpAY04FRKOLMT@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMBmpAY04FRKOLMT@atomide.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 09, 2021 at 09:58:44AM +0300, Tony Lindgren wrote:
> * Greg KH <greg@kroah.com> [210609 06:22]:
> > On Wed, Jun 09, 2021 at 09:13:53AM +0300, Tony Lindgren wrote:
> > > How about the following for the description:
> > > 
> > > Upstream commit 52762fbd1c4778ac9b173624ca0faacd22ef4724 usage of
> > > struct dmtimer_clockevent backported to the platform timer code
> > > still used in linux-5.4.y stable kernel. Needed to backport upstream
> > > commit 3efe7a878a11c13b5297057bfc1e5639ce1241ce and commit
> > > 25de4ce5ed02994aea8bc111d133308f6fd62566. Earlier kernels use
> > > mach-omap2/timer instead of drivers/clocksource as these kernels still
> > > depend on legacy platform code for booting.
> > 
> > Why are you combining 2 commits into one here?
> 
> OK so still too confusing, how about let's just have:
> 
> Upstream commit 52762fbd1c4778ac9b173624ca0faacd22ef4724 usage of
> struct dmtimer_clockevent backported to the platform timer code
> still used in linux-5.4.y stable kernel.

Why not just use the normal commit message with the "upstream commit..."
message as the first line, and then in the s-o-b area add
[backported to 5.4.y - tony]

That's the normal thing we do here for backporting.

thanks,

greg k-h
