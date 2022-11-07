Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0BF961EE6F
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 10:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231687AbiKGJMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 04:12:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231719AbiKGJMh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 04:12:37 -0500
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D8B9175A9
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 01:12:34 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id AF06B5C00C1;
        Mon,  7 Nov 2022 04:12:33 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 07 Nov 2022 04:12:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; t=1667812353; x=
        1667898753; bh=TRtlv9pGdSEUDOrOSLRLRfxV4uO+MIHMFeZ5pMG+o0Y=; b=v
        2TOdj0KeVZEGPbt5nSEnZXvAX9S0Iuyfx35d4EY5k7lcUdeJK0tg4MfHHwNLRCMB
        lBU1NSSXrQV9/HiibYTgLSHySopouXG2md3H2GYoi8+g0/kqFnInXb6J5CZW85pP
        B56hYHMyST5JByPMg5lVxiKko+Zz6rdPS3F4blDqR/extAl5tKVneh0+12ZRzhON
        GFznrDYd7efTJk3RWXqu+WN/79NQ8jJJ8ET7Tup8I63dhRbwRCWlofTgWjd+ffJa
        F+1tB/GZNYF7HKlQGxaaIONenSHqMlrCkdERe5A4xcTnBudhZ5g2EdX095Qqqleg
        dXx/WUzPL8WV89zQwPf+g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1667812353; x=
        1667898753; bh=TRtlv9pGdSEUDOrOSLRLRfxV4uO+MIHMFeZ5pMG+o0Y=; b=H
        qUDR7God0UUmalquFDPVlA7SKl7VM9wOg5KvgGd2r5/0cAyhMOpdCDV43ZSoAuCi
        2nuJwRLmGWbEYqQV5EqUyWXGktPEIYqwEIV3DMFZF/JHQJIXqnyEf+C22tInCSH9
        82f8ewTRCbX3qNbfhZzTqWhe9vmDkzU66eMk1iTf3N4lR5/7A2soOLcPOtkHmf8s
        L5inbXz9TJZVKapb0sH4FcyovOparneuzPF8UFoxonS5PlNetHpnSWqI5VANTC+v
        Yl77VZqina3wdAE9451T+0hznJRy5S8hekWeRo0r7hxpifVgv9LIcrPA6xBYD2RX
        0qhInXoBv1/WXb9Oe+w/Q==
X-ME-Sender: <xms:AMxoY-tDCsjOaccP1GzuWPp1Yx48JIzmT5CtKTXFiXBI0KefsysAHw>
    <xme:AMxoYzcp_hOr1oGHRZN5UG5kLN8YAmiDmKiJEOiIYTbz3wqq2lSVvYM5J0T1P00EY
    NaL4Mlv2vO6Hw>
X-ME-Received: <xmr:AMxoY5xOU4SbdZAWKA-YCq2jwhKRz1AXxPHlNAGzpoU73xTFUJJouDqtnEwx7BAlTg41qXe_2gb-ymGNIXmMbRiZ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrvdekucetufdoteggodetrfdotffvucfrrh
    hofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epfffhvfevuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpefirhgvghcumffj
    uceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpefgkeffieefie
    evkeelteejvdetvddtledugfdvhfetjeejieduledtfefffedvieenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:AMxoY5MMzDTdpCAuElm_I8W948N9wy4slYXJGGcKDSYm4X0JmCRUdQ>
    <xmx:AMxoY-8w9Ru4zbk0zamBIpM3Z9nEUQ4cMENUZEMp-_25LgEvsOvXJg>
    <xmx:AMxoYxUslxDjWutFr59Q4grSaoknZ9fJqOIiLg17JOH5D2smmAgIgg>
    <xmx:AcxoYx2RqDP6v8_mdC0q4d_sxYkWwb48CCDBGPGH5KzujTjJR3Eahw>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 7 Nov 2022 04:12:32 -0500 (EST)
Date:   Mon, 7 Nov 2022 10:12:31 +0100
From:   Greg KH <greg@kroah.com>
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Tomasz =?utf-8?Q?Mo=C5=84?= <tomasz.mon@camlingroup.com>,
        Richard Weinberger <richard@nod.at>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        Sasha Levin <sashal@kernel.org>, Han Xu <han.xu@nxp.com>,
        kernel <kernel@pengutronix.de>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2 stable 5.10] mtd: rawnand: gpmi: Set WAIT_FOR_READY
 timeout based on program/erase times
Message-ID: <Y2jL/8zu90UizMGF@kroah.com>
References: <20221103153341.2600899-1-tharvey@gateworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221103153341.2600899-1-tharvey@gateworks.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 03, 2022 at 08:33:41AM -0700, Tim Harvey wrote:
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
> v2: add sb tag and add upstream commit id

Now queued up, thanks.

greg k-h
