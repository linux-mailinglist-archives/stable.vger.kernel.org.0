Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F21A85FB61D
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 17:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbiJKPAp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 11:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231449AbiJKO7T (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:59:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D913D9E698;
        Tue, 11 Oct 2022 07:53:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68040611C0;
        Tue, 11 Oct 2022 14:53:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB38BC433D6;
        Tue, 11 Oct 2022 14:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665500016;
        bh=/vjPFn6aiS8PXqIl4mDIzUxIFIt0BU90h2SuA14McLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jL2xpnhC6eopGuwZAZmjSm+v67MN1LmjVGE2/lmJ+CBrIHt/8RubjjBuOLb4DmLTQ
         d9JBpj5Q2Ezo+6BlKHc7V6viyxQZ3EzVzWEAzpA0+oczoR70Iwb0GSjvRw0DctWIsT
         WwgI1AmY2xpoRcfyqsEdWaeFZJS/mS5NDk0qxV9CA0y2RE2gCr2s7n56SlOrDEcH67
         BIH5SzuYO4adhwX4hTpGtE9gkR56T4RJmB6mjjegWW5BTnZMsEpA0GbhcHDARlkFt0
         JIlFWnqZHwLSm6uUope+IYE/baJHMTUG04wb1ETQC93+u30/mnkei5A5HQGrZjR3Aj
         RRN5zqHuVHUMQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 16/17] arm64: dts: uniphier: Add USB-device support for PXs3 reference board
Date:   Tue, 11 Oct 2022 10:53:11 -0400
Message-Id: <20221011145312.1624341-16-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145312.1624341-1-sashal@kernel.org>
References: <20221011145312.1624341-1-sashal@kernel.org>
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
index c0fd029b37e5..f909ec2e5333 100644
--- a/arch/arm/boot/dts/uniphier-pinctrl.dtsi
+++ b/arch/arm/boot/dts/uniphier-pinctrl.dtsi
@@ -196,11 +196,21 @@ pinctrl_usb0: usb0 {
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
index dda3da33614b..33989a9643ac 100644
--- a/arch/arm64/boot/dts/socionext/Makefile
+++ b/arch/arm64/boot/dts/socionext/Makefile
@@ -5,4 +5,6 @@ dtb-$(CONFIG_ARCH_UNIPHIER) += \
 	uniphier-ld20-akebi96.dtb \
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

