Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1805A4B4620
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243684AbiBNJcK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:32:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243522AbiBNJbw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:31:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 325611AD93;
        Mon, 14 Feb 2022 01:30:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8EABB80DCB;
        Mon, 14 Feb 2022 09:30:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2122C340E9;
        Mon, 14 Feb 2022 09:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831031;
        bh=PxAmF0SKGpeqELjz1UDvowOi6GjdGdS2hFerTKhDzi8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gbrqINtdhrLAd17ZLhZkX2920m9PvfoQTpkqDm1FbQlAMYmFI2FEpGeQDVVNOha1B
         i4AYQjOw6KLgxh599wDtgfKt74MprmtYWrFjCgD4FhdoSv1vVOwoj2MwXLpVohmYnF
         Akzk5FYNRC2Xay6Ydsh+yAlkRQUxeC3QHPDsOLV8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 21/44] ARM: dts: imx6qdl-udoo: Properly describe the SD card detect
Date:   Mon, 14 Feb 2022 10:25:44 +0100
Message-Id: <20220214092448.601120879@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092447.897544753@linuxfoundation.org>
References: <20220214092447.897544753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit 993d66140f8d1c1853a3b58b77b43b681eb64dee ]

GPIO7_IO00 is used as SD card detect.

Properly describe this in the devicetree.

Fixes: 40cdaa542cf0 ("ARM: dts: imx6q-udoo: Add initial board support")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qdl-udoo.dtsi | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6qdl-udoo.dtsi b/arch/arm/boot/dts/imx6qdl-udoo.dtsi
index fc4ae2e423bd7..b0fdcae66ead3 100644
--- a/arch/arm/boot/dts/imx6qdl-udoo.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-udoo.dtsi
@@ -9,6 +9,8 @@
  *
  */
 
+#include <dt-bindings/gpio/gpio.h>
+
 / {
 	aliases {
 		backlight = &backlight;
@@ -201,6 +203,7 @@ MX6QDL_PAD_SD3_DAT0__SD3_DATA0		0x17059
 				MX6QDL_PAD_SD3_DAT1__SD3_DATA1		0x17059
 				MX6QDL_PAD_SD3_DAT2__SD3_DATA2		0x17059
 				MX6QDL_PAD_SD3_DAT3__SD3_DATA3		0x17059
+				MX6QDL_PAD_SD3_DAT5__GPIO7_IO00		0x1b0b0
 			>;
 		};
 
@@ -267,7 +270,7 @@ &usbh1 {
 &usdhc3 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_usdhc3>;
-	non-removable;
+	cd-gpios = <&gpio7 0 GPIO_ACTIVE_LOW>;
 	status = "okay";
 };
 
-- 
2.34.1



