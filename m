Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 195EB478EA5
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 15:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237505AbhLQO50 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 09:57:26 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:41723 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234609AbhLQO5Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 09:57:24 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 0D7233201EA3;
        Fri, 17 Dec 2021 09:57:23 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 17 Dec 2021 09:57:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=uXzuFOncQXw4p/5n4qrWE755cjq
        84ymeK1Faxpnud6g=; b=V12IMYb83TBgAEcqWQS0wtoDlNQW9rRA6HXBmVperpB
        scxyoH9ybGBUwALkofoq+TaVexeVUQ0vhmKA2ipF9Xt6SJsQ+9/H86v5zxJBGwRM
        QEMlqlh3uESw2kGjgCG8E5dHL7m594cUs97rvU/F8hYq2izkmoUt2YyLqh7EpFU6
        nn12aLpxAUqjR5tSOae8xTXvLeTYQXgduk8cpODgpoCfJArtA2pplgf7W1/EAZtX
        FXGPFC2QuEfIq4OmGwhJFKfGrdGyy4nfYjhhgCNe1HRhlMBgN0Oq7S26MwzPjS8g
        0mUpkkWAr3yFvLEQYNa4HcV6esHVEGXzGTCRsZxocJA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=uXzuFO
        ncQXw4p/5n4qrWE755cjq84ymeK1Faxpnud6g=; b=UJSTTG0tu0xgrZWFYeDaKd
        bAjtOAECvXXV0LmVjVAN1pCJH58qU4U2uW4jFbrG/1JhPGIh+os7rWWL+bJ9xCns
        AcZxWA2NS0q9I2LCmxpiVr1VGUHSE+MDP11GhfKZbBgPth9+ubumsF+RPspTucK9
        MhnEsDHA5LlBUQ7EGXy+htUsltYKrtUb2GEvncaycx6Y39Xzyjh2burl5qqQ9mBw
        l4jhcwCCdxF7tuwzgOKqy/8rjc+xbfZ7rZok4M0iEMn3arbyxvt9Xr0Cqvz4k64L
        MZXlIRmQsT2dh6wp+ipJmx8z5FPxQvTWVgoqCsnHcVIGU3S5kZiQh//d1AGN3dWQ
        ==
X-ME-Sender: <xms:U6W8YUTZAJ7LnvuVs-LB4bQf09q6cIbnCfO0-EW2Y6aDdgRZiR_SaA>
    <xme:U6W8YRy2NZSGfItQCF-WD5aDOcXfcG-47heorta1Ea8bCvxuGMOtQS6PJLnu7Gr10
    kwEcz70LrnnVg>
X-ME-Received: <xmr:U6W8YR0KrH1ysxNiMtmAwhr7qvZ5FQDW4rSJkT1zfo_TvFpbNOPIfo43zxpI1s7Q9haPpZ6WyT1HNHOZZEhrgaK-VDRoAPYU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrleeigdejudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelledthe
    ekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:U6W8YYDI9dAsMexGSoHZPMAMm-Ia26_Oe4FwhbGDvtSH1ldaMvb_9g>
    <xmx:U6W8YdgiDd0v4fgh1GFTmzsLZ3IbrMyO5xm43AMxTL4Os_0cthIxFQ>
    <xmx:U6W8YUqC7NujCpBQJqJgDgrsJyQCFcTzsJxrdqsHM5RpI0psES0ehQ>
    <xmx:U6W8YQuzWJUZjtoaGAmSrKvaXaPqcRE5ITlRSrQ-VGcnmS-U2YGvIQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 17 Dec 2021 09:57:22 -0500 (EST)
Date:   Fri, 17 Dec 2021 15:57:21 +0100
From:   Greg KH <greg@kroah.com>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.15] scsi: ufs: core: Retry START_STOP on UNIT_ATTENTION
Message-ID: <YbylUdf6KLwbdHJ3@kroah.com>
References: <20211216100749.202131-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211216100749.202131-1-adrian.hunter@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 16, 2021 at 12:07:49PM +0200, Adrian Hunter wrote:
> From: Jaegeuk Kim <jaegeuk@kernel.org>
> 
> commit af21c3fd5b3ec540a97b367a70b26616ff7e0c55 upstream.
> 
> Note for stable: This patch is required if commit edc0596cc04bf ("scsi:
> ufs: core: Stop clearing UNIT ATTENTIONS") has been cherry-picked.
> 
> Commit 57d104c153d3 ("ufs: add UFS power management support") made the UFS
> driver submit a REQUEST SENSE command before submitting a power management
> command to a WLUN to clear the POWER ON unit attention. Instead of
> submitting a REQUEST SENSE command before submitting a power management
> command, retry the power management command until it succeeds.
> 
> This is the preparation to get rid of all UNIT ATTENTION code which should
> be handled by users.
> 
> Link: https://lore.kernel.org/r/20211001182015.1347587-2-jaegeuk@kernel.org
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> [Adrian: For stable]
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)

Now queued up, thanks.

greg k-h
