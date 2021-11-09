Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD74F44B555
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245535AbhKIWU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:20:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:40218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245415AbhKIWTw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:19:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C82D61279;
        Tue,  9 Nov 2021 22:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496225;
        bh=5NHhnPFnmRP7rOjBJUnuC1YemOngahBxhPc6e+iD/xQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WigRR0h/DT43pn+u5C1U4h9RbZyMt2sL9/t6fDLA+z5irRQo8kstOe3xmawIBFclS
         B+4DNgj3N2/kWvhFhGcSwY5kWQT3rbMbIi///51Mj4I4P/346BIMAQmFBUW18DPapc
         ay3cPn/1C99SPCeupRVqhVZoFaqQPMbefyQ9PTRp3tJZucFHuCFbEBXVY3/stn8G1Z
         OoHd/UjXdxLm2FUj+IeheD69YdXtgjm1HlFhLvawUe5j1VSoTgTWaD3DXeI9hirSVf
         LixTkBwic8SSaL2TUikqvUk6T08pPkGfX+He3lydmzc7gymqCZ2GzTKGHqt5X7cSro
         v4FWS82qyxcpg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>, hauke@hauke-m.de,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 08/82] ARM: dts: BCM5301X: Fix nodes names
Date:   Tue,  9 Nov 2021 17:15:26 -0500
Message-Id: <20211109221641.1233217-8-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221641.1233217-1-sashal@kernel.org>
References: <20211109221641.1233217-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 9dba049b6d32e95c0dd2a0d607f593ea288ac140 ]

This fixes following errors for all BCM5301X dts files:
chipcommonA@18000000: $nodename:0: 'chipcommonA@18000000' does not match '^([a-z][a-z0-9\\-]+-bus|bus|soc|axi|ahb|apb)(@[0-9a-f]+)?$'
mpcore@19000000: $nodename:0: 'mpcore@19000000' does not match '^([a-z][a-z0-9\\-]+-bus|bus|soc|axi|ahb|apb)(@[0-9a-f]+)?$'
mdio-bus-mux@18003000: $nodename:0: 'mdio-bus-mux@18003000' does not match '^mdio-mux[\\-@]?'
dmu@1800c000: $nodename:0: 'dmu@1800c000' does not match '^([a-z][a-z0-9\\-]+-bus|bus|soc|axi|ahb|apb)(@[0-9a-f]+)?$'

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm47094-linksys-panamera.dts | 2 +-
 arch/arm/boot/dts/bcm5301x.dtsi                 | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/bcm47094-linksys-panamera.dts b/arch/arm/boot/dts/bcm47094-linksys-panamera.dts
index 05d4f2931772b..9bef6b9bfa8d9 100644
--- a/arch/arm/boot/dts/bcm47094-linksys-panamera.dts
+++ b/arch/arm/boot/dts/bcm47094-linksys-panamera.dts
@@ -129,7 +129,7 @@
 		};
 	};
 
-	mdio-bus-mux@18003000 {
+	mdio-mux@18003000 {
 
 		/* BIT(9) = 1 => external mdio */
 		mdio@200 {
diff --git a/arch/arm/boot/dts/bcm5301x.dtsi b/arch/arm/boot/dts/bcm5301x.dtsi
index f92089290ccd5..f9d3a53065ef7 100644
--- a/arch/arm/boot/dts/bcm5301x.dtsi
+++ b/arch/arm/boot/dts/bcm5301x.dtsi
@@ -19,7 +19,7 @@
 	#size-cells = <1>;
 	interrupt-parent = <&gic>;
 
-	chipcommonA@18000000 {
+	chipcommon-a-bus@18000000 {
 		compatible = "simple-bus";
 		ranges = <0x00000000 0x18000000 0x00001000>;
 		#address-cells = <1>;
@@ -44,7 +44,7 @@
 		};
 	};
 
-	mpcore@19000000 {
+	mpcore-bus@19000000 {
 		compatible = "simple-bus";
 		ranges = <0x00000000 0x19000000 0x00023000>;
 		#address-cells = <1>;
@@ -369,7 +369,7 @@
 		#address-cells = <1>;
 	};
 
-	mdio-bus-mux@18003000 {
+	mdio-mux@18003000 {
 		compatible = "mdio-mux-mmioreg";
 		mdio-parent-bus = <&mdio>;
 		#address-cells = <1>;
@@ -415,7 +415,7 @@
 		status = "disabled";
 	};
 
-	dmu@1800c000 {
+	dmu-bus@1800c000 {
 		compatible = "simple-bus";
 		ranges = <0 0x1800c000 0x1000>;
 		#address-cells = <1>;
-- 
2.33.0

