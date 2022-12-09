Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67CFA64850B
	for <lists+stable@lfdr.de>; Fri,  9 Dec 2022 16:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbiLIPZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Dec 2022 10:25:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbiLIPZy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Dec 2022 10:25:54 -0500
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4D178B92;
        Fri,  9 Dec 2022 07:25:52 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 0748932005CA;
        Fri,  9 Dec 2022 10:25:50 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Fri, 09 Dec 2022 10:25:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1670599550; x=1670685950; bh=QcJkwn62sj
        SUOtcXIxjSe2Ij1zsJVgf9eHa19mY4Xuw=; b=ZB0g3ByITNvp2JclQkUUMmnurx
        Hw2WKBVfiaeUCZ0qkCu9CRcQgNAwifkRRYdK7ZU8BL1HNSEZql+6qI+ejbR/wtd4
        UBNYooBMpsy3RNzOL1i6l3/TbJzC9LcQyXQur9VKfLIJ7g75jFon3BvKxiPSbhs6
        upsDTYn3ACM3rzRkTofG4GygGDeolY0ZU7T5X5UoGGimvp8QdKSSIiKHysaxudPZ
        Udv1FFwXV5FHRi8JBeuMIkYMSDjh7P7gBF+zkcxtpi83RoQKrXSP9vDyzLgR0HFi
        ZF7vn8yx7AmqdiopZMryYsbbcvPSY2OTOeLLQ12h60moZ9ZBC8HE6/8F0qFw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1670599550; x=1670685950; bh=QcJkwn62sjSUOtcXIxjSe2Ij1zsJ
        Vgf9eHa19mY4Xuw=; b=i7ItSB9QnsGmP0r+/l9chqlgI1OKe+6eE94cI8W6tBST
        wseD/DOIwI/Dtku3VN0v9G8eW4AyMB/lNSoA4bQrzrr7SVM5LCj4ngB209QNH6Aa
        KfD/ng6CJYxSQuUmF2uxO++u91vDF2DJW8fUaXPEqojMdM3WbhoLKTdT5v7635/j
        hb22dGebTe4uqIRZulWLTov7xQBztX0KYc0WqzYRS/T97uePJo3a+b9UspTVviZj
        RoM8j8mWKJmwG0MFQ0Xt/091QcHk35mfITgvzM6pJyAEPwRm9eVtCuSUcY7TYU2S
        XlZLKPs7OdqanPE8g3/7t3+r13LrZZoHl08CrTlHbQ==
X-ME-Sender: <xms:flOTY9DYlF9uHVO2E_p0tTIH8xukhAMSrSGtR5rOSR5sQ4LC6IPutQ>
    <xme:flOTY7hM4fQNhf59GrRArIKcU6ljgLqjEswtVAMmoas8qxsRNCIviBOWsFRkDXQb-
    RIVMyplMOkDJlp36vg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvddvgdejhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdetrhhn
    ugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtth
    gvrhhnpeevhfffledtgeehfeffhfdtgedvheejtdfgkeeuvefgudffteettdekkeeufeeh
    udenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomheprghrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:flOTY4lS2-8bcwz2yQ0AM3mN5WRChiyoqOiuCVkiYATp1cRQ_SYh3w>
    <xmx:flOTY3ymuFViJsl0X-CpNhDE_pCNwlBzFGhRJ9xkkbMmjQKWrICTOA>
    <xmx:flOTYyQPxqPc3FX8fGIZbXFi9IvbrC6vkSMTSeld3_0chzIVqTX9iA>
    <xmx:flOTY8BYXfPjSXzLHDTx5_aPnNHRuMmtpp2aiHwYWLgD98nPRDhICQ>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 21CA5B60086; Fri,  9 Dec 2022 10:25:50 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1115-g8b801eadce-fm-20221102.001-g8b801ead
Mime-Version: 1.0
Message-Id: <dbdb4417-a1cf-4613-8f7a-98b524bfdedc@app.fastmail.com>
In-Reply-To: <bb4e185a-c4db-428b-a1ee-ee1ba767fffb@leemhuis.info>
References: <20221205152327.26881-1-francesco@dolcini.it>
 <0aa2d48b-35a0-1781-f265-0387d213bdd6@denx.de>
 <20221208115124.6cc7a8bf@xps-13>
 <Y5ITkZtKWHzWaLS4@francesco-nb.int.toradex.com>
 <bb4e185a-c4db-428b-a1ee-ee1ba767fffb@leemhuis.info>
Date:   Fri, 09 Dec 2022 16:25:28 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Thorsten Leemhuis" <regressions@leemhuis.info>
Cc:     "Marek Vasut" <marex@denx.de>, "Shawn Guo" <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        "Francesco Dolcini" <francesco.dolcini@toradex.com>,
        "Rob Herring" <robh+dt@kernel.org>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski+dt@linaro.org>,
        "Sascha Hauer" <s.hauer@pengutronix.de>,
        "Pengutronix Kernel Team" <kernel@pengutronix.de>,
        "Fabio Estevam" <festevam@gmail.com>,
        "NXP Linux Team" <linux-imx@nxp.com>, devicetree@vger.kernel.org,
        linux-mtd@lists.infradead.org, stable@vger.kernel.org,
        "Francesco Dolcini" <francesco@dolcini.it>,
        "Miquel Raynal" <miquel.raynal@bootlin.com>
Subject: Re: [PATCH v1] Revert "ARM: dts: imx7: Fix NAND controller size-cells"
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 9, 2022, at 14:30, Thorsten Leemhuis wrote:
> On 08.12.22 17:40, Francesco Dolcini wrote:
>> + Arnd
>
> Arnd, have you seen this? We haven't heard anything from Shawn afaics,
> who normally would take care of a patch like this. Hence could you
> consider picking up the patch at the start of this thread (e.g.
> https://lore.kernel.org/all/20221205152327.26881-1-francesco@dolcini.it/
> ) and send it to Linus in the next 48 hours? It seems low-risk and fixes
> a regression introduced this cycle various people care about. That's why
> I'll likely ask Linus to consider picking this up directly before
> releasing 6.1, if I don't hear anything from you soon. But I'd prefer if
> the patch would go through at least somewhat the proper channels;
> alternatively a ACK from you to signal Linus "yeah, pick this up" would
> help as well.

Done now.

   Arnd
