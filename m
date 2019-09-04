Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12639A89F1
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731709AbfIDP6B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 11:58:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:59772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731699AbfIDP6A (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 11:58:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F35D22DBF;
        Wed,  4 Sep 2019 15:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612679;
        bh=98bX0MPt6vFtYJpPxfdI5sUpNttahp3t6HhrK1Ib86Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zcDGPzAXAbghf7gjiecwoHrFOKkKFTDiLwXDzeNmHYtlNaLuCIwExXdtx8TlQq08w
         B/6CKoyldbNAZlPjZzT9xAXoHrmT4sgxwlBvGQTzAT6z70V6LWcxyHgiicLHZHHxZP
         7x1GJ6wur2dl1lfspEDNNrr168Fc/tU+2f8AzAVk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Emmanuel Vadot <manu@freebsd.org>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 12/94] ARM: dts: am335x: Fix UARTs length
Date:   Wed,  4 Sep 2019 11:56:17 -0400
Message-Id: <20190904155739.2816-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904155739.2816-1-sashal@kernel.org>
References: <20190904155739.2816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Emmanuel Vadot <manu@freebsd.org>

[ Upstream commit 8613e2ca4fff764f23785eadfa54a08631ee682a ]

As seen on the AM335x TRM all the UARTs controller only are 0x1000 in size.
Fix this in the DTS.

Signed-off-by: Emmanuel Vadot <manu@freebsd.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/am33xx-l4.dtsi | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/am33xx-l4.dtsi b/arch/arm/boot/dts/am33xx-l4.dtsi
index 4bd22c1edf963..46849d6ecb3e2 100644
--- a/arch/arm/boot/dts/am33xx-l4.dtsi
+++ b/arch/arm/boot/dts/am33xx-l4.dtsi
@@ -185,7 +185,7 @@
 			uart0: serial@0 {
 				compatible = "ti,am3352-uart", "ti,omap3-uart";
 				clock-frequency = <48000000>;
-				reg = <0x0 0x2000>;
+				reg = <0x0 0x1000>;
 				interrupts = <72>;
 				status = "disabled";
 				dmas = <&edma 26 0>, <&edma 27 0>;
@@ -934,7 +934,7 @@
 			uart1: serial@0 {
 				compatible = "ti,am3352-uart", "ti,omap3-uart";
 				clock-frequency = <48000000>;
-				reg = <0x0 0x2000>;
+				reg = <0x0 0x1000>;
 				interrupts = <73>;
 				status = "disabled";
 				dmas = <&edma 28 0>, <&edma 29 0>;
@@ -966,7 +966,7 @@
 			uart2: serial@0 {
 				compatible = "ti,am3352-uart", "ti,omap3-uart";
 				clock-frequency = <48000000>;
-				reg = <0x0 0x2000>;
+				reg = <0x0 0x1000>;
 				interrupts = <74>;
 				status = "disabled";
 				dmas = <&edma 30 0>, <&edma 31 0>;
@@ -1614,7 +1614,7 @@
 			uart3: serial@0 {
 				compatible = "ti,am3352-uart", "ti,omap3-uart";
 				clock-frequency = <48000000>;
-				reg = <0x0 0x2000>;
+				reg = <0x0 0x1000>;
 				interrupts = <44>;
 				status = "disabled";
 			};
@@ -1644,7 +1644,7 @@
 			uart4: serial@0 {
 				compatible = "ti,am3352-uart", "ti,omap3-uart";
 				clock-frequency = <48000000>;
-				reg = <0x0 0x2000>;
+				reg = <0x0 0x1000>;
 				interrupts = <45>;
 				status = "disabled";
 			};
@@ -1674,7 +1674,7 @@
 			uart5: serial@0 {
 				compatible = "ti,am3352-uart", "ti,omap3-uart";
 				clock-frequency = <48000000>;
-				reg = <0x0 0x2000>;
+				reg = <0x0 0x1000>;
 				interrupts = <46>;
 				status = "disabled";
 			};
-- 
2.20.1

