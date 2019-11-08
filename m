Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9653EF5608
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391236AbfKHTGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:06:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:36790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390329AbfKHTGX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:06:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9B6F21D7B;
        Fri,  8 Nov 2019 19:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239982;
        bh=ZtU+Fu4bBsLK2P2Vw8HoSiIAGUI7g1RNPpnXnmF3TkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=chg07r+tf/qthkAt8TKhw0jTbDFvToAIhbmBdQNYuebhEqa4u5+wVJByX9tWCXAA+
         RALx3ZtNDOTYFozKbwfzvOzpDWe80ud2J4FdXzSPyuU4A82U91pjSB+uQF+tb/vycr
         T80QkguBffV+T1JEo+3Km/dEzErQ8kwXEPZIBQjI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anson Huang <Anson.Huang@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 048/140] arm64: dts: imx8mm: Use correct clock for usdhcs ipg clk
Date:   Fri,  8 Nov 2019 19:49:36 +0100
Message-Id: <20191108174908.428048542@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anson Huang <Anson.Huang@nxp.com>

[ Upstream commit a6a40d5688f2264afd40574ee1c92e5f824b34ba ]

On i.MX8MM, usdhc's ipg clock is from IMX8MM_CLK_IPG_ROOT,
assign it explicitly instead of using IMX8MM_CLK_DUMMY.

Fixes: a05ea40eb384 ("arm64: dts: imx: Add i.mx8mm dtsi support")
Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm.dtsi b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
index 232a7412755a9..0d0a6543e5db2 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
@@ -650,7 +650,7 @@
 				compatible = "fsl,imx8mm-usdhc", "fsl,imx7d-usdhc";
 				reg = <0x30b40000 0x10000>;
 				interrupts = <GIC_SPI 22 IRQ_TYPE_LEVEL_HIGH>;
-				clocks = <&clk IMX8MM_CLK_DUMMY>,
+				clocks = <&clk IMX8MM_CLK_IPG_ROOT>,
 					 <&clk IMX8MM_CLK_NAND_USDHC_BUS>,
 					 <&clk IMX8MM_CLK_USDHC1_ROOT>;
 				clock-names = "ipg", "ahb", "per";
@@ -666,7 +666,7 @@
 				compatible = "fsl,imx8mm-usdhc", "fsl,imx7d-usdhc";
 				reg = <0x30b50000 0x10000>;
 				interrupts = <GIC_SPI 23 IRQ_TYPE_LEVEL_HIGH>;
-				clocks = <&clk IMX8MM_CLK_DUMMY>,
+				clocks = <&clk IMX8MM_CLK_IPG_ROOT>,
 					 <&clk IMX8MM_CLK_NAND_USDHC_BUS>,
 					 <&clk IMX8MM_CLK_USDHC2_ROOT>;
 				clock-names = "ipg", "ahb", "per";
@@ -680,7 +680,7 @@
 				compatible = "fsl,imx8mm-usdhc", "fsl,imx7d-usdhc";
 				reg = <0x30b60000 0x10000>;
 				interrupts = <GIC_SPI 24 IRQ_TYPE_LEVEL_HIGH>;
-				clocks = <&clk IMX8MM_CLK_DUMMY>,
+				clocks = <&clk IMX8MM_CLK_IPG_ROOT>,
 					 <&clk IMX8MM_CLK_NAND_USDHC_BUS>,
 					 <&clk IMX8MM_CLK_USDHC3_ROOT>;
 				clock-names = "ipg", "ahb", "per";
-- 
2.20.1



