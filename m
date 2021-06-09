Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9083A0C53
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 08:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbhFIGY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 02:24:27 -0400
Received: from wnew2-smtp.messagingengine.com ([64.147.123.27]:59699 "EHLO
        wnew2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231503AbhFIGY0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Jun 2021 02:24:26 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.west.internal (Postfix) with ESMTP id 8F07D23F1;
        Wed,  9 Jun 2021 02:22:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 09 Jun 2021 02:22:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=VzIpShIJ81NOtKGbsMynymINOsO
        4efkrr8lJ3dk3FnU=; b=Fbi14MWF94I86eQgClspdOz1uCkG1dcNvIrlprR6VMq
        t7d9CqYuBCPsgtc0vwiut1ZI6yFTRTyE7sGk3OcB7m5tqmHF+5f2XB2Mvmr0nmC+
        fjWV4pR4XhDnvTul8fUq5g7Vx7E+QvzsgNfpm4W9FGlSl8v8ypn23WyKGNihH6vH
        5PHm9aSw5iDORtOcYbjFJyyFlt9Esz3c6n+KEU0j90IZEt+dWN4Woshg+EG9da5B
        r+oCduWl4Hvn8YKbNb+NonXpVTbRY7I57GGllJ2iYKcBRaFj7Z9tSc1KIqqyl6i1
        t6f9dUKQeg0nMBnH4UwxRdC0VizsjMTpSRg/5jUF3CQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=VzIpSh
        IJ81NOtKGbsMynymINOsO4efkrr8lJ3dk3FnU=; b=WWYkMfWKrIQBb8ib5FpzKw
        HYTzBAznu061oi9zcT7JGEKs4Epfb6xrUef9iRB7TX0zZ4LJXS0EcAUEXaKZi5r6
        bgRwDvqvqS7tW5vf7Pe0M6oKw8koeGeQoxjaLBKpSXoqHOLB1CjHcm0rfrftgPvO
        nIFNUvCRSWoO6aCxzZIWsyppAy2xgrjlsV5vP3m0lp7TYNGkS0CdGRLXAz1IEkeW
        vhSD8fISa+T/QDTFjaCY2/cc64+Ra94QTzz76s61Gq8dKQqJkfLKxU4mzJNT0urp
        FHAfzVJ3x/t5KFJ5z2Hx5MFXZT2qR9hlhMG4eMW0XT1FUZFznXnvsTLAIs0yyqRw
        ==
X-ME-Sender: <xms:Jl7AYIMkOvRzJ-IQYJ4RgRt9wFyaa99BLqoGemBtXdBXp8qcXNrQEA>
    <xme:Jl7AYO9ZScQkCUIfOENu90htseSS0_vnfOJZBep_QT-RQu7aLru75dlUEniUrt3-S
    G1kvEaLFqOUHg>
X-ME-Received: <xmr:Jl7AYPRcvJua6YDS8Q26jMU2rBpMcQ6nlcftLqRHKzPI-mRiZ1Th-3c-z_aKAwMQ2yFa4IpqBnq73zQ1XBp3-CklgrdF0Jtt>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedutddgleekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:Jl7AYAs4ihgvXLkQb1rXV7YG-NHyc8scMymRd1LAufhVs8uwFz832g>
    <xmx:Jl7AYAeDmxF5Vv1hJOejgnKYS0q6zE_RyxnFRCS8fK9qUauf0CPiSw>
    <xmx:Jl7AYE2wSZS1-cJrJjRY97_TIjOef1ogTS1CVVZVSO00UOUf5tLdyA>
    <xmx:J17AYG2CK1e6oJViqSD_yNdcyHSQtA0jIJQ9yDoA42Yonxtg7_75RWv-Puo>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 9 Jun 2021 02:22:29 -0400 (EDT)
Date:   Wed, 9 Jun 2021 08:22:27 +0200
From:   Greg KH <greg@kroah.com>
To:     Tony Lindgren <tony@atomide.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Keerthy <j-keerthy@ti.com>, Tero Kristo <kristo@kernel.org>
Subject: Re: [Backport for linux-5.4.y PATCH 2/4] ARM: OMAP2+: Prepare timer
 code to backport dra7 timer wrap errata i940
Message-ID: <YMBeI4aOMmWMRsu/@kroah.com>
References: <20210602104625.6079-1-tony@atomide.com>
 <20210602104625.6079-2-tony@atomide.com>
 <YL+lOumPYQ1fNoYw@kroah.com>
 <YMBcIbBPfr6W19j5@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMBcIbBPfr6W19j5@atomide.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 09, 2021 at 09:13:53AM +0300, Tony Lindgren wrote:
> Hi,
> 
> * Greg KH <greg@kroah.com> [210608 17:13]:
> > On Wed, Jun 02, 2021 at 01:46:23PM +0300, Tony Lindgren wrote:
> > > Prepare linux-5.4.y to backport upstream timer wrap errata commit
> > > 3efe7a878a11c13b5297057bfc1e5639ce1241ce and commit
> > > 25de4ce5ed02994aea8bc111d133308f6fd62566. Earlier kernels still use
> > > mach-omap2/timer instead of drivers/clocksource as these kernels still
> > > depend on legacy platform code for timers. Note that earlier stable
> > > kernels need also additional patches and will be posted separately.
> > 
> > I do not understand this paragraph.
> > 
> > What upstream commit is this?  And "posted separately" shouldn't show up
> > in a changelog text, right?
> 
> This would be a partial backport to add struct dmtimer_clockevent from
> commit 52762fbd1c4778ac9b173624ca0faacd22ef4724 to the platform timer
> code used in the older kernels.
> 
> How about the following for the description:
> 
> Upstream commit 52762fbd1c4778ac9b173624ca0faacd22ef4724 usage of
> struct dmtimer_clockevent backported to the platform timer code
> still used in linux-5.4.y stable kernel. Needed to backport upstream
> commit 3efe7a878a11c13b5297057bfc1e5639ce1241ce and commit
> 25de4ce5ed02994aea8bc111d133308f6fd62566. Earlier kernels use
> mach-omap2/timer instead of drivers/clocksource as these kernels still
> depend on legacy platform code for booting.

Why are you combining 2 commits into one here?

I do not understand what this commit really is at all still, sorry.

How about just providing backports for the individual commits, do not
combine them as that just is a mess.

> > Can you fix this up to make this obvious what is happening here and make
> > a patch series that I can take without editing changelog text?
> 
> Sure I'll repost the series, assuming the above is OK for description :)
> Please let me know if you need further details added.
> 
> Hmm so what's the correct way to prevent automatically applying these
> into the earlier stable kernels?

What would cause them to be automatically applied?  You need to let us
know what kernel(s) they should go to.

thanks,

greg k-h
