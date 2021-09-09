Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28633404ADA
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238519AbhIILti (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:49:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241491AbhIILrX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:47:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAE6F611C1;
        Thu,  9 Sep 2021 11:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187792;
        bh=K+OMO1Njztw6YlyzgkSSexuPlQDmCvLsuLAOUOCSwT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X3nGTL9fneRI26YSAxc5Ot4/DMkxP2mNJeA6PJUikf7RExwA6brzUK/IF2DHWu7Qs
         y4ehKBIIzr612pwlC6JXv8l9VwRxBKzK6STaZce4sFIdUQuxDmUS+7FPucQRo6h1OE
         CO8kvMpuhFQ5dP7qfJTuVDhgc46ctvntOtbgHSjH3jagR6RtbOIOR8cgfR/KS3OTSr
         OmbzN2dvIroTLEO8ZBVuP5T9RXyp9IOPcbk84ZyKYLhYPxeSCJkLN9rJ9oLKGsfYSN
         7dZ8i8ebcTN1CTIc/GHY2maF0VMgS5m78HJlj+wl7IYy6M1EBX49NyAjT5hUmWQdqg
         B7gX1+VnA1ugA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.14 098/252] ARM: dts: at91: use the right property for shutdown controller
Date:   Thu,  9 Sep 2021 07:38:32 -0400
Message-Id: <20210909114106.141462-98-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@microchip.com>

[ Upstream commit 818c4593434e81c9971b8fc278215121622c755e ]

The wrong property "atmel,shdwc-debouncer" was used to specify the
debounce delay for the shutdown controler. Replace it with the
documented and implemented property "debounce-delay-us", as mentioned
in v4 driver submission. See:
https://lore.kernel.org/r/1458134390-23847-3-git-send-email-nicolas.ferre@atmel.com/

Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Reported-by: Clément Léger <clement.leger@bootlin.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20210730172729.28093-1-nicolas.ferre@microchip.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/at91-kizbox3_common.dtsi    | 2 +-
 arch/arm/boot/dts/at91-sam9x60ek.dts          | 2 +-
 arch/arm/boot/dts/at91-sama5d27_som1_ek.dts   | 2 +-
 arch/arm/boot/dts/at91-sama5d27_wlsom1_ek.dts | 2 +-
 arch/arm/boot/dts/at91-sama5d2_icp.dts        | 2 +-
 arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts     | 2 +-
 arch/arm/boot/dts/at91-sama5d2_xplained.dts   | 2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm/boot/dts/at91-kizbox3_common.dtsi b/arch/arm/boot/dts/at91-kizbox3_common.dtsi
index c4b3750495da..abe27adfa4d6 100644
--- a/arch/arm/boot/dts/at91-kizbox3_common.dtsi
+++ b/arch/arm/boot/dts/at91-kizbox3_common.dtsi
@@ -336,7 +336,7 @@ &pwm0 {
 };
 
 &shutdown_controller {
-	atmel,shdwc-debouncer = <976>;
+	debounce-delay-us = <976>;
 	atmel,wakeup-rtc-timer;
 
 	input@0 {
diff --git a/arch/arm/boot/dts/at91-sam9x60ek.dts b/arch/arm/boot/dts/at91-sam9x60ek.dts
index edca66c232c1..a071e53cb854 100644
--- a/arch/arm/boot/dts/at91-sam9x60ek.dts
+++ b/arch/arm/boot/dts/at91-sam9x60ek.dts
@@ -648,7 +648,7 @@ &rtt {
 };
 
 &shutdown_controller {
-	atmel,shdwc-debouncer = <976>;
+	debounce-delay-us = <976>;
 	status = "okay";
 
 	input@0 {
diff --git a/arch/arm/boot/dts/at91-sama5d27_som1_ek.dts b/arch/arm/boot/dts/at91-sama5d27_som1_ek.dts
index a9e6fee55a2a..8034e5dacc80 100644
--- a/arch/arm/boot/dts/at91-sama5d27_som1_ek.dts
+++ b/arch/arm/boot/dts/at91-sama5d27_som1_ek.dts
@@ -138,7 +138,7 @@ i2c3: i2c@600 {
 			};
 
 			shdwc@f8048010 {
-				atmel,shdwc-debouncer = <976>;
+				debounce-delay-us = <976>;
 				atmel,wakeup-rtc-timer;
 
 				input@0 {
diff --git a/arch/arm/boot/dts/at91-sama5d27_wlsom1_ek.dts b/arch/arm/boot/dts/at91-sama5d27_wlsom1_ek.dts
index ff83967fd008..c145c4e5ef58 100644
--- a/arch/arm/boot/dts/at91-sama5d27_wlsom1_ek.dts
+++ b/arch/arm/boot/dts/at91-sama5d27_wlsom1_ek.dts
@@ -205,7 +205,7 @@ &sdmmc0 {
 };
 
 &shutdown_controller {
-	atmel,shdwc-debouncer = <976>;
+	debounce-delay-us = <976>;
 	atmel,wakeup-rtc-timer;
 
 	input@0 {
diff --git a/arch/arm/boot/dts/at91-sama5d2_icp.dts b/arch/arm/boot/dts/at91-sama5d2_icp.dts
index bd64721fa23c..34faca597c35 100644
--- a/arch/arm/boot/dts/at91-sama5d2_icp.dts
+++ b/arch/arm/boot/dts/at91-sama5d2_icp.dts
@@ -693,7 +693,7 @@ &sdmmc0 {
 };
 
 &shutdown_controller {
-	atmel,shdwc-debouncer = <976>;
+	debounce-delay-us = <976>;
 	atmel,wakeup-rtc-timer;
 
 	input@0 {
diff --git a/arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts b/arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts
index dfd150eb0fd8..3f972a4086c3 100644
--- a/arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts
+++ b/arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts
@@ -203,7 +203,7 @@ i2c2: i2c@600 {
 			};
 
 			shdwc@f8048010 {
-				atmel,shdwc-debouncer = <976>;
+				debounce-delay-us = <976>;
 
 				input@0 {
 					reg = <0>;
diff --git a/arch/arm/boot/dts/at91-sama5d2_xplained.dts b/arch/arm/boot/dts/at91-sama5d2_xplained.dts
index 509c732a0d8b..627b7bf88d83 100644
--- a/arch/arm/boot/dts/at91-sama5d2_xplained.dts
+++ b/arch/arm/boot/dts/at91-sama5d2_xplained.dts
@@ -347,7 +347,7 @@ i2c2: i2c@600 {
 			};
 
 			shdwc@f8048010 {
-				atmel,shdwc-debouncer = <976>;
+				debounce-delay-us = <976>;
 				atmel,wakeup-rtc-timer;
 
 				input@0 {
-- 
2.30.2

