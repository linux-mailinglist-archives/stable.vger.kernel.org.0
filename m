Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD4840E080
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235075AbhIPQVl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:21:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241213AbhIPQPV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:15:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 353E0613B5;
        Thu, 16 Sep 2021 16:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808680;
        bh=ZLv1C3RG3riPpt4zVxb0SbdFlgyPyAJ537EUYTgLIes=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0gYNQbJHTZiGlbxsfX4qZvE4NPYK2HsZh6VvF9QkbvmKAHZ2O6V5A3L2Dd9EeVMdb
         xNSBmHIAs2yTDtBJMwf+6L9R4NZU2oQgu1IZsMFLpy/3wWSCPO7+CinBPENtHuyGib
         ZkaE7CTtLH1lxNdqIr6wbPSkbr+G3z27g6qLnJxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 175/306] ARM: dts: at91: use the right property for shutdown controller
Date:   Thu, 16 Sep 2021 17:58:40 +0200
Message-Id: <20210916155800.043511564@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 7c3076e245ef..dc77d8e80e56 100644
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
index ebbc9b23aef1..b1068cca4228 100644
--- a/arch/arm/boot/dts/at91-sam9x60ek.dts
+++ b/arch/arm/boot/dts/at91-sam9x60ek.dts
@@ -662,7 +662,7 @@ &rtt {
 };
 
 &shutdown_controller {
-	atmel,shdwc-debouncer = <976>;
+	debounce-delay-us = <976>;
 	status = "okay";
 
 	input@0 {
diff --git a/arch/arm/boot/dts/at91-sama5d27_som1_ek.dts b/arch/arm/boot/dts/at91-sama5d27_som1_ek.dts
index d3cd2443ba25..9a18453d7842 100644
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
index 4883b84b4ede..20bcb7480d2e 100644
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
index 19bb50f50c1f..308d472bd104 100644
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
index 1c6361ba1aca..317c6ddb5677 100644
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
index d767968ae217..08c5182ba86b 100644
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



