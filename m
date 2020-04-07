Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB2C51A02E8
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 02:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727666AbgDGAB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Apr 2020 20:01:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:35662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727635AbgDGAB4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Apr 2020 20:01:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA4DA20842;
        Tue,  7 Apr 2020 00:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586217715;
        bh=pPQAnpLJ6swHilZZiXwdXrhXTemHxz69XOukH7cla4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PVUNp2ASOJKjj9mc7IOVx+44rWDUsXxTcVZvT2RlwLc6Zku/yJsiLJHz5gMaXbkuV
         vVWlcefeRbCfpWbT33wYkMjhj9Sqt3Q90mVOIATtBRHaI2YKE2ubUTQ6OXNKwceunq
         R5HnPnFuaYuKFKlQsbp3kD5YUgPh1SRfUGcCowVY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>, Sasha Levin <sashal@kernel.org>,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 03/32] ARM: dts: Fix dm814x Ethernet by changing to use rgmii-id mode
Date:   Mon,  6 Apr 2020 20:01:21 -0400
Message-Id: <20200407000151.16768-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200407000151.16768-1-sashal@kernel.org>
References: <20200407000151.16768-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit b46b2b7ba6e104d265ab705914859ec0db7a98c5 ]

Commit cd28d1d6e52e ("net: phy: at803x: Disable phy delay for RGMII mode")
caused a regression for dm814x boards where NFSroot would no longer work.

Let's fix the issue by configuring "rgmii-id" mode as internal delays are
needed that is no longer the case with "rgmii" mode.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/dm8148-evm.dts       | 4 ++--
 arch/arm/boot/dts/dm8148-t410.dts      | 4 ++--
 arch/arm/boot/dts/dra62x-j5eco-evm.dts | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/dm8148-evm.dts b/arch/arm/boot/dts/dm8148-evm.dts
index 3931fb068ff09..91d1018ab75fc 100644
--- a/arch/arm/boot/dts/dm8148-evm.dts
+++ b/arch/arm/boot/dts/dm8148-evm.dts
@@ -24,12 +24,12 @@
 
 &cpsw_emac0 {
 	phy-handle = <&ethphy0>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 };
 
 &cpsw_emac1 {
 	phy-handle = <&ethphy1>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 };
 
 &davinci_mdio {
diff --git a/arch/arm/boot/dts/dm8148-t410.dts b/arch/arm/boot/dts/dm8148-t410.dts
index 9e43d5ec0bb2f..79ccdd4470f4c 100644
--- a/arch/arm/boot/dts/dm8148-t410.dts
+++ b/arch/arm/boot/dts/dm8148-t410.dts
@@ -33,12 +33,12 @@
 
 &cpsw_emac0 {
 	phy-handle = <&ethphy0>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 };
 
 &cpsw_emac1 {
 	phy-handle = <&ethphy1>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 };
 
 &davinci_mdio {
diff --git a/arch/arm/boot/dts/dra62x-j5eco-evm.dts b/arch/arm/boot/dts/dra62x-j5eco-evm.dts
index 861ab90a3f3aa..c16e183822bee 100644
--- a/arch/arm/boot/dts/dra62x-j5eco-evm.dts
+++ b/arch/arm/boot/dts/dra62x-j5eco-evm.dts
@@ -24,12 +24,12 @@
 
 &cpsw_emac0 {
 	phy-handle = <&ethphy0>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 };
 
 &cpsw_emac1 {
 	phy-handle = <&ethphy1>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 };
 
 &davinci_mdio {
-- 
2.20.1

