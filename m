Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 167E110163C
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731758AbfKSFvX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:51:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:48800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731777AbfKSFvW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:51:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F589208C3;
        Tue, 19 Nov 2019 05:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142682;
        bh=faCWoOYAfIbvkx3JZpbhyswh7/Ci/iA7KBk4Qo6abWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RpLdfsOaHhjBngJ90w5RAlNiQZkYaYHBe+2vQwgWDU+gz9nbmY2EP+mJxWZkHkyVW
         jIYZ/jzTWIxo60XA9FvusOZoY5DN2UNoTOgD1zXSYz8H+hpTReTqlfsmmeCOnifENE
         twFmTAodOZk8oZgjYpcWZw46toiHoV3xKAZWZyJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 163/239] ARM: dts: ste: Fix SPI controller node names
Date:   Tue, 19 Nov 2019 06:19:23 +0100
Message-Id: <20191119051333.501044561@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



