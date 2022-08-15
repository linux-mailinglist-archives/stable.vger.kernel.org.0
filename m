Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F710592C00
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 12:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbiHOJ0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 05:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230431AbiHOJ0o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 05:26:44 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E3091BEAB
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 02:26:43 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 9F06D5C00B1;
        Mon, 15 Aug 2022 05:26:39 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 15 Aug 2022 05:26:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1660555599; x=1660641999; bh=ntCX/mGYTR
        dqjdUaTM8HLJVhdv09ZTotT1LUyC6hd14=; b=lAQb3VlhHuNi3OjYi2jlx8w5+x
        5JinKMKTM4Y1tqIoW03zNVi/uyUlWf3OLXnt6mrpJ3y3qnGRoGccb+lC9bBGdTqe
        VhfosmoJPTN0DN0HaEXJg/COhZotVKAr/fUukcVmKIDZtEo9Tc+b7VXcZOgoPS5y
        nyz1iBDBoOfERlOPBdLdmO1K1zKGUd757SAKWauHAycUELTRHCYcjJTCuVtQDrZl
        F+C8AR8cuPCinecP6jm5cKIXKlsMrLuYFkzrdM0uqKiQm0Vu9/ZyjzcxfScKAiAC
        4eq3DvRz4irEw0pn4/E6n70mPNxLInM8Rrp21HWUDuEWiVpJcuoMvuaEIq4A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1660555599; x=1660641999; bh=ntCX/mGYTRdqjdUaTM8HLJVhdv09
        ZTotT1LUyC6hd14=; b=vixSZKX3pz7+T+BJiDAsVW5t5G6lyGTzmKrO5Cho/ONg
        iu10EFN9PTIZMcw3T1csvvryzAjsI/ihf25EpsBI2zSFn/Qei1Sg0CyQH8HRmyUE
        2gBcON11XI/1POAPRaVrYNfp9J6So2jEdfMC6LCKPbsrwJiB2BEMcynfF/tRrPjn
        im6t692rEXX4PBl/j30+venhTmGuRyVD6GFFCQ/VG9z3e8ww0QJkEFWXjAzsrzUH
        Q84Jz3QlJzr0/ugq6SMY8j8egDyYE6iwhXNFKLqvakkUqdkh5hiWKlDPYCqoZdF+
        EV7p+LGqTOdrxiJdrS/BO7XdO20LztN4BtiVslAq6w==
X-ME-Sender: <xms:TxH6YkmaWdZcftZafDhlXNSrnxuEQf9XDZOfzMMO4oVZAp4mlobr8w>
    <xme:TxH6Yj1jBpZ4OMekXYg9r6kN4p-2eq0TtfJSNJE1J2-MFJvwTjzciUdZqqtBt7ExK
    W57T6-SIaJy4w>
X-ME-Received: <xmr:TxH6YipnffeAEO6fj2GzWdu4UzPR2DQgrP3t39fqOcAHJ8-iy6z-4AmF7yyzpqEt1w-lXxauHkTMcaMPRVpSL2B7dwPg3qPr>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdehvddgudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepgeehue
    ehgfdtledutdelkeefgeejteegieekheefudeiffdvudeffeelvedttddvnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:TxH6YgkVsNZCKLwlkwEHyPgG06UakvI9XkuOL_WwSL5LDgX3EIv3RA>
    <xmx:TxH6Yi3PbgoY03lGPcj2BIlINq2mO9c98tCQBhcwallDnhqJXZeY1w>
    <xmx:TxH6YntAs4MP_TFQGJXRx_5CBBcm7-7PuuOzNFLf-45Sumtc3Bu0dg>
    <xmx:TxH6YjJuXIh0tu-NmLjj28vIZY5oVDN0-3iD3s6IAvyZSqTwICvn9Q>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 15 Aug 2022 05:26:38 -0400 (EDT)
Date:   Mon, 15 Aug 2022 11:26:36 +0200
From:   Greg KH <greg@kroah.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Samuel Holland <samuel@sholland.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Patch "genirq: GENERIC_IRQ_IPI depends on SMP" has been added to
 the 5.4-stable tree
Message-ID: <YvoRTKSkPLL6pcXI@kroah.com>
References: <20220813225008.2015117-1-sashal@kernel.org>
 <089a8281-000e-d275-1b50-77c03a5eb06c@sholland.org>
 <87edxhvr1o.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87edxhvr1o.wl-maz@kernel.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 15, 2022 at 09:39:47AM +0100, Marc Zyngier wrote:
> On Mon, 15 Aug 2022 05:21:51 +0100,
> Samuel Holland <samuel@sholland.org> wrote:
> > 
> > Hi Sasha,
> > 
> > On 8/13/22 5:50 PM, Sasha Levin wrote:
> > > This is a note to let you know that I've just added the patch titled
> > > 
> > >     genirq: GENERIC_IRQ_IPI depends on SMP
> > > 
> > > to the 5.4-stable tree which can be found at:
> > >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > > 
> > > The filename of the patch is:
> > >      genirq-generic_irq_ipi-depends-on-smp.patch
> > > and it can be found in the queue-5.4 subdirectory.
> > > 
> > > If you, or anyone else, feels it should not be added to the stable tree,
> > > please let <stable@vger.kernel.org> know about it.
> > 
> > This commit should not be backported further than 8190cc572981
> > ("irqchip/mips-gic: Only register IPI domain when SMP is enabled"), which it
> > depends on. It looks like that commit only went back to 5.10.
> 
> I also wonder why these commits were backported *at all*. On their
> own, they don't fix anything, but allowed further improvements that
> are not backport candidates either.
> 
> Honestly, if I wanted these backported to stable, I'd have put a 'Cc:
> stable' tag. These patches don't even have a 'Fixes:' tag, for the
> same reason.

Ok, now dropped from everything older than 5.10, thanks.

greg k-h
