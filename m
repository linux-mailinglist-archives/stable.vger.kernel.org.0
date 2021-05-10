Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ADDE3783E0
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231797AbhEJKrz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:47:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:59674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233341AbhEJKpj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:45:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1E4D61929;
        Mon, 10 May 2021 10:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642968;
        bh=L3gxnrR/qpr8HoeAqCEQcL9VfvyQy5lGhB/iMYR/Vqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BOLxT9ehyoM5NvSHK1EwJT/YISTMsZ3dBarfS7suUHyeuz32KZSw5ifL/q2IdPgH4
         b5CIKS/bAMhgujUrGFzjX0F2Bx4ZZW2Cex8qY88n+Kg5oVcuD9eWt/bgqKrqsDk1p1
         IEIwnr+2QhrNkrIhveWhzaznUWyTDWR3QJm468EQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 089/299] ARM: dts: at91: change the key code of the gpio key
Date:   Mon, 10 May 2021 12:18:06 +0200
Message-Id: <20210510102007.890786972@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ludovic Desroches <ludovic.desroches@microchip.com>

[ Upstream commit ca7a049ad1a72ec5f03d1330b53575237fcb727c ]

Having a button code and not a key code causes issues with libinput.
udev won't set ID_INPUT_KEY. If it is forced, then it causes a bug
within libinput.

Signed-off-by: Ludovic Desroches <ludovic.desroches@microchip.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20210402130227.21478-1-nicolas.ferre@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/at91-sam9x60ek.dts          | 3 ++-
 arch/arm/boot/dts/at91-sama5d27_som1_ek.dts   | 3 ++-
 arch/arm/boot/dts/at91-sama5d27_wlsom1_ek.dts | 3 ++-
 arch/arm/boot/dts/at91-sama5d2_icp.dts        | 3 ++-
 arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts     | 3 ++-
 arch/arm/boot/dts/at91-sama5d2_xplained.dts   | 3 ++-
 arch/arm/boot/dts/at91-sama5d3_xplained.dts   | 3 ++-
 arch/arm/boot/dts/at91sam9260ek.dts           | 3 ++-
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi   | 3 ++-
 9 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/arch/arm/boot/dts/at91-sam9x60ek.dts b/arch/arm/boot/dts/at91-sam9x60ek.dts
index 775ceb3acb6c..edca66c232c1 100644
--- a/arch/arm/boot/dts/at91-sam9x60ek.dts
+++ b/arch/arm/boot/dts/at91-sam9x60ek.dts
@@ -8,6 +8,7 @@
  */
 /dts-v1/;
 #include "sam9x60.dtsi"
+#include <dt-bindings/input/input.h>
 
 / {
 	model = "Microchip SAM9X60-EK";
@@ -84,7 +85,7 @@
 		sw1 {
 			label = "SW1";
 			gpios = <&pioD 18 GPIO_ACTIVE_LOW>;
-			linux,code=<0x104>;
+			linux,code=<KEY_PROG1>;
 			wakeup-source;
 		};
 	};
diff --git a/arch/arm/boot/dts/at91-sama5d27_som1_ek.dts b/arch/arm/boot/dts/at91-sama5d27_som1_ek.dts
index 0e159f879c15..d3cd2443ba25 100644
--- a/arch/arm/boot/dts/at91-sama5d27_som1_ek.dts
+++ b/arch/arm/boot/dts/at91-sama5d27_som1_ek.dts
@@ -11,6 +11,7 @@
 #include "at91-sama5d27_som1.dtsi"
 #include <dt-bindings/mfd/atmel-flexcom.h>
 #include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/input/input.h>
 
 / {
 	model = "Atmel SAMA5D27 SOM1 EK";
@@ -467,7 +468,7 @@
 		pb4 {
 			label = "USER";
 			gpios = <&pioA PIN_PA29 GPIO_ACTIVE_LOW>;
-			linux,code = <0x104>;
+			linux,code = <KEY_PROG1>;
 			wakeup-source;
 		};
 	};
diff --git a/arch/arm/boot/dts/at91-sama5d27_wlsom1_ek.dts b/arch/arm/boot/dts/at91-sama5d27_wlsom1_ek.dts
index 6b38fa3f5568..4883b84b4ede 100644
--- a/arch/arm/boot/dts/at91-sama5d27_wlsom1_ek.dts
+++ b/arch/arm/boot/dts/at91-sama5d27_wlsom1_ek.dts
@@ -8,6 +8,7 @@
  */
 /dts-v1/;
 #include "at91-sama5d27_wlsom1.dtsi"
+#include <dt-bindings/input/input.h>
 
 / {
 	model = "Microchip SAMA5D27 WLSOM1 EK";
@@ -35,7 +36,7 @@
 		sw4 {
 			label = "USER BUTTON";
 			gpios = <&pioA PIN_PB2 GPIO_ACTIVE_LOW>;
-			linux,code = <0x104>;
+			linux,code = <KEY_PROG1>;
 			wakeup-source;
 		};
 	};
