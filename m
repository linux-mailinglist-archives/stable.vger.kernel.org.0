Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E11963C8F75
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237755AbhGNTwi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:52:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239852AbhGNTt0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:49:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61940613D7;
        Wed, 14 Jul 2021 19:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291870;
        bh=Hs3W3Mm1f8sD0e9WxTGvUbwaTyCPWbH4/NOsffg9lNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sieQoZm1Jf8EKzUt2Q1ZhZFwXVBEsrTDrLF4wFgveQ35yeQO7+OA7ECJseXgw22O1
         ae7pyos3abpaMVSznJKEcjOH82HUw2N9gdPr4IUqcJjBAmKZnXjLkkR1EVM9tqQ1eG
         f3bqkQ6ZI1qQtovcE5XdIyE81RHSpU8x4e74p9PZxrOG859FX1AUckXelPG1HCFxVO
         W/p1Prm9CCjLh5bwAy4187mIDX4ds2DcmM9SigQXfY1J9nKJNJ1Uys9NW5LQTz5Ts2
         wDKVFS6at0afF/5Qyz/1hUT0fFGgijUiYIy2N2wBqX/OZlHn3qbVE0WzMweWrmJA7Z
         Ha52xCFs2yIUQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefan Wahren <stefan.wahren@i2se.com>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 57/88] ARM: dts: bcm283x: Fix up GPIO LED node names
Date:   Wed, 14 Jul 2021 15:42:32 -0400
Message-Id: <20210714194303.54028-57-sashal@kernel.org>
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

From: Stefan Wahren <stefan.wahren@i2se.com>

[ Upstream commit 5f30dacf37bc93308e91e4d0fc94681ca73f0f91 ]

Fix the node names for the GPIO LEDs to conform to the standard node
name led-..

Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Link: https://lore.kernel.org/r/1622981777-5023-6-git-send-email-stefan.wahren@i2se.com
Signed-off-by: Nicolas Saenz Julienne <nsaenz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm2711-rpi-4-b.dts      | 4 ++--
 arch/arm/boot/dts/bcm2835-rpi-a-plus.dts   | 4 ++--
 arch/arm/boot/dts/bcm2835-rpi-a.dts        | 2 +-
 arch/arm/boot/dts/bcm2835-rpi-b-plus.dts   | 4 ++--
 arch/arm/boot/dts/bcm2835-rpi-b-rev2.dts   | 2 +-
 arch/arm/boot/dts/bcm2835-rpi-b.dts        | 2 +-
 arch/arm/boot/dts/bcm2835-rpi-cm1.dtsi     | 2 +-
 arch/arm/boot/dts/bcm2835-rpi-zero-w.dts   | 2 +-
 arch/arm/boot/dts/bcm2835-rpi-zero.dts     | 2 +-
 arch/arm/boot/dts/bcm2835-rpi.dtsi         | 2 +-
 arch/arm/boot/dts/bcm2836-rpi-2-b.dts      | 4 ++--
 arch/arm/boot/dts/bcm2837-rpi-3-a-plus.dts | 4 ++--
 arch/arm/boot/dts/bcm2837-rpi-3-b-plus.dts | 4 ++--
 arch/arm/boot/dts/bcm2837-rpi-3-b.dts      | 2 +-
 arch/arm/boot/dts/bcm2837-rpi-cm3.dtsi     | 2 +-
 15 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/arch/arm/boot/dts/bcm2711-rpi-4-b.dts b/arch/arm/boot/dts/bcm2711-rpi-4-b.dts
