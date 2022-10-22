Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F26FB6089B9
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234184AbiJVIkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234755AbiJVIjn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:39:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23522CABE0;
        Sat, 22 Oct 2022 01:06:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C557CB82E11;
        Sat, 22 Oct 2022 08:04:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17FEAC433D6;
        Sat, 22 Oct 2022 08:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425853;
        bh=V3gHEUw1Kk05qfDus0qF9T3OcYJdKc5uRN6/d7kBomw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t7uVWK2bc+3ntJupJ6HN7DY1jIbnoXyfYdxME50+6O2pa0QOS5u+3KJVafRDeRVc6
         OP2UkrKKPEIPiUHzuVPOwk+odOCOTEnVx9Ddxfr0vXvmcWK8QeJdZjQGfggEMCNJvl
         hXsWAsaYABZhS1vHYpAsu6snLX6/fmMRmo4axXZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 638/717] ARM: dts: imx6sx-udoo-neo: dont use multiple blank lines
Date:   Sat, 22 Oct 2022 09:28:37 +0200
Message-Id: <20221022072526.649211292@linuxfoundation.org>
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
@@ -226,7 +226,7 @@
 &iomuxc {
 	pinctrl_bt_reg: btreggrp {
 		fsl,pins =
-			<MX6SX_PAD_KEY_ROW2__GPIO2_IO_17        0x15059>;
+			<MX6SX_PAD_KEY_ROW2__GPIO2_IO_17	0x15059>;
 	};
 
 	pinctrl_enet1: enet1grp {
@@ -306,7 +306,6 @@
 		>;
 	};
 
-
 	pinctrl_uart1: uart1grp {
 		fsl,pins =
 			<MX6SX_PAD_GPIO1_IO04__UART1_DCE_TX	0x1b0b1>,
@@ -347,24 +346,23 @@
 
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



