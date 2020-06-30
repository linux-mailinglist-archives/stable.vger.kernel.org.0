Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 017A020FBC5
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 20:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389488AbgF3Sdm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 14:33:42 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:55873 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729676AbgF3Sdl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 14:33:41 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 7D3705C00B5;
        Tue, 30 Jun 2020 14:33:40 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 30 Jun 2020 14:33:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=m
        fiMhvbmtnm+tXAKCN63eyhgj9b7musJa++oOQ18GmI=; b=BAIwnhaNqYpRzszHu
        kMJQzYdfuqPvgkWKcv/YfGqZlwZCaYxibCE3p2BwXzniISJ8Knxje8fW7bUXsDol
        77S530XIAuWFHOXKJgHYfAU/dqxEwK9rtrXCWgcBeR2qwOH2sAGPC73V8uTuw6HE
        MPEB3vhhit/sdnzjQgaJ/4SEUN/lG7uD9nqOvrqLrEjZC4Qpk4uPQclwjHIfSudj
        /m1JSb3aJWoGJ7w/P3Qga1kH5x+LNJlXtNRz02UFKSOudzeqWLiwjrShiro0vAfC
        qdFCzMLIUSz/TygjvyrV/OKNO5tNHQITJ0XK+CfYJGNsM5xXHpEgmy2UjufliBKO
        YDtJA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=mfiMhvbmtnm+tXAKCN63eyhgj9b7musJa++oOQ18G
        mI=; b=UfTIEjG5HUvcqW9D1KsWrGE4hsFLj7TjV1lskAM7i8l/lrlysD1x7xOcK
        Ob+SlbSOoOcjA4KayDgbbeb1gXehyhmLkBHfC3wfJSJJN0t3rRJcISD/gaCcMiog
        oSP8bXyn7GMw24Zx/j9RFrz2hC9RwA0et7a5F54bQmWQmROZjdRjpGZIQRE7aEcr
        4WFtMbpBSFf6TRpa9ZBSHR3hb5ckphPsyp71yeD+BMtb9X3y4OdGRjOn+WVqKBX9
        5hO0Bh1XpYrM+wVtF77GPfi3c+08w5SnFMtRViZ38eGAISYlVGbNS4prymwmgKN0
        3OP1kZVIIRxAPXPv4B828lnDEzBQQ==
X-ME-Sender: <xms:g4X7XtDm9eyvWjoso0EisCwKG4_yn2HY-VIGqqv1Mm3rhv2hINS_bg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrtddtgdelkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeegieejue
    dvffeuvdfftdetfeeuhfekhefgueffjeevtedtlefgueduffffteeftdenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledruddtjeenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgr
    hhdrtghomh
X-ME-Proxy: <xmx:g4X7XrhCyEEd2xITSiCxMxfaYlhGuXIcyTF24HZmUsxAfasLbhKzzw>
    <xmx:g4X7XokQNvfCWRz5wcKq7_2DyzXubGkVAWg3LLS59R2p2mJ01Oi2oQ>
    <xmx:g4X7XnyMDyZTYlTm3iHpNLS9sOR0qE5_50GN1L3o67LhKF9vfQdEVg>
    <xmx:hIX7XlIrhf00EhPQRtSkviR1D802GfjDqYwZmyr-C5LBT39IKGNWLg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6861630600BF;
        Tue, 30 Jun 2020 14:33:39 -0400 (EDT)
Date:   Tue, 30 Jun 2020 20:33:28 +0200
From:   Greg KH <greg@kroah.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Alexander Tsoy <alexander@tsoy.me>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 4.9 026/191] ALSA: usb-audio: Improve frames size
 computation
Message-ID: <20200630183328.GA1916087@kroah.com>
References: <20200629154007.2495120-1-sashal@kernel.org>
 <20200629154007.2495120-27-sashal@kernel.org>
 <e033669a50b53e439f5071ad12d05c2d02ab6cfc.camel@tsoy.me>
 <20200630165407.GZ1931@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200630165407.GZ1931@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 30, 2020 at 12:54:07PM -0400, Sasha Levin wrote:
> On Tue, Jun 30, 2020 at 01:49:50PM +0300, Alexander Tsoy wrote:
> > В Пн, 29/06/2020 в 11:37 -0400, Sasha Levin пишет:
> > > From: Alexander Tsoy <alexander@tsoy.me>
> > > 
> > > [ Upstream commit f0bd62b64016508938df9babe47f65c2c727d25c ]
> > > 
> > > For computation of the the next frame size current value of fs/fps
> > > and
> > > accumulated fractional parts of fs/fps are used, where values are
> > > stored
> > > in Q16.16 format. This is quite natural for computing frame size for
> > > asynchronous endpoints driven by explicit feedback, since in this
> > > case
> > > fs/fps is a value provided by the feedback endpoint and it's already
> > > in
> > > the Q format. If an error is accumulated over time, the device can
> > > adjust fs/fps value to prevent buffer overruns/underruns.
> > > 
> > > But for synchronous endpoints the accuracy provided by these
> > > computations
> > > is not enough. Due to accumulated error the driver periodically
> > > produces
> > > frames with incorrect size (+/- 1 audio sample).
> > > 
> > > This patch fixes this issue by implementing a different algorithm for
> > > frame size computation. It is based on accumulating of the remainders
> > > from division fs/fps and it doesn't accumulate errors over time. This
> > > new method is enabled for synchronous and adaptive playback
> > > endpoints.
> > > 
> > > Signed-off-by: Alexander Tsoy <alexander@tsoy.me>
> > > Link:
> > > https://lore.kernel.org/r/20200424022449.14972-1-alexander@tsoy.me
> > > Signed-off-by: Takashi Iwai <tiwai@suse.de>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > ---
> > >  sound/usb/card.h     |  4 ++++
> > >  sound/usb/endpoint.c | 43 ++++++++++++++++++++++++++++++++++++++--
> > > ---
> > >  sound/usb/endpoint.h |  1 +
> > >  sound/usb/pcm.c      |  2 ++
> > >  4 files changed, 45 insertions(+), 5 deletions(-)
> > 
> > Please drop this patch from the queue for now (and for 4.4 as well). It
> > introduced a regression for some devices. The fix is available, but not
> > accepted yet.
> 
> I've dropped it from the older branches, but note that it's already in
> newer released stable kernels. Should it be reverted or should we wait
> for the fix?

I was going to wait for the fix.
