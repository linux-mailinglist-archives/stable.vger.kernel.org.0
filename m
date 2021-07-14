Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E26753C8DBC
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236094AbhGNTpd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:45:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:38880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236591AbhGNTo4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:44:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37BF2613E6;
        Wed, 14 Jul 2021 19:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291698;
        bh=MGbGQrJ3adadjnLKu1fb72/dngB4J4tAJ+SjgSlVw4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TP3qVxbzC7txwXHGWH0PGFfdWAhnKKAuvzSN7UGWQr5XXPLRZ9BBo3CaCR4ShRrFJ
         PvXhqvDmpbea+s/LGjfIfvJIIBbHf+3W26WMaTp26KDmih2puC6dG3wWT7obFiw32R
         pHRrkjObsBur+/G3Nhle1To/nfRfeEgoh5X1QFCBCcA9J3/dyCZnVzUjrWjZCRkb3n
         uW1yyJc0BQZsGy5EJUMKmFYMI22AZX+5hiIplaLQeYsABdte5MOD1sAjVv38zZjnWd
         UX+/wuwokiSOSA4pFJ9Jn3STxBpNg9+eWkw2GkB3ivlNZFL7m0sj+2K4ph5r+K9sGA
         eN5qjvjJ4yg+A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 044/102] ARM: dts: dra7x-evm: Align GPIO hog names with dt-schema
Date:   Wed, 14 Jul 2021 15:39:37 -0400
Message-Id: <20210714194036.53141-44-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194036.53141-1-sashal@kernel.org>
References: <20210714194036.53141-1-sashal@kernel.org>
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
index 38530dbb89a0..3dcb6e1f49bc 100644
--- a/arch/arm/boot/dts/dra7-evm.dts
+++ b/arch/arm/boot/dts/dra7-evm.dts
@@ -366,7 +366,7 @@ pcf_hdmi: gpio@26 {
 		reg = <0x26>;
 		gpio-controller;
 		#gpio-cells = <2>;
-		p1 {
+		hdmi-audio-hog {
 			/* vin6_sel_s0: high: VIN6, low: audio */
 			gpio-hog;
 			gpios = <1 GPIO_ACTIVE_HIGH>;
diff --git a/arch/arm/boot/dts/dra71-evm.dts b/arch/arm/boot/dts/dra71-evm.dts
index 6d2cca6b4488..a64364443031 100644
--- a/arch/arm/boot/dts/dra71-evm.dts
+++ b/arch/arm/boot/dts/dra71-evm.dts
@@ -187,7 +187,7 @@ &pcf_gpio_21 {
 };
 
 &pcf_hdmi {
-	p0 {
+	hdmi-i2c-disable-hog {
 		/*
 		 * PM_OEn to High: Disable routing I2C3 to PM_I2C
 		 * With this PM_SEL(p3) should not matter
diff --git a/arch/arm/boot/dts/dra72-evm-common.dtsi b/arch/arm/boot/dts/dra72-evm-common.dtsi
index b65b2dd094d0..f2384277d5dc 100644
--- a/arch/arm/boot/dts/dra72-evm-common.dtsi
+++ b/arch/arm/boot/dts/dra72-evm-common.dtsi
@@ -268,7 +268,7 @@ pcf_hdmi: pcf8575@26 {
 		 */
 		lines-initial-states = <0x0f2b>;
 
-		p1 {
+		hdmi-audio-hog {
 			/* vin6_sel_s0: high: VIN6, low: audio */
 			gpio-hog;
 			gpios = <1 GPIO_ACTIVE_HIGH>;
diff --git a/arch/arm/boot/dts/dra76-evm.dts b/arch/arm/boot/dts/dra76-evm.dts
index 9bd01ae40b1d..df47ea59c9c4 100644
--- a/arch/arm/boot/dts/dra76-evm.dts
+++ b/arch/arm/boot/dts/dra76-evm.dts
@@ -381,7 +381,7 @@ pcf_hdmi: pcf8575@26 {
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

