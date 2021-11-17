Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A485A454CB3
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 19:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237847AbhKQSF2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 13:05:28 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49217 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229678AbhKQSF1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 13:05:27 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B130E5C025E;
        Wed, 17 Nov 2021 13:02:28 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 17 Nov 2021 13:02:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=SbK0ea+ZKUafHFvRiNRPgL7pcs8
        OW58Yz5JNFDPC1oY=; b=t1q+Aiw+YBOUJBNOD/P5GtUOLVoaFZG6uJne+XpjSWz
        X4cqwyL4Xok99vGbvwpQrO1RK5HnEWoFJtTW0A2VOB3Wto41vz8OvyYTahBULDgf
        hNkJQP4piu9gfssS50AWAxcbWODOBY4UgAobXe9uEk+8XjhG9wt97gvzxdolBrJV
        Ss+BjCFjQKhOdixRyQnynRrWDInKvX0gLGwPo8/oZ+H/9u+BFXk4nZlHBW6sLsa0
        6hk1CsSAW0AujzEQWOLFLFDKkbNV20b+8DBW8OGlOhEkw29B6oBG6u4xj3fHibNN
        hjx4iiTIXseys+tqHslGC+W3sqc3+8a7cPiI9WVdXhQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=SbK0ea
        +ZKUafHFvRiNRPgL7pcs8OW58Yz5JNFDPC1oY=; b=cfDA6ffi3eBM1uRTWEVi4A
        +N4Gtfv+UWQCM1bRj1QEe/SOPKIlR+juD1HzPAG9ZGLawdPzX2bJQ+Db1vi9fX9c
        Px7aEsF2DiP331nhKLNW67L+SHE0a1OtVIkSsNqGyMx+m6y2WvKJfPrNEpmTqaAR
        T/eoSl350ZpAC/W6Xwl4qrDK8nhADn+qnh3ZNVIKCI0z9cWAI5FwFC0A80eK/UMK
        iJuBkAu+Hh7i+su+0z0s8yd95fnix/7ryIganm4E7nHCXr0S0ouWSL2UJnhxW0w4
        DJ0y321ZECMI7YbQ5S9GAh28M3FOa5ydxAs70Y/rxUKZHsHn8gs9w1F3xk9kejPw
        ==
X-ME-Sender: <xms:tEOVYdIP8CZ5Zu8fNFqNGrloGeFxH0ZeVMl7DSjqLHRe7UPOOeHSDA>
    <xme:tEOVYZKE-zsBk34IKP9RRBDoFG76BBYO47HgnsUH4KkoWeW6NVStwhKbwY_QCQ3NB
    u6rBPoC0i-K1A>
X-ME-Received: <xmr:tEOVYVv2Kk2sEAB6eF8kK-QkaehMGQBPMQBveSoCDwLs_JEyaL-37Ss3u9r9IqpxUGplUvmN84Be0TDqOr53JZKxv40Jo-RG>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrfeeggddutdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdortddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpedutdeivd
    ejgedufffgvdfhtdejuefghfehvdejhefggfeludeugfefkeegvdelhfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:tEOVYeYSaL8nZtUUHdZccdzRJA-EvwxP-jfcG152Cgk4GAFxwRHBSw>
    <xmx:tEOVYUZ0lhz56mykW6BdP9X_XG-HBfXPxfCMIkPWGLZ3h_9pD8l8Kg>
    <xmx:tEOVYSAC9b23ybKYBpxWxb7cDxbN_vLIe1gSCbK6LJsFuZBPDTRHDA>
    <xmx:tEOVYTmEhSauOpoGo_eL-l1wzjcaGsSXnL2LmT2ksa7bmtaZ2KtzcQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 17 Nov 2021 13:02:27 -0500 (EST)
Date:   Wed, 17 Nov 2021 19:02:26 +0100
From:   Greg KH <greg@kroah.com>
To:     Shaoying Xu <shaoyi@amazon.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.4] ext4: fix lazy initialization next schedule time
 computation in more granular unit
Message-ID: <YZVDshkxnSxnIdfq@kroah.com>
References: <20211115214212.GA18940@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211115214212.GA18940@amazon.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 15, 2021 at 09:42:12PM +0000, Shaoying Xu wrote:
> commit 39fec6889d15a658c3a3ebb06fd69d3584ddffd3 upstream.
> 
> Ext4 file system has default lazy inode table initialization setup once
> it is mounted. However, it has issue on computing the next schedule time
> that makes the timeout same amount in jiffies but different real time in
> secs if with various HZ values. Therefore, fix by measuring the current
> time in a more granular unit nanoseconds and make the next schedule time
> independent of the HZ value.
> 
> Fixes: bfff68738f1c ("ext4: add support for lazy inode table initialization")
> Signed-off-by: Shaoying Xu <shaoyi@amazon.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Link: https://lore.kernel.org/r/20210902164412.9994-2-shaoyi@amazon.com
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
> Member lr_sbi was removed from the struct ext4_li_request since kernel 5.9 
> so the way to access s_li_wait_mult was also changed. To adapt to the old 
> kernel versions, adjust the upstream fix by following the old ext4_li_request
> strucutre. 

Now queued up, thanks.

greg k-h
