Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D927E6CC3AA
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233569AbjC1O4W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233567AbjC1O4K (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:56:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60324E19C
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:56:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D135FB81D75
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:56:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B144C433EF;
        Tue, 28 Mar 2023 14:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015366;
        bh=c1HPlBFh+gY+QtFKvh2J84KPuFrFErNYBqBYl8CBcGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I8sqEZGlaZKhXnJqG5EXI9bXxYrijMwtQiA1501TO7Bey5GGVzySi/Fr07ZpHqcdb
         2f0dQLHR5cQxiMXIhJlgMCaOaha8DjnwN90sPGGEO6y+eUHTnLEY9sDikpEO5PJRFw
         2DYrwDQdsP6lIw8ppuEhQ40jz4B5Z83wIgB98ENg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 023/224] arm64: dts: imx93: add missing #address-cells and #size-cells to i2c nodes
Date:   Tue, 28 Mar 2023 16:40:19 +0200
Message-Id: <20230328142618.255472162@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit b3cdf730486b048ca0bf23bef050550d9fd40422 ]

Add them to the SoC .dtsi, so that not every board has to specify them.

Fixes: 1225396fefea ("arm64: dts: imx93: add lpi2c nodes")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx93.dtsi | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx93.dtsi b/arch/arm64/boot/dts/freescale/imx93.dtsi
index 0247866fc86b0..8ab9f8194702e 100644
--- a/arch/arm64/boot/dts/freescale/imx93.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx93.dtsi
@@ -150,6 +150,8 @@ system_counter: timer@44290000 {
 			lpi2c1: i2c@44340000 {
 				compatible = "fsl,imx93-lpi2c", "fsl,imx7ulp-lpi2c";
 				reg = <0x44340000 0x10000>;
+				#address-cells = <1>;
+				#size-cells = <0>;
 				interrupts = <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clk IMX93_CLK_LPI2C1_GATE>,
 					 <&clk IMX93_CLK_BUS_AON>;
@@ -160,6 +162,8 @@ lpi2c1: i2c@44340000 {
 			lpi2c2: i2c@44350000 {
 				compatible = "fsl,imx93-lpi2c", "fsl,imx7ulp-lpi2c";
 				reg = <0x44350000 0x10000>;
+				#address-cells = <1>;
+				#size-cells = <0>;
 				interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clk IMX93_CLK_LPI2C2_GATE>,
 					 <&clk IMX93_CLK_BUS_AON>;
@@ -277,6 +281,8 @@ mu2: mailbox@42440000 {
 			lpi2c3: i2c@42530000 {
 				compatible = "fsl,imx93-lpi2c", "fsl,imx7ulp-lpi2c";
 				reg = <0x42530000 0x10000>;
+				#address-cells = <1>;
+				#size-cells = <0>;
 				interrupts = <GIC_SPI 62 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clk IMX93_CLK_LPI2C3_GATE>,
 					 <&clk IMX93_CLK_BUS_WAKEUP>;
@@ -287,6 +293,8 @@ lpi2c3: i2c@42530000 {
 			lpi2c4: i2c@42540000 {
 				compatible = "fsl,imx93-lpi2c", "fsl,imx7ulp-lpi2c";
 				reg = <0x42540000 0x10000>;
+				#address-cells = <1>;
+				#size-cells = <0>;
 				interrupts = <GIC_SPI 63 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clk IMX93_CLK_LPI2C4_GATE>,
 					 <&clk IMX93_CLK_BUS_WAKEUP>;
@@ -351,6 +359,8 @@ lpuart8: serial@426a0000 {
 			lpi2c5: i2c@426b0000 {
 				compatible = "fsl,imx93-lpi2c", "fsl,imx7ulp-lpi2c";
 				reg = <0x426b0000 0x10000>;
+				#address-cells = <1>;
+				#size-cells = <0>;
 				interrupts = <GIC_SPI 195 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clk IMX93_CLK_LPI2C5_GATE>,
 					 <&clk IMX93_CLK_BUS_WAKEUP>;
@@ -361,6 +371,8 @@ lpi2c5: i2c@426b0000 {
 			lpi2c6: i2c@426c0000 {
 				compatible = "fsl,imx93-lpi2c", "fsl,imx7ulp-lpi2c";
 				reg = <0x426c0000 0x10000>;
+				#address-cells = <1>;
+				#size-cells = <0>;
 				interrupts = <GIC_SPI 196 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clk IMX93_CLK_LPI2C6_GATE>,
 					 <&clk IMX93_CLK_BUS_WAKEUP>;
@@ -371,6 +383,8 @@ lpi2c6: i2c@426c0000 {
 			lpi2c7: i2c@426d0000 {
 				compatible = "fsl,imx93-lpi2c", "fsl,imx7ulp-lpi2c";
 				reg = <0x426d0000 0x10000>;
+				#address-cells = <1>;
+				#size-cells = <0>;
 				interrupts = <GIC_SPI 197 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clk IMX93_CLK_LPI2C7_GATE>,
 					 <&clk IMX93_CLK_BUS_WAKEUP>;
@@ -381,6 +395,8 @@ lpi2c7: i2c@426d0000 {
 			lpi2c8: i2c@426e0000 {
 				compatible = "fsl,imx93-lpi2c", "fsl,imx7ulp-lpi2c";
 				reg = <0x426e0000 0x10000>;
+				#address-cells = <1>;
+				#size-cells = <0>;
 				interrupts = <GIC_SPI 198 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clk IMX93_CLK_LPI2C8_GATE>,
 					 <&clk IMX93_CLK_BUS_WAKEUP>;
-- 
2.39.2



