Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE26E118222
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 09:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfLJIWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 03:22:00 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:60145 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726750AbfLJIV7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 03:21:59 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id DBE76223C2;
        Tue, 10 Dec 2019 03:21:58 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 10 Dec 2019 03:21:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=Wqu0tGKGVL90xHMWKQw/VjaC2QW
        m+a3ToA8E39L6EIM=; b=kmjIX7S9qea6pwJgG8vX1mMPBmQ4A8ftrZm0Y2FHRcf
        mcK3d1w1GjCgt6zo+4Mz3ZQAQGBzOQ9G7bSZtkEr4SLa5sH5CToh2JlOqLvWYBAu
        nEBDzot/7h+g8MKhipA+tV4QDkj/6dpz3rxrPfnkYGh0AijNejHD0Lc/GboETPh2
        biQ+yHFZLquI3Qh2pCwUZ2XOcO66UlqJL8VKqd72Zd+sdoCaIQ+mpRm4ju1hWIDn
        qAho0jS4p3X8AYkqJscWlxVKqOnXdBenir4YMlvDB1Ys3UEd28SWJvIYK3le8GrG
        7MZu/gwUdLbMGGW5LtfpfjIWhqNrgp72okbMw0YjNmQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Wqu0tG
        KGVL90xHMWKQw/VjaC2QWm+a3ToA8E39L6EIM=; b=M5/ysrV1hxHmTGeqxbUrsQ
        f1+ih1GW5UvsHDdOFQEbm1TludIAS0WMYd7l861b7qlR+8rdVzkHhxRSbM5j5I1m
        xmoYWOzgEmhsvijtlujC67rm7Okx/NcRkhmI9BlV26D2JZaBnLx6VZLcydR2WL9T
        zt3mlo6Un+ApmVbab07u27128v5nCPQU6M0wayU2NFyXdvibklJW5cZTbzuOJfGh
        7h4CGw2F4fNZ9+B5zVAWC5lgNcj+RzhNcb9hmJZ1KnleZluL1eCQIbZirLSfsyNv
        tpEnM2JRIr9cP8NbAvG+muvwtIhbhOttxB/LXmnRAVwMD83ACXtD55K35DWzzJbQ
        ==
X-ME-Sender: <xms:plXvXWubazSyrk9nPMZeGW-70np6fXppAMTvom0vYYB7_UtgG1m5_A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudelvddgudduiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:plXvXSmANoM8lch9PI_grw55-BeEQ9eoU_qf4zVDvagyOtpi0rUg-g>
    <xmx:plXvXULk_3gIIpp7XTyfWLPwnJvW5bM_kWpj8XE1LappypcdelVkzA>
    <xmx:plXvXa5mP9LedRDtCGEr9OItIKlvFT5scbpVoqsUzDd6IbXfJi5Xrg>
    <xmx:plXvXfoyJZpT6rLQE0B13eAcsfTd4yWFsTwsFWy9jDU_pNhYoDv7Mg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2CFEF30600AB;
        Tue, 10 Dec 2019 03:21:58 -0500 (EST)
Date:   Tue, 10 Dec 2019 09:21:55 +0100
From:   Greg KH <greg@kroah.com>
To:     Brian Norris <briannorris@google.com>
Cc:     stable <stable@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        sharvari.harisangam@nxp.com,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>
Subject: Re: [REQUEST TO BACKPORT] mwifiex: update set_mac_address logic
Message-ID: <20191210082155.GA3182516@kroah.com>
References: <CA+ASDXPfK7a8RYdg19nga59QwNkovo7Dt2VOqsCa5vLsc2F-SQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+ASDXPfK7a8RYdg19nga59QwNkovo7Dt2VOqsCa5vLsc2F-SQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 09, 2019 at 05:03:54PM -0800, Brian Norris wrote:
> I'd like to request the following commit [1] go to -stable. It fixes a
> regression (as far back as kernel v4.17) where the default MAC address
> is computed incorrectly. This can have pretty nasty effects when
> upgrading kernels, since people don't expect their HW MAC address to
> change.
> 
> It probably should have had this tag, for the record:
> 
> Fixes: 864164683678 ("mwifiex: set different mac address for
> interfaces with same bss type")
> 
> Thanks,
> Brian
> 
> [1]
> commit 7afb94da3cd8a28ed7ae268143117bf1ac8a3371
> Author: Sharvari Harisangam <sharvari@marvell.com>
> Date:   Wed Jun 12 20:42:11 2019 +0530
> 
>     mwifiex: update set_mac_address logic
> 
>     In set_mac_address, driver check for interfaces with same bss_type
>     For first STA entry, this would return 3 interfaces since all priv's have
>     bss_type as 0 due to kzalloc. Thus mac address gets changed for STA
>     unexpected. This patch adds check for first STA and avoids mac address
>     change. This patch also adds mac_address change for p2p based on bss_num
>     type.
> 
>     Signed-off-by: Sharvari Harisangam <sharvari@marvell.com>
>     Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
>     Signed-off-by: Kalle Valo <kvalo@codeaurora.org

Given this shows up in 5.3, 4.19.y is the only tree it can be applied
to, so I have now done that, thanks.

greg k-h
