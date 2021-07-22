Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3FE3D2865
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232915AbhGVP47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:56:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:33080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232621AbhGVP4w (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:56:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A65F360FDA;
        Thu, 22 Jul 2021 16:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971846;
        bh=Yv+PaLvFPVUFr/rbwxnIrm8wqywelCaulAh4i7taKss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eQ/91cbEsD0ZyvkEb/ywyAiHQgoXSClZ2tdUW//YsCrVjwR09ZG7oTag23MLlHiyh
         MWkiqfeQxjKZbaw6EHRqUpfd4Ll14Q5KA8uMcuP3Ru7EA/lFxynv8bysKQWeoop2ja
         FwfngfIQ62GqcARgL+C3C8G+Flhwm/I/NRVCUBNM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Wahren <stefan.wahren@i2se.com>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 050/125] ARM: dts: bcm283x: Fix up GPIO LED node names
Date:   Thu, 22 Jul 2021 18:30:41 +0200
Message-Id: <20210722155626.378703123@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -28,11 +28,11 @@
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
@@ -14,11 +14,11 @@
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
@@ -14,7 +14,7 @@
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
@@ -15,11 +15,11 @@
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
@@ -15,7 +15,7 @@
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
@@ -15,7 +15,7 @@
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
@@ -23,7 +23,7 @@
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
@@ -18,7 +18,7 @@
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
@@ -4,7 +4,7 @@
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
@@ -15,11 +15,11 @@
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
@@ -19,11 +19,11 @@
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
@@ -20,11 +20,11 @@
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
@@ -20,7 +20,7 @@
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
@@ -14,7 +14,7 @@
 		 * Since there is no upstream GPIO driver yet,
 		 * remove the incomplete node.
 		 */
-		/delete-node/ act;
+		/delete-node/ led-act;
 	};
 
 	reg_3v3: fixed-regulator {
-- 
2.30.2



