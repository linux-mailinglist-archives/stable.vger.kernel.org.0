Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0CB4BA951
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 20:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245047AbiBQTLO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 14:11:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245046AbiBQTLN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 14:11:13 -0500
X-Greylist: delayed 411 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 17 Feb 2022 11:10:58 PST
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D3C2B254;
        Thu, 17 Feb 2022 11:10:58 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 15F865C0064;
        Thu, 17 Feb 2022 14:04:07 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 17 Feb 2022 14:04:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; bh=QFf+1UQuhFiD6o/OV3ZI0/VGRxHqSMiTS6VAmB
        d+ZNY=; b=rBNlw98TXZPXc6ttrVjSrTs79JEaU5wGOPD3zssNUtQFnfYw55U2ox
        b9ZRGqLTuQbD+DchsFTCZ3HVdQT6wZV0qIDcveOIO7VhPnowN3po5MMRzkWEJ/6u
        tFlv4n2cstgKadsDfw5rXVGgE97VEU8ciXwxo/vgm4QPDZ3+RLggIQA1d00ebWtO
        DLwhqgLk0N22z19Vtjw+yxFXEdhU1VCxUN6z99NEC6d/MhtNCTQW8EWs3mtL3im0
        bhkUEfqBxilCSGbJBnR/HuwOKv8y+aP2yyQZn7AO8p/tb5Xo3INyoLPq2Cuk8AL9
        YUIIzvGZtXnN0kWIsJRttk0Hs4S4fW1w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=QFf+1UQuhFiD6o/OV
        3ZI0/VGRxHqSMiTS6VAmBd+ZNY=; b=hUa4OM+V0redQSuX06Lq/X78CIvjGgNv/
        Z2rpI1YslyP+aF0TBmk32gobsMmOPONGkwvuB+9S96Hl72TqDztNSvBlZzpMZ021
        d50KpC7GuzrJCS+dh5oa8TbNbkrRaprFlCkDZq+7Jbw1vIFN1Do9Dc/wvHRJ6EIA
        f3ajq0TTCJ2FgbyMBo3Yyk9NpkE5xCFoEOym4iRGxwWRBbBWylCBuMnw2fAROGCX
        DxEjL2/4EAiFNu/Y/8oIt84R6CZF5UYHuIKQTa7QntCaX17hU9xrJZ3CKwsOYDi+
        pryy0+ZjWNlpi6E2B43V/5EbeboVlVQft0GXWNCl474vXOQITSIFA==
X-ME-Sender: <xms:JpwOYlmTQFjqM2tRMmep2T6EI3Xsehw0ollekkqzXm0yOz9aKWVFQg>
    <xme:JpwOYg3P4uM7LYzL9G7_ggvVbVTmRNPy6TQ_qYkAKfPmrDDTKsXfkfTv17_ZegT_W
    ojoP71JSGleOQ>
X-ME-Received: <xmr:JpwOYrou9OquFRKjVJ1ze1pDwmM3YwIEMCaWoekdvFncpKXy9oC-U2o9QWCazI9dE1NNbYHKeSVogvMFhLXdRtSsTvdRzLGe>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrjeekgdduudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:JpwOYlltThDR4CHoNg8PdlNVfOmew-KRvcI0nyQE-9_fJhDXcNpCZw>
    <xmx:JpwOYj1J8p9FzodEc24jcRMHM568QwPTiHTYUMUdoCQ7JWRZKgcKkA>
    <xmx:JpwOYkuZGLMsKZLBb2_4xNW2_7oNmnQ01xtH2ncqBKrcAVKcBttw_w>
    <xmx:J5wOYtqATbl5u0_mXpjp-OwFU30OE7qzst5TeKfRURJhlH5TvPOYlA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 17 Feb 2022 14:04:06 -0500 (EST)
Date:   Thu, 17 Feb 2022 20:03:56 +0100
From:   Greg KH <greg@kroah.com>
To:     Naohiro Aota <naohiro.aota@wdc.com>
Cc:     stable@vger.kernel.org, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH for-5.15.y] btrfs: zoned: cache reported zone during mount
Message-ID: <Yg6cHEP44PIGFva7@kroah.com>
References: <20220217045056.1299721-1-naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220217045056.1299721-1-naohiro.aota@wdc.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 17, 2022 at 01:50:56PM +0900, Naohiro Aota wrote:
> commit 16beac87e95e2fb278b552397c8260637f8a63f7 upstream.
> 
> When mounting a device, we are reporting the zones twice: once for
> checking the zone attributes in btrfs_get_dev_zone_info and once for
> loading block groups' zone info in
> btrfs_load_block_group_zone_info(). With a lot of block groups, that
> leads to a lot of REPORT ZONE commands and slows down the mount
> process.
> 
> This patch introduces a zone info cache in struct
> btrfs_zoned_device_info. The cache is populated while in
> btrfs_get_dev_zone_info() and used for
> btrfs_load_block_group_zone_info() to reduce the number of REPORT ZONE
> commands. The zone cache is then released after loading the block
> groups, as it will not be much effective during the run time.
> 
> Benchmark: Mount an HDD with 57,007 block groups
> Before patch: 171.368 seconds
> After patch: 64.064 seconds
> 
> While it still takes a minute due to the slowness of loading all the
> block groups, the patch reduces the mount time by 1/3.
> 
> Link: https://lore.kernel.org/linux-btrfs/CAHQ7scUiLtcTqZOMMY5kbWUBOhGRwKo6J6wYPT5WY+C=cD49nQ@mail.gmail.com/
> Fixes: 5b316468983d ("btrfs: get zone information of zoned block devices")
> CC: stable@vger.kernel.org
> Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/dev-replace.c |  2 +-
>  fs/btrfs/disk-io.c     |  2 +
>  fs/btrfs/volumes.c     |  2 +-
>  fs/btrfs/zoned.c       | 85 ++++++++++++++++++++++++++++++++++++++----
>  fs/btrfs/zoned.h       |  8 +++-
>  5 files changed, 87 insertions(+), 12 deletions(-)

Now queued up, thanks.

greg k-h
