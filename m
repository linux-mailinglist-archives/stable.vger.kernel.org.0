Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC1B3C8F51
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237898AbhGNTwY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:52:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239109AbhGNTtL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:49:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B05FC61411;
        Wed, 14 Jul 2021 19:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291840;
        bh=v16LNw21tEYiOZ/cDbAReCH71CMg1TUMCoA5fAVf4ro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WIcyLcdpqqtB9jvn2dKn52x9hlCZjnAYPl1I+jUHPYc+k2zdZ4cK0ShsvV6Ia06s+
         lDxOlmBbc8Yhu62+rowK/JZYRmjrIuqN6b1yo+WMpyEKjUTAapCDZo5tbr/JL6bR6q
         HJ5rUUWP4YarBbV8e0hV/JrMlOFlxJPp+XD/qptayrCzOUzoDOF5u31ZyrE5mb9Ye4
         QKcVub8qCcX/RE+APhm0GlkI4DUbuKbCEJLI0MuD6jG7UM5tM7C70inXjHANot5msT
         EXTGAPbQI5kgOWdJUDcoyLOvKfoxhIWc2tu5dx/pmTazfLBlGMNCxbNcTr+uBEEW+Y
         Z2w0Qu6xUvYKQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 37/88] ARM: dts: dra7x-evm: Align GPIO hog names with dt-schema
Date:   Wed, 14 Jul 2021 15:42:12 -0400
Message-Id: <20210714194303.54028-37-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194303.54028-1-sashal@kernel.org>
References: <20210714194303.54028-1-sashal@kernel.org>
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
index cad58f733bd6..6f24c38131be 100644
--- a/arch/arm/boot/dts/dra71-evm.dts
+++ b/arch/arm/boot/dts/dra71-evm.dts
@@ -185,7 +185,7 @@ &pcf_gpio_21 {
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

