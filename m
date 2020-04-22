Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74D1D1B3FDB
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731642AbgDVKl0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:41:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730076AbgDVKUP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:20:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D28C20775;
        Wed, 22 Apr 2020 10:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550815;
        bh=rIGziLLxe2ceDpbJPs9IiUJwzSZStLtOnXCL8JvRm3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WQh15wk2p532a+cVSJadETed3exGsXo4Igderg2uVSORokG0G1RLDrUi5VdO/0qel
         xyYbC476ynv19TUWWkLB7hHKFVUBvohZ4tgAIFqbjQ0E/l4hrYloATBGrpaAGgxtxj
         vVnA/Mzyah2uKN3Air77CoMUsyw0wGyFd35KHO1s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@siol.net>,
        Chen-Yu Tsai <wens@csie.org>
Subject: [PATCH 5.4 104/118] ARM: dts: sunxi: Fix DE2 clocks register range
Date:   Wed, 22 Apr 2020 11:57:45 +0200
Message-Id: <20200422095048.243999707@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095031.522502705@linuxfoundation.org>
References: <20200422095031.522502705@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jernej Skrabec <jernej.skrabec@siol.net>

commit da180322582bd9db07f29e6d4a2d170afde0703f upstream.

As it can be seen from DE2 manual, clock range is 0x10000.

Fix it.

Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
Fixes: 73f122c82775 ("ARM: dts: sun8i: a83t: Add display pipeline")
Fixes: 05a43a262d03 ("ARM: dts: sun8i: r40: Add HDMI pipeline")
Fixes: 21b299209330 ("ARM: sun8i: v3s: add device nodes for DE2 display pipeline")
Fixes: d8c6f1f0295c ("ARM: sun8i: h3/h5: add DE2 CCU device node for H3")
[wens@csie.org: added fixes tags]
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/sun8i-a83t.dtsi  |    2 +-
 arch/arm/boot/dts/sun8i-r40.dtsi   |    2 +-
 arch/arm/boot/dts/sun8i-v3s.dtsi   |    2 +-
 arch/arm/boot/dts/sunxi-h3-h5.dtsi |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm/boot/dts/sun8i-a83t.dtsi
+++ b/arch/arm/boot/dts/sun8i-a83t.dtsi
@@ -313,7 +313,7 @@
 
 		display_clocks: clock@1000000 {
 			compatible = "allwinner,sun8i-a83t-de2-clk";
-			reg = <0x01000000 0x100000>;
+			reg = <0x01000000 0x10000>;
 			clocks = <&ccu CLK_BUS_DE>,
 				 <&ccu CLK_PLL_DE>;
 			clock-names = "bus",
--- a/arch/arm/boot/dts/sun8i-r40.dtsi
+++ b/arch/arm/boot/dts/sun8i-r40.dtsi
@@ -118,7 +118,7 @@
 		display_clocks: clock@1000000 {
 			compatible = "allwinner,sun8i-r40-de2-clk",
 				     "allwinner,sun8i-h3-de2-clk";
-			reg = <0x01000000 0x100000>;
+			reg = <0x01000000 0x10000>;
 			clocks = <&ccu CLK_BUS_DE>,
 				 <&ccu CLK_DE>;
 			clock-names = "bus",
--- a/arch/arm/boot/dts/sun8i-v3s.dtsi
+++ b/arch/arm/boot/dts/sun8i-v3s.dtsi
@@ -105,7 +105,7 @@
 
 		display_clocks: clock@1000000 {
 			compatible = "allwinner,sun8i-v3s-de2-clk";
-			reg = <0x01000000 0x100000>;
+			reg = <0x01000000 0x10000>;
 			clocks = <&ccu CLK_BUS_DE>,
 				 <&ccu CLK_DE>;
 			clock-names = "bus",
--- a/arch/arm/boot/dts/sunxi-h3-h5.dtsi
+++ b/arch/arm/boot/dts/sunxi-h3-h5.dtsi
@@ -113,7 +113,7 @@
 
 		display_clocks: clock@1000000 {
 			/* compatible is in per SoC .dtsi file */
-			reg = <0x01000000 0x100000>;
+			reg = <0x01000000 0x10000>;
 			clocks = <&ccu CLK_BUS_DE>,
 				 <&ccu CLK_DE>;
 			clock-names = "bus",


