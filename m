Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0AAF62103A
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 13:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233722AbiKHMUE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 07:20:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234142AbiKHMT7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 07:19:59 -0500
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CDFD13EBE
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 04:19:58 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id BB3373200949;
        Tue,  8 Nov 2022 07:19:54 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Tue, 08 Nov 2022 07:19:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; t=1667909994; x=
        1667996394; bh=INoMKea8/YjuVb0DOGy4KpaM4P6h8yxH9m9PnsFW8P4=; b=d
        WKg1vxP46Zv3gWDTDOZ0RESSBuxBVD4ZfAjJX1XMxbOsY1jRl3w3TFxvC46Ftwmh
        dmj1k6y82kfuqpUg/hcFeYXHZOuZAWKqFLAaKyeUOTq3aWZ6e5B5pcBfqeiyiPtv
        rmnEqCdofmZqXUzK37ZTgYtn3/sY/doXS6HjjT6O9cc+g/FZOKAupSyHy28s72Ft
        68gL7I7qdBX6as47HMWedUcPjJwfxlqVpp86ITT+VC/r/UfOcMR92YccmaFotqpP
        CyNpkI0qRZvGBAOEEfcpOgdnAF+uTzMOHuPlocDwKTRuOqK4QKjL3iwZfCGEalrX
        82D5tT7dOOXkOHGLCgrkQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1667909994; x=
        1667996394; bh=INoMKea8/YjuVb0DOGy4KpaM4P6h8yxH9m9PnsFW8P4=; b=A
        OkYF/OxwnkJbNcUCCh14yqAZtsbnLpEEGaUGZ9pfXRz5wTbG/tYIhdsjIqyUQ+Oq
        8kGg9Hoxno8IkSElrrV3ciaQpjx+zMgAuSWD+Ocxj4oKSU4iZuq81/znv4n/jbuR
        fi76E3G7ongzhyVGizutHtrT/d58ho4D8Pv1lhUctzQziFvHjmRrTuF/fAfrpiut
        Rycyb1QNzygFIsB0gTKFenIhN/nxQ+epadXvINuIGUdwDjQ9oMHUL10iuDRyQZfP
        do2CpdWea/hMN0Jhq4Svlqu2mWfDN6hiHU4g3mKvVuEVGfkCBFgkqbQCtKSABGrC
        aMlvE47r0XVUFfhprfucA==
X-ME-Sender: <xms:aUlqY9gtoAm16uBFEwulJ7l3UNn4zhPJmsnRYi--4Sc_hFi27C6ssg>
    <xme:aUlqYyCxed3Y73sZ6ui0g0se0KFSLwEqlIqJRYtvr6PKdng_oJEA6Hnrv2XC69nAm
    VYmt02z-TwuXw>
X-ME-Received: <xmr:aUlqY9GC06LUvFD2LC3TuBt2chNGWqRt20h-0-_wzEakB13nHca_-pHFUBYEpZRCY4KLctcAAwHg4gn0OR7-JxCp-RWlApRj>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrfedtgdegtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtugfgjgesthekredttddtjeenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepgfekff
    eifeeiveekleetjedvtedvtdeludfgvdfhteejjeeiudeltdefffefvdeinecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:aUlqYyTlJXf2gjJXqfqlVr2HnzDXxzhwAgx_iZPNAizzFOxxlpMQyA>
    <xmx:aUlqY6ysdHgvk908ViHRZawh49igNPunGYv3y0114yJOQElBYRowpQ>
    <xmx:aUlqY46pRvRNoSMzLuG5jvx9b4jEUegH6FW-flOx9_FoOcC3xrejWQ>
    <xmx:aklqY7o4qbCooT8PwHYTq7SzTEqSnUkzyFd-HNjju7EQlkZ5MxLp9w>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Nov 2022 07:19:52 -0500 (EST)
Date:   Tue, 8 Nov 2022 13:19:49 +0100
From:   Greg KH <greg@kroah.com>
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Tomasz =?utf-8?Q?Mo=C5=84?= <tomasz.mon@camlingroup.com>,
        Richard Weinberger <richard@nod.at>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        Sasha Levin <sashal@kernel.org>, Han Xu <han.xu@nxp.com>,
        kernel <kernel@pengutronix.de>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH stable 5.4] mtd: rawnand: gpmi: Set WAIT_FOR_READY
 timeout based on program/erase times
Message-ID: <Y2pJZQvoKrwm3mjj@kroah.com>
References: <20221107173351.209558-1-tharvey@gateworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221107173351.209558-1-tharvey@gateworks.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 07, 2022 at 09:33:51AM -0800, Tim Harvey wrote:
> From: Sascha Hauer <s.hauer@pengutronix.de>
> 
> commit 0fddf9ad06fd9f439f137139861556671673e31c upstream.
> 
> 06781a5026350 Fixes the calculation of the DEVICE_BUSY_TIMEOUT register
> value from busy_timeout_cycles. busy_timeout_cycles is calculated wrong
> though: It is calculated based on the maximum page read time, but the
> timeout is also used for page write and block erase operations which
> require orders of magnitude bigger timeouts.
> 
> Fix this by calculating busy_timeout_cycles from the maximum of
> tBERS_max and tPROG_max.
> 
> This is for now the easiest and most obvious way to fix the driver.
> There's room for improvements though: The NAND_OP_WAITRDY_INSTR tells us
> the desired timeout for the current operation, so we could program the
> timeout dynamically for each operation instead of setting a fixed
> timeout. Also we could wire up the interrupt handler to actually detect
> and forward timeouts occurred when waiting for the chip being ready.
> 
> As a sidenote I verified that the change in 06781a5026350 is really
> correct. I wired up the interrupt handler in my tree and measured the
> time between starting the operation and the timeout interrupt handler
> coming in. The time increases 41us with each step in the timeout
> register which corresponds to 4096 clock cycles with the 99MHz clock
> that I have.
> 
> Fixes: 06781a5026350 ("mtd: rawnand: gpmi: Fix setting busy timeout setting")
> Fixes: b1206122069aa ("mtd: rawniand: gpmi: use core timings instead of an empirical derivation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> Acked-by: Han Xu <han.xu@nxp.com>
> Tested-by: Tomasz Moń <tomasz.mon@camlingroup.com>
> Signed-off-by: Richard Weinberger <richard@nod.at>
> Signed-off-by: Tim Harvey <tharvey@gateworks.com>
> ---
>  drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 

Now queued up, thanks.

greg k-h
