Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8221221F7C0
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 18:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728800AbgGNQ62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 12:58:28 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:60063 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726062AbgGNQ62 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jul 2020 12:58:28 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id A37F6C60;
        Tue, 14 Jul 2020 12:58:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 14 Jul 2020 12:58:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=J
        n3Ad37SZHYYU1k/teK9BKKpMr/A2B9BBUZL/dISkAw=; b=rRonHJCIud40+m7Fz
        d+DHSXfd+BJrfwWI9tMwkRffZ9Uq6k1GrtwJp8Q/C+26k4tbg1Yadc4d8S9n0S2v
        hr9/Y+eRygltnOdxjjJynh0JPxJ1sO9TD2EGJ3Dtxlls0Pyt2LjuSDDdiz6/V0bL
        QtV1fvo1t0YsoPYh9G0dS+ZBFGGAe0X1LDtgH74M3CNpmsfJiyQJmLwNS6nD3yEC
        KHO8+Bd12f85i453o5FMCvI1kdxIsYiCjebwFU7Iu23L0izQyOlDhpqPGpIKB0+O
        wIgmwFAWli4AO2TMnjlLZY4ga+cC8rrw1KVMe+69I1bolPRn7KsS2l8h7dcGMGju
        lahJQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=Jn3Ad37SZHYYU1k/teK9BKKpMr/A2B9BBUZL/dISk
        Aw=; b=d+e507VnLJEX/bU269xQFlaHhcDOlaP56eL+UnVJ7wS4UreDbd8+wLQeG
        uGH63+FGRR56QaYud7+WzxfVDv3UND+hrIn+1lCyp88mrfW26LxGfirevaL8a8th
        CC+8WuOFk708i+HhV4k7JovSRtirV7+DJcHCS8trHqAID2oYQfEg4hkUMs+oIE3Z
        CzcEl4U5g7QsXfiVGMHbIrhfjac4KNfm8ziykmD6SLQ7g9aWbZn00WF8IawDgiow
        k9CldDrW0DAXLwxm6EFMkLD6AHAUSIrncd2Ctu9BE0ZJ6wqeoyhnld2528nHl2WL
        hwx/xDu+pfFLY3W740H86KbR6I3MA==
X-ME-Sender: <xms:MeQNXx2shWVdt-0a8WgJskjjtwldq8kpE3j9wl8ERVlphuKK_PnVvQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrfedtgddutdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtudenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepvedtie
    elueetgeeggfeufefhvefgtdetgfetgfdtvdegjeehieduvddtkeffheffnecukfhppeek
    fedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:MeQNX4FyPmsEPLoY3rJG8-Y8k4t0iP8vvEsKbuYdUy9cqLoB-OzVvg>
    <xmx:MeQNXx7_wijXZzyA34CaJUKkrb6C4m7QA7OesUtE3Fm0ub106fNjrg>
    <xmx:MeQNX-3_xgT0Lj0TRaq6m2md3F0rVqWozNva2WE0gCQWbKK6iQKY3Q>
    <xmx:MuQNX55S2lpFY5-BJy5oiPdD7CKarlEeyLKeKRZCmequaFXEhoYibA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id EF64A3280065;
        Tue, 14 Jul 2020 12:58:24 -0400 (EDT)
Date:   Tue, 14 Jul 2020 18:58:23 +0200
From:   Greg KH <greg@kroah.com>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     "H. Nikolaus Schaller" <hns@goldelico.com>, stable@vger.kernel.org,
        Paul Cercueil <paul@crapouillou.net>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        letux-kernel@openphoenux.org, linux-mips@vger.kernel.org,
        tsbogend@alpha.franken.de
Subject: Re: [PATCH] [stable v5.4.x] pwm: jz4740: Fix build failure
Message-ID: <20200714165823.GA2127080@kroah.com>
References: <20200710102758.8341-1-u.kleine-koenig@pengutronix.de>
 <DB8C7C01-0FBB-4A9F-B068-15C06BBC0873@goldelico.com>
 <20200710194702.ire4deel2zn7mnxk@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200710194702.ire4deel2zn7mnxk@pengutronix.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 10, 2020 at 09:47:02PM +0200, Uwe Kleine-König wrote:
> On Fri, Jul 10, 2020 at 12:48:36PM +0200, H. Nikolaus Schaller wrote:
> > 
> > > Am 10.07.2020 um 12:27 schrieb Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> > > 
> > > When commit 9017dc4fbd59 ("pwm: jz4740: Enhance precision in calculation
> > > of duty cycle") from v5.8-rc1 was backported to v5.4.x its dependency on
> > > commit ce1f9cece057 ("pwm: jz4740: Use clocks from TCU driver") was not
> > > noticed which made the pwm-jz4740 driver fail to build.
> > 
> > Please can you add my "reported by?"
> 
> Greg, can you please add this while applying? (Assuming you're ok with
> this change and ideally Paul can confirm the change is fine.)
> 
> Reported-by: H. Nikolaus Schaller <hns@goldelico.com>

Now added, thanks.
