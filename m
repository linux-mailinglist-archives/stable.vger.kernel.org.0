Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD6DC58668B
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 10:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiHAIq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 04:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbiHAIq2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 04:46:28 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 307E232BAD;
        Mon,  1 Aug 2022 01:46:26 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 520113200319;
        Mon,  1 Aug 2022 04:46:22 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 01 Aug 2022 04:46:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1659343581; x=1659429981; bh=MmWQQwnoIs
        Ox2ktt+sqgYPhQg8kOnNwtDf2Fo92hJuM=; b=j/1yvp0dvB40mwD16TE4i+E9g4
        aui9sSfvJOWtCA0hHNTpJT6sl0/QcSaES3VArdbsXpHtX/+VTqQ8H6agP0MDYwcS
        U4hF01teRwdtSCXIv9xzlj00YcV+gc/68iH6g1geEouv58n/uG4S0nWm8o7AGpby
        gmyv5T28bamtdPSw+uwTq75jtEX0dJWtgNbWQ1h2sxTJAt+1ihtRefsP3bWWzPA7
        jfXP8mJdU9TV6sA+GLXXK+UfIv3/dEwP9Ag6zICxPCpZdHrcyJhJAXyuPhAhZ2OF
        hAHzxKPIp/aKZsrEO1jRg4OlU2K2tmyrh3j/3Gvhh4VMCQebOKY9Z5iIAAAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1659343581; x=1659429981; bh=MmWQQwnoIsOx2ktt+sqgYPhQg8kO
        nNwtDf2Fo92hJuM=; b=N7RYiqbTKDoJTloKtiRNk8R85wCaKANCmum3Q4cMpCKd
        MUBypEDHdzzhKTMxqLO74WfcZk+y5ZOCL8IgXVV/jH0/4ev3P0ZjYZe6uzt3+6dD
        CHjos1ksel7N75Catzq/Wq3bxNVQLh0lTH5rjg2PPdt+KvqaG0b/pbxN4HLlacl3
        nEiA9hquQ0zQhMgvDTU67gH/idQn9QYxj+U3KfXvoHZcz3aN+0K4r/ybenzd5t9I
        vLxIJQa4fzSmRnzIcmaenizY0O3BQSCE475AlCn+pg1RluFa2OPeJTjr0qx3JO6O
        xbg7NvBuMzinBkaIbWV0QcXjdq9BhOTb7DjJZvr4rQ==
X-ME-Sender: <xms:3ZLnYizPB-U4tuh4lpaApwbGe526Zwh1b9PowmPeVKkflsZ82Qm0ag>
    <xme:3ZLnYuTZ-vSmBR9PM_PQliqPCkrhBeTRz_1wEYaguxU6MSRCp6AElndOVtXXVNijF
    rUQyVGDxR2MuQ>
X-ME-Received: <xmr:3ZLnYkX2ITzkJBDqpJ99w-EEqL5Y0SkUiDPWvdmh5-r36ycz4jREhfnNIaSFbif7856bU-qkm9dNyUWfBG84mqTiWncyzgc5zQugPQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvddvfedgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepgeehue
    ehgfdtledutdelkeefgeejteegieekheefudeiffdvudeffeelvedttddvnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:3ZLnYohFN0BbwBXymKYrYPYOhDdy3A72PclkGWswDjtV0-jskTz7Lw>
    <xmx:3ZLnYkCPpEVpAwKxEeM5cmGgvpL-KAY2mgYJzDCKmhRhGTeaZ9JVCg>
    <xmx:3ZLnYpIaq4-_TPpoKx5Vk6xqo5P39RyzRd6z4nSXtoNRoZRV7OTrIQ>
    <xmx:3ZLnYuy4M526QGgGht5MOgw0gd5qDQrm7BTIBZQV3zpx81mrzKtGVw>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 1 Aug 2022 04:46:21 -0400 (EDT)
Date:   Mon, 1 Aug 2022 10:46:11 +0200
From:   Greg KH <greg@kroah.com>
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     ming.lei@redhat.com, stable@vger.kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, yukuai3@huawei.com,
        yi.zhang@huawei.com
Subject: Re: [PATCH stable 5.4] scsi: core: Fix race between handling
 STS_RESOURCE and completion
Message-ID: <YueS04RIq2gTUGgg@kroah.com>
References: <20220801012251.1959147-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220801012251.1959147-1-yukuai1@huaweicloud.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 01, 2022 at 09:22:51AM +0800, Yu Kuai wrote:
> From: Ming Lei <ming.lei@redhat.com>
> 
> commit 673235f915318ced5d7ec4b2bfd8cb909e6a4a55 upstream.
> 
> When queuing I/O request to LLD, STS_RESOURCE may be returned because:
> 
>  - Host is in recovery or blocked
> 
>  - Target queue throttling or target is blocked
> 
>  - LLD rejection
> 
> In these scenarios BLK_STS_DEV_RESOURCE is returned to the block layer to
> avoid an unnecessary re-run of the queue. However, all of the requests
> queued to this SCSI device may complete immediately after reading
> 'sdev->device_busy' and BLK_STS_DEV_RESOURCE is returned to block layer. In
> that case the current I/O won't get a chance to get queued since it is
> invisible at that time for both scsi_run_queue_async() and blk-mq's
> RESTART.
> 
> Fix the issue by not returning BLK_STS_DEV_RESOURCE in this situation.
> 
> Link: https://lore.kernel.org/r/20201202100419.525144-1-ming.lei@redhat.com
> Fixes: 86ff7c2a80cd ("blk-mq: introduce BLK_STS_DEV_RESOURCE")
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Sumit Saxena <sumit.saxena@broadcom.com>
> Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Ewan Milne <emilne@redhat.com>
> Cc: Long Li <longli@microsoft.com>
> Reported-by: John Garry <john.garry@huawei.com>
> Tested-by: "chenxiang (M)" <chenxiang66@hisilicon.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/scsi/scsi_lib.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Both now queued up, thanks.

greg k-h
