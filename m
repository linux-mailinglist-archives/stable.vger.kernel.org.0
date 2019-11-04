Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 041FEEED93
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389388AbfKDWIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:08:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:40740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390170AbfKDWIB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:08:01 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42363205C9;
        Mon,  4 Nov 2019 22:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905280;
        bh=GzKKrQi05r8rJU/BL3AzUsyM+vQgG8U/4raDE/E8vNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f40hKZ/XS6KUHWu8YDZtBFdBT8Z/absn8wrvTZttKkTYOpBFOG86j1wrbGsHrIG44
         fpxKkAq8j5FUC4YE6GUwLdic3okzcrxmYlbzpWhDauXw3u3xZeNq72YJDqg8OUYJZ/
         PQVuZN1OZeVyE3+I0nnIl9eNpqZCZxnwBMPd+9Yw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 089/163] arm64: dts: qcom: Add Asus NovaGo TP370QL
Date:   Mon,  4 Nov 2019 22:44:39 +0100
Message-Id: <20191104212146.656585449@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>

[ Upstream commit 722eb2f65acc4cebeb710fc7cc98f51513e90f1f ]

This adds the initial DT for the Asus NovaGo TP370QL laptop.  Supported
functionality includes USB (host), microSD-card, keyboard, and trackpad.

Signed-off-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/Makefile             |  1 +
 .../dts/qcom/msm8998-asus-novago-tp370ql.dts  | 47 +++++++++++++++++++
 2 files changed, 48 insertions(+)
 create mode 100644 arch/arm64/boot/dts/qcom/msm8998-asus-novago-tp370ql.dts

diff --git a/arch/arm64/boot/dts/qcom/Makefile b/arch/arm64/boot/dts/qcom/Makefile
index 28695e7c0cc3d..954d75de617ba 100644
--- a/arch/arm64/boot/dts/qcom/Makefile
+++ b/arch/arm64/boot/dts/qcom/Makefile
@@ -6,6 +6,7 @@ dtb-$(CONFIG_ARCH_QCOM)	+= msm8916-mtp.dtb
 dtb-$(CONFIG_ARCH_QCOM)	+= msm8992-bullhead-rev-101.dtb
 dtb-$(CONFIG_ARCH_QCOM)	+= msm8994-angler-rev-101.dtb
 dtb-$(CONFIG_ARCH_QCOM)	+= msm8996-mtp.dtb
+dtb-$(CONFIG_ARCH_QCOM)	+= msm8998-asus-novago-tp370ql.dtb
 dtb-$(CONFIG_ARCH_QCOM)	+= msm8998-hp-envy-x2.dtb
 dtb-$(CONFIG_ARCH_QCOM)	+= msm8998-lenovo-miix-630.dtb
 dtb-$(CONFIG_ARCH_QCOM)	+= msm8998-mtp.dtb
diff --git a/arch/arm64/boot/dts/qcom/msm8998-asus-novago-tp370ql.dts b/arch/arm64/boot/dts/qcom/msm8998-asus-novago-tp370ql.dts
new file mode 100644
index 0000000000000..db5821be1e2fe
--- /dev/null
+++ b/arch/arm64/boot/dts/qcom/msm8998-asus-novago-tp370ql.dts
@@ -0,0 +1,47 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019, Jeffrey Hugo. All rights reserved. */
+
+/dts-v1/;
+
+#include "msm8998-clamshell.dtsi"
+
+/ {
+	model = "Asus NovaGo TP370QL";
+	compatible = "asus,novago-tp370ql", "qcom,msm8998";
+};
+
+&blsp1_i2c6 {
+	status = "okay";
+
+	touchpad@15 {
+		compatible = "hid-over-i2c";
+		interrupt-parent = <&tlmm>;
+		interrupts = <0x7b IRQ_TYPE_LEVEL_LOW>;
+		reg = <0x15>;
+		hid-descr-addr = <0x0001>;
+
+		pinctrl-names = "default";
+		pinctrl-0 = <&touchpad>;
+	};
+
+	keyboard@3a {
+		compatible = "hid-over-i2c";
+		interrupt-parent = <&tlmm>;
+		interrupts = <0x25 IRQ_TYPE_LEVEL_LOW>;
+		reg = <0x3a>;
+		hid-descr-addr = <0x0001>;
+	};
+};
+
+&sdhc2 {
+	cd-gpios = <&tlmm 95 GPIO_ACTIVE_HIGH>;
+};
+
+&tlmm {
+	touchpad: touchpad {
+		config {
+			pins = "gpio123";
+			bias-pull-up;
+		};
+	};
+};
-- 
2.20.1



