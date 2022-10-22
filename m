Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EFFB608AAC
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 11:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbiJVJEX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 05:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232281AbiJVJD1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 05:03:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256102FACC5;
        Sat, 22 Oct 2022 01:18:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD000B82DEE;
        Sat, 22 Oct 2022 08:04:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29F4DC433D6;
        Sat, 22 Oct 2022 08:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425850;
        bh=teLkVvsGmTvEmoonmZOWurIfqTWLncO4ba3j6bGrtxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0IeNMsY2447Lhuf8ngQrYIsFHdvgDTTTr8bctZwGGgyS5/TTQgA4e2j+VSNlmV15Q
         6BQ059teO6YaQCdke+4UhaW7geHXMF7edTeSyWavRl4B1IWj6CWWK82jK+8cNo9yIn
         AwkRAM4n4YRWCuSKICbL6Lgv1CW7ksXmlcZzFjrQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 637/717] ARM: dts: imx6sl: use tabs for code indent
Date:   Sat, 22 Oct 2022 09:28:36 +0200
Message-Id: <20221022072526.616634824@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcel Ziswiler <marcel.ziswiler@toradex.com>

[ Upstream commit 218db824a7519856d0eaaeb5c41ca504ed550210 ]

This fixes the following error:

arch/arm/boot/dts/imx6sl.dtsi:714: error: code indent should use tabs
where possible

Signed-off-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6sl.dtsi | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm/boot/dts/imx6sl.dtsi b/arch/arm/boot/dts/imx6sl.dtsi
index cfd6b4972ae7..01122ddfdc0d 100644
--- a/arch/arm/boot/dts/imx6sl.dtsi
+++ b/arch/arm/boot/dts/imx6sl.dtsi
@@ -61,10 +61,10 @@
 				<792000  1175000>,
 				<396000  975000>;
 			fsl,soc-operating-points =
-				/* ARM kHz      SOC-PU uV */
-				<996000         1225000>,
-				<792000         1175000>,
-				<396000         1175000>;
+				/* ARM kHz	SOC-PU uV */
+				<996000		1225000>,
+				<792000		1175000>,
+				<396000		1175000>;
 			clock-latency = <61036>; /* two CLK32 periods */
 			#cooling-cells = <2>;
 			clocks = <&clks IMX6SL_CLK_ARM>, <&clks IMX6SL_CLK_PLL2_PFD2>,
@@ -225,7 +225,7 @@
 
 				uart5: serial@2018000 {
 					compatible = "fsl,imx6sl-uart",
-						   "fsl,imx6q-uart", "fsl,imx21-uart";
+						     "fsl,imx6q-uart", "fsl,imx21-uart";
 					reg = <0x02018000 0x4000>;
 					interrupts = <0 30 IRQ_TYPE_LEVEL_HIGH>;
 					clocks = <&clks IMX6SL_CLK_UART>,
@@ -238,7 +238,7 @@
 
 				uart1: serial@2020000 {
 					compatible = "fsl,imx6sl-uart",
-						   "fsl,imx6q-uart", "fsl,imx21-uart";
+						     "fsl,imx6q-uart", "fsl,imx21-uart";
 					reg = <0x02020000 0x4000>;
 					interrupts = <0 26 IRQ_TYPE_LEVEL_HIGH>;
 					clocks = <&clks IMX6SL_CLK_UART>,
@@ -251,7 +251,7 @@
 
 				uart2: serial@2024000 {
 					compatible = "fsl,imx6sl-uart",
-						   "fsl,imx6q-uart", "fsl,imx21-uart";
+						     "fsl,imx6q-uart", "fsl,imx21-uart";
 					reg = <0x02024000 0x4000>;
 					interrupts = <0 27 IRQ_TYPE_LEVEL_HIGH>;
 					clocks = <&clks IMX6SL_CLK_UART>,
@@ -312,7 +312,7 @@
 
 				uart3: serial@2034000 {
 					compatible = "fsl,imx6sl-uart",
-						   "fsl,imx6q-uart", "fsl,imx21-uart";
+						     "fsl,imx6q-uart", "fsl,imx21-uart";
 					reg = <0x02034000 0x4000>;
 					interrupts = <0 28 IRQ_TYPE_LEVEL_HIGH>;
 					clocks = <&clks IMX6SL_CLK_UART>,
@@ -325,7 +325,7 @@
 
 				uart4: serial@2038000 {
 					compatible = "fsl,imx6sl-uart",
-						   "fsl,imx6q-uart", "fsl,imx21-uart";
+						     "fsl,imx6q-uart", "fsl,imx21-uart";
 					reg = <0x02038000 0x4000>;
 					interrupts = <0 29 IRQ_TYPE_LEVEL_HIGH>;
 					clocks = <&clks IMX6SL_CLK_UART>,
@@ -714,7 +714,7 @@
 						#power-domain-cells = <0>;
 						power-supply = <&reg_pu>;
 						clocks = <&clks IMX6SL_CLK_GPU2D_OVG>,
-						         <&clks IMX6SL_CLK_GPU2D_PODF>;
+							 <&clks IMX6SL_CLK_GPU2D_PODF>;
 					};
 
 					pd_disp: power-domain@2 {
-- 
2.35.1



