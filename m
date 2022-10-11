Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED6245FB5A7
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 16:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbiJKO4P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 10:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbiJKOzJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:55:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3825F9C2FA;
        Tue, 11 Oct 2022 07:51:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33655611CC;
        Tue, 11 Oct 2022 14:51:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDCECC4314F;
        Tue, 11 Oct 2022 14:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665499907;
        bh=Egm4MdP0NHVzUlEWm6pobpbnZfwGNN+TlkYTi/H0mow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eQAhO1weedBsVK0Pc8v8lS1hywNY8dM7D0Ys2aq1nh9fd52a97ekCrI/vqgoHde2y
         wCrPYQ3ghdf3YnLiXbVNEuaLb0AhWMrIrgL7XyXJeHuzc4HsZM0geLxVueMlxRgz36
         C+pK8xHfyrr/fcGIhb+tM0y2thjhuPkwpkFcZrS6oV/bj5AY/uo79b/V5IBxoiee8L
         MI9tT+J9xWbBvsArK2LYrSBK2+wmoXRtaG5Ealhx7eFvsfepIoTEaqtQKZwGrfKqeu
         C2KhIX68Qf5jLGXqKBmGPnMAyK4zDxWpp159gElAxHdsjF8IkZHGpM18ofqYu9HadD
         zi8wDxyg1rREg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.19 12/40] ARM: dts: imx6sl: use tabs for code indent
Date:   Tue, 11 Oct 2022 10:51:01 -0400
Message-Id: <20221011145129.1623487-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145129.1623487-1-sashal@kernel.org>
References: <20221011145129.1623487-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -61,10 +61,10 @@ cpu0: cpu@0 {
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
@@ -225,7 +225,7 @@ ecspi4: spi@2014000 {
 
 				uart5: serial@2018000 {
 					compatible = "fsl,imx6sl-uart",
-						   "fsl,imx6q-uart", "fsl,imx21-uart";
+						     "fsl,imx6q-uart", "fsl,imx21-uart";
 					reg = <0x02018000 0x4000>;
 					interrupts = <0 30 IRQ_TYPE_LEVEL_HIGH>;
 					clocks = <&clks IMX6SL_CLK_UART>,
@@ -238,7 +238,7 @@ uart5: serial@2018000 {
 
 				uart1: serial@2020000 {
 					compatible = "fsl,imx6sl-uart",
-						   "fsl,imx6q-uart", "fsl,imx21-uart";
+						     "fsl,imx6q-uart", "fsl,imx21-uart";
 					reg = <0x02020000 0x4000>;
 					interrupts = <0 26 IRQ_TYPE_LEVEL_HIGH>;
 					clocks = <&clks IMX6SL_CLK_UART>,
@@ -251,7 +251,7 @@ uart1: serial@2020000 {
 
 				uart2: serial@2024000 {
 					compatible = "fsl,imx6sl-uart",
-						   "fsl,imx6q-uart", "fsl,imx21-uart";
+						     "fsl,imx6q-uart", "fsl,imx21-uart";
 					reg = <0x02024000 0x4000>;
 					interrupts = <0 27 IRQ_TYPE_LEVEL_HIGH>;
 					clocks = <&clks IMX6SL_CLK_UART>,
@@ -312,7 +312,7 @@ ssi3: ssi@2030000 {
 
 				uart3: serial@2034000 {
 					compatible = "fsl,imx6sl-uart",
-						   "fsl,imx6q-uart", "fsl,imx21-uart";
+						     "fsl,imx6q-uart", "fsl,imx21-uart";
 					reg = <0x02034000 0x4000>;
 					interrupts = <0 28 IRQ_TYPE_LEVEL_HIGH>;
 					clocks = <&clks IMX6SL_CLK_UART>,
@@ -325,7 +325,7 @@ uart3: serial@2034000 {
 
 				uart4: serial@2038000 {
 					compatible = "fsl,imx6sl-uart",
-						   "fsl,imx6q-uart", "fsl,imx21-uart";
+						     "fsl,imx6q-uart", "fsl,imx21-uart";
 					reg = <0x02038000 0x4000>;
 					interrupts = <0 29 IRQ_TYPE_LEVEL_HIGH>;
 					clocks = <&clks IMX6SL_CLK_UART>,
@@ -714,7 +714,7 @@ pd_pu: power-domain@1 {
 						#power-domain-cells = <0>;
 						power-supply = <&reg_pu>;
 						clocks = <&clks IMX6SL_CLK_GPU2D_OVG>,
-						         <&clks IMX6SL_CLK_GPU2D_PODF>;
+							 <&clks IMX6SL_CLK_GPU2D_PODF>;
 					};
 
 					pd_disp: power-domain@2 {
-- 
2.35.1

