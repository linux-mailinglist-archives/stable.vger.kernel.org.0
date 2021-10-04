Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06EA7421A72
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 01:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbhJDXIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 19:08:54 -0400
Received: from finn.gateworks.com ([108.161.129.64]:51968 "EHLO
        finn.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231273AbhJDXIx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 19:08:53 -0400
X-Greylist: delayed 2592 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Oct 2021 19:08:53 EDT
Received: from 068-189-091-139.biz.spectrum.com ([68.189.91.139] helo=tharvey.pdc.gateworks.com)
        by finn.localdomain with esmtp (Exim 4.93)
        (envelope-from <tharvey@gateworks.com>)
        id 1mXWN4-0078Ft-U2; Mon, 04 Oct 2021 22:23:43 +0000
From:   Tim Harvey <tharvey@gateworks.com>
To:     Shawn Guo <shawnguo@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>, stable@vger.kernel.org
Subject: [PATCH] arm64: dts: imx8m*-venice-gw7902: fix M2_RST# gpio
Date:   Mon,  4 Oct 2021 15:23:41 -0700
Message-Id: <20211004222341.27949-1-tharvey@gateworks.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix invalid M2_RST# gpio pinmux.

Fixes: ef484dfcf6f7 ("arm64: dts: imx: Add i.mx8mm/imx8mn Gateworks gw7902 dts support")
Cc: stable@vger.kernel.org
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
---
 arch/arm64/boot/dts/freescale/imx8mm-venice-gw7902.dts | 2 +-
 arch/arm64/boot/dts/freescale/imx8mn-venice-gw7902.dts | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7902.dts b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7902.dts
index b4c1b662fa79..05c3406c90f5 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7902.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7902.dts
@@ -681,7 +681,7 @@
 	pinctrl_hog: hoggrp {
 		fsl,pins = <
 			MX8MM_IOMUXC_NAND_CE0_B_GPIO3_IO1	0x40000159 /* M2_GDIS# */
-			MX8MM_IOMUXC_GPIO1_IO12_GPIO1_IO12	0x40000041 /* M2_RST# */
+			MX8MM_IOMUXC_GPIO1_IO13_GPIO1_IO13	0x40000041 /* M2_RST# */
 			MX8MM_IOMUXC_NAND_DATA01_GPIO3_IO7	0x40000119 /* M2_OFF# */
 			MX8MM_IOMUXC_GPIO1_IO15_GPIO1_IO15	0x40000159 /* M2_WDIS# */
 			MX8MM_IOMUXC_SAI1_TXD2_GPIO4_IO14	0x40000041 /* AMP GPIO1 */
diff --git a/arch/arm64/boot/dts/freescale/imx8mn-venice-gw7902.dts b/arch/arm64/boot/dts/freescale/imx8mn-venice-gw7902.dts
index e77db4996e58..236f425e1570 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn-venice-gw7902.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mn-venice-gw7902.dts
@@ -633,7 +633,7 @@
 	pinctrl_hog: hoggrp {
 		fsl,pins = <
 			MX8MN_IOMUXC_NAND_CE0_B_GPIO3_IO1	0x40000159 /* M2_GDIS# */
-			MX8MN_IOMUXC_GPIO1_IO12_GPIO1_IO12	0x40000041 /* M2_RST# */
+			MX8MN_IOMUXC_GPIO1_IO13_GPIO1_IO13	0x40000041 /* M2_RST# */
 			MX8MN_IOMUXC_NAND_DATA01_GPIO3_IO7	0x40000119 /* M2_OFF# */
 			MX8MN_IOMUXC_GPIO1_IO15_GPIO1_IO15	0x40000159 /* M2_WDIS# */
 			MX8MN_IOMUXC_SAI2_RXFS_GPIO4_IO21	0x40000041 /* APP GPIO1 */
-- 
2.17.1

