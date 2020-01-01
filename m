Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A93B12DF9D
	for <lists+stable@lfdr.de>; Wed,  1 Jan 2020 18:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbgAARCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jan 2020 12:02:54 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:42215 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727170AbgAARCy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jan 2020 12:02:54 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id CD4F621EFE;
        Wed,  1 Jan 2020 12:02:52 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 01 Jan 2020 12:02:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=MAkW5HOVDbL6U65BugZhLWiC8WF
        DjukILBSbnpq0heM=; b=dZX0NVKz/nfP4q7JiaQma3dzTPR4o/ZW7iXACKGZB62
        2EXFgrwJlWCZKUjDgaGCw2WruIHCI0wZLkYyQuOAc4iqkjhn7Ay1LTp1aHfjgSmd
        c87uNpagcIu9ehtrOFe8Hb611JXXfsd3+f25MnPKDH0G+1Q5/DESMdmsA1IX7oJC
        h7PnX9NmjHgQbY5HxtvFcs7HquxhxIc8eloDRMOxzpoHwYVv8Azj9oAd9ljKhoGB
        aTSu6kURpBQ2CHeNr4uR7dcrx21EyCACk5XVMQNjJVJsNrZz15vIk2PgiUfn1w1w
        IhlrmlisSauJXJ44SGbYD32UWK43o4ZkGOtomFojT3w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=MAkW5H
        OVDbL6U65BugZhLWiC8WFDjukILBSbnpq0heM=; b=BPnAB88OmtCXOQAM2ItJgJ
        PesHQqa6Nx4WAWnEpbdtzRqhsyAsSkxE0oHdGIl1FDs975EiB7025xCNo6kscaGH
        atWIsq+gPVJwW7PmF6BEPdeimfP90YrB9RYq33/zj4Cyl3yySHIGW59Ax2KPAiPW
        4PrsmCoOMvRsVBOhL1xK+yBN9zTcEBmEIRgxewLceZC23zkasatY9feK5e/lAZHu
        wfjw4I/IH7YEllrn8I2UlSQZSxz2KW43YfqPbdNXB9WVvPHeLtnfDTtqe5oOR72z
        DVwUcBCjKsjhNTgKPsMX92AtBFhv127403joe3qOZNhEcq+vDvVKJ5Y9/pChcIpA
        ==
X-ME-Sender: <xms:vNAMXho_Neo6Gly_pSOiqrd1GdgKiHUXGTpIVdztAvHKikw2mlg6Rg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdefledgleehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:vNAMXrnwS0uAZW_Ll8-UKDVlpIXe5an064vtYsOlXfwjxpQbZi6cSg>
    <xmx:vNAMXla-zbfAqlrFN1BOGQ9u6nfrQNYTFvM9bcQSZYBbncfg4yLg9w>
    <xmx:vNAMXjWsxjtZ9IRlNDo9gmeTqBhVEVS6sJTL8kH5DbkLC-r-VOZWNQ>
    <xmx:vNAMXjOVt05QkHcBwMQCavRMjyOQvhdQ_FmZFRGuP0VIJArF-AJJ7Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id CEBF23060886;
        Wed,  1 Jan 2020 12:02:51 -0500 (EST)
Date:   Wed, 1 Jan 2020 18:02:49 +0100
From:   Greg KH <greg@kroah.com>
To:     Daniel Wagner <dwagner@suse.de>
Cc:     stable@vger.kernel.org, Pavel Machek <pavel@denx.de>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v4.4] net: davinci_cpdma: use dma_addr_t for DMA address
Message-ID: <20200101170249.GD2712976@kroah.com>
References: <20191221104948.10233-1-dwagner@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191221104948.10233-1-dwagner@suse.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 21, 2019 at 11:49:48AM +0100, Daniel Wagner wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> [ Upstream commit 84092996673211f16ef3b942a191d7952e9dfea9 ]
> 
> The davinci_cpdma mixes up physical addresses as seen from the CPU
> and DMA addresses as seen from a DMA master, since it can operate
> on both normal memory or an on-chip buffer. If dma_addr_t is
> different from phys_addr_t, this means we get a compile-time warning
> about the type mismatch:
> 
> ethernet/ti/davinci_cpdma.c: In function 'cpdma_desc_pool_create':
> ethernet/ti/davinci_cpdma.c:182:48: error: passing argument 3 of 'dma_alloc_coherent' from incompatible pointer type [-Werror=incompatible-pointer-types]
>    pool->cpumap = dma_alloc_coherent(dev, size, &pool->phys,
> In file included from ethernet/ti/davinci_cpdma.c:21:0:
> dma-mapping.h:398:21: note: expected 'dma_addr_t * {aka long long unsigned int *}' but argument is of type 'phys_addr_t * {aka unsigned int *}'
>  static inline void *dma_alloc_coherent(struct device *dev, size_t size,
> 
> This slightly restructures the code so the address we use for
> mapping RAM into a DMA address is always a dma_addr_t, avoiding
> the warning. The code is correct even if both types are 32-bit
> because the DMA master in this device only supports 32-bit addressing
> anyway, independent of the types that are used.
> 
> We still assign this value to pool->phys, and that is wrong if
> the driver is ever used with an IOMMU, but that value appears to
> be never used, so there is no problem really. I've added a couple
> of comments about where we do things that are slightly violating
> the API.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> ---
> 
> Hi,
> 
> Pavel reported this fix is needed for the CIP kernel.
> 
> Since this patch was added to v4.5, we only need to backport
> to v4.4.

Now queued up, thanks.

greg k-h
