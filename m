Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27A59D92A7
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 15:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728986AbfJPNgY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 09:36:24 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:48369 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727619AbfJPNgY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 09:36:24 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 9B96921F5A;
        Wed, 16 Oct 2019 09:36:23 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 16 Oct 2019 09:36:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=I2axke+zfKE1kKiY2eqd2wz8yhT
        xSBuSvwgkdaPlAz8=; b=nhf1iNJeFNZGfSlMpkPiPaxvmV5MW8T0pZ94g/R3wfW
        pI11lv5wujCQlrJgtlxoJ5pY1UPQ0h9HgSPP6TDd/bPpQ/fkG1k42K0/In9nDs6o
        c7ZsTP8S5yVykPIpOsV96N124vCejRwYUPCMWEAPZdWJUflwrRFgU/P0ertRAsi1
        lsTlHLznF9TNB7v/GNbpLQE4ghHOc+FGBd/kqtYuM+nv89thOHS9FArftgXziXo8
        nULxD7IgyV9YlHjmWze06Y1ynykwwa/VYZHER6BZ4jCMg1On0RA1ZSKjRSCnbDy+
        YoMdn3SXxJzjPQYkvb3uLv8aGe/Exf9stDR2arXYAXA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=I2axke
        +zfKE1kKiY2eqd2wz8yhTxSBuSvwgkdaPlAz8=; b=PCrECjzdfAZLCQLqMtlJI2
        E94ajZQj8WH/+upP1ziMXyI58eq3bmeFSTeBCXuZ3xQsj1saddeeR47vNJDXRP+q
        mLVw/iNDAqk5pL2wCQESg5/HXwIlE7WpxaEx2o6zBSaRqsr1czgxzLm1AICNiIz9
        fZnQIX6ozWfdB4fS81/KRwm79tQIuP857ixXMgZhynDqcyZw2Y5iED38UuGYsCrE
        CP19pdaEhrxRN1AxvezYvITB9xWFsuXcxQQbTPjb/wZDIyNzZtjZYwjI/nrtj1uB
        RYBv+6A9xg0x8pNRm9699r53M9ZThPXA7l3/mmHfz5je1IjRWtgn6o20dhNuA0uw
        ==
X-ME-Sender: <xms:1xynXU_NtLP0MnOQD5_4_lZ0RciNDBPyTlSROpOnpYXlNAaqmaXjUg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrjeehgdeikecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepvddtledrudefiedrvdefie
    drleegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:1xynXRbo9Np4Ef78DYHmmaf8kqySIn5DL6Qk4cWltfJXQWh5V4MFew>
    <xmx:1xynXaT9AK4-YCQo6C-eaFTD5JS5ADrsZrjORNHLHldXTwcTzDZ7QQ>
    <xmx:1xynXYmTPRANBQYaeN90qnA9qZ9IO_AXaiKa4BM1CIFQHueCD0SUJg>
    <xmx:1xynXW0iSV7sMiosVF-iBVkdY0_3-SxeVoyXDKegTwKRdvV9-BZ3sQ>
Received: from localhost (unknown [209.136.236.94])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4A80E80064;
        Wed, 16 Oct 2019 09:36:16 -0400 (EDT)
Date:   Wed, 16 Oct 2019 06:36:14 -0700
From:   Greg KH <greg@kroah.com>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     stable@vger.kernel.org, robdclark@chromium.org, cphealy@gmail.com,
        jonathan@marek.ca
Subject: Re: [PATCH] drm/msm: Use the correct dma_sync calls harder
Message-ID: <20191016133614.GA198670@kroah.com>
References: <20191015133353.14900-1-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191015133353.14900-1-festevam@gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 15, 2019 at 10:33:53AM -0300, Fabio Estevam wrote:
> From: Rob Clark <robdclark@chromium.org>
> 
> [ Upstream commit 9f614197c744002f9968e82c649fdf7fe778e1e7 ]
> 
> Looks like the dma_sync calls don't do what we want on armv7 either.
> Fixes:
> 
>   Unable to handle kernel paging request at virtual address 50001000
>   pgd = (ptrval)
>   [50001000] *pgd=00000000
>   Internal error: Oops: 805 [#1] SMP ARM
>   Modules linked in:
>   CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.3.0-rc6-00271-g9f159ae07f07 #4
>   Hardware name: Freescale i.MX53 (Device Tree Support)
>   PC is at v7_dma_clean_range+0x20/0x38
>   LR is at __dma_page_cpu_to_dev+0x28/0x90
>   pc : [<c011c76c>]    lr : [<c01181c4>]    psr: 20000013
>   sp : d80b5a88  ip : de96c000  fp : d840ce6c
>   r10: 00000000  r9 : 00000001  r8 : d843e010
>   r7 : 00000000  r6 : 00008000  r5 : ddb6c000  r4 : 00000000
>   r3 : 0000003f  r2 : 00000040  r1 : 50008000  r0 : 50001000
>   Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
>   Control: 10c5387d  Table: 70004019  DAC: 00000051
>   Process swapper/0 (pid: 1, stack limit = 0x(ptrval))
> 
> Cc: <stable@vger.kernel.org> #5.3
> Signed-off-by: Rob Clark <robdclark@chromium.org>
> Fixes: 3de433c5b38a ("drm/msm: Use the correct dma_sync calls in msm_gem")
> Tested-by: Fabio Estevam <festevam@gmail.com>
> Signed-off-by: Fabio Estevam <festevam@gmail.com>
> ---
>  drivers/gpu/drm/msm/msm_gem.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Now queued up, thanks!

greg k-h
