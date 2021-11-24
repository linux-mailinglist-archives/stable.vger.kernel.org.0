Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A19545C3FF
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348488AbhKXNpF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:45:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:37488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353673AbhKXNnv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:43:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83BA861205;
        Wed, 24 Nov 2021 12:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758758;
        bh=5NHhnPFnmRP7rOjBJUnuC1YemOngahBxhPc6e+iD/xQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2KTb4Vgw4S6z8cvkaV+NnsThnT86pUbxkInh0Ae1HgTBNidKo00vNNuA8O1z5NhVr
         T5+2Qok/Pz4P1rSEJjJqVwsOVUeULvANFFVebFoB4R7VqxaRi6PH6S+soZ6kxkJ8Xq
         ByzRn88MWsVImr+/5f0dedGPOCbRlQdULxhKEfbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 008/279] ARM: dts: BCM5301X: Fix nodes names
Date:   Wed, 24 Nov 2021 12:54:55 +0100
Message-Id: <20211124115719.048663504@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



