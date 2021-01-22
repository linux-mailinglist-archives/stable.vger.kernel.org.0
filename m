Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95519300228
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 12:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727705AbhAVL4t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 06:56:49 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:43653 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727898AbhAVK6k (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jan 2021 05:58:40 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 3BD615C011A;
        Fri, 22 Jan 2021 05:57:16 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 22 Jan 2021 05:57:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm2; bh=I
        MVygnsRJIL4hb8tM1Qe6tCzc5Sr0FFuKwVF1vo0P+4=; b=teBlpqg5STFuGzQTw
        Je1PQEGVPfrZy+Os7YO5iLpcvWeEGuw9fmow75cOO13ls0qv5iw51MVGXmHssot2
        wDy2KavVvJqXflLZ77mAPLQiLLlvck9rSS0dojfb4TAK5swPKEXxmT29kG2MIoGt
        1MnGxIiK/CNe11uZQYFU9I1qzTXGdk2yIeLz/ZltN2BWzNI7OyXbw2dr3Zcy0ffX
        hULiHR4X/FmvOymwUrh33dnTEjkRKsuYVpCmJM5jqz2wkm1Jkk6+i2O0ITClfHCD
        sGmMzGbeSqwSUv3F9pDUl0hKLT/Z3sevVBxe2g4kvQBeTjzULoASzZrLa8IYMZTH
        sC0aQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=IMVygnsRJIL4hb8tM1Qe6tCzc5Sr0FFuKwVF1vo0P
        +4=; b=PKjA2+OCFdOk6fJRqU5N+tXVz+VKlR3VIYU7vTy3V1gxUuj5jaEIuWnE4
        fPzEypmsBs9Y+HXxhBXUtR/wdNxfa2Luvn2o48i4R32p1xkN1bqXLMK+rPYVHB3w
        ghZV0cPqTKOPLFq3rThk+KFyps2V3T/kWtH0YbGW0sGe4MJA580jj/OEew6uhkKY
        sGtuXhAQoUg8TxyBlYlmVa3f8RKJ3ZoXMb4DB9Fc6WeNgxAGH5Tuo6WV+Iqzpcpy
        GfcUuj3Hjn48BK+m1fARNPAHFUUohgVkfY8zFQmg/4GZrz+4Qu3iZIYp2rHqJtXr
        5fPQ6v48R635pHV1k3cibOpAhUF0Q==
X-ME-Sender: <xms:i68KYPWIt5jaIERV1MFvd7Xx8RfSGXehl34SZVVWTpSsos2hsxOPLA>
    <xme:i68KYHmKA-uVLo2Y5by3PWFxnyNE3KaPdzkxYCoCZ8b4ZdIUoYUpSgPzs61BkbVos
    n_dME_U1cUt0g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeigddvhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggugfgjsehtkeertddttddunecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpedvfffgue
    eiuefhheevheetgfehvdefgeekfeevueejfeeftdetudetiefhheffvdenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhm
X-ME-Proxy: <xmx:i68KYLYD18vyGABq8ul-0_2OT0QaH4cod4nYj2_BlMrZFB7aEwZ2lw>
    <xmx:i68KYKWEjXy7JHyrcsozmeBgf1TmDOVS4rxe3B9KjyWNwEOQ4wbAew>
    <xmx:i68KYJl8zccV0CesSfkeUykFu_qvXk-S_6XG4nQvjBdJnPb4kvQ9QA>
    <xmx:jK8KYOwjyCf2N3lbl3ANW2mmkB2fkh3-pTWzJO9msabM0ZRja2BEvA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 552E21080064;
        Fri, 22 Jan 2021 05:57:15 -0500 (EST)
Date:   Fri, 22 Jan 2021 11:57:13 +0100
From:   Greg KH <greg@kroah.com>
To:     Jouni =?iso-8859-1?Q?Sepp=E4nen?= <jks@iki.fi>
Cc:     stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [BACKPORT 4.4.y, 4.9.y] net: cdc_ncm: correct overhead in
 delayed_ndp_size
Message-ID: <YAqviTgJl/85S/q2@kroah.com>
References: <161070228139179@kroah.com>
 <20210122045457.50289-1-jks@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210122045457.50289-1-jks@iki.fi>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 22, 2021 at 06:54:57AM +0200, Jouni Seppänen wrote:
> From: Jouni K. Seppänen <jks@iki.fi>
> 
> commit 7a68d725e4ea384977445e0bcaed3d7de83ab5b3 upstream.
> 
> Aligning to tx_ndp_modulus is not sufficient because the next align
> call can be cdc_ncm_align_tail, which can add up to ctx->tx_modulus +
> ctx->tx_remainder - 1 bytes. This used to lead to occasional crashes
> on a Huawei 909s-120 LTE module as follows:
> 
> - the condition marked /* if there is a remaining skb [...] */ is true
>   so the swaps happen
> - skb_out is set from ctx->tx_curr_skb
> - skb_out->len is exactly 0x3f52
> - ctx->tx_curr_size is 0x4000 and delayed_ndp_size is 0xac
>   (note that the sum of skb_out->len and delayed_ndp_size is 0x3ffe)
> - the for loop over n is executed once
> - the cdc_ncm_align_tail call marked /* align beginning of next frame */
>   increases skb_out->len to 0x3f56 (the sum is now 0x4002)
> - the condition marked /* check if we had enough room left [...] */ is
>   false so we break out of the loop
> - the condition marked /* If requested, put NDP at end of frame. */ is
>   true so the NDP is written into skb_out
> - now skb_out->len is 0x4002, so padding_count is minus two interpreted
>   as an unsigned number, which is used as the length argument to memset,
>   leading to a crash with various symptoms but usually including
> 
> > Call Trace:
> >  <IRQ>
> >  cdc_ncm_fill_tx_frame+0x83a/0x970 [cdc_ncm]
> >  cdc_mbim_tx_fixup+0x1d9/0x240 [cdc_mbim]
> >  usbnet_start_xmit+0x5d/0x720 [usbnet]
> 
> The cdc_ncm_align_tail call first aligns on a ctx->tx_modulus
> boundary (adding at most ctx->tx_modulus-1 bytes), then adds
> ctx->tx_remainder bytes. Alternatively, the next alignment call can
> occur in cdc_ncm_ndp16 or cdc_ncm_ndp32, in which case at most
> ctx->tx_ndp_modulus-1 bytes are added.
> 
> A similar problem has occurred before, and the code is nontrivial to
> reason about, so add a guard before the crashing call. By that time it
> is too late to prevent any memory corruption (we'll have written past
> the end of the buffer already) but we can at least try to get a warning
> written into an on-disk log by avoiding the hard crash caused by padding
> past the buffer with a huge number of zeros.
> 
> Signed-off-by: Jouni K. Seppänen <jks@iki.fi>
> Fixes: 4a0e3e989d66 ("cdc_ncm: Add support for moving NDP to end of NCM frame")
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=209407
> Reported-by: kernel test robot <lkp@intel.com>
> Reviewed-by: Bjørn Mork <bjorn@mork.no>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> [jks@iki.fi: backport to 4.4.y, 4.9.y]
> Signed-off-by: Jouni K. Seppänen <jks@iki.fi>
> ---
> Backport to 4.4.y and 4.9.y: there is no skb_put_zero or ctx->tx_curr_size
> so use memset(skb_put(...)) and ctx->tx_max, respectively.

Thanks for the backport, now queued up.

greg k-h
