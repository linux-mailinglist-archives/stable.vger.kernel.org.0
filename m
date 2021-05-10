Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA49B377D7D
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 09:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbhEJHxQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 03:53:16 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38359 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229852AbhEJHxO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 03:53:14 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id DA0065C00AA;
        Mon, 10 May 2021 03:52:09 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 10 May 2021 03:52:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=u62L0RJTBDV6D9bC+KUDXpUGe78
        3lPGMAmhATTBBj2c=; b=QzYM/qJgbI3BMXLE3WcFgyEU2l4l6oRW4y2BL+xo9gk
        fHGoMxEAIkMZjKlVcSdV3/SARimk7dQflSpaavjlAvW8NtEK5kNpD6zI3fp2/2kE
        bQgErNlbpBUWog4+yO/jmG6FEqU/7YFxzw0SApwjDzrEFRPrqD2SEaahSTfoCJw3
        OvXL0A3DnP43sp2JNXJ64AAJ5TF5eC7VkzS+RpCrHy+jbkoY4sCEwPXkh4hgfHl7
        NY4hp1VW8jY4YjmJDn9+ZfxsIdaxVTWYEya7QXzgDswg0KVHGo3FVXwQhTqulPd8
        9q2ZmXE9lwlhbUmTIk5doN99uwvN5kvF3i/CVMdeRrQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=u62L0R
        JTBDV6D9bC+KUDXpUGe783lPGMAmhATTBBj2c=; b=QMY0WlBKmGoLhfA4EldhxL
        qWvzfqFh+9L/GxqdsfCBrjvR9hNIK4LWL41mGuMC2iJBfAp48B3tWY3ul4NHY1k4
        aYuRIQLOq3AYnMVaLjoBL3rFR3iJF7jrJr4IocH8JLlU8ZB0BOhbGDahifKKuaqG
        ZBuuG+SzklByQ7wWJ/CScftJ8E4bUrdbrsVQGOZoak9Skd7gVtMWtsNRXmJMtqNX
        5sNZ8epw8VXDRsUGGyW2zeOtXPEC6BZYlm4wn3dZafHdrN0oKcM9qh+8losW0BO4
        QdPK2W18zAC8cAdDf630AGJZJuxkeQYhnVmVA8vixUy5OOw99IURWpx3Id/rB9UQ
        ==
X-ME-Sender: <xms:KOaYYCGwWtU2-WVNQY6yQaf5aqDyoX-z2NJiMk6VePZmyIAncdx5xw>
    <xme:KOaYYDXAPJamFrNh1horZiAtt9f-G3TFm_XIebiYId6IKyQq_3orG2V2eo4bAIFaO
    pI7oU-h-_sUaA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegjedguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuhe
    ejgfffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:KOaYYMLMyar--H9OwyXfrkz8adSZI98ET7eVaEvckw4JF7plOkGihw>
    <xmx:KOaYYMHmnUmKFCx_st_Jzv4sVA4gfLNMBeu-sd2S5Ye0cn-MWkJmiA>
    <xmx:KOaYYIVqvIm-KpidNyZIdhvWmg09sDjXQ3LPPxK1H18tFrdBbsav6Q>
    <xmx:KeaYYLHBWonj6GMtuwI3k0yc5gtTO7Dg2zOmRldRZQbhH8fUbvfNUA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 10 May 2021 03:52:08 -0400 (EDT)
Date:   Mon, 10 May 2021 09:52:06 +0200
From:   Greg KH <greg@kroah.com>
To:     Pavel Machek <pavel@denx.de>
Cc:     wens@csie.org, stable@vger.kernel.org,
        mark.tomlinson@alliedtelesis.co.nz, pablo@netfilter.org
Subject: Re: [PATCH 4.4] netfilter: x_tables: Use correct memory barriers.
Message-ID: <YJjmJvw/urUncdcd@kroah.com>
References: <20210509082436.GA25504@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210509082436.GA25504@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 09, 2021 at 10:24:36AM +0200, Pavel Machek wrote:
> 
> From: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
> 
> commit 175e476b8cdf2a4de7432583b49c871345e4f8a1 upstream.
> 
> When a new table value was assigned, it was followed by a write memory
> barrier. This ensured that all writes before this point would complete
> before any writes after this point. However, to determine whether the
> rules are unused, the sequence counter is read. To ensure that all
> writes have been done before these reads, a full memory barrier is
> needed, not just a write memory barrier. The same argument applies when
> incrementing the counter, before the rules are read.
> 
> Changing to using smp_mb() instead of smp_wmb() fixes the kernel panic
> reported in cc00bcaa5899 (which is still present), while still
> maintaining the same speed of replacing tables.
> 
> The smb_mb() barriers potentially slow the packet path, however testing
> has shown no measurable change in performance on a 4-core MIPS64
> platform.
> 
> Fixes: 7f5c6d4f665b ("netfilter: get rid of atomic ops in fast path")
> Signed-off-by: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> [Ported to stable, affected barrier is added by d3d40f237480abf3268956daf18cdc56edd32834 in mainline]
> Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
> ---
>  include/linux/netfilter/x_tables.h | 2 +-
>  net/netfilter/x_tables.c           | 3 +++
>  2 files changed, 4 insertions(+), 1 deletion(-)

What about 4.14 and 4.9?  I can't take patches only for 4.4 that are not
also in newer releases.

thanks,

greg k-h
