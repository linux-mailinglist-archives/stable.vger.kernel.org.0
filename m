Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0F1F6519
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728181AbfKJDEb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 22:04:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:51106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729169AbfKJCqs (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:46:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 684F321D7B;
        Sun, 10 Nov 2019 02:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354008;
        bh=faCWoOYAfIbvkx3JZpbhyswh7/Ci/iA7KBk4Qo6abWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l/GCH/BGQdcR25LI9fzc3AM4+J6LIpWWhlzuXTnfDK04+FtRETUhmPSRboV6mORAd
         2PPG2m9vDpi9av0PCT9a49sRzsSCDHrHnuYo6/MZFVQMOXfGm7rZNJWv3SEiTwThYh
         ZIrodIgt6kzEQ/8qUeVDyAMC0Ne5YHzDshLMt03E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rob Herring <robh@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 034/109] ARM: dts: ste: Fix SPI controller node names
Date:   Sat,  9 Nov 2019 21:44:26 -0500
Message-Id: <20191110024541.31567-34-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024541.31567-1-sashal@kernel.org>
References: <20191110024541.31567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

[ Upstream commit 2f967f9e9fa076affb711da1a8389b5d33814fc6 ]

SPI controller nodes should be named 'spi' rather than 'ssp'. Fixing the
name enables dtc SPI bus checks.

Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ste-dbx5x0.dtsi     | 4 ++--
 arch/arm/boot/dts/ste-hrefprev60.dtsi | 2 +-
 arch/arm/boot/dts/ste-snowball.dts    | 2 +-
 arch/arm/boot/dts/ste-u300.dts        | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/ste-dbx5x0.dtsi b/arch/arm/boot/dts/ste-dbx5x0.dtsi
index 3dc0028e108b3..986767735e249 100644
--- a/arch/arm/boot/dts/ste-dbx5x0.dtsi
+++ b/arch/arm/boot/dts/ste-dbx5x0.dtsi
@@ -878,7 +878,7 @@
 			power-domains = <&pm_domains DOMAIN_VAPE>;
 		};
 
-		ssp@80002000 {
+		spi@80002000 {
 			compatible = "arm,pl022", "arm,primecell";
 			reg = <0x80002000 0x1000>;
 			interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
@@ -892,7 +892,7 @@
 			power-domains = <&pm_domains DOMAIN_VAPE>;
 		};
 
-		ssp@80003000 {
+		spi@80003000 {
 			compatible = "arm,pl022", "arm,primecell";
 			reg = <0x80003000 0x1000>;
 			interrupts = <GIC_SPI 52 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/arch/arm/boot/dts/ste-hrefprev60.dtsi b/arch/arm/boot/dts/ste-hrefprev60.dtsi
index 3f14b4df69b4e..94eeb7f1c9478 100644
--- a/arch/arm/boot/dts/ste-hrefprev60.dtsi
+++ b/arch/arm/boot/dts/ste-hrefprev60.dtsi
@@ -57,7 +57,7 @@
 			};
 		};
 
-		ssp@80002000 {
+		spi@80002000 {
 			/*
 			 * On the first generation boards, this SSP/SPI port was connected
 			 * to the AB8500.
diff --git a/arch/arm/boot/dts/ste-snowball.dts b/arch/arm/boot/dts/ste-snowball.dts
index ade1d0d4e5f45..1bf4358f8fa71 100644
--- a/arch/arm/boot/dts/ste-snowball.dts
+++ b/arch/arm/boot/dts/ste-snowball.dts
@@ -376,7 +376,7 @@
 			pinctrl-1 = <&i2c3_sleep_mode>;
 		};
 
-		ssp@80002000 {
+		spi@80002000 {
 			pinctrl-names = "default";
 			pinctrl-0 = <&ssp0_snowball_mode>;
 		};
diff --git a/arch/arm/boot/dts/ste-u300.dts b/arch/arm/boot/dts/ste-u300.dts
index 62ecb6a2fa39e..1bd1aba3322f1 100644
--- a/arch/arm/boot/dts/ste-u300.dts
+++ b/arch/arm/boot/dts/ste-u300.dts
@@ -442,7 +442,7 @@
 			dma-names = "rx";
 		};
 
-		spi: ssp@c0006000 {
+		spi: spi@c0006000 {
 			compatible = "arm,pl022", "arm,primecell";
 			reg = <0xc0006000 0x1000>;
 			interrupt-parent = <&vica>;
-- 
2.20.1

