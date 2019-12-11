Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D07311B53E
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731675AbfLKPUV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:20:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:49556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731267AbfLKPUU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:20:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A5872465B;
        Wed, 11 Dec 2019 15:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077620;
        bh=68xZ3u58C8jS9MejQCAJ5ABHymWTJHDY7QMDuXRC7OE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l7ek/10HFtqyECaztHRJWSMkOsljw/F6m44uJ3YUKjQlq8Yf9VjXA1vqYZDXX+Bam
         6TWDiXE3AsJarRNjV6pKTKmy3rnR4sAOC02IAjJRjC46FCgvlKVXbpvMALF86Zd4/p
         UfnneAC5G9V1XjBSOHRRlUxDzyokiOSPBe+3bsUc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Otavio Salvador <otavio@ossystems.com.br>,
        Fabio Berton <fabio.berton@ossystems.com.br>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 106/243] ARM: dts: rockchip: Assign the proper GPIO clocks for rv1108
Date:   Wed, 11 Dec 2019 16:04:28 +0100
Message-Id: <20191211150346.285142276@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Otavio Salvador <otavio@ossystems.com.br>

[ Upstream commit efc2e0bd9594060915696a418564aefd0270b1d6 ]

It is not correct to assign the 24MHz clock oscillator to the GPIO
ports.

Fix it by assigning the proper GPIO clocks instead.

Signed-off-by: Otavio Salvador <otavio@ossystems.com.br>
Tested-by: Fabio Berton <fabio.berton@ossystems.com.br>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rv1108.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/rv1108.dtsi b/arch/arm/boot/dts/rv1108.dtsi
index 4090ad2619ffb..a9f053dfdc068 100644
--- a/arch/arm/boot/dts/rv1108.dtsi
+++ b/arch/arm/boot/dts/rv1108.dtsi
@@ -541,7 +541,7 @@
 			compatible = "rockchip,gpio-bank";
 			reg = <0x20030000 0x100>;
 			interrupts = <GIC_SPI 40 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&xin24m>;
+			clocks = <&cru PCLK_GPIO0_PMU>;
 
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -554,7 +554,7 @@
 			compatible = "rockchip,gpio-bank";
 			reg = <0x10310000 0x100>;
 			interrupts = <GIC_SPI 41 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&xin24m>;
+			clocks = <&cru PCLK_GPIO1>;
 
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -567,7 +567,7 @@
 			compatible = "rockchip,gpio-bank";
 			reg = <0x10320000 0x100>;
 			interrupts = <GIC_SPI 42 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&xin24m>;
+			clocks = <&cru PCLK_GPIO2>;
 
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -580,7 +580,7 @@
 			compatible = "rockchip,gpio-bank";
 			reg = <0x10330000 0x100>;
 			interrupts = <GIC_SPI 43 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&xin24m>;
+			clocks = <&cru PCLK_GPIO3>;
 
 			gpio-controller;
 			#gpio-cells = <2>;
-- 
2.20.1



