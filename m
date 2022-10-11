Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1DF75FB61F
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 17:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbiJKPAq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 11:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231455AbiJKO7U (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:59:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E583AA02DF;
        Tue, 11 Oct 2022 07:54:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBDEFB8162D;
        Tue, 11 Oct 2022 14:53:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C55C433D7;
        Tue, 11 Oct 2022 14:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665500036;
        bh=2GAUjPFyV4IlrTA3QhSUljwJ8vfaEsuco81VWHGTfIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IIkmWHuyZMrB8J1sMPLWr/TYhWaD8xeeIalFm5tOjWYwOjLQPYXpASB3kPwpXJ4dn
         +Qfs4phkh0uvZ7hUimGtB5wQvkutrV+jUTqpaDl4pSQ+McrbIpr0SExTZGyOxnguO/
         Q4UhroGAXN9fmZBEpXaG8e2HfxxTABNRqrKSzw9IlO6HD23eUK9MahPUoGHDX8XlVM
         jOT2KHdaUuUZntYE8rXLwmCTQyjftcA142Rr4EYwZKB4ROCiVf+sa3PNHGWFJu3I51
         9KMUyFWv70BVgqGFU4K5jVM04S0IkDUWoDgvx3FjOWtDycjfqrF6+THjrsAFl6zJOg
         vLLLrxuKqhUHQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 12/13] arm64: dts: uniphier: Add USB-device support for PXs3 reference board
Date:   Tue, 11 Oct 2022 10:53:37 -0400
Message-Id: <20221011145338.1624591-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145338.1624591-1-sashal@kernel.org>
References: <20221011145338.1624591-1-sashal@kernel.org>
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

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

[ Upstream commit 19fee1a1096d21ab1f1e712148b5417bda2939a2 ]

PXs3 reference board can change each USB port 0 and 1 to device mode
with jumpers. Prepare devicetree sources for USB port 0 and 1.

This specifies dr_mode, pinctrl, and some quirks and removes nodes for
unused phys and vbus-supply properties.

Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Link: https://lore.kernel.org/r/20220913042321.4817-8-hayashi.kunihiko@socionext.com'
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/uniphier-pinctrl.dtsi       | 10 +++++
 arch/arm64/boot/dts/socionext/Makefile        |  4 +-
 .../socionext/uniphier-pxs3-ref-gadget0.dts   | 41 +++++++++++++++++++
 .../socionext/uniphier-pxs3-ref-gadget1.dts   | 40 ++++++++++++++++++
 4 files changed, 94 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget0.dts
 create mode 100644 arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget1.dts

diff --git a/arch/arm/boot/dts/uniphier-pinctrl.dtsi b/arch/arm/boot/dts/uniphier-pinctrl.dtsi
index 1fee5ffbfb9c..2c1e0a6b0b6a 100644
--- a/arch/arm/boot/dts/uniphier-pinctrl.dtsi
+++ b/arch/arm/boot/dts/uniphier-pinctrl.dtsi
@@ -181,11 +181,21 @@ pinctrl_usb0: usb0 {
 		function = "usb0";
 	};
 
+	pinctrl_usb0_device: usb0-device {
+		groups = "usb0_device";
+		function = "usb0";
+	};
+
 	pinctrl_usb1: usb1 {
 		groups = "usb1";
 		function = "usb1";
 	};
 
+	pinctrl_usb1_device: usb1-device {
+		groups = "usb1_device";
+		function = "usb1";
+	};
+
 	pinctrl_usb2: usb2 {
 		groups = "usb2";
 		function = "usb2";
diff --git a/arch/arm64/boot/dts/socionext/Makefile b/arch/arm64/boot/dts/socionext/Makefile
index d45441249cb5..c922d9303b69 100644
--- a/arch/arm64/boot/dts/socionext/Makefile
+++ b/arch/arm64/boot/dts/socionext/Makefile
@@ -4,4 +4,6 @@ dtb-$(CONFIG_ARCH_UNIPHIER) += \
 	uniphier-ld11-ref.dtb \
 	uniphier-ld20-global.dtb \
 	uniphier-ld20-ref.dtb \
-	uniphier-pxs3-ref.dtb
+	uniphier-pxs3-ref.dtb \
+	uniphier-pxs3-ref-gadget0.dtb \
+	uniphier-pxs3-ref-gadget1.dtb
diff --git a/arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget0.dts b/arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget0.dts
new file mode 100644
index 000000000000..7069f51bc120
--- /dev/null
+++ b/arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget0.dts
@@ -0,0 +1,41 @@
+// SPDX-License-Identifier: GPL-2.0-or-later OR MIT
+//
+// Device Tree Source for UniPhier PXs3 Reference Board (for USB-Device #0)
+//
+// Copyright (C) 2021 Socionext Inc.
+//   Author: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
+
+/dts-v1/;
+#include "uniphier-pxs3-ref.dts"
+
+/ {
+	model = "UniPhier PXs3 Reference Board (USB-Device #0)";
+};
+
+/* I2C3 pinctrl is shared with USB*VBUSIN */
+&i2c3 {
+	status = "disabled";
+};
+
+&usb0 {
+	status = "okay";
+	dr_mode = "peripheral";
+	pinctrl-0 = <&pinctrl_usb0_device>;
+	snps,dis_enblslpm_quirk;
+	snps,dis_u2_susphy_quirk;
+	snps,dis_u3_susphy_quirk;
+	snps,usb2_gadget_lpm_disable;
+	phy-names = "usb2-phy", "usb3-phy";
+	phys = <&usb0_hsphy0>, <&usb0_ssphy0>;
+};
+
+&usb0_hsphy0 {
+	/delete-property/ vbus-supply;
+};
+
+&usb0_ssphy0 {
+	/delete-property/ vbus-supply;
+};
+
+/delete-node/ &usb0_hsphy1;
+/delete-node/ &usb0_ssphy1;
diff --git a/arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget1.dts b/arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget1.dts
new file mode 100644
index 000000000000..a3cfa8113ffb
--- /dev/null
+++ b/arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget1.dts
@@ -0,0 +1,40 @@
+// SPDX-License-Identifier: GPL-2.0-or-later OR MIT
+//
+// Device Tree Source for UniPhier PXs3 Reference Board (for USB-Device #1)
+//
+// Copyright (C) 2021 Socionext Inc.
+//   Author: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
+
+/dts-v1/;
+#include "uniphier-pxs3-ref.dts"
+
+/ {
+	model = "UniPhier PXs3 Reference Board (USB-Device #1)";
+};
+
+/* I2C3 pinctrl is shared with USB*VBUSIN */
+&i2c3 {
+	status = "disabled";
+};
+
+&usb1 {
+	status = "okay";
+	dr_mode = "peripheral";
+	pinctrl-0 = <&pinctrl_usb1_device>;
+	snps,dis_enblslpm_quirk;
+	snps,dis_u2_susphy_quirk;
+	snps,dis_u3_susphy_quirk;
+	snps,usb2_gadget_lpm_disable;
+	phy-names = "usb2-phy", "usb3-phy";
+	phys = <&usb1_hsphy0>, <&usb1_ssphy0>;
+};
+
+&usb1_hsphy0 {
+	/delete-property/ vbus-supply;
+};
+
+&usb1_ssphy0 {
+	/delete-property/ vbus-supply;
+};
+
+/delete-node/ &usb1_hsphy1;
-- 
2.35.1

