Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4813567DE9B
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 08:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbjA0HhH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 02:37:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231740AbjA0HhH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 02:37:07 -0500
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5DEC6384C;
        Thu, 26 Jan 2023 23:37:06 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 864953200B6B;
        Fri, 27 Jan 2023 02:37:05 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 27 Jan 2023 02:37:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1674805025; x=1674891425; bh=fRllG4uN0S
        GtFMCEuqa6Mj+jYgbzJ4Zdp7WyxbIC+uc=; b=Lq8XQxqZ/0Zco25U1wVe+UTt4u
        hrfPK4Su5vXP1v82l32ZwCKXvt/D1tI3DQlt01/VTUmP8FX9Y6U46a8/6vbDzN/g
        O5rI3p9HjTGxi95DyPP+fUeiC455beRjRaLQCqATIhM9I+nChwGOUikm/w/zSUPY
        DS22nEnSozSEbCu90iu2DoxD9GtW6UCeCG1yCfv1+DLEBrSzKC3sAUcIqg3DLCfv
        22FIRog1Z0PP/dDB+MG9O9gKJDHd449VWNuHQkmuC1YOS6OEL/iV6uYgLHSuvvIR
        gujhGAaB2f3DN0+W5Rf8ydNgIO/jclrhic2PYHpMRYUsvnJ1aOYKb2jlEbTQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1674805025; x=1674891425; bh=fRllG4uN0SGtFMCEuqa6Mj+jYgbz
        J4Zdp7WyxbIC+uc=; b=CQWvhbfyCcv5kASo01aQwy36KYH81Ce7GoRWR0RoRukA
        ZoeTu4jfSvMaOPewsqZrKKfmEpgvE52zvZmlMvMtBrLTii95Ms1M5lrgFScSpV+3
        WVcsqsSS7SrErgz5SXgSpyb+GhRsGlcPks0XtGYq7HLaUJd0KQM79jndxzjJ76eN
        6zvdqMJ0FzprZM5roy5b18B6kC0GS66wooG/gPGoJsOEurvi4iIFT3IwSyEYOJjV
        HGYwiIxqOg3lCXTbV27hqtmH8y4gulZDkiFvKlSDj06d15QRUAjotS4lXxkzG0E3
        eJnBuAdPXArUXiVomKaaJAAXPA0JHXK/HfDWORT4Sg==
X-ME-Sender: <xms:IH_TY_8p_ceL6hhXVjdMymuy20HMvJws8evG-9uDSZOu61hxJDfYng>
    <xme:IH_TY7sXkLs7EkncEZ-NUdAcR4rISvBJLUZyBbEm71gjiybFsuIvCbhhf_VP40_GO
    aHJdXX9jqe6vQ>
X-ME-Received: <xmr:IH_TY9B0cFPxBYqiS2wD5jfoPcp6gs8G3KZbRvOCUY9KpimK9Z3jy-reJhgRlej1BQa9RklMLgCaPnWA8v5cJvfD1EhBoyMBzOJpDA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedruddvhedgudduudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeghe
    euhefgtdeluddtleekfeegjeetgeeikeehfeduieffvddufeefleevtddtvdenucffohhm
    rghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrg
    hmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:IH_TY7cIeOSuGGuVhlKtC1ddawPxCouJo0L0vahEFBrwCfRcp9M9Mg>
    <xmx:IH_TY0Pk5xVh1LCorf1zBwemem1ScHOSiYcT1mJEVC9V2pTHoVJEjw>
    <xmx:IH_TY9n-erNq5Xy9sxouOSg5kItt0X5KO7IZplRU0ALxLu9z9bxnJw>
    <xmx:IX_TYwANlRT5tTwPYyBsPVH0cm91ceFVBpmE2mDQxzrJ7FDtvAy98g>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Jan 2023 02:37:04 -0500 (EST)
Date:   Fri, 27 Jan 2023 08:37:02 +0100
From:   Greg KH <greg@kroah.com>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
        stable@vger.kernel.org
Subject: Re: [stable v6.1 2/2] wifi: mac80211: Fix iTXQ AMPDU fragmentation
 handling
Message-ID: <Y9N/HguY5B2E4kXw@kroah.com>
References: <20230121223330.389255-1-alexander@wetzel-home.de>
 <20230121223330.389255-2-alexander@wetzel-home.de>
 <Y9N/BQpu/2xC1v1t@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9N/BQpu/2xC1v1t@kroah.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 27, 2023 at 08:36:37AM +0100, Greg KH wrote:
> On Sat, Jan 21, 2023 at 11:33:30PM +0100, Alexander Wetzel wrote:
> > This is a backport of 'commit 592234e941f1 ("wifi: mac80211: Fix iTXQ
> > AMPDU fragmentation handling")' from linux 6.2.
> > 
> > mac80211 must not enable aggregation wile transmitting a fragmented
> > MPDU. Enforce that for mac80211 internal TX queues (iTXQs).
> > 
> > Cc: stable@vger.kernel.org
> > Link: https://lore.kernel.org/r/20230106223141.98696-1-alexander@wetzel-home.de
> > Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
> > ---
> >  net/mac80211/agg-tx.c |  2 --
> >  net/mac80211/ht.c     | 37 +++++++++++++++++++++++++++++++++++++
> >  net/mac80211/tx.c     | 13 +++++++------
> >  3 files changed, 44 insertions(+), 8 deletions(-)
> 
> This backport fails to apply to the 6.1.y tree:
> 
> Applying patch wifi-mac80211-fix-itxq-ampdu-fragmentation-handling.patch
> patching file net/mac80211/agg-tx.c
> patching file net/mac80211/ht.c
> patching file net/mac80211/tx.c
> Hunk #2 FAILED at 3726.
> Hunk #3 FAILED at 3739.
> Hunk #4 succeeded at 3744 (offset -7 lines).
> Hunk #5 succeeded at 3797 (offset -7 lines).
> 2 out of 5 hunks FAILED -- rejects in file net/mac80211/tx.c
> 
> 
> Try again?

Argh, forgot to apply patch 1/2...

{sigh}  I need more coffee...
