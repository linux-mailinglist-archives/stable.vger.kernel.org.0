Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEDB758BFA3
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242727AbiHHBm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242859AbiHHBlM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:41:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE44912D3A;
        Sun,  7 Aug 2022 18:35:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D816760DDC;
        Mon,  8 Aug 2022 01:35:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61C39C4347C;
        Mon,  8 Aug 2022 01:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922504;
        bh=kOSR+0U1mUJKjfVnIM3iHP1kjHk8W/lX2Xo52qIYRy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GqZVYT/ZNQawh9CzdTFtN6ARzvAhSbtvtbURgM5tLiS918WqbMPOzrJwyqc9D/tdu
         dr2CbwtrL+Zvje5H/zQ8/WHKcubLlht6waXcj1tMTU7nQG/On1nZalD/G3l9j6n9oH
         PVxbDyV13rL8Kkjxq16nq+mY0mHv3YeV2/ig4sqJlWSMROUlzClu3zQM44lA710VY3
         i17N2uzPuspOq0fvK/oG99wFduvMHksNcAsPwwkoNYqPt0VlO3yaA0TqzVfDMvpdtK
         kwSyxpR95816ATvVwA1FcVGX83QeCOrd4iSQqVQPNOoPrLrCH9Qk0YzsYKxX3YxAQJ
         t1PscGQIF3PpQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.18 26/53] ARM: dts: imx6ul: fix lcdif node compatible
Date:   Sun,  7 Aug 2022 21:33:21 -0400
Message-Id: <20220808013350.314757-26-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013350.314757-1-sashal@kernel.org>
References: <20220808013350.314757-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 1a884d17ca324531634cce82e9f64c0302bdf7de ]

In yaml binding "fsl,imx6ul-lcdif" is listed as compatible to imx6sx-lcdif,
but not imx28-lcdif. Change the list accordingly. Fixes the
dt_binding_check warning:
lcdif@21c8000: compatible: 'oneOf' conditional failed, one must be fixed:
['fsl,imx6ul-lcdif', 'fsl,imx28-lcdif'] is too long
Additional items are not allowed ('fsl,imx28-lcdif' was unexpected)
'fsl,imx6ul-lcdif' is not one of ['fsl,imx23-lcdif', 'fsl,imx28-lcdif',
'fsl,imx6sx-lcdif']
'fsl,imx6sx-lcdif' was expected

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6ul.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6ul.dtsi b/arch/arm/boot/dts/imx6ul.dtsi
index 367657a9a99f..bc6548058d8c 100644
--- a/arch/arm/boot/dts/imx6ul.dtsi
+++ b/arch/arm/boot/dts/imx6ul.dtsi
@@ -1008,7 +1008,7 @@ csi: csi@21c4000 {
 			};
 
 			lcdif: lcdif@21c8000 {
-				compatible = "fsl,imx6ul-lcdif", "fsl,imx28-lcdif";
+				compatible = "fsl,imx6ul-lcdif", "fsl,imx6sx-lcdif";
 				reg = <0x021c8000 0x4000>;
 				interrupts = <GIC_SPI 5 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clks IMX6UL_CLK_LCDIF_PIX>,
-- 
2.35.1

