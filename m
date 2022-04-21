Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E06E509AA0
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 10:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbiDUI2c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 04:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386648AbiDUI2a (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 04:28:30 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A4121573A
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 01:25:41 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 829E15C00B6;
        Thu, 21 Apr 2022 04:25:40 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 21 Apr 2022 04:25:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1650529540; x=1650615940; bh=UWozKajUeM
        qxyBZRKmNrHKofHxq5zAiqUyhyvSk8Zic=; b=QAv71617DQxzQmcYzhw1UsbreM
        59Xillp2HwqCIV/Jod6BP9HUW4Y68r1w1iKAf1vEkHbIrt/fm+9gn3Q8Saks3AT+
        16d3YQbCqQQ4sI7bU2e0L+j/L1DPxeWAcDGpVPN3EeDVe59keCw5g5wmKNA9blEH
        xF8ydMC6a7sEUX0SgsCi4n1n0/jC2HsUiDF0pPyPHvfEGYpKn7s8ci0CRTlKqHPk
        cmG/yp6kpbdkdjzUX4CBa7T2pRnnT4aGPH7AHnF8HrdoYfPNZk8zYX8JmYtCHYrR
        rBiZ1dKlrkl2I2hK91xLNBioEZ2q4eOZOL59gri9QaukgKt2ZEWkQMbv7xWg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1650529540; x=
        1650615940; bh=UWozKajUeMqxyBZRKmNrHKofHxq5zAiqUyhyvSk8Zic=; b=m
        DJ+oAnwNggGtXij5YTApuBYu1KPAOLlBQheDNM/8qtVuOn60RBUdnD9w81V5qXmZ
        lzVhrldCNC6P6NOCXOAPnYr4uf4NziIAuD+KUbnDIfwIdjhwfwUT/hfR3qzYfdQo
        e57k6jO3ImCkPlSmuz8Vi9QbjFYrLsE4DrjrBM1r1GfS8c9KuENxODruE2JRDb9Z
        zB09u9U5Gy1EaL3nI1I+jJqrkTbabz+hiNDCxWZ6GXqdhdHwHZ0l+9T3EV9bsUlX
        VJzu8xhT29W3hdXru/Th6P3clzhCuMBDpzlUsWins2kl+7duJKIIYjiVO78hDWQr
        wtJl4CUQrb0u4l1FUPJyQ==
X-ME-Sender: <xms:BBVhYgfg1RKLEpLYprkiwt25Rx2E4GzTu4aTQPP_lPBroyZuY7UbuA>
    <xme:BBVhYiPJwAyYjhHgCw0SNGxtDDVR6XR4FepIlaOUW2mJovRmuJPSxdHJFTyaa9qd1
    YlR1tEEaFXX5w>
X-ME-Received: <xmr:BBVhYhhub2BcB_uh3i23f9LhSRbBSho95k2-cGN5WBtdvkehkXXYBXOA_QD4yV-_eCfkWL5jIG0HPdBBBj8fJ0uzpPre4T03>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrtddvgddtgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeegheeuhe
    fgtdeluddtleekfeegjeetgeeikeehfeduieffvddufeefleevtddtvdenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:BBVhYl_cXr-5bq6IsCH0me5Sd26s8-YlsYNuqS0xlsHLsFEVsAWDHw>
    <xmx:BBVhYsvyOHuMyNsVz-JOOIwrN-n6H_2J8KqQh7Kpz9QE0GYn8Ghqyw>
    <xmx:BBVhYsFebP8jI5vzxcfok9lLb1HFvgVh1EoZ0hz6-KEkQ2IamoPd5Q>
    <xmx:BBVhYseJtqsUEKOIkDlDkfgG5QHdzQAu0ntTAP0cELr_GYqeQzjn9Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 21 Apr 2022 04:25:39 -0400 (EDT)
Date:   Thu, 21 Apr 2022 10:25:37 +0200
From:   Greg KH <greg@kroah.com>
To:     Georgi Djakov <djakov@kernel.org>
Cc:     Georgi Djakov <quic_c_gdjako@quicinc.com>, stable@vger.kernel.org,
        rppt@linux.ibm.com, anshuman.khandual@arm.com, david@redhat.com,
        will@kernel.org, catalin.marinas@arm.com, hch@lst.de,
        akpm@linux-foundation.org, surenb@google.com,
        quic_sudaraja@quicinc.com
Subject: Re: [PATCH 5.15 1/2] dma-mapping: remove bogus test for pfn_valid
 from dma_map_resource
Message-ID: <YmEVAQXpo3xMxB4Z@kroah.com>
References: <20220420124341.14982-1-quic_c_gdjako@quicinc.com>
 <YmD8+0S2AxAlUaG4@kroah.com>
 <ebccb5ef-e9df-48f5-ecf6-3969fb62df16@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ebccb5ef-e9df-48f5-ecf6-3969fb62df16@kernel.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 21, 2022 at 10:51:39AM +0300, Georgi Djakov wrote:
> 
> On 21.04.22 9:43, Greg KH wrote:
> > On Wed, Apr 20, 2022 at 05:43:40AM -0700, Georgi Djakov wrote:
> > > From: Mike Rapoport <rppt@linux.ibm.com>
> > > 
> > > [ Upstream commit a9c38c5d267cb94871dfa2de5539c92025c855d7 ]
> > > 
> > > dma_map_resource() uses pfn_valid() to ensure the range is not RAM.
> > > However, pfn_valid() only checks for availability of the memory map for a
> > > PFN but it does not ensure that the PFN is actually backed by RAM.
> > > 
> > > As dma_map_resource() is the only method in DMA mapping APIs that has this
> > > check, simply drop the pfn_valid() test from dma_map_resource().
> > > 
> > > Link: https://lore.kernel.org/all/20210824173741.GC623@arm.com/
> > > Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > Acked-by: David Hildenbrand <david@redhat.com>
> > > Link: https://lore.kernel.org/r/20210930013039.11260-2-rppt@kernel.org
> > > Signed-off-by: Will Deacon <will@kernel.org>
> > > Fixes: 859a85ddf90e ("mm: remove pfn_valid_within() and CONFIG_HOLES_IN_ZONE")
> > > Link: https://lore.kernel.org/r/Yl0IZWT2nsiYtqBT@linux.ibm.com
> > > Signed-off-by: Georgi Djakov <quic_c_gdjako@quicinc.com>
> > > ---
> > >   kernel/dma/mapping.c | 4 ----
> > >   1 file changed, 4 deletions(-)
> > 
> > I took this, but I do not understand why patch 2/2 in this series is
> > needed, as Sasha points out.  Cleanups are nice, but is it necessary
> > here?
> 
> It's needed as it removes the "select HAVE_ARCH_PFN_VALID" from the arm64/Kconfig.
> This will make us use the generic pfn_valid() function in mmzone.h, instead of the
> arch-specific one, that we are dropping.

Ah, that is not obvious at all.  Ok, I'll queue this up, but you should
make sure that this doesn't break anything on your systems as I thought
they required this to be a function for some reason...

thanks,

greg k-h
