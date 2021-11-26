Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D26ED45E7DD
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 07:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352580AbhKZGgR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 01:36:17 -0500
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:41993 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352604AbhKZGeR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 01:34:17 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id 4911758030B;
        Fri, 26 Nov 2021 01:31:04 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Fri, 26 Nov 2021 01:31:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=TQT7bhXqwH8akKiIgle7DOfwOzq
        sXFgyjCJ+JSwVBvM=; b=UArY7GF/grHcjnLfBnXEUU1gwzqTyNaaOluwb+sg0Eo
        pm+/1TsfpLJAebvBYApjuv3QnnnlEa3HKiaUw0P9fxcA8XHtXWdnrWB6sAwvLghr
        LOvI9XUzjoetQ7FveDlUQAeKg8j8FYqbdK43JJXM+GiYg58cOSAI21yr+b4cxxoM
        OszMI1XHTjBFRX7/Gu1lFy/6jg5XBUrEim4Fz5YGMOoe554GfMxmBrs72PDEP0xg
        Twv/mANVLQoUrK8AtS7bFKIgj4+WdMrCyOSAqYbHBgb68AiUBTRs5wlU4U5MOAja
        IawCmEDPlpOyGCwnyvoSkIwlNuxwVJTHw3clze+/mZA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=TQT7bh
        XqwH8akKiIgle7DOfwOzqsXFgyjCJ+JSwVBvM=; b=ad7MUCGgy6GBCEqiy5C7uF
        ENvuoMF/KjO9QrM9e+6Lfkql40q5ow+9hhnHEjNDZ0/v0R7eBG+dbTVPRg45BseY
        l6gY4gC/yALZBstQklXQfqD4FBY+g2bFVHBCDHfB/MaI8gEciv4JrkQ6yhxBrKz1
        CGbqK6u2RIS7vXeNUVfmhjyT7Tn+vfL90md6jHPu9Ueu8HrkWljf1niHkQCDocoW
        CaUyH3Psf9Q7ARs3nafg+tDn4VnCCTVOknEiaYbfxiG7Fdv6imBrkTFyijuFmkaH
        1BDnujDlMfsYcznk3Zmu2vrST6xQ8S63AWa4KUxxZ5tTsz/Pu9c7qQdxIaygrzXw
        ==
X-ME-Sender: <xms:J3-gYbgcJ7yuOd9PxPF7z6PUzVcR_5VDdV8atw8k7Ay6OiR9EabrhQ>
    <xme:J3-gYYCmCpJxWZh5GwcOX9abxzx6nWFs5JXay71t0m3W-qzumEF6ZXT_67GjD3Ksw
    JVBrl8GJsYpPw>
X-ME-Received: <xmr:J3-gYbE8gDUQBc2O0-GjvN0MDTqjRvWxBoOuptqQU9aRGWTCcZD6Ednqpvz5dH-YyVj0S47HffvL0d2035sbccQtgMwchpU5>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrhedugdeliecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjsehttdertd
    dttddvnecuhfhrohhmpefirhgvghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeen
    ucggtffrrghtthgvrhhnpeeuleeltdehkeeltefhleduuddvhfffuedvffduveegheekge
    eiffevheegfeetgfenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:J3-gYYRJMLRkMk3wyBE0Iv5OCuMK6kiSI-TXUIV8c2nhFI-hcKra9w>
    <xmx:J3-gYYypj5QB_CACUx3mkprwpqxZmTsm6Qj8en4BV4UyKs8jn2_aEQ>
    <xmx:J3-gYe6UdYl0Eb_CsMSzKsj3799OfW3C_EshpDEE60S5X8eTugPQWw>
    <xmx:KH-gYZT9W9xTQhOIPR-7TKNmuMW6_Ud9CatWFziCagno6socGADzTQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 26 Nov 2021 01:31:02 -0500 (EST)
Date:   Fri, 26 Nov 2021 07:31:00 +0100
From:   Greg KH <greg@kroah.com>
To:     guangming.cao@mediatek.com
Cc:     robin.murphy@arm.com, Brian.Starkey@arm.com,
        benjamin.gaignard@linaro.org, christian.koenig@amd.com,
        dri-devel@lists.freedesktop.org, john.stultz@linaro.org,
        labbott@redhat.com, linaro-mm-sig@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mediatek@lists.infradead.org,
        lmark@codeaurora.org, matthias.bgg@gmail.com,
        sumit.semwal@linaro.org, wsd_upstream@mediatek.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] dma-buf: system_heap: Use 'for_each_sgtable_sg' in
 pages free flow
Message-ID: <YaB/JHP/pMbgRJ1O@kroah.com>
References: <eb6cc56d-cbe0-73d5-d4f5-0aa2b76272a4@arm.com>
 <20211126031605.81436-1-guangming.cao@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211126031605.81436-1-guangming.cao@mediatek.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 26, 2021 at 11:16:05AM +0800, guangming.cao@mediatek.com wrote:
> From: Guangming <Guangming.Cao@mediatek.com>
> 
> For previous version, it uses 'sg_table.nent's to traverse sg_table in pages
> free flow.
> However, 'sg_table.nents' is reassigned in 'dma_map_sg', it means the number of
> created entries in the DMA adderess space.
> So, use 'sg_table.nents' in pages free flow will case some pages can't be freed.
> 
> Here we should use sg_table.orig_nents to free pages memory, but use the
> sgtable helper 'for each_sgtable_sg'(, instead of the previous rather common
> helper 'for_each_sg' which maybe cause memory leak) is much better.
> 
> Fixes: d963ab0f15fb0 ("dma-buf: system_heap: Allocate higher order pages if available")
> 
> Signed-off-by: Guangming <Guangming.Cao@mediatek.com>
> ---
>  drivers/dma-buf/heaps/system_heap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-buf/heaps/system_heap.c
> index 23a7e74ef966..8660508f3684 100644
> --- a/drivers/dma-buf/heaps/system_heap.c
> +++ b/drivers/dma-buf/heaps/system_heap.c
> @@ -289,7 +289,7 @@ static void system_heap_dma_buf_release(struct dma_buf *dmabuf)
>  	int i;
>  
>  	table = &buffer->sg_table;
> -	for_each_sg(table->sgl, sg, table->nents, i) {
> +	for_each_sgtable_sg(table, sg, i) {
>  		struct page *page = sg_page(sg);
>  
>  		__free_pages(page, compound_order(page));
> -- 
> 2.17.1
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
