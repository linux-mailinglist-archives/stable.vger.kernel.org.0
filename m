Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF803C507C
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244048AbhGLHdK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:33:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:49814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347044AbhGLHba (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:31:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4886C60230;
        Mon, 12 Jul 2021 07:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074921;
        bh=LE0ggWALqFHZTFF2fwQS3K77C4N1qrd6O5zo/TNfuH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S/42YymwPqdscJgaUk+uLQGRWOG45nXCsdIZUDdE39ADf3U8hJhxarQ38CVuTxmS2
         xCL0fPrplQgWYCio7gVAezadvUln784BPpiqAJIJBLsMXonytRnzxMzN2eYIgro2eV
         A2JNzJt+lXRjX7DlYx+37J/4uV0K+vUwknaOdLY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH 5.13 044/800] ARM: dts: ux500: Fix LED probing
Date:   Mon, 12 Jul 2021 08:01:07 +0200
Message-Id: <20210712060919.565657039@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

commit 7749510c459c10c431d746a4749e7c9cf2899156 upstream.

The Ux500 HREF LEDs have not been probing properly for a
while as this was introduce:

     ret = of_property_read_u32(np, "color", &led_color);
     if (ret)
             return ret;

Since the device tree did not define the new invented color
attribute, probe was failing.

Define color attributes for the LEDs so they work again.

Link: https://lore.kernel.org/r/20210613123356.880933-1-linus.walleij@linaro.org
Fixes: 92a81562e695 ("leds: lp55xx: Add multicolor framework support to lp55xx")
Cc: stable@vger.kernel.org
Cc: Dan Murphy <dmurphy@ti.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/ste-href.dtsi |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/arm/boot/dts/ste-href.dtsi
+++ b/arch/arm/boot/dts/ste-href.dtsi
@@ -4,6 +4,7 @@
  */
 
 #include <dt-bindings/interrupt-controller/irq.h>
+#include <dt-bindings/leds/common.h>
 #include "ste-href-family-pinctrl.dtsi"
 
 / {
@@ -64,17 +65,20 @@
 					reg = <0>;
 					led-cur = /bits/ 8 <0x2f>;
 					max-cur = /bits/ 8 <0x5f>;
+					color = <LED_COLOR_ID_BLUE>;
 					linux,default-trigger = "heartbeat";
 				};
 				chan@1 {
 					reg = <1>;
 					led-cur = /bits/ 8 <0x2f>;
 					max-cur = /bits/ 8 <0x5f>;
+					color = <LED_COLOR_ID_BLUE>;
 				};
 				chan@2 {
 					reg = <2>;
 					led-cur = /bits/ 8 <0x2f>;
 					max-cur = /bits/ 8 <0x5f>;
+					color = <LED_COLOR_ID_BLUE>;
 				};
 			};
 			lp5521@34 {
@@ -88,16 +92,19 @@
 					reg = <0>;
 					led-cur = /bits/ 8 <0x2f>;
 					max-cur = /bits/ 8 <0x5f>;
+					color = <LED_COLOR_ID_BLUE>;
 				};
 				chan@1 {
 					reg = <1>;
 					led-cur = /bits/ 8 <0x2f>;
 					max-cur = /bits/ 8 <0x5f>;
+					color = <LED_COLOR_ID_BLUE>;
 				};
 				chan@2 {
 					reg = <2>;
 					led-cur = /bits/ 8 <0x2f>;
 					max-cur = /bits/ 8 <0x5f>;
+					color = <LED_COLOR_ID_BLUE>;
 				};
 			};
 			bh1780@29 {