diff --git a/arch/arm/boot/dts/at91-sama5d2_icp.dts b/arch/arm/boot/dts/at91-sama5d2_icp.dts
index 6783cf16ff81..19bb50f50c1f 100644
--- a/arch/arm/boot/dts/at91-sama5d2_icp.dts
+++ b/arch/arm/boot/dts/at91-sama5d2_icp.dts
@@ -12,6 +12,7 @@
 #include "sama5d2.dtsi"
 #include "sama5d2-pinfunc.h"
 #include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/input/input.h>
 #include <dt-bindings/mfd/atmel-flexcom.h>
 
 / {
@@ -51,7 +52,7 @@
 		sw4 {
 			label = "USER_PB1";
 			gpios = <&pioA PIN_PD0 GPIO_ACTIVE_LOW>;
-			linux,code = <0x104>;
+			linux,code = <KEY_PROG1>;
 			wakeup-source;
 		};
 	};
diff --git a/arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts b/arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts
index c894c7c788a9..1c6361ba1aca 100644
--- a/arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts
+++ b/arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts
@@ -11,6 +11,7 @@
 #include "sama5d2-pinfunc.h"
 #include <dt-bindings/mfd/atmel-flexcom.h>
 #include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/input/input.h>
 #include <dt-bindings/pinctrl/at91.h>
 
 / {
@@ -403,7 +404,7 @@
 		bp1 {
 			label = "PB_USER";
 			gpios = <&pioA PIN_PA10 GPIO_ACTIVE_LOW>;
-			linux,code = <0x104>;
+			linux,code = <KEY_PROG1>;
 			wakeup-source;
 		};
 	};
diff --git a/arch/arm/boot/dts/at91-sama5d2_xplained.dts b/arch/arm/boot/dts/at91-sama5d2_xplained.dts
index 058fae1b4a76..d767968ae217 100644
--- a/arch/arm/boot/dts/at91-sama5d2_xplained.dts
+++ b/arch/arm/boot/dts/at91-sama5d2_xplained.dts
@@ -10,6 +10,7 @@
 #include "sama5d2-pinfunc.h"
 #include <dt-bindings/mfd/atmel-flexcom.h>
 #include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/input/input.h>
 #include <dt-bindings/regulator/active-semi,8945a-regulator.h>
 
 / {
@@ -713,7 +714,7 @@
 		bp1 {
 			label = "PB_USER";
 			gpios = <&pioA PIN_PB9 GPIO_ACTIVE_LOW>;
-			linux,code = <0x104>;
+			linux,code = <KEY_PROG1>;
 			wakeup-source;
 		};
 	};
diff --git a/arch/arm/boot/dts/at91-sama5d3_xplained.dts b/arch/arm/boot/dts/at91-sama5d3_xplained.dts
index 5179258f9247..9c55a921263b 100644
--- a/arch/arm/boot/dts/at91-sama5d3_xplained.dts
+++ b/arch/arm/boot/dts/at91-sama5d3_xplained.dts
@@ -7,6 +7,7 @@
  */
 /dts-v1/;
 #include "sama5d36.dtsi"
+#include <dt-bindings/input/input.h>
 
 / {
 	model = "SAMA5D3 Xplained";
@@ -354,7 +355,7 @@
 		bp3 {
 			label = "PB_USER";
 			gpios = <&pioE 29 GPIO_ACTIVE_LOW>;
-			linux,code = <0x104>;
+			linux,code = <KEY_PROG1>;
 			wakeup-source;
 		};
 	};
diff --git a/arch/arm/boot/dts/at91sam9260ek.dts b/arch/arm/boot/dts/at91sam9260ek.dts
index d3446e42b598..ce96345d28a3 100644
--- a/arch/arm/boot/dts/at91sam9260ek.dts
+++ b/arch/arm/boot/dts/at91sam9260ek.dts
@@ -7,6 +7,7 @@
  */
 /dts-v1/;
 #include "at91sam9260.dtsi"
+#include <dt-bindings/input/input.h>
 
 / {
 	model = "Atmel at91sam9260ek";
@@ -156,7 +157,7 @@
 		btn4 {
 			label = "Button 4";
 			gpios = <&pioA 31 GPIO_ACTIVE_LOW>;
-			linux,code = <0x104>;
+			linux,code = <KEY_PROG1>;
 			wakeup-source;
 		};
 	};
diff --git a/arch/arm/boot/dts/at91sam9g20ek_common.dtsi b/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
index 6e6e672c0b86..87bb39060e8b 100644
--- a/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
+++ b/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
@@ -5,6 +5,7 @@
  * Copyright (C) 2012 Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
  */
 #include "at91sam9g20.dtsi"
+#include <dt-bindings/input/input.h>
 
 / {
 
@@ -234,7 +235,7 @@
 		btn4 {
 			label = "Button 4";
 			gpios = <&pioA 31 GPIO_ACTIVE_LOW>;
-			linux,code = <0x104>;
+			linux,code = <KEY_PROG1>;
 			wakeup-source;
 		};
 	};
-- 
2.30.2



