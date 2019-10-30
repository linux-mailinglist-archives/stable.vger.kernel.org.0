Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F38FEE9FDD
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 16:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727852AbfJ3Pvu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:51:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:52662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726825AbfJ3Pvu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:51:50 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 281732087E;
        Wed, 30 Oct 2019 15:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450709;
        bh=FRfSfBQVULDXdAO520uMvwwd2i4lO+PEwK/kcFWv+wc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=igYx6m1ZQIwgqvcfQ9Qs08RHRrJgWVx0FnJR0UlBAtlOO5esViczuXZpNcc089zRK
         oJJFXF2/3l+u2pihhlRFh7V5RxRXvC2+utkwpAacIzndTOxfe1m/3wZEUyDxrMCi8p
         FlsB1n0zSjdsoVmt8CytrhTYVLWohzyrQqTAU4dY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Graeme Smecher <gsmecher@threespeedlogic.com>,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 30/81] ARM: dts: am3874-iceboard: Fix 'i2c-mux-idle-disconnect' usage
Date:   Wed, 30 Oct 2019 11:48:36 -0400
Message-Id: <20191030154928.9432-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030154928.9432-1-sashal@kernel.org>
References: <20191030154928.9432-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Smirnov <andrew.smirnov@gmail.com>

[ Upstream commit 647c8977e111c0a62c93a489ebc4b045c833fdb4 ]

According to
Documentation/devicetree/bindings/i2c/i2c-mux-pca954x.txt,
i2c-mux-idle-disconnect is a property of a parent node since it
pertains to the mux/switch as a whole, so move it there and drop all
of the concurrences in child nodes.

Fixes: d031773169df ("ARM: dts: Adds device tree file for McGill's IceBoard, based on TI AM3874")
Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Benoît Cousson <bcousson@baylibre.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Graeme Smecher <gsmecher@threespeedlogic.com>
Cc: linux-omap@vger.kernel.org
Cc: devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Tested-by: Graeme Smecher <gsmecher@threespeedlogic.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/am3874-iceboard.dts | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/am3874-iceboard.dts b/arch/arm/boot/dts/am3874-iceboard.dts
index 883fb85135d46..1b4b2b0500e4c 100644
--- a/arch/arm/boot/dts/am3874-iceboard.dts
+++ b/arch/arm/boot/dts/am3874-iceboard.dts
@@ -111,13 +111,13 @@
 		reg = <0x70>;
 		#address-cells = <1>;
 		#size-cells = <0>;
+		i2c-mux-idle-disconnect;
 
 		i2c@0 {
 			/* FMC A */
 			#address-cells = <1>;
 			#size-cells = <0>;
 			reg = <0>;
-			i2c-mux-idle-disconnect;
 		};
 
 		i2c@1 {
@@ -125,7 +125,6 @@
 			#address-cells = <1>;
 			#size-cells = <0>;
 			reg = <1>;
-			i2c-mux-idle-disconnect;
 		};
 
 		i2c@2 {
@@ -133,7 +132,6 @@
 			#address-cells = <1>;
 			#size-cells = <0>;
 			reg = <2>;
-			i2c-mux-idle-disconnect;
 		};
 
 		i2c@3 {
@@ -141,7 +139,6 @@
 			#address-cells = <1>;
 			#size-cells = <0>;
 			reg = <3>;
-			i2c-mux-idle-disconnect;
 		};
 
 		i2c@4 {
@@ -149,14 +146,12 @@
 			#address-cells = <1>;
 			#size-cells = <0>;
 			reg = <4>;
-			i2c-mux-idle-disconnect;
 		};
 
 		i2c@5 {
 			#address-cells = <1>;
 			#size-cells = <0>;
 			reg = <5>;
-			i2c-mux-idle-disconnect;
 
 			ina230@40 { compatible = "ti,ina230"; reg = <0x40>; shunt-resistor = <5000>; };
 			ina230@41 { compatible = "ti,ina230"; reg = <0x41>; shunt-resistor = <5000>; };
@@ -182,14 +177,12 @@
 			#address-cells = <1>;
 			#size-cells = <0>;
 			reg = <6>;
-			i2c-mux-idle-disconnect;
 		};
 
 		i2c@7 {
 			#address-cells = <1>;
 			#size-cells = <0>;
 			reg = <7>;
-			i2c-mux-idle-disconnect;
 
 			u41: pca9575@20 {
 				compatible = "nxp,pca9575";
-- 
2.20.1