index 09a1182c2936..5395e8c2484e 100644
--- a/arch/arm/boot/dts/bcm2711-rpi-4-b.dts
+++ b/arch/arm/boot/dts/bcm2711-rpi-4-b.dts
@@ -28,11 +28,11 @@ aliases {
 	};
 
 	leds {
-		act {
+		led-act {
 			gpios = <&gpio 42 GPIO_ACTIVE_HIGH>;
 		};
 
-		pwr {
+		led-pwr {
 			label = "PWR";
 			gpios = <&expgpio 2 GPIO_ACTIVE_LOW>;
 			default-state = "keep";
diff --git a/arch/arm/boot/dts/bcm2835-rpi-a-plus.dts b/arch/arm/boot/dts/bcm2835-rpi-a-plus.dts
index 6c8ce39833bf..40b9405f1a8e 100644
--- a/arch/arm/boot/dts/bcm2835-rpi-a-plus.dts
+++ b/arch/arm/boot/dts/bcm2835-rpi-a-plus.dts
@@ -14,11 +14,11 @@ memory@0 {
 	};
 
 	leds {
-		act {
+		led-act {
 			gpios = <&gpio 47 GPIO_ACTIVE_HIGH>;
 		};
 
-		pwr {
+		led-pwr {
 			label = "PWR";
 			gpios = <&gpio 35 GPIO_ACTIVE_HIGH>;
 			default-state = "keep";
diff --git a/arch/arm/boot/dts/bcm2835-rpi-a.dts b/arch/arm/boot/dts/bcm2835-rpi-a.dts
index 17fdd48346ff..11edb581dbaf 100644
--- a/arch/arm/boot/dts/bcm2835-rpi-a.dts
+++ b/arch/arm/boot/dts/bcm2835-rpi-a.dts
@@ -14,7 +14,7 @@ memory@0 {
 	};
 
 	leds {
-		act {
+		led-act {
 			gpios = <&gpio 16 GPIO_ACTIVE_LOW>;
 		};
 	};
diff --git a/arch/arm/boot/dts/bcm2835-rpi-b-plus.dts b/arch/arm/boot/dts/bcm2835-rpi-b-plus.dts
index b0355c229cdc..1b435c64bd9c 100644
--- a/arch/arm/boot/dts/bcm2835-rpi-b-plus.dts
+++ b/arch/arm/boot/dts/bcm2835-rpi-b-plus.dts
@@ -15,11 +15,11 @@ memory@0 {
 	};
 
 	leds {
-		act {
+		led-act {
 			gpios = <&gpio 47 GPIO_ACTIVE_HIGH>;
 		};
 
-		pwr {
+		led-pwr {
 			label = "PWR";
 			gpios = <&gpio 35 GPIO_ACTIVE_HIGH>;
 			default-state = "keep";
diff --git a/arch/arm/boot/dts/bcm2835-rpi-b-rev2.dts b/arch/arm/boot/dts/bcm2835-rpi-b-rev2.dts
index 33b3b5c02521..a23c25c00eea 100644
--- a/arch/arm/boot/dts/bcm2835-rpi-b-rev2.dts
+++ b/arch/arm/boot/dts/bcm2835-rpi-b-rev2.dts
@@ -15,7 +15,7 @@ memory@0 {
 	};
 
 	leds {
-		act {
+		led-act {
 			gpios = <&gpio 16 GPIO_ACTIVE_LOW>;
 		};
 	};
diff --git a/arch/arm/boot/dts/bcm2835-rpi-b.dts b/arch/arm/boot/dts/bcm2835-rpi-b.dts
index 2b69957e0113..1b63d6b19750 100644
--- a/arch/arm/boot/dts/bcm2835-rpi-b.dts
+++ b/arch/arm/boot/dts/bcm2835-rpi-b.dts
@@ -15,7 +15,7 @@ memory@0 {
 	};
 
 	leds {
-		act {
+		led-act {
 			gpios = <&gpio 16 GPIO_ACTIVE_LOW>;
 		};
 	};
diff --git a/arch/arm/boot/dts/bcm2835-rpi-cm1.dtsi b/arch/arm/boot/dts/bcm2835-rpi-cm1.dtsi
index 58059c2ce129..e4e6b6abbfc1 100644
--- a/arch/arm/boot/dts/bcm2835-rpi-cm1.dtsi
+++ b/arch/arm/boot/dts/bcm2835-rpi-cm1.dtsi
@@ -5,7 +5,7 @@
 
 / {
 	leds {
-		act {
+		led-act {
 			gpios = <&gpio 47 GPIO_ACTIVE_LOW>;
 		};
 	};
diff --git a/arch/arm/boot/dts/bcm2835-rpi-zero-w.dts b/arch/arm/boot/dts/bcm2835-rpi-zero-w.dts
index f65448c01e31..33b2b77aa47d 100644
--- a/arch/arm/boot/dts/bcm2835-rpi-zero-w.dts
+++ b/arch/arm/boot/dts/bcm2835-rpi-zero-w.dts
@@ -23,7 +23,7 @@ chosen {
 	};
 
 	leds {
-		act {
+		led-act {
 			gpios = <&gpio 47 GPIO_ACTIVE_LOW>;
 		};
 	};
diff --git a/arch/arm/boot/dts/bcm2835-rpi-zero.dts b/arch/arm/boot/dts/bcm2835-rpi-zero.dts
index 6dd93c6f4966..6f9b3a908f28 100644
--- a/arch/arm/boot/dts/bcm2835-rpi-zero.dts
+++ b/arch/arm/boot/dts/bcm2835-rpi-zero.dts
@@ -18,7 +18,7 @@ memory@0 {
 	};
 
 	leds {
-		act {
+		led-act {
 			gpios = <&gpio 47 GPIO_ACTIVE_HIGH>;
 		};
 	};
diff --git a/arch/arm/boot/dts/bcm2835-rpi.dtsi b/arch/arm/boot/dts/bcm2835-rpi.dtsi
index d94357b21f7e..87ddcad76083 100644
--- a/arch/arm/boot/dts/bcm2835-rpi.dtsi
+++ b/arch/arm/boot/dts/bcm2835-rpi.dtsi
@@ -4,7 +4,7 @@ / {
 	leds {
 		compatible = "gpio-leds";
 
-		act {
+		led-act {
 			label = "ACT";
 			default-state = "keep";
 			linux,default-trigger = "heartbeat";
diff --git a/arch/arm/boot/dts/bcm2836-rpi-2-b.dts b/arch/arm/boot/dts/bcm2836-rpi-2-b.dts
index 0455a680394a..d8af8eeac7b6 100644
--- a/arch/arm/boot/dts/bcm2836-rpi-2-b.dts
+++ b/arch/arm/boot/dts/bcm2836-rpi-2-b.dts
@@ -15,11 +15,11 @@ memory@0 {
 	};
 
 	leds {
-		act {
+		led-act {
 			gpios = <&gpio 47 GPIO_ACTIVE_HIGH>;
 		};
 
-		pwr {
+		led-pwr {
 			label = "PWR";
 			gpios = <&gpio 35 GPIO_ACTIVE_HIGH>;
 			default-state = "keep";
diff --git a/arch/arm/boot/dts/bcm2837-rpi-3-a-plus.dts b/arch/arm/boot/dts/bcm2837-rpi-3-a-plus.dts
index 28be0332c1c8..77099a7871b0 100644
--- a/arch/arm/boot/dts/bcm2837-rpi-3-a-plus.dts
+++ b/arch/arm/boot/dts/bcm2837-rpi-3-a-plus.dts
@@ -19,11 +19,11 @@ memory@0 {
 	};
 
 	leds {
-		act {
+		led-act {
 			gpios = <&gpio 29 GPIO_ACTIVE_HIGH>;
 		};
 
-		pwr {
+		led-pwr {
 			label = "PWR";
 			gpios = <&expgpio 2 GPIO_ACTIVE_LOW>;
 			default-state = "keep";
diff --git a/arch/arm/boot/dts/bcm2837-rpi-3-b-plus.dts b/arch/arm/boot/dts/bcm2837-rpi-3-b-plus.dts
index 37343148643d..61010266ca9a 100644
--- a/arch/arm/boot/dts/bcm2837-rpi-3-b-plus.dts
+++ b/arch/arm/boot/dts/bcm2837-rpi-3-b-plus.dts
@@ -20,11 +20,11 @@ memory@0 {
 	};
 
 	leds {
-		act {
+		led-act {
 			gpios = <&gpio 29 GPIO_ACTIVE_HIGH>;
 		};
 
-		pwr {
+		led-pwr {
 			label = "PWR";
 			gpios = <&expgpio 2 GPIO_ACTIVE_LOW>;
 			default-state = "keep";
diff --git a/arch/arm/boot/dts/bcm2837-rpi-3-b.dts b/arch/arm/boot/dts/bcm2837-rpi-3-b.dts
index 054ecaa355c9..dd4a48604097 100644
--- a/arch/arm/boot/dts/bcm2837-rpi-3-b.dts
+++ b/arch/arm/boot/dts/bcm2837-rpi-3-b.dts
@@ -20,7 +20,7 @@ memory@0 {
 	};
 
 	leds {
-		act {
+		led-act {
 			gpios = <&expgpio 2 GPIO_ACTIVE_HIGH>;
 		};
 	};
diff --git a/arch/arm/boot/dts/bcm2837-rpi-cm3.dtsi b/arch/arm/boot/dts/bcm2837-rpi-cm3.dtsi
index 925cb37c22f0..828a20561b96 100644
--- a/arch/arm/boot/dts/bcm2837-rpi-cm3.dtsi
+++ b/arch/arm/boot/dts/bcm2837-rpi-cm3.dtsi
@@ -14,7 +14,7 @@ leds {
 		 * Since there is no upstream GPIO driver yet,
 		 * remove the incomplete node.
 		 */
-		/delete-node/ act;
+		/delete-node/ led-act;
 	};
 
 	reg_3v3: fixed-regulator {
-- 
2.30.2

