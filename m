Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72A4551A94E
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356001AbiEDRMS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356961AbiEDRJv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A590A47064;
        Wed,  4 May 2022 09:56:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4107061808;
        Wed,  4 May 2022 16:56:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B8C1C385A5;
        Wed,  4 May 2022 16:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683403;
        bh=BQI/BWu84cGIr7wcJBUztzbUZxXOZxMAvC14UpLb+8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BUICga2oEMWDUXYCMYCl38HKVxngh+WHFIDklI0dx7nJLuonOm9Q1ZrdtNVKjJU58
         lMHz+3jDDAgLZ92d9xuX+bEFJjXKaceQ7cwJDrGr+CMax32xTBiDNwWzwXNMyu3QCM
         rPVeq18C4ag5AGU2a4mUzN8+4Gxx1I7jLv58z0Rc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Adam Ford <aford173@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Peng Fan <peng.fan@nxp.com>, Shawn Guo <shawnguo@kernel.org>,
        NXP Linux Team <linux-imx@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 074/225] arm64: dts: imx8mn: Fix SAI nodes
Date:   Wed,  4 May 2022 18:45:12 +0200
Message-Id: <20220504153118.004201715@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Marek Vasut <marex@denx.de>

[ Upstream commit 574518b7ccbaef74cb89eb1a1a0da88afa1e0113 ]

The most specific compatible string element should be "fsl,imx8mn-sai"
on i.MX8M Nano, fix it from current "fsl,imx8mm-sai" (two Ms, likely
due to copy-paste error from i.MX8M Mini).

Fixes: 9e9860069725f ("arm64: dts: imx8mn: Add SAI nodes")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Adam Ford <aford173@gmail.com>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: Peng Fan <peng.fan@nxp.com>
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: NXP Linux Team <linux-imx@nxp.com>
To: linux-arm-kernel@lists.infradead.org
Reviewed-by: Adam Ford <aford173@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mn.dtsi | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mn.dtsi b/arch/arm64/boot/dts/freescale/imx8mn.dtsi
index b8d49d5f2668..98bfb53491fc 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mn.dtsi
@@ -291,7 +291,7 @@ spba2: spba-bus@30000000 {
 				ranges;
 
 				sai2: sai@30020000 {
-					compatible = "fsl,imx8mm-sai", "fsl,imx8mq-sai";
+					compatible = "fsl,imx8mn-sai", "fsl,imx8mq-sai";
 					reg = <0x30020000 0x10000>;
 					interrupts = <GIC_SPI 96 IRQ_TYPE_LEVEL_HIGH>;
 					clocks = <&clk IMX8MN_CLK_SAI2_IPG>,
@@ -305,7 +305,7 @@ sai2: sai@30020000 {
 				};
 
 				sai3: sai@30030000 {
-					compatible = "fsl,imx8mm-sai", "fsl,imx8mq-sai";
+					compatible = "fsl,imx8mn-sai", "fsl,imx8mq-sai";
 					reg = <0x30030000 0x10000>;
 					interrupts = <GIC_SPI 50 IRQ_TYPE_LEVEL_HIGH>;
 					clocks = <&clk IMX8MN_CLK_SAI3_IPG>,
@@ -319,7 +319,7 @@ sai3: sai@30030000 {
 				};
 
 				sai5: sai@30050000 {
-					compatible = "fsl,imx8mm-sai", "fsl,imx8mq-sai";
+					compatible = "fsl,imx8mn-sai", "fsl,imx8mq-sai";
 					reg = <0x30050000 0x10000>;
 					interrupts = <GIC_SPI 90 IRQ_TYPE_LEVEL_HIGH>;
 					clocks = <&clk IMX8MN_CLK_SAI5_IPG>,
@@ -335,7 +335,7 @@ sai5: sai@30050000 {
 				};
 
 				sai6: sai@30060000 {
-					compatible = "fsl,imx8mm-sai", "fsl,imx8mq-sai";
+					compatible = "fsl,imx8mn-sai", "fsl,imx8mq-sai";
 					reg = <0x30060000  0x10000>;
 					interrupts = <GIC_SPI 90 IRQ_TYPE_LEVEL_HIGH>;
 					clocks = <&clk IMX8MN_CLK_SAI6_IPG>,
@@ -392,7 +392,7 @@ spdif1: spdif@30090000 {
 				};
 
 				sai7: sai@300b0000 {
-					compatible = "fsl,imx8mm-sai", "fsl,imx8mq-sai";
+					compatible = "fsl,imx8mn-sai", "fsl,imx8mq-sai";
 					reg = <0x300b0000 0x10000>;
 					interrupts = <GIC_SPI 111 IRQ_TYPE_LEVEL_HIGH>;
 					clocks = <&clk IMX8MN_CLK_SAI7_IPG>,
-- 
2.35.1



