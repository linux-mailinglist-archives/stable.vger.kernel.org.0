Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04D2650984C
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 09:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385447AbiDUGsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 02:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385233AbiDUGqs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 02:46:48 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0179414095
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 23:43:14 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id D65C85C0102;
        Thu, 21 Apr 2022 02:43:11 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 21 Apr 2022 02:43:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1650523391; x=1650609791; bh=9qG4AnldRe
        irFG1fVaei7zZ4OCNlT1HdSQLZvgH3468=; b=PgYb8xEfwTw86BXN2sFnnCqrGl
        Y2gpNfKMzf4Ln5HzgXp1uN7oln6zpNvAQscnDjon2kjK2FJNhfKAo4HtNIALZbip
        /hGzji8eQArRM0ssnL6e+DepcpgUxoRVZ2w/EQEKIianwyAUwd73BqCtIagIcWvv
        oCF48ZJ/TM/OocrNAPTHVDOvG51PKy0XfJ5S5KTe3SPUSoFUEVd2g+NSWiKMefNc
        5a6nQVgEVblaiuvMIoJFcF0vKti1+O63EgvIjCAIO/pwK5Z5fWNjdhmLAHgIs4Sg
        4frQgirGC3iiQOLGZWc99bFuxWJlMTofJwrNPUiIYcrRCQpc7Idq3pGLJldA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1650523391; x=
        1650609791; bh=9qG4AnldReirFG1fVaei7zZ4OCNlT1HdSQLZvgH3468=; b=u
        Q84/Np/dsM88QZ2aUDwr1t1mLHiDnVx8MCDy5du6xreR+K2IM9sugLaDia2CFBF3
        cwHL9NgH7SoZKz/rUKq74IYfwIrUGG+oNPLiTxcOAr2jbaSbN3pYoJIfY1KrZpFm
        P4krFezS0SNx1fxehBkoZAhgaCnpytAUiWm/wFN9M6lDwqLZAzIBz6tMhj8OLO0s
        dppDzUIwUCzENygoRZXWJdxPUF+iSTDbOrc97B3pd86xeQeiIrSMZ+deDggwioyl
        1MnSrV9yTEPqZsoCYiyNnyE1VBg5NdOkJfkIDarpbZI5B8NFwDt+znkrCf/ILbjb
        TBgiyIl4WNLB7xcGnopbQ==
X-ME-Sender: <xms:__xgYuqQsittkixq77GYSNhGtkqBTd9UyrGxouiHtknFjne81N35xQ>
    <xme:__xgYsoL6NRtZq80Frtddum-lmOFjThCdLwmZY4MEfH0oY4CHBv92CX2DqXlRDMdc
    oOnmjrqSsy7Hg>
X-ME-Received: <xmr:__xgYjPZ_CJcHZnehaS7zpvzSLjV8n7K6g9EaGKpL4l-54G9pG8y-6WmWEW2__Wc0glmi9FbetKZSKmB8vi95Av69GZwpWGG>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrtddugdduudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfhfgggtuggjsehttd
    ertddttddvnecuhfhrohhmpefirhgvghcumffjuceoghhrvghgsehkrhhorghhrdgtohhm
    qeenucggtffrrghtthgvrhhnpeegheeuhefgtdeluddtleekfeegjeetgeeikeehfeduie
    ffvddufeefleevtddtvdenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:__xgYt64s8p490-wSij0PRhS1V7S-NORjPlsPyskVz-7QzE33HJUXQ>
    <xmx:__xgYt7uiPOQVxh1I_zF0oW5MZOuvT5SDHFWsbw5oYJvC9me5M522Q>
    <xmx:__xgYtjEd_HK6SC1STTqXRjthaOi1U76nP80ijA31SdUhc5PcFSnXg>
    <xmx:__xgYipo5FCeUMdtxK_YNHRuKRS75LkgF1CaX-b5eF5qBY_Ic9S-VQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 21 Apr 2022 02:43:10 -0400 (EDT)
Date:   Thu, 21 Apr 2022 08:43:07 +0200
From:   Greg KH <greg@kroah.com>
To:     Georgi Djakov <quic_c_gdjako@quicinc.com>
Cc:     stable@vger.kernel.org, rppt@linux.ibm.com,
        anshuman.khandual@arm.com, david@redhat.com, will@kernel.org,
        catalin.marinas@arm.com, hch@lst.de, akpm@linux-foundation.org,
        surenb@google.com, quic_sudaraja@quicinc.com, djakov@kernel.org
Subject: Re: [PATCH 5.15 1/2] dma-mapping: remove bogus test for pfn_valid
 from dma_map_resource
Message-ID: <YmD8+0S2AxAlUaG4@kroah.com>
References: <20220420124341.14982-1-quic_c_gdjako@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220420124341.14982-1-quic_c_gdjako@quicinc.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 20, 2022 at 05:43:40AM -0700, Georgi Djakov wrote:
> From: Mike Rapoport <rppt@linux.ibm.com>
> 
> [ Upstream commit a9c38c5d267cb94871dfa2de5539c92025c855d7 ]
> 
> dma_map_resource() uses pfn_valid() to ensure the range is not RAM.
> However, pfn_valid() only checks for availability of the memory map for a
> PFN but it does not ensure that the PFN is actually backed by RAM.
> 
> As dma_map_resource() is the only method in DMA mapping APIs that has this
> check, simply drop the pfn_valid() test from dma_map_resource().
> 
> Link: https://lore.kernel.org/all/20210824173741.GC623@arm.com/
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Acked-by: David Hildenbrand <david@redhat.com>
> Link: https://lore.kernel.org/r/20210930013039.11260-2-rppt@kernel.org
> Signed-off-by: Will Deacon <will@kernel.org>
> Fixes: 859a85ddf90e ("mm: remove pfn_valid_within() and CONFIG_HOLES_IN_ZONE")
> Link: https://lore.kernel.org/r/Yl0IZWT2nsiYtqBT@linux.ibm.com
> Signed-off-by: Georgi Djakov <quic_c_gdjako@quicinc.com>
> ---
>  kernel/dma/mapping.c | 4 ----
>  1 file changed, 4 deletions(-)

I took this, but I do not understand why patch 2/2 in this series is
needed, as Sasha points out.  Cleanups are nice, but is it necessary
here?

thanks,

greg k-h
