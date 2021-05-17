Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094813829DD
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 12:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234691AbhEQKf1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 06:35:27 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:46327 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231754AbhEQKf0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 06:35:26 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 4C003AED;
        Mon, 17 May 2021 06:34:09 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 17 May 2021 06:34:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=RsDU+xE10Nbh1FFYxZYGSDPWg/3
        7OHjVLBDs3JnjJAA=; b=pa6FTxhFhYScoLPFsc5KV5+VRGifSZzE6xiuuOaun1w
        xkUjjxdTw3cNAaBxU5n0x3mAy+giBWIXiKmjPcWzIrtwE/ix3Q/sOsN7hB5bK6Gv
        B5dio1D3RSrhvRd/YVXbuas1BK1tqYbNyoMcKzus0Vw+ae88R1uG0nula2yI4kdB
        uvgk5vQR2h88pK3qI9AJVGXCU5zlAnfksCLjdiBeqV/2GU9VBvq0HZwGDUnKyDtk
        t3+RSKxZedoEBunUDib7IGPYxjMyrgzTHEfQZBh5QdHCSF1L6oStkVKnaCeDMR5o
        R3Vjc6uuEhYhb6GVieWbUTkxxPDXTm+XziUhHRzOGWA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=RsDU+x
        E10Nbh1FFYxZYGSDPWg/37OHjVLBDs3JnjJAA=; b=q6O7GAKZ0CH2gYlHa00thV
        p/u5r1+yN1u0zC5ud2GouNg2A0fj7cTa1Fs2FrumA17P3CNYDojtUurIFIhOGnw0
        73Jud7xlHkEYO+HF2usr2Wl8l39v6qM4df6y/yLg5YxkOBjyjVpXOn01E/NiplP/
        d/ADp0GJ1ox2yskY7cD2OE/oBdQrcba3/E3q/Z+UJkMO2nTVxsKgZIH4fKtUGFA4
        Ui2dovDBSslZLRgxE6zesZ3gqLWn86jxcnHNxj7InUNm2SbNt3FNBX22DbYNnXV8
        z8x+7lgFkZ+uRUJNvFCx13dtQs9uktpr2G2YXY/4uRaCpsyduSKVzOzpn0xcCX7w
        ==
X-ME-Sender: <xms:oEaiYGgxVRJVveNJ5x0cHVxC0l4WP5UCAR3xo0QWvxv6UwA2ljP-bw>
    <xme:oEaiYHCVf1xV1gINaw5VaMs7bmnAzxJOE6y5vr9J8217dIw0YGJsDTggYdKf1riEy
    ARA56PY6JUK5w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeihedgfeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdortddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevhefgje
    eitdfffefhvdegleeigeejgeeiffekieffjeeflefhieegtefhudejueenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:oEaiYOGYNd3HZDdUi1mnHRDT41eZ92YIx8aUUiYeEL1akm8K3-5mcQ>
    <xmx:oEaiYPSpe6m6m74sQVtSgf9pc4f0qgimPlOo5vJL227Kk51Eac6Z3g>
    <xmx:oEaiYDxZjMUfYpJvEhccYjWAWrk7KL8CVhNOEJapQtxx9VO0e1z-RA>
    <xmx:oEaiYKxbuSSPiOadOosJS7PnmTWsqvZhZ2nki5-nU3BIXrJLjB3gZw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 17 May 2021 06:34:07 -0400 (EDT)
Date:   Mon, 17 May 2021 12:34:06 +0200
From:   Greg KH <greg@kroah.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org, Yunlei He <heyunlei@hihonor.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH 5.4] f2fs: fix error handling in f2fs_end_enable_verity()
Message-ID: <YKJGnjRoJfXcxYbX@kroah.com>
References: <20210512194714.1199896-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210512194714.1199896-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 12, 2021 at 12:47:14PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> commit 3c0315424f5e3d2a4113c7272367bee1e8e6a174 upstream.
> 
> f2fs didn't properly clean up if verity failed to be enabled on a file:
> 
> - It left verity metadata (pages past EOF) in the page cache, which
>   would be exposed to userspace if the file was later extended.
> 
> - It didn't truncate the verity metadata at all (either from cache or
>   from disk) if an error occurred while setting the verity bit.
> 
> Fix these bugs by adding a call to truncate_inode_pages() and ensuring
> that we truncate the verity metadata (both from cache and from disk) in
> all error paths.  Also rework the code to cleanly separate the success
> path from the error paths, which makes it much easier to understand.
> 
> Finally, log a message if f2fs_truncate() fails, since it might
> otherwise fail silently.
> 
> Reported-by: Yunlei He <heyunlei@hihonor.com>
> Fixes: 95ae251fe828 ("f2fs: add fs-verity support")
> Cc: <stable@vger.kernel.org> # v5.4+
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> Reviewed-by: Chao Yu <yuchao0@huawei.com>
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>  fs/f2fs/verity.c | 75 ++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 54 insertions(+), 21 deletions(-)

Now queued up, thanks.

greg k-h
