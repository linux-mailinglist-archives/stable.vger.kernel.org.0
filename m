Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39232531439
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 18:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237516AbiEWPOZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 11:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237513AbiEWPOY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 11:14:24 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7532759B8B
        for <stable@vger.kernel.org>; Mon, 23 May 2022 08:14:23 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 091A75C01B1;
        Mon, 23 May 2022 11:14:21 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 23 May 2022 11:14:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1653318861; x=1653405261; bh=LRgLiPwbnN
        PxI993DR7l88clkcTjZX/VfvbsptZQBdo=; b=TQZhEwHoGR1weHqIUxKyf04PLT
        muQm2jDU6QOSFxGmOVYCenTA4qLNGebu9yxPe6P1J42dY/mHIx7HGHim4kzLSx7g
        zO1SkHTBL/aeRl+jnyGqPlFfsQNidV4yjkdyFA105Upe+w0zEfNDA2dF1oNh/Wl/
        LLXG10w87Uzd/pHJhE774j7Q28ZEu/q1awvAm/cmOOa/CJIx/oA3N0LFzlCpTbc2
        cB3+4tBgwaMEr4yEOjkk6hnTo7lmV1FRwMnU6ltMcTk4AUIUsb1YXPJNmR0GiQd3
        VCP1GCE47My/cB5IQkVAUMh+RRh010vPSsKMml+KxNePd/B06RfYlVa3OXIg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1653318861; x=1653405261; bh=LRgLiPwbnNPxI993DR7l88clkcTj
        ZX/VfvbsptZQBdo=; b=woRkJrQAKl9u+QeUuRf63p8lsVae5U8XWornbgNZoCFI
        TMeCfKYUGDvFY4dQu04i5iK99APkNW0adO5OjWna7ZM753cNCGsFAMJWzwPE3yEo
        Hvf5jTVWduZ3yhs2yHsHLnqQ9J8kjs+UB2Ek9wCZFvU6FEzRLRl6q6g8PXzJVg1G
        LzYm12khJFW1cFdht++FSWoJb803pnrTlzbhf7yNDm4IlcQugGFwPRDF00GkzkkQ
        JVzsj9pZvKbzqCBT8cTzbh4sKGoPNY3vySXM8gg7adVcYTLH53jMXv2z/PNIgQWR
        VFTSc2lUjoGuAA5h6+kW1+Xo3K7GaYY2eRdXfnEldA==
X-ME-Sender: <xms:zKSLYn1RLvCsxa52jLzWSp60FwRkicT9J3BGdHShB0Y7eYqZXbTodg>
    <xme:zKSLYmEcIa6v0MxbxJqTHDAh__pMu36k1uxTlPrz267OWiSzAtw33wAEHTiEfTA8F
    -Dvjsmf7qwLaA>
X-ME-Received: <xmr:zKSLYn6TZCKdtLxSfgZ58omZQ13fNXNICc0Tr5oEYpxOx5Ve2oDcJ_CrXw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrjedugdehhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepfffhvfevuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepifhrvghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheq
    necuggftrfgrthhtvghrnhepheegvdevvdeljeeugfdtudduhfekledtiefhveejkeejue
    fhtdeufefhgfehkeetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghi
    lhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:zKSLYs1sYYJeW0qoCvqjzo0w1gzZNXmTwhW7FfiKC7zg9sbmkOTbbA>
    <xmx:zKSLYqFFe1pl34AUPq0EE7FceGQFKiQOt-6xa0GwBMDnViO2axyLow>
    <xmx:zKSLYt_nXZaXqfg8HJaPJc22KuiARt005dWNfxRPL5-D-jAgg0a89w>
    <xmx:zaSLYvQFMwbsHB65-OcDx7eU8Ww6_deu8iqWsH-YzaE2-TAtqy4CJA>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 23 May 2022 11:14:20 -0400 (EDT)
Date:   Mon, 23 May 2022 17:14:17 +0200
From:   Greg KH <greg@kroah.com>
To:     Tan Tee Min <tee.min.tan@linux.intel.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] net: stmmac: disable Split Header (SPH) for Intel
 platforms
Message-ID: <YoukydQZAds2Lazf@kroah.com>
References: <20220523013910.3147844-1-tee.min.tan@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220523013910.3147844-1-tee.min.tan@linux.intel.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 23, 2022 at 09:39:10AM +0800, Tan Tee Min wrote:
> commit 47f753c1108e287edb3e27fad8a7511a9d55578e upstream.
> 
> Based on DesignWare Ethernet QoS datasheet, we are seeing the limitation
> of Split Header (SPH) feature is not supported for Ipv4 fragmented packet.
> This SPH limitation will cause ping failure when the packets size exceed
> the MTU size. For example, the issue happens once the basic ping packet
> size is larger than the configured MTU size and the data is lost inside
> the fragmented packet, replaced by zeros/corrupted values, and leads to
> ping fail.
> 
> So, disable the Split Header for Intel platforms.
> 
> v2: Add fixes tag in commit message.
> 
> Fixes: 67afd6d1cfdf("net: stmmac: Add Split Header support and enable it in XGMAC cores")
> Cc: <stable@vger.kernel.org> # 5.4.x
> Suggested-by: Ong, Boon Leong <boon.leong.ong@intel.com>
> Signed-off-by: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
> Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
> Signed-off-by: Tan Tee Min <tee.min.tan@linux.intel.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
>  drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c  | 1 +
>  include/linux/stmmac.h                            | 1 +
>  3 files changed, 3 insertions(+), 1 deletion(-)

Now queued up, thanks.

greg k-h
