Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 279DB148A0C
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 15:41:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390700AbgAXOS3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 09:18:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:37816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390657AbgAXOS3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 09:18:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 434C62087E;
        Fri, 24 Jan 2020 14:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875508;
        bh=HLGLxSrsXy20mO7PpmbyNdO1rFVVjTyzEN2g0d2ZYoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OpcpCvFmciq7INya800Y+JT9ucmfoZcvUyT362+B+TcwA+gwnlVFyIHV0ytdBZqpU
         V09mvoXnkidSXeHti9tRKAle0OgZqvIWRON0ykwkCigJJ2j4s0OZzZKhwnEn/IF9JV
         tvzPRik9UOkPrnyw6QfyVrH7O+cSsHW7oexgThp0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 009/107] ARM: dts: am57xx-beagle-x15/am57xx-idk: Remove "gpios" for  endpoint dt nodes
Date:   Fri, 24 Jan 2020 09:16:39 -0500
Message-Id: <20200124141817.28793-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124141817.28793-1-sashal@kernel.org>
References: <20200124141817.28793-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kishon Vijay Abraham I <kishon@ti.com>

[ Upstream commit 81cc0877840f72210e809bbedd6346d686560fc1 ]

PERST# line in the PCIE connector is driven by the host mode and not
EP mode. The gpios property here is used for driving the PERST# line.
Remove gpios property from all endpoint device tree nodes.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/am571x-idk.dts                | 4 ----
 arch/arm/boot/dts/am572x-idk-common.dtsi        | 4 ----
 arch/arm/boot/dts/am57xx-beagle-x15-common.dtsi | 4 ----
 3 files changed, 12 deletions(-)

diff --git a/arch/arm/boot/dts/am571x-idk.dts b/arch/arm/boot/dts/am571x-idk.dts
index 0aaacea1d887b..975a6b1d3fc80 100644
--- a/arch/arm/boot/dts/am571x-idk.dts
+++ b/arch/arm/boot/dts/am571x-idk.dts
@@ -170,10 +170,6 @@
 	gpios = <&gpio3 23 GPIO_ACTIVE_HIGH>;
 };
 
-&pcie1_ep {
-	gpios = <&gpio3 23 GPIO_ACTIVE_HIGH>;
-};
-
 &mmc1 {
 	pinctrl-names = "default", "hs";
 	pinctrl-0 = <&mmc1_pins_default_no_clk_pu>;
diff --git a/arch/arm/boot/dts/am572x-idk-common.dtsi b/arch/arm/boot/dts/am572x-idk-common.dtsi
index a064f13b38802..ddf123620e962 100644
--- a/arch/arm/boot/dts/am572x-idk-common.dtsi
+++ b/arch/arm/boot/dts/am572x-idk-common.dtsi
@@ -147,10 +147,6 @@
 	gpios = <&gpio3 23 GPIO_ACTIVE_HIGH>;
 };
 
-&pcie1_ep {
-	gpios = <&gpio3 23 GPIO_ACTIVE_HIGH>;
-};
-
 &mailbox5 {
 	status = "okay";
 	mbox_ipu1_ipc3x: mbox_ipu1_ipc3x {
diff --git a/arch/arm/boot/dts/am57xx-beagle-x15-common.dtsi b/arch/arm/boot/dts/am57xx-beagle-x15-common.dtsi
index bc76f1705c0f6..9a94c96b0350e 100644
--- a/arch/arm/boot/dts/am57xx-beagle-x15-common.dtsi
+++ b/arch/arm/boot/dts/am57xx-beagle-x15-common.dtsi
@@ -547,10 +547,6 @@
 	gpios = <&gpio2 8 GPIO_ACTIVE_LOW>;
 };
 
-&pcie1_ep {
-	gpios = <&gpio2 8 GPIO_ACTIVE_LOW>;
-};
-
 &mcasp3 {
 	#sound-dai-cells = <0>;
 	assigned-clocks = <&l4per2_clkctrl DRA7_L4PER2_MCASP3_CLKCTRL 24>;
-- 
2.20.1

