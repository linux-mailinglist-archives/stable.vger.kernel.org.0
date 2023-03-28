Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80B9A6CC4AF
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233886AbjC1PH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233889AbjC1PHZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:07:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08BDFE3AE
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:06:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6636E61861
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:06:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 744ACC433D2;
        Tue, 28 Mar 2023 15:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015971;
        bh=RZr8306DY+9xcyADv6hoJ0Xfw9DnmlE+zsEg+C7RNDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cLcbTO+4juI0+aSeb+axNeUQ1JfDQoPi/t9R+aMEVIGQr2UyU3RwPLkRnQ6QBD8RG
         diS6IGh88tlgm7p90f8a68jSArS0AgfagOHQiGXgjKjDsMMccym9fktcA3TjcP51PW
         t3VOYmHm7SDQIR5FlnvvVdf615brGdJl9Izr5hA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Adam Ford <aford173@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 019/146] arm64: dts: imx8mn: specify #sound-dai-cells for SAI nodes
Date:   Tue, 28 Mar 2023 16:41:48 +0200
Message-Id: <20230328142603.521877637@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 62fb54148cd6eb456ff031be8fb447c98cf0bd9b ]

Add #sound-dai-cells properties to SAI nodes.

Reviewed-by: Adam Ford <aford173@gmail.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Fixes: 9e9860069725 ("arm64: dts: imx8mn: Add SAI nodes")
Signed-off-by: Marek Vasut <marex@denx.de>
Reviewed-by: Marco Felsch <m.felsch@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mn.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mn.dtsi b/arch/arm64/boot/dts/freescale/imx8mn.dtsi
index 0c47ff2426410..16a5efba17f39 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mn.dtsi
@@ -265,6 +265,7 @@ spba2: spba-bus@30000000 {
 				sai2: sai@30020000 {
 					compatible = "fsl,imx8mn-sai", "fsl,imx8mq-sai";
 					reg = <0x30020000 0x10000>;
+					#sound-dai-cells = <0>;
 					interrupts = <GIC_SPI 96 IRQ_TYPE_LEVEL_HIGH>;
 					clocks = <&clk IMX8MN_CLK_SAI2_IPG>,
 						<&clk IMX8MN_CLK_DUMMY>,
@@ -279,6 +280,7 @@ sai2: sai@30020000 {
 				sai3: sai@30030000 {
 					compatible = "fsl,imx8mn-sai", "fsl,imx8mq-sai";
 					reg = <0x30030000 0x10000>;
+					#sound-dai-cells = <0>;
 					interrupts = <GIC_SPI 50 IRQ_TYPE_LEVEL_HIGH>;
 					clocks = <&clk IMX8MN_CLK_SAI3_IPG>,
 						 <&clk IMX8MN_CLK_DUMMY>,
@@ -293,6 +295,7 @@ sai3: sai@30030000 {
 				sai5: sai@30050000 {
 					compatible = "fsl,imx8mn-sai", "fsl,imx8mq-sai";
 					reg = <0x30050000 0x10000>;
+					#sound-dai-cells = <0>;
 					interrupts = <GIC_SPI 90 IRQ_TYPE_LEVEL_HIGH>;
 					clocks = <&clk IMX8MN_CLK_SAI5_IPG>,
 						 <&clk IMX8MN_CLK_DUMMY>,
@@ -309,6 +312,7 @@ sai5: sai@30050000 {
 				sai6: sai@30060000 {
 					compatible = "fsl,imx8mn-sai", "fsl,imx8mq-sai";
 					reg = <0x30060000  0x10000>;
+					#sound-dai-cells = <0>;
 					interrupts = <GIC_SPI 90 IRQ_TYPE_LEVEL_HIGH>;
 					clocks = <&clk IMX8MN_CLK_SAI6_IPG>,
 						 <&clk IMX8MN_CLK_DUMMY>,
@@ -366,6 +370,7 @@ spdif1: spdif@30090000 {
 				sai7: sai@300b0000 {
 					compatible = "fsl,imx8mn-sai", "fsl,imx8mq-sai";
 					reg = <0x300b0000 0x10000>;
+					#sound-dai-cells = <0>;
 					interrupts = <GIC_SPI 111 IRQ_TYPE_LEVEL_HIGH>;
 					clocks = <&clk IMX8MN_CLK_SAI7_IPG>,
 						 <&clk IMX8MN_CLK_DUMMY>,
-- 
2.39.2



