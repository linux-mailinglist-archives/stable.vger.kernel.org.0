Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB9BB3C9053
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241438AbhGNTyT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:54:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:46246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241117AbhGNTuY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:50:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7D21613D4;
        Wed, 14 Jul 2021 19:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626292017;
        bh=toCRbi6VfVAnEan8GVuYqR9Ynz9EDwemt+7R9hhvUnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oEAReKftWzQJpC4ziK3j641/Jkj6V4bdpKVkRXbkHyjYrHEa9+JLHA9IJdifuILDK
         cluodf+Mo1S0SnAPi0d82Kv20HyTt+LZXXN0sq5Euu3pY5+Fh9XBt+/OuNxshHOwng
         nXN+yYoC+VLhCTvug9IJnymNsKsX5+6BqZlinlxVAqGVv9mwZH8QHGwKCVyBAPvIDO
         h0T5O8GrH0UNgd29OEYSqV9zKRjAsoliaEQh8mX17FS1lY68ixweoZKRh3y0FnH1R5
         XZN6W/aqkiccNvxOecjcZVWGz+VQVnrL+igorEn9Xn0sBPMnNUWc9mSAb38b/adfqZ
         Lc7z7TLE30Rlw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 22/39] ARM: dts: dra7x-evm: Align GPIO hog names with dt-schema
Date:   Wed, 14 Jul 2021 15:46:07 -0400
Message-Id: <20210714194625.55303-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194625.55303-1-sashal@kernel.org>
References: <20210714194625.55303-1-sashal@kernel.org>
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
index 6ed5f9156270..1b7f1c7921de 100644
--- a/arch/arm/boot/dts/dra7-evm.dts
+++ b/arch/arm/boot/dts/dra7-evm.dts
@@ -335,7 +335,7 @@ pcf_hdmi: gpio@26 {
 		reg = <0x26>;
 		gpio-controller;
 		#gpio-cells = <2>;
-		p1 {
+		hdmi-audio-hog {
 			/* vin6_sel_s0: high: VIN6, low: audio */
 			gpio-hog;
 			gpios = <1 GPIO_ACTIVE_HIGH>;
diff --git a/arch/arm/boot/dts/dra71-evm.dts b/arch/arm/boot/dts/dra71-evm.dts
index c471bf3277b4..60ce286edf03 100644
--- a/arch/arm/boot/dts/dra71-evm.dts
+++ b/arch/arm/boot/dts/dra71-evm.dts
@@ -161,7 +161,7 @@ &pcf_gpio_21 {
 };
 
 &pcf_hdmi {
-	p0 {
+	hdmi-i2c-disable-hog {
 		/*
 		 * PM_OEn to High: Disable routing I2C3 to PM_I2C
 		 * With this PM_SEL(p3) should not matter
diff --git a/arch/arm/boot/dts/dra72-evm-common.dtsi b/arch/arm/boot/dts/dra72-evm-common.dtsi
index e297b923b71a..b33221747ac3 100644
--- a/arch/arm/boot/dts/dra72-evm-common.dtsi
+++ b/arch/arm/boot/dts/dra72-evm-common.dtsi
@@ -264,7 +264,7 @@ pcf_hdmi: pcf8575@26 {
 		 */
 		lines-initial-states = <0x0f2b>;
 
-		p1 {
+		hdmi-audio-hog {
 			/* vin6_sel_s0: high: VIN6, low: audio */
 			gpio-hog;
 			gpios = <1 GPIO_ACTIVE_HIGH>;
diff --git a/arch/arm/boot/dts/dra76-evm.dts b/arch/arm/boot/dts/dra76-evm.dts
index 5a46163d465f..08f414db95aa 100644
--- a/arch/arm/boot/dts/dra76-evm.dts
+++ b/arch/arm/boot/dts/dra76-evm.dts
@@ -295,7 +295,7 @@ pcf_hdmi: pcf8575@26 {
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

