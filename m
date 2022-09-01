Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAAA05A8D44
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 07:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232939AbiIAFWa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 01:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbiIAFW3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 01:22:29 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C1241090B9;
        Wed, 31 Aug 2022 22:22:29 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id F0C823200035;
        Thu,  1 Sep 2022 01:22:27 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 01 Sep 2022 01:22:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=traverse.com.au;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1662009747; x=
        1662096147; bh=7349+jbluXT87Q+gPFh56bxTKRfjtLef4BT2I6pPdxI=; b=A
        ZKdyM2vdKDVVofkfPmxInMfhY+GLD2l0QWCb21xnZjCZ05zmUt4RTvyQh+oEYHIf
        K5fZGswKvfoOp5voHVh0L9eJ9s6IlZbUVcQBjnWNR8LzSx3/e4KXOYm50lzBkTey
        n70FKlBLFzj2FJwT/53f5g5gx0yJ1aVQHvw+0sDq+Jk9kT8aMGRg7my6Lrkm6DVb
        NFyZhdp8lTVT6pnbAdTn/KQBwJCqOWHnrGp7l/xxnCQHLNIVZ2pdXQMbj9ztBAJh
        muXCai2neXjNT4HeBOAWa/tpzBnNXV2CUdGZXUm/68O7II26cJqxFJ8ZaSx9oJIb
        PYChI0TSdhb+7v4ByZ0Ow==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1662009747; x=1662096147; bh=7349+jbluXT87
        Q+gPFh56bxTKRfjtLef4BT2I6pPdxI=; b=FaqsSVXlZFB8nQbtrekTagyTTjB9M
        0GiPVCpSVs0g83q47F51mM3KW7sLYCYzWNU6Zq9mzPcKEae5PlpWVu0GQUUThl5y
        2hyCp6s7SdAxx3CPxxMJLusJxIVNmbbZs4yg43QjzpwbozlGkjOw4m1alYbNsf2S
        KT3nedhonl9hXkW/b2qApkojVDC93HNMVpJwk8YFKQkxy3RO/jBi1boeQ95LuvUR
        X/P6PMwJvQwXX40hdTom2cAmq6xFQYGqAY1z7Xa9HKFUy/h8ytYA475fULz3FtB3
        Jmgn2wUfKAIx3vryLeLy4iYfH9ujCVzfE8P33FSkBc90RJy1BJ2k2w78A==
X-ME-Sender: <xms:k0EQY-9IYKsI-eQViG5gZDPHYVhFHT6J-EG61s_xdknu0m_IN6V1Ag>
    <xme:k0EQY-vjzz-8mfis3bA8bFAa5SujlBUI0xQO3GVKIfOhWsrwnZ1ksV9_LADrB4z5M
    ALqenCZE1HYDD4CtK4>
X-ME-Received: <xmr:k0EQY0CFTdBVok0Dw0X3wrZ1W3eILvhRbh1rjVA0wXYTgcS-tvwL7yVLvXzcYDf0LLNXNz1NJm4OLjFRrPS68puQlS1MRwM-Twv_fnrK-q_SDXhs1ezeUrsMdBI4c_E>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdekjedgleejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepofgrthhh
    vgifucfotgeurhhiuggvuceomhgrthhtsehtrhgrvhgvrhhsvgdrtghomhdrrghuqeenuc
    ggtffrrghtthgvrhhnpeeiieefheeiieeuledufefgtdevfeejffetgedvveduffffleeh
    jedtjeegleelgeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfh
    hrohhmpehmrghtthesthhrrghvvghrshgvrdgtohhmrdgruh
X-ME-Proxy: <xmx:k0EQY2eonPLAJnHmovC2jX-wqPvIwpxxdBKzVRQB57JygfZL0q-zmw>
    <xmx:k0EQYzMCONlQ34uBB-CyCk-bHbBAKSZsCpbVcs-XQlQgKrQoWL0MGw>
    <xmx:k0EQYwlevZCC5994OdApykL-x-PLM34FItw2mY6XP1_9J9HVOooMhQ>
    <xmx:k0EQY-1c7xD_SMyAsmxJxtIy8HOg4W87URnDvFBTNDr2aQUtX4RVIw>
Feedback-ID: i426947f3:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 1 Sep 2022 01:22:25 -0400 (EDT)
From:   Mathew McBride <matt@traverse.com.au>
To:     Li Yang <leoyang.li@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>, soc@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Mathew McBride <matt@traverse.com.au>, stable@vger.kernel.org
Subject: [PATCH 1/1 RESEND] soc: fsl: select FSL_GUTS driver for DPIO
Date:   Thu,  1 Sep 2022 05:21:49 +0000
Message-Id: <20220901052149.23873-2-matt@traverse.com.au>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20220901052149.23873-1-matt@traverse.com.au>
References: <20220620043243.32235-1-matt@traverse.com.au>
 <20220901052149.23873-1-matt@traverse.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The soc/fsl/dpio driver will perform a soc_device_match()
to determine the optimal cache settings for a given CPU core.

If FSL_GUTS is not enabled, this search will fail and
the driver will not configure cache stashing for the given
DPIO, and a string of "unknown SoC" messages will appear:

fsl_mc_dpio dpio.7: unknown SoC version
fsl_mc_dpio dpio.6: unknown SoC version
fsl_mc_dpio dpio.5: unknown SoC version

Signed-off-by: Mathew McBride <matt@traverse.com.au>
Fixes: 51da14e96e9b ("soc: fsl: dpio: configure cache stashing destination")
Cc: stable@vger.kernel.org
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/soc/fsl/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/fsl/Kconfig b/drivers/soc/fsl/Kconfig
index 07d52cafbb31..fcec6ed83d5e 100644
--- a/drivers/soc/fsl/Kconfig
+++ b/drivers/soc/fsl/Kconfig
@@ -24,6 +24,7 @@ config FSL_MC_DPIO
         tristate "QorIQ DPAA2 DPIO driver"
         depends on FSL_MC_BUS
         select SOC_BUS
+        select FSL_GUTS
         select DIMLIB
         help
 	  Driver for the DPAA2 DPIO object.  A DPIO provides queue and
-- 
2.30.1

