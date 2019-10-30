Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DBC6EA00D
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 16:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbfJ3PxC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:53:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:54192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727377AbfJ3PxB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:53:01 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CA1120656;
        Wed, 30 Oct 2019 15:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450780;
        bh=ZtU+Fu4bBsLK2P2Vw8HoSiIAGUI7g1RNPpnXnmF3TkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fPwVj36/Mg19A1xzk7dUVt5UkVUNrALOrb3QtUSJOMi9HC8D8Pt14PPWiAZ2pbP2G
         wiXcaZH3EUzA54zUp7xhM1Em3zYycxafrnyOXAxCKhL2+FcBfuNXJ+Oh8HzA2zW8A8
         eS/y/fJ8HSJurnjImR1YJ6CqNoChW0RBeiD6Bk84=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anson Huang <Anson.Huang@nxp.com>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 48/81] arm64: dts: imx8mm: Use correct clock for usdhc's ipg clk
Date:   Wed, 30 Oct 2019 11:48:54 -0400
Message-Id: <20191030154928.9432-48-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030154928.9432-1-sashal@kernel.org>
References: <20191030154928.9432-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

