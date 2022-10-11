Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B75385FB5AE
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 16:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbiJKO4Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 10:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbiJKOzS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:55:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ECC79C7D4;
        Tue, 11 Oct 2022 07:51:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92FD8611CE;
        Tue, 11 Oct 2022 14:51:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F96C43143;
        Tue, 11 Oct 2022 14:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665499909;
        bh=gDTh/xKEFGKKo13t9yNjObc/OhXJ5Xj9ooYHUhlu1AA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aGTNwiGM11ZrTuEx/vCQOEEslJJrDurte4MCVTPv0+VWhayDsjXbN8RfbM9b80r8Y
         TUxtppL3BL1gfN/yOtZnthb58Mqicfc1CHS6zKD+jNOrRCDd1ZGMiychJOf75HXD2d
         0LrIA6Q3t+9jYF7F/vfBI0KUm6SeLM5QH72dZoVMG7SoDeS4HSO7Vjs7uuOYBEObGD
         L7K0G4N2Oq4dAcLdYBLN6BU+2uEk9zKbactJbRs3uWonuYbOcjxTpS0PjgOrxkly/W
         U5STGreV5V5nPoIHtA941dyZLWluugoTOLSNYOTubQ8qUIx6eTUZmimPNhlORsFbW9
         MIr2DivjLJpSw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.19 13/40] ARM: dts: imx6sx-udoo-neo: don't use multiple blank lines
Date:   Tue, 11 Oct 2022 10:51:02 -0400
Message-Id: <20221011145129.1623487-13-sashal@kernel.org>
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

[ Upstream commit fd2dd7077c7498765e7326c1b7f34bde85f1a975 ]

This fixes the following warning:

arch/arm/boot/dts/imx6sx-udoo-neo.dtsi:309: check: Please don't use multiple
blank lines

While at it, use tabs indent for some pinctrl entries.

Signed-off-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6sx-udoo-neo.dtsi | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/imx6sx-udoo-neo.dtsi b/arch/arm/boot/dts/imx6sx-udoo-neo.dtsi
index 35861bbea94e..c84ea1fac5e9 100644
--- a/arch/arm/boot/dts/imx6sx-udoo-neo.dtsi
+++ b/arch/arm/boot/dts/imx6sx-udoo-neo.dtsi
@@ -226,7 +226,7 @@ lcdc: endpoint {
 &iomuxc {
 	pinctrl_bt_reg: btreggrp {
 		fsl,pins =
-			<MX6SX_PAD_KEY_ROW2__GPIO2_IO_17        0x15059>;
+			<MX6SX_PAD_KEY_ROW2__GPIO2_IO_17	0x15059>;
 	};
 
 	pinctrl_enet1: enet1grp {
@@ -306,7 +306,6 @@ MX6SX_PAD_LCD1_RESET__GPIO3_IO_27		0x4001b0b0
 		>;
 	};
 
-
 	pinctrl_uart1: uart1grp {
 		fsl,pins =
 			<MX6SX_PAD_GPIO1_IO04__UART1_DCE_TX	0x1b0b1>,
@@ -347,24 +346,23 @@ pinctrl_uart6: uart6grp {
 
 	pinctrl_otg1_reg: otg1grp {
 		fsl,pins =
-			<MX6SX_PAD_GPIO1_IO09__GPIO1_IO_9        0x10b0>;
+			<MX6SX_PAD_GPIO1_IO09__GPIO1_IO_9	0x10b0>;
 	};
 
-
 	pinctrl_otg2_reg: otg2grp {
 		fsl,pins =
-			<MX6SX_PAD_NAND_RE_B__GPIO4_IO_12        0x10b0>;
+			<MX6SX_PAD_NAND_RE_B__GPIO4_IO_12	0x10b0>;
 	};
 
 	pinctrl_usb_otg1: usbotg1grp {
 		fsl,pins =
-			<MX6SX_PAD_GPIO1_IO10__ANATOP_OTG1_ID    0x17059>,
-			<MX6SX_PAD_GPIO1_IO08__USB_OTG1_OC       0x10b0>;
+			<MX6SX_PAD_GPIO1_IO10__ANATOP_OTG1_ID	0x17059>,
+			<MX6SX_PAD_GPIO1_IO08__USB_OTG1_OC	0x10b0>;
 	};
 
 	pinctrl_usb_otg2: usbot2ggrp {
 		fsl,pins =
-			<MX6SX_PAD_QSPI1A_DATA0__USB_OTG2_OC     0x10b0>;
+			<MX6SX_PAD_QSPI1A_DATA0__USB_OTG2_OC	0x10b0>;
 	};
 
 	pinctrl_usdhc2: usdhc2grp {
-- 
2.35.1

