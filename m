Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8F7F52A0
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 18:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbfKHRfB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 12:35:01 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35573 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726199AbfKHRfB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Nov 2019 12:35:01 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id A8F6521E56;
        Fri,  8 Nov 2019 12:34:59 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 08 Nov 2019 12:34:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=t+v17yEUJ+D1QIUgaP0pMKq/uqX
        TvVZc+pKxvdRB8GY=; b=ELrHou/+XcrfsnDeD31rpuoG3n0M/KapJyFkKUFbMUO
        yOJ6RgktCDioH4rNF/U0CZ8zVJ17KdHkBfdmMMi03DzjWooFgomh/oi8Poy/bPP+
        bOSQgM+4nrp8B4szOCDsLcehof+5rEee/kiffLvklYHnPGJlNN/T5EACFBy9/x/p
        OMLcjXkSqirV8L8/PmDsmHREIL9cNB82NExyzIwSqCQcqO3oy2r3WUyE0oQytmpx
        5jcny5q/3k9A07rZnPGVWSUKQh3QkoG4RP0Mz4s9E6rE16lV4vjs1c8/Mq74F57g
        2cn70jXOQseC6D07XIN09cMDh8dx1xySojciiC5MWNw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=t+v17y
        EUJ+D1QIUgaP0pMKq/uqXTvVZc+pKxvdRB8GY=; b=VL58M+JFC3+X16Xe878sQW
        ND9iyO0xHXhjeZ3u4benBEG0+jA3Xo5bJCZLCJXe5RYKnmseYeZrDG97EvhJ4mFa
        B6WaxN3E4AIgIkbpoZVAqwvjLvxVS/n2oXI9w8AwVHKI9K8cm8sapfPrV9Hkl8Ca
        y/x6KiYQ+9noF3LB2KbyxM6g+zlzdlTQWJEYo7NzC0TaMDY9yjTAlOP1nKtp8XcS
        TdZZ5Ng6D7tKxGCdLZprAYwzKcLjiXvO9IDWXCa5EewSkhLCZX/Pdg8q3onIfOgr
        Epv6Ou9yMGY3DkNgIE4VOicRhtG2dwtBuwlC2gm4eRf2rnq8ZwDNasJHovja7Zmg
        ==
X-ME-Sender: <xms:Q6fFXarxNgQzlQapIi5vIVtnBsDVUUNjiQA-WeqVE_XUTfP1aZDw8w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddvuddguddtgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:Q6fFXTYX9aZflcVOqGDhpZ_wiOQFoIZFIQbC8WaxcumvZc_CpeapSA>
    <xmx:Q6fFXYhQMg9nZQN_vHKcbSofQoVstp88ejTzTfCaB3w20I7hMAztyQ>
    <xmx:Q6fFXYrKgdSZR_jXHZrnMPeG7D6krByZ_7I_vUeD2HZY0iNwMMSckA>
    <xmx:Q6fFXZwQdj1Ik5K0WygDflaFsQ2hLQvXFNuQHfHU0Ztk9YgKq-bbTg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D6B4E306005E;
        Fri,  8 Nov 2019 12:34:58 -0500 (EST)
Date:   Fri, 8 Nov 2019 18:34:57 +0100
From:   Greg KH <greg@kroah.com>
To:     Petr Vorel <pvorel@suse.cz>
Cc:     stable@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: Re: [PATCH v4.9-stable] alarmtimer: Change remaining ENOTSUPP to
 EOPNOTSUPP
Message-ID: <20191108173457.GA1209225@kroah.com>
References: <20191108155050.12786-1-pvorel@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108155050.12786-1-pvorel@suse.cz>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 08, 2019 at 04:50:50PM +0100, Petr Vorel wrote:
> Fix backport of commit f18ddc13af981ce3c7b7f26925f099e7c6929aba upstream.
> 
> Update backport to change ENOTSUPP to EOPNOTSUPP in
> alarm_timer_{del,set}(), which were removed in
> f2c45807d3992fe0f173f34af9c347d907c31686 in v4.13-rc1.
> 
> Fixes: 65b7a5a36afb11a6769a70308c1ef3a2afae6bf4
> 
> Signed-off-by: Petr Vorel <pvorel@suse.cz>
> ---
>  kernel/time/alarmtimer.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Thanks for both backports, now queued up.

greg k-h
