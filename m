Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE1153148E
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 18:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238486AbiEWQB7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 12:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238551AbiEWQBs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 12:01:48 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E2E3EF13
        for <stable@vger.kernel.org>; Mon, 23 May 2022 09:01:47 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 5D1B25C0042;
        Mon, 23 May 2022 12:01:46 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 23 May 2022 12:01:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; t=1653321706; x=
        1653408106; bh=3fE90OIXHmCWfviVoAFS/MaoOHNai/2kNBfRTTz2xaM=; b=H
        S4vZob/rAis9sdJWgD9lueCDReBFcMBg65/gL0Nvo9kpLuNc+khlI8hObW8AR4lS
        FL5ITovDUjGUAiQXvb8FR1X8dHW4hMz/8KcP6LSVeNDioKd/O7V7ztberJElNjkj
        4Z5PGTjqGQeJZPzvsMKL4/9tCwJRSGKeGJyjfbuW4IMgmTLB09QT5fagVN91qodu
        dGnLM6YpysnQ4gXylIppy8S49XcKrOAXf2+irn3bGJiDQim9Sd43Jt0psPbbnoLU
        FrN7TRgiegtREyF7wSYxAYsusCGQTP37Uf8KT/jkSaHTzXPsnwlpFbaWlAqCrUye
        UORdUfmcuODx4zdfDrOOw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1653321706; x=
        1653408106; bh=3fE90OIXHmCWfviVoAFS/MaoOHNai/2kNBfRTTz2xaM=; b=s
        s7E+pwZlhPIJZkcfOgFbxmT0GNXj5zifytVrsFNNGw/fuHfsNCiL/6gx5JeXZIjH
        mdYGSwWJvMno3YnlBz0aYhDL+bCdu6eKCOdR277fAzjDGNbMtKTJuopPvmNqrC8H
        cSP72SD/7bisn9KXuQnMu0OPuS8e5g5smiEpUz9xdIItYhSYv2QlBXrICRjdG4OW
        GeELuUVZbmG1Rs9gEdf/ODEzm6xMhhpIoLPzqh0bB4Ugb5LCvf8k9+CrQRAb7oIh
        DgROW9YVN8x9HDGfo3pLDvOvzOwJYvaqeSlclDLYvE6J3xQTN5erHqeF2Pf2jdeb
        TXZ9NvG/5dxVbZxcqd+qw==
X-ME-Sender: <xms:6a-LYpZ5rrVKw65Po3TShGhrmv3qxTl7TdiwmffR7wV_IVpWvwod0w>
    <xme:6a-LYgalxI6jGwbCRnQ8MH9vA-XbcIoTmWcJlz1IIws3bn-GxaA_SQzgykwHH0rnH
    CuUZBxOez6ztQ>
X-ME-Received: <xmr:6a-LYr__5cIwiSdUunl-PMmRqJFdmXHqF2QG7QT6TQ4cd3ouHvo-3CiYGA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrjedugdeihecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtugfgjgesthekredttddtjeenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepleekhe
    ejjeeiheejvdetheejveekudegueeigfefudefgfffhfefteeuieekudefnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:6a-LYnrqqkoXhgkqwJ6B_qL8xyjRv0L3yKSo6HQEwkBGZYiluXmDUg>
    <xmx:6a-LYko2K4px36P7z17a_E9_kG9uMoTYEUhpAz-ztfljdldu6XHSrg>
    <xmx:6a-LYtQ1S2B5jolKiT97tTof7TN8Q5b1vIYRqga7ekT_X1JSijaXGw>
    <xmx:6q-LYhjvU1Ua4-yPVNBL_O4bvYbOV3r66Kmop_y2523Bm09DUVTcrw>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 23 May 2022 12:01:44 -0400 (EDT)
Date:   Mon, 23 May 2022 18:01:42 +0200
From:   Greg KH <greg@kroah.com>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4.14 2/2] Reinstate some of "swiotlb: rework "fix info
 leak with DMA_FROM_DEVICE""
Message-ID: <Youv5m8L4FmP1zQf@kroah.com>
References: <20220523154624.1141489-1-ovidiu.panait@windriver.com>
 <20220523154624.1141489-2-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220523154624.1141489-2-ovidiu.panait@windriver.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 23, 2022 at 06:46:24PM +0300, Ovidiu Panait wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> 
> commit 901c7280ca0d5e2b4a8929fbe0bfb007ac2a6544 upstream.
> 
> Halil Pasic points out [1] that the full revert of that commit (revert
> in bddac7c1e02b), and that a partial revert that only reverts the
> problematic case, but still keeps some of the cleanups is probably
> better.  ￼
> 
> And that partial revert [2] had already been verified by Oleksandr
> Natalenko to also fix the issue, I had just missed that in the long
> discussion.
> 
> So let's reinstate the cleanups from commit aa6f8dcbab47 ("swiotlb:
> rework "fix info leak with DMA_FROM_DEVICE""), and effectively only
> revert the part that caused problems.
> 
> Link: https://lore.kernel.org/all/20220328013731.017ae3e3.pasic@linux.ibm.com/ [1]
> Link: https://lore.kernel.org/all/20220324055732.GB12078@lst.de/ [2]
> Link: https://lore.kernel.org/all/4386660.LvFx2qVVIh@natalenko.name/ [3]
> Suggested-by: Halil Pasic <pasic@linux.ibm.com>
> Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> [OP: backport to 4.14: apply swiotlb_tbl_map_single() changes in lib/swiotlb.c]
> Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
> ---
>  Documentation/DMA-attributes.txt | 10 ----------
>  include/linux/dma-mapping.h      |  8 --------
>  lib/swiotlb.c                    | 13 ++++++++-----
>  3 files changed, 8 insertions(+), 23 deletions(-)
> 

Both now queued up, thanks.

greg k-h
