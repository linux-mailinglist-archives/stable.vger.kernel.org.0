Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1694BF4C29
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbfKHMxa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:53:30 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38035 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726373AbfKHMxa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Nov 2019 07:53:30 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id D7BCE2179E;
        Fri,  8 Nov 2019 07:53:27 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 08 Nov 2019 07:53:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=tVK81DjKzTpZ5A/g0hA0fAY6+df
        srIU784jVVZ7319k=; b=JapXeNKNHpS+UcQQ9fGP8bGb8zEVSAQ5PucjjSH9cug
        9RRKtt2h3sKwtZ8ECjNDk+1eZ0W5GUNB7rOVTgzui69/ca07Vn1QrQNlXnNehqqo
        d8ma27LPbSPe+mUOrqL9bHBxhyuqN+vzF9LD9WqDR5DzxUfG5+cZt2EHV5SgYyiV
        Njlh6/JrOGvGt1OoY/5FJyEs7QqSLn6mljsZtWLHh9yWB/ZT7hi8CWndFb81yYWQ
        Oz9K+UR9R6qMEInHFjJWy+/zi3V0hkkBO1pl8BErWISO6yKBZYAzAjYqMGVhw0rk
        sL3iMW+GQfjaG6zreBHQax2PeCQx3nOSJQmNT50EAcw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=tVK81D
        jKzTpZ5A/g0hA0fAY6+dfsrIU784jVVZ7319k=; b=d0dYimQIcM5bB3P9Rcn6vP
        LXW6ResWq0zuCmejDcXKSfxLLMGxuBqztQDqmW+jo+d8H9WE43HeqXFV0ZMjjwMj
        bwwDBlEZIVF86WH/I+VoyuKsL+DUeV6XBU46vNIhFYJyjqgQGSae+gcJOZJqGZJD
        BMG7RSIeOkV3EvCiRgYHRtOqVCkzEcM8JwSgAtISI3umrVjfMlVBHg5kOKvf0BNl
        vDuGx8ULtiulMUsGl5xO10eDCH5CDGaXrxZCVGK6GjZ9/XNwSX86CMSi+JLDOgh9
        6w478JN5D2Ha3oCTMmMPGkS1AjCGitNHmGkgPmotOQpKJ5n8c40iGdjHS0U45N9g
        ==
X-ME-Sender: <xms:R2XFXQ9DA-KEgjDL13C4WB8MAqi3d4DkCPX19RKvuMknsKgLbYXg5Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddvuddggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuffhomhgrihhnpehkvghrnhgvlh
    drohhrghenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhr
    ohhmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:R2XFXWWSLBpyeWM5I8xfsOD-stkDzvC3sr3p7YPLCq0jPuXWQt5FGg>
    <xmx:R2XFXbnYExOM0DMG4RsEjkRsELrbZqXM9I-eWTP5Y_cty5nZDx9WzQ>
    <xmx:R2XFXUGQkuMCbnOhFvs-MJuOAPAoOB1OcFCVj1UVchIbNNtuYGZv6Q>
    <xmx:R2XFXSREWTJ_rhT1PmbQPNiOzmCoiSW5bts0pTk1wvAxR6CvV_XLGA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 65E033060064;
        Fri,  8 Nov 2019 07:53:27 -0500 (EST)
Date:   Fri, 8 Nov 2019 13:53:25 +0100
From:   Greg KH <greg@kroah.com>
To:     Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Cc:     stable@vger.kernel.org, vkoul@kernel.org
Subject: Re: [PATCH][STABLE backport 4.14/4.9] dmaengine: qcom: bam_dma: Fix
 resource leak
Message-ID: <20191108125325.GA738452@kroah.com>
References: <20191105201442.12477-1-jeffrey.l.hugo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105201442.12477-1-jeffrey.l.hugo@gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 05, 2019 at 12:14:42PM -0800, Jeffrey Hugo wrote:
> Commit 7667819385457b4aeb5fac94f67f52ab52cc10d5 upstream.
> 
> bam_dma_terminate_all() will leak resources if any of the transactions are
> committed to the hardware (present in the desc fifo), and not complete.
> Since bam_dma_terminate_all() does not cause the hardware to be updated,
> the hardware will still operate on any previously committed transactions.
> This can cause memory corruption if the memory for the transaction has been
> reassigned, and will cause a sync issue between the BAM and its client(s).
> 
> Fix this by properly updating the hardware in bam_dma_terminate_all().
> 
> Fixes: e7c0fe2a5c84 ("dmaengine: add Qualcomm BAM dma driver")
> Signed-off-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/r/20191017152606.34120-1-jeffrey.l.hugo@gmail.com
> Signed-off-by: Vinod Koul <vkoul@kernel.org>
> ---
> Backported to 4.14 which is lacking 6b4faeac05bc
> ("dmaengine: qcom-bam: Process multiple pending descriptors")
> This version also applies to 4.9.

Thanks for this and the 4.4 backport, all now queued up.

greg k-h
