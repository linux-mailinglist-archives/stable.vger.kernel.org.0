Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C48783C9050
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241323AbhGNTyS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:54:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241113AbhGNTuY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:50:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55AA5613D3;
        Wed, 14 Jul 2021 19:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626292012;
        bh=OK8bWUprBv6Z3OB1VmNxruIQpI3AHXCnbnXL+M4sLsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e1M/XCQwrTljc5MCRs5xJf+jHsTGC4fcSdeahEax+IBj2crsF3MuTilPReh+lBo3o
         aG5Q0FS2zrW4UF0v/+nNf5/hACJ+Ku3V5wuypDnPCAZLt7OPt4TYFuN3M4ty6wOP8e
         GtwT0gekj/fL3PirOWFf61VMIEKJfvi9dLkny39exXqY1N0w4AFYJN2bzcxWm2OwDB
         kF4dekbTd4MYqJfJdgaTCqrSOkTlnqUfjXbT2fjV3spHo4j9FrNFVCdrPZitQ2obkP
         h1r8d7uuBbFPGXkMKV6+AvZEcIuA2YEPZIhFbbswbJCewqF42UsTHVsBrcEo7b6MT6
         sbhquNAQozrKA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 19/39] ARM: dts: am335x: align GPIO hog names with dt-schema
Date:   Wed, 14 Jul 2021 15:46:04 -0400
Message-Id: <20210714194625.55303-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194625.55303-1-sashal@kernel.org>
References: <20210714194625.55303-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit fb97f63106f3174992a22fe5e42dda96a0810750 ]

The GPIO Hog dt-schema node naming convention expect GPIO hogs node names
to end with a 'hog' suffix.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/am335x-boneblack-wireless.dts | 2 +-
 arch/arm/boot/dts/am335x-boneblue.dts           | 2 +-
 arch/arm/boot/dts/am335x-bonegreen-wireless.dts | 4 ++--
 arch/arm/boot/dts/am335x-icev2.dts              | 4 ++--
 arch/arm/boot/dts/am335x-shc.dts                | 8 ++++----
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm/boot/dts/am335x-boneblack-wireless.dts b/arch/arm/boot/dts/am335x-boneblack-wireless.dts
index 83f49f616b19..d8a712938a70 100644
--- a/arch/arm/boot/dts/am335x-boneblack-wireless.dts
+++ b/arch/arm/boot/dts/am335x-boneblack-wireless.dts
@@ -105,7 +105,7 @@ bluetooth {
 };
 
 &gpio3 {
-	ls_buf_en {
+	ls-buf-en-hog {
 		gpio-hog;
 		gpios = <10 GPIO_ACTIVE_HIGH>;
 		output-high;
diff --git a/arch/arm/boot/dts/am335x-boneblue.dts b/arch/arm/boot/dts/am335x-boneblue.dts
index 7bcd72691f06..f71dac2b72d9 100644
--- a/arch/arm/boot/dts/am335x-boneblue.dts
+++ b/arch/arm/boot/dts/am335x-boneblue.dts
@@ -526,7 +526,7 @@ &dcan1 {
 };
 
 &gpio3 {
-	ls_buf_en {
+	ls-buf-en-hog {
 		gpio-hog;
 		gpios = <10 GPIO_ACTIVE_HIGH>;
 		output-high;
diff --git a/arch/arm/boot/dts/am335x-bonegreen-wireless.dts b/arch/arm/boot/dts/am335x-bonegreen-wireless.dts
index 57731f0daf10..04c52194fa91 100644
--- a/arch/arm/boot/dts/am335x-bonegreen-wireless.dts
+++ b/arch/arm/boot/dts/am335x-bonegreen-wireless.dts
@@ -105,7 +105,7 @@ bluetooth {
 };
 
 &gpio1 {
-	ls_buf_en {
+	ls-buf-en-hog {
 		gpio-hog;
 		gpios = <29 GPIO_ACTIVE_HIGH>;
 		output-high;
@@ -122,7 +122,7 @@ ls_buf_en {
 /* an external pulldown on U21 pin 4.                                  */
 
 &gpio3 {
-	bt_aud_in {
+	bt-aud-in-hog {
 		gpio-hog;
 		gpios = <16 GPIO_ACTIVE_HIGH>;
 		output-low;
diff --git a/arch/arm/boot/dts/am335x-icev2.dts b/arch/arm/boot/dts/am335x-icev2.dts
index f2005ecca74f..be81b98da71e 100644
--- a/arch/arm/boot/dts/am335x-icev2.dts
+++ b/arch/arm/boot/dts/am335x-icev2.dts
@@ -448,14 +448,14 @@ &uart3 {
 };
 
 &gpio3 {
-	p4 {
+	pr1-mii-ctl-hog {
 		gpio-hog;
 		gpios = <4 GPIO_ACTIVE_HIGH>;
 		output-high;
 		line-name = "PR1_MII_CTRL";
 	};
 
-	p10 {
+	mux-mii-hog {
 		gpio-hog;
 		gpios = <10 GPIO_ACTIVE_HIGH>;
 		/* ETH1 mux: Low for MII-PRU, high for RMII-CPSW */
diff --git a/arch/arm/boot/dts/am335x-shc.dts b/arch/arm/boot/dts/am335x-shc.dts
index 4f6a286ea293..961a422256cf 100644
--- a/arch/arm/boot/dts/am335x-shc.dts
+++ b/arch/arm/boot/dts/am335x-shc.dts
@@ -146,14 +146,14 @@ ehrpwm1: pwm@48302200 {
 };
 
 &gpio1 {
-	hmtc_rst {
+	hmtc-rst-hog {
 		gpio-hog;
 		gpios = <24 GPIO_ACTIVE_LOW>;
 		output-high;
 		line-name = "homematic_reset";
 	};
 
-	hmtc_prog {
+	hmtc-prog-hog {
 		gpio-hog;
 		gpios = <27 GPIO_ACTIVE_LOW>;
 		output-high;
@@ -162,14 +162,14 @@ hmtc_prog {
 };
 
 &gpio3 {
-	zgb_rst {
+	zgb-rst-hog {
 		gpio-hog;
 		gpios = <18 GPIO_ACTIVE_LOW>;
 		output-low;
 		line-name = "zigbee_reset";
 	};
 
-	zgb_boot {
+	zgb-boot-hog {
 		gpio-hog;
 		gpios = <19 GPIO_ACTIVE_HIGH>;
 		output-high;
-- 
2.30.2

