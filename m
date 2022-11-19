Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E313630932
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 03:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbiKSCMK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 21:12:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232034AbiKSCLz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 21:11:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED763C6C1;
        Fri, 18 Nov 2022 18:11:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63FEAB82679;
        Sat, 19 Nov 2022 02:11:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4DBAC433D6;
        Sat, 19 Nov 2022 02:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668823898;
        bh=fgVj5nOWOnl47lIW/xWgrRwA6PJNr5fnn5l5d58KssQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IP/8xAdk+ZHc9Vvj7TCUBda8D1DKiv7HsRchOxxIgr21TkljX9ENajvFISAJ6Ka80
         hhOjZZyhBXzApMSo0/pdGf9IbK5+VYN5uKHyKZ6X9VmaDzszbDTrhccbHRyCWpwsKX
         LL0JsurLMoFDjM9xWYfjQ05xnZT0xdUmrDCzurD7vNfu+enm5eyP4r3pifradpUSCf
         QzS8OtKyxu3bJ7aJCvz7xXunXlyys2ZReDkU8wlzhQsl91iw10V4WHG5C+/1b8iX4R
         rLxN4sUXjKbBLCuNzytHO2TIRSHrgJD5G0MtbR0qG3xMKqUA0parwtm0HOYKWTq/+a
         /CmhT+rjDMNBw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Emil Renner Berthing <emil.renner.berthing@canonical.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, palmer@dabbelt.com,
        paul.walmsley@sifive.com, aou@eecs.berkeley.edu,
        bin.meng@windriver.com, devicetree@vger.kernel.org,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 6.0 05/44] riscv: dts: sifive unleashed: Add PWM controlled LEDs
Date:   Fri, 18 Nov 2022 21:10:45 -0500
Message-Id: <20221119021124.1773699-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221119021124.1773699-1-sashal@kernel.org>
References: <20221119021124.1773699-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Emil Renner Berthing <emil.renner.berthing@canonical.com>

[ Upstream commit 8bc8824d30193eb7755043d5bb65fa7f0d11a595 ]

This adds the 4 PWM controlled green LEDs to the HiFive Unleashed device
tree. The schematic doesn't specify any special function for the LEDs,
so they're added here without any default triggers and named d1, d2, d3
and d4 just like in the schematic.

Signed-off-by: Emil Renner Berthing <emil.renner.berthing@canonical.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Tested-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20221012110928.352910-1-emil.renner.berthing@canonical.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/sifive/hifive-unleashed-a00.dts  | 38 +++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts b/arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts
index ced0d4e47938..900a50526d77 100644
--- a/arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts
+++ b/arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts
@@ -3,6 +3,8 @@
 
 #include "fu540-c000.dtsi"
 #include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/leds/common.h>
+#include <dt-bindings/pwm/pwm.h>
 
 /* Clock frequency (in Hz) of the PCB crystal for rtcclk */
 #define RTCCLK_FREQ		1000000
@@ -42,6 +44,42 @@ gpio-restart {
 		compatible = "gpio-restart";
 		gpios = <&gpio 10 GPIO_ACTIVE_LOW>;
 	};
+
+	led-controller {
+		compatible = "pwm-leds";
+
+		led-d1 {
+			pwms = <&pwm0 0 7812500 PWM_POLARITY_INVERTED>;
+			active-low;
+			color = <LED_COLOR_ID_GREEN>;
+			max-brightness = <255>;
+			label = "d1";
+		};
+
+		led-d2 {
+			pwms = <&pwm0 1 7812500 PWM_POLARITY_INVERTED>;
+			active-low;
+			color = <LED_COLOR_ID_GREEN>;
+			max-brightness = <255>;
+			label = "d2";
+		};
+
+		led-d3 {
+			pwms = <&pwm0 2 7812500 PWM_POLARITY_INVERTED>;
+			active-low;
+			color = <LED_COLOR_ID_GREEN>;
+			max-brightness = <255>;
+			label = "d3";
+		};
+
+		led-d4 {
+			pwms = <&pwm0 3 7812500 PWM_POLARITY_INVERTED>;
+			active-low;
+			color = <LED_COLOR_ID_GREEN>;
+			max-brightness = <255>;
+			label = "d4";
+		};
+	};
 };
 
 &uart0 {
-- 
2.35.1

