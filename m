Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8BE3D296E
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233541AbhGVQEC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:04:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:39778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233882AbhGVQDK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:03:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF1F961949;
        Thu, 22 Jul 2021 16:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972224;
        bh=0X5IJGP0GNDxqqdex+rJkuRy55+bI/TK04lUuNMUfcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DTIDK8bY/xjHzf8w/+eKLxRSEQDe2hvXLjOa14kvvSdTLH2PjOYtzvudYkeEW5MsA
         0QMhxoCmP8U/KcH10/cPtS2ornVVP7gFkw1vUGxmr5MrtG1mW15+lAg5gbVHkFBGYR
         uAiMjES0EpmC7W48vNaah6C0uqOYQ3VUvhHkB3b0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 031/156] ARM: dts: ux500: Fix some compatible strings
Date:   Thu, 22 Jul 2021 18:30:06 +0200
Message-Id: <20210722155629.417258396@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 59ba546d1662c4beb738725965041f350afe24b4 ]

The Golden and Skomer phones have BCM4334 WLAN+BT chips,
so make the compatible strings reflect the new available
bindings for these.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ste-ux500-samsung-golden.dts | 3 ++-
 arch/arm/boot/dts/ste-ux500-samsung-janice.dts | 4 ++--
 arch/arm/boot/dts/ste-ux500-samsung-skomer.dts | 3 ++-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/ste-ux500-samsung-golden.dts b/arch/arm/boot/dts/ste-ux500-samsung-golden.dts
index 0d43ee6583cf..40df7c61bf69 100644
--- a/arch/arm/boot/dts/ste-ux500-samsung-golden.dts
+++ b/arch/arm/boot/dts/ste-ux500-samsung-golden.dts
@@ -121,7 +121,7 @@
 			#size-cells = <0>;
 
 			wifi@1 {
-				compatible = "brcm,bcm4329-fmac";
+				compatible = "brcm,bcm4334-fmac", "brcm,bcm4329-fmac";
 				reg = <1>;
 
 				/* GPIO216 (WLAN_HOST_WAKE) */
@@ -162,6 +162,7 @@
 			pinctrl-1 = <&u0_a_1_sleep>;
 
 			bluetooth {
+				/* BCM4334B0 actually */
 				compatible = "brcm,bcm4330-bt";
 				/* GPIO222 (BT_VREG_ON) */
 				shutdown-gpios = <&gpio6 30 GPIO_ACTIVE_HIGH>;
diff --git a/arch/arm/boot/dts/ste-ux500-samsung-janice.dts b/arch/arm/boot/dts/ste-ux500-samsung-janice.dts
index f24369873ce2..eaf8039d10ad 100644
--- a/arch/arm/boot/dts/ste-ux500-samsung-janice.dts
+++ b/arch/arm/boot/dts/ste-ux500-samsung-janice.dts
@@ -401,8 +401,7 @@
 			status = "okay";
 
 			wifi@1 {
-				/* Actually BRCM4330 */
-				compatible = "brcm,bcm4329-fmac";
+				compatible = "brcm,bcm4330-fmac", "brcm,bcm4329-fmac";
 				reg = <1>;
 				/* GPIO216 WL_HOST_WAKE */
 				interrupt-parent = <&gpio6>;
@@ -436,6 +435,7 @@
 			status = "okay";
 
 			bluetooth {
+				/* BCM4330B1 actually */
 				compatible = "brcm,bcm4330-bt";
 				/* GPIO222 rail BT_VREG_EN to BT_REG_ON */
 				shutdown-gpios = <&gpio6 30 GPIO_ACTIVE_HIGH>;
diff --git a/arch/arm/boot/dts/ste-ux500-samsung-skomer.dts b/arch/arm/boot/dts/ste-ux500-samsung-skomer.dts
index d28a00757d0b..94afd7a0fe1f 100644
--- a/arch/arm/boot/dts/ste-ux500-samsung-skomer.dts
+++ b/arch/arm/boot/dts/ste-ux500-samsung-skomer.dts
@@ -211,7 +211,7 @@
 			#size-cells = <0>;
 
 			wifi@1 {
-				compatible = "brcm,bcm4329-fmac";
+				compatible = "brcm,bcm4334-fmac", "brcm,bcm4329-fmac";
 				reg = <1>;
 				/* GPIO216 WL_HOST_WAKE */
 				interrupt-parent = <&gpio6>;
@@ -247,6 +247,7 @@
 
 			/* FIXME: not quite working yet, probably needs regulators */
 			bluetooth {
+				/* BCM4334B0 actually */
 				compatible = "brcm,bcm4330-bt";
 				shutdown-gpios = <&gpio6 30 GPIO_ACTIVE_HIGH>;
 				device-wakeup-gpios = <&gpio6 7 GPIO_ACTIVE_HIGH>;
-- 
2.30.2



