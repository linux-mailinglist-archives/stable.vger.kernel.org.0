Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A71D575517
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 20:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240834AbiGNSe2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 14:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240776AbiGNSeJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 14:34:09 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEBA152477
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 11:34:03 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id BA5B6320010B;
        Thu, 14 Jul 2022 14:34:01 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Thu, 14 Jul 2022 14:34:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1657823641; x=1657910041; bh=7SaasPwrvv
        OmYU6zeU2IbJ7N3BqTdfMFMubq7UcA7Io=; b=jgtB5FLpOhYv43OCl2S3TLEaCM
        2ZruTZI1lw+FAMtjEEsPsNvpb80HFY6jkALDuLdNuf2lMPyPzDqa009+apxUP8RF
        uZOZdVB0xY3xUkCwVWFmesoagPvbN17IpnBo6KSMHEdAo4b29rUw+fb1kQEba22W
        qumpIRyqXJttLbm33cYJZMOK6PChXAT+TQ6BW9q2w+eTTP7vooPEZ9iSnD6D9mo9
        v/n/7bP1XR5hmkELtl8LgaXoihnU5/de8rBDSelMdV5lLfMXHvoHn+rJxDAmHzuQ
        JBEs4OgwsHsqQZ307eHsiDDMW7NLCrRt1xUd/WpAI9A6QxRYbPlJfKZG7eKA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1657823641; x=1657910041; bh=7SaasPwrvvOmYU6zeU2IbJ7N3BqT
        dfMFMubq7UcA7Io=; b=Jxyul80yrW/oPwB+dnpa5FdZtvy57gkXREXpKbfUQXmm
        mn4H6py4lV3O9XIOFvxjY+1eFkeV64Gbzk3qY6pJY/g0lyDBcfZ0O5lo0wHuhWEk
        a8SbCY138nzdoFMMgxOvLifyMgAa2cZv19y13rv5pobDSlT0LOYesmopnLrkcMh5
        LzYCnvhV/Xgh9m3U/1hrzDYuIrrM72DzEAvMEWfTR89PQCzQmkZFshXzv93bRM7R
        V8ud0d1wuzxnk47haDRWttW6xOHv9R1gjCZ5l6YbFGV2ujhinUuh6Ia/9BdJj0B0
        XKSY1GdK6njr6zMZIKCh4ub7iCNEyNMmB2l8V3pVDQ==
X-ME-Sender: <xms:mGHQYjFcKVvrj1B8ttYw8qDi2XwgTq2fHdwEPXVa62xEQLAZnV69FQ>
    <xme:mGHQYgVjkrziaXpuL-GIuX266OOgqGMDhT_XY0zFKn_5gwhidrOvjO2DQwAwpGRus
    EIJ3yORncFmEQ>
X-ME-Received: <xmr:mGHQYlL_RmUcV7opeopNDPlARo4Urp3o4sj4KrXCfqeQsaw2y3WK38jSrT6gTZMniY_OEbfKL3rhqUXLQMRRYD3OQwNTA5tj>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudejledguddvlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdortddttddvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeejhf
    elffejkeejheetgfeigeekueeuuddvveekjeekueeggfdvhfefteelgefgvdenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:mGHQYhHOGalxiWzZLUQvi1FQEo7bAJvauOh2PvPDZQnL89FmfN3JVw>
    <xmx:mGHQYpXHDyH1y4h8v_NtGE4UHXeLYT8gigkUzSUsExjNjiKv6Vwlug>
    <xmx:mGHQYsN0SvXQ72Pa_I4FtORQgb0IhG_UELj3fuNQ4vFZXcrIex3uEQ>
    <xmx:mWHQYlpg3O2Nh6FOpZVYVqhmx83RQx4qyh4v_086Mlw5AWU6qNSmrA>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 14 Jul 2022 14:34:00 -0400 (EDT)
Date:   Thu, 14 Jul 2022 20:33:56 +0200
From:   Greg KH <greg@kroah.com>
To:     James Morse <james.morse@arm.com>
Cc:     stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sumit Gupta <sumitg@nvidia.com>
Subject: Re: [stable:PATCH v4.9.323] arm64: entry: Restore tramp_map_kernel
 ISB
Message-ID: <YtBhlADgSRAnLePW@kroah.com>
References: <20220714162225.280073-1-james.morse@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220714162225.280073-1-james.morse@arm.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 14, 2022 at 05:22:25PM +0100, James Morse wrote:
> Summit reports that the BHB backports for v4.9 prevent vulnerable
> platforms from booting when CONFIG_RANDOMIZE_BASE is enabled.
> 
> This is because the trampoline code takes a translation fault when
> accessing the data page, because the TTBR write hasn't been completed
> by an ISB before the access is made.
> 
> Upstream has a complex erratum workaround for QCOM_FALKOR_E1003 in
> this area, which removes the ISB when the workaround has been applied.
> v4.9 lacks this workaround, but should still have the ISB.
> 
> Restore the barrier.
> 
> Fixes: aee10c2dd013 ("arm64: entry: Add macro for reading symbol addresses from the trampoline")
> Reported-by: Sumit Gupta <sumitg@nvidia.com>
> Tested-by: Sumit Gupta <sumitg@nvidia.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: James Morse <james.morse@arm.com>
> ---
> This only applies to the v4.9 backport, as v4.14 has the QCOM_FALKOR_E1003
> workaround.
> 
>  arch/arm64/kernel/entry.S | 1 +
>  1 file changed, 1 insertion(+)

Now queued up, thanks.

greg k-h
