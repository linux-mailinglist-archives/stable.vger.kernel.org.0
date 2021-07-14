Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61ADF3C90C7
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240493AbhGNT4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:56:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236895AbhGNTun (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:50:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8965600D4;
        Wed, 14 Jul 2021 19:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626292071;
        bh=kdetEYL8bZ12lyAXjMNP1Yqi5TPzNdtdj75PtaAcwws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DIT/SQGuSosSFFEC5DI2JHO5h2EykRshNcupIGP3ETMSmPJqQoV1YlMF93bWUIbPn
         QdBx/MWzA+k9UVPyoTvBfE48gVH4WI1KiMW19DV5NfufaqB7Fkvhin7eyF5KkMP5Vf
         p2w4nxevYdxskdwIF/66hfIDy1pQP5EhMs2hdPwz5BdaoKyBe/Q39PPGzdCfEoLKpl
         p0hvHREp0HJv5Zk43lhEnW0We6CgZ1gbjA6ZL4Pdkft73G//WojHtAyVSCu3r4FB05
         TcUWxDjMYawgX4zN4rYgTRhCrhRh5dZSQlEQU720rI6IE0hK56eWa9t9iSGe1hbLAr
         XprnpLO/KtLpQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 18/28] ARM: dts: dra7x-evm: Align GPIO hog names with dt-schema
Date:   Wed, 14 Jul 2021 15:47:13 -0400
Message-Id: <20210714194723.55677-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194723.55677-1-sashal@kernel.org>
References: <20210714194723.55677-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 0c149400c2f676e7b4cc68e517db29005a7a38c7 ]

The dt-schema for nxp,pcf8575 expects GPIO hogs node names to end with a
'hog' suffix.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/dra7-evm.dts          | 2 +-
 arch/arm/boot/dts/dra71-evm.dts         | 2 +-
 arch/arm/boot/dts/dra72-evm-common.dtsi | 2 +-
 arch/arm/boot/dts/dra76-evm.dts         | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/dra7-evm.dts b/arch/arm/boot/dts/dra7-evm.dts
index aa426dabb6c3..c3990325f7e6 100644
--- a/arch/arm/boot/dts/dra7-evm.dts
+++ b/arch/arm/boot/dts/dra7-evm.dts
@@ -315,7 +315,7 @@ pcf_hdmi: gpio@26 {
 		reg = <0x26>;
 		gpio-controller;
 		#gpio-cells = <2>;
-		p1 {
+		hdmi-audio-hog {
 			/* vin6_sel_s0: high: VIN6, low: audio */
 			gpio-hog;
 			gpios = <1 GPIO_ACTIVE_HIGH>;
diff --git a/arch/arm/boot/dts/dra71-evm.dts b/arch/arm/boot/dts/dra71-evm.dts
index 64363f75c01a..cf1db1b71bab 100644
--- a/arch/arm/boot/dts/dra71-evm.dts
+++ b/arch/arm/boot/dts/dra71-evm.dts
@@ -160,7 +160,7 @@ &pcf_gpio_21 {
 };
 
 &pcf_hdmi {
-	p0 {
+	hdmi-i2c-disable-hog {
 		/*
 		 * PM_OEn to High: Disable routing I2C3 to PM_I2C
 		 * With this PM_SEL(p3) should not matter
diff --git a/arch/arm/boot/dts/dra72-evm-common.dtsi b/arch/arm/boot/dts/dra72-evm-common.dtsi
index 2e485a13dfd7..a5e65c1a568e 100644
--- a/arch/arm/boot/dts/dra72-evm-common.dtsi
+++ b/arch/arm/boot/dts/dra72-evm-common.dtsi
@@ -272,7 +272,7 @@ pcf_hdmi: pcf8575@26 {
 		 */
 		lines-initial-states = <0x0f2b>;
 
-		p1 {
+		hdmi-audio-hog {
 			/* vin6_sel_s0: high: VIN6, low: audio */
 			gpio-hog;
 			gpios = <1 GPIO_ACTIVE_HIGH>;
diff --git a/arch/arm/boot/dts/dra76-evm.dts b/arch/arm/boot/dts/dra76-evm.dts
index f64aab450315..51ff6321199d 100644
--- a/arch/arm/boot/dts/dra76-evm.dts
+++ b/arch/arm/boot/dts/dra76-evm.dts
@@ -314,7 +314,7 @@ pcf_hdmi: pcf8575@26 {
 		reg = <0x26>;
 		gpio-controller;
 		#gpio-cells = <2>;
-		p1 {
+		hdmi-audio-hog {
 			/* vin6_sel_s0: high: VIN6, low: audio */
 			gpio-hog;
 			gpios = <1 GPIO_ACTIVE_HIGH>;
-- 
2.30.2

