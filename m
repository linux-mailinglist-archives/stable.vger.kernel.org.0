Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73A6E6C137A
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 14:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbjCTNd7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 09:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjCTNd6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 09:33:58 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D429883E0
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 06:33:56 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 4B1EA5C00D3;
        Mon, 20 Mar 2023 09:33:56 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 20 Mar 2023 09:33:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1679319236; x=1679405636; bh=vx
        rSDkxArUxhWRWnBmm4Jatgs3YB2HWBde0SK2BeMNM=; b=gSXtTWL+wXWtPnJWlk
        yx5b9wX3CngwudDpDsvNgAcCicd5VRs5i1XkTLdGkjohvwlZ+VfB3hSSgqUzeRH4
        DRdOG7ah8s/jaCik28veCyqYgHov9DOScUIETllTxaplpP9TKtl6yJSruvFuzZS5
        oEwK9JdWwE/yQUwt2ZcPz19qc7g84kIvAfQBRm6kWfgyKUHZ3iPYjHgY1lXyFy4g
        jNJtW8JKs25OwFboba6xv+4cepcJ0P4jwUGFu7v6P3ivUcLpnEuGooL7NpIrfpRH
        Ecgx24s08cQMqm6r6SHx4r8uetFn+PT/qO/zN39so6cxxgCq5Gl+ZlJLkDd2EVIw
        j3Lg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1679319236; x=1679405636; bh=vxrSDkxArUxhW
        RWnBmm4Jatgs3YB2HWBde0SK2BeMNM=; b=ml06d3HbTCK+RS5xlOkHO6SD1ErIr
        ROeJeO5XljS4sDWQfFfTgNZlV5jWLiTQU+pZMXk48VNkgAkWnsWucx4HD9uc8e5W
        dFSaliRMC4QfKfGX4e4x41X77nrdzc+FtROqRd2w22RBd/aItyvFEh/YxTOhNUHi
        aoHack4ChSsBnQAZWfchzJUc5Wx5cV/Qwr0IJTu80x3+mUQ+O92TenNu9LbXj0s0
        4E7/LvTx7Jmq2CHQhrSXr/JelRoNuB6akzzrE8J70mzAoS7DpVCZw5NCsVSIFUEx
        HWIkvU4NM3sI6dlGpXjG/KAQ9Axu+1LjvU1Pd4KV1bvnIECg48BmroNkw==
X-ME-Sender: <xms:xGAYZHBSl_P0QZSKr0o9ymBTLvEFGdqzaI3JsfjvxEbUP9_ITTTKPQ>
    <xme:xGAYZNjVtBIGyDyk23ulfemh6HPrAeiE_Jc2ckxJ7X8cAwQ2UYHgMUAvVkRMWE3cY
    mi5zxoUZNdMWg>
X-ME-Received: <xmr:xGAYZCl1n9nfqMKNvstso6f5l9CXXOjc8ZojWqB9tovEqj2qCt2jCXwRtNyNCP_1xm8e5ulqRtRv8VCUanl1RxlpIw0TYNTzl6_AoA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdefkedgheefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepheegvd
    evvdeljeeugfdtudduhfekledtiefhveejkeejuefhtdeufefhgfehkeetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:xGAYZJwk18Aj9dd-m-0db8mrPtmunN0Y7-AfMC1I1UR1d33sQPCdYg>
    <xmx:xGAYZMSCkqoAKUB2qhVYjjX0cYY1-jUASCOwtee0ZAdqEWx0TsZEVQ>
    <xmx:xGAYZMZhdEeDjoyQF4FW_McYWSPZugqVh4jp1uU3pJZi-VzjECIuew>
    <xmx:xGAYZCMssaccbEzir4gGoIfEq3UUo5O6rKwlieYjDLkzh44UmDPnvg>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 20 Mar 2023 09:33:55 -0400 (EDT)
Date:   Mon, 20 Mar 2023 14:33:54 +0100
From:   Greg KH <greg@kroah.com>
To:     Sven Schnelle <svens@linux.ibm.com>
Cc:     stable@vger.kernel.org, gor@linux.ibm.com
Subject: Re: [PATCH 5.10.y] s390/ipl: add missing intersection check to
 ipl_report handling
Message-ID: <ZBhgwuvFo1xgyfCp@kroah.com>
References: <16793039081369@kroah.com>
 <20230320103202.34739-1-svens@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230320103202.34739-1-svens@linux.ibm.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 20, 2023 at 11:32:02AM +0100, Sven Schnelle wrote:
> The code which handles the ipl report is searching for a free location
> in memory where it could copy the component and certificate entries to.
> It checks for intersection between the sections required for the kernel
> and the component/certificate data area, but fails to check whether
> the data structures linking these data areas together intersect.
> 
> This might cause the iplreport copy code to overwrite the iplreport
> itself. Fix this by adding two addtional intersection checks.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 9641b8cc733f ("s390/ipl: read IPL report at early boot")
> Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
> Reviewed-by: Vasily Gorbik <gor@linux.ibm.com>
> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
> (cherry picked from commit a52e5cdbe8016d4e3e6322fd93d71afddb9a5af9)
> Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
> ---
>  arch/s390/boot/ipl_report.c | 8 ++++++++
>  1 file changed, 8 insertions(+)

Both now queued up, thanks.

greg k-h
