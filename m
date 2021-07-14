Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84D7E3C8E2E
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236258AbhGNTqp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:46:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:38756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236513AbhGNTo4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:44:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3110613E9;
        Wed, 14 Jul 2021 19:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291692;
        bh=JvSXnC2gAX+lzZsmF2MthPE7lxewKYt2nWZkSbN4Gb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=liVaxu98taT2mFYonUtdzQLESgGysm8E9cSuzGomVcvbpUIENL7QaTz6UkHqOF+Ui
         8PASD++/MjTEOu22eE+kM0Sza4UFnEs0Ixw0dlfQRStO7rrpM+xESaOU4e6A4yrAQ7
         rYrprsD0EaoOU5F0IrwyPMQdn8yZ3VXCOI4gU/5NhjhdXFgZQQdrpJ+tb8Wro0UKPd
         9YDFxHwIbKzJSon4LNT8TyiwfztANTAFj/pCvaqTp7GxJMoxPEinxRDpVttD4gJl+o
         i0505DmUJ4MK7jHt+70cXVgANYqJp41VvTnwp5hZRv3it+lR9Z8E4+Cz/4fNJskSs7
         FnPxQ9bSkNruA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 040/102] ARM: dts: am335x: align GPIO hog names with dt-schema
Date:   Wed, 14 Jul 2021 15:39:33 -0400
Message-Id: <20210714194036.53141-40-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194036.53141-1-sashal@kernel.org>
References: <20210714194036.53141-1-sashal@kernel.org>
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
index 86cad9912906..80116646a3fe 100644
--- a/arch/arm/boot/dts/am335x-boneblack-wireless.dts
+++ b/arch/arm/boot/dts/am335x-boneblack-wireless.dts
@@ -101,7 +101,7 @@ bluetooth {
 };
 
 &gpio3 {
-	ls_buf_en {
+	ls-buf-en-hog {
 		gpio-hog;
 		gpios = <10 GPIO_ACTIVE_HIGH>;
 		output-high;
diff --git a/arch/arm/boot/dts/am335x-boneblue.dts b/arch/arm/boot/dts/am335x-boneblue.dts
index 69acaf4ea0f3..0afcc2ee0b63 100644
--- a/arch/arm/boot/dts/am335x-boneblue.dts
+++ b/arch/arm/boot/dts/am335x-boneblue.dts
@@ -436,7 +436,7 @@ &dcan1 {
 };
 
 &gpio3 {
-	ls_buf_en {
+	ls-buf-en-hog {
 		gpio-hog;
 		gpios = <10 GPIO_ACTIVE_HIGH>;
 		output-high;
diff --git a/arch/arm/boot/dts/am335x-bonegreen-wireless.dts b/arch/arm/boot/dts/am335x-bonegreen-wireless.dts
index 7615327d906a..74db0fc39397 100644
--- a/arch/arm/boot/dts/am335x-bonegreen-wireless.dts
+++ b/arch/arm/boot/dts/am335x-bonegreen-wireless.dts
@@ -101,7 +101,7 @@ bluetooth {
 };
 
 &gpio1 {
-	ls_buf_en {
+	ls-buf-en-hog {
 		gpio-hog;
 		gpios = <29 GPIO_ACTIVE_HIGH>;
 		output-high;
@@ -118,7 +118,7 @@ ls_buf_en {
 /* an external pulldown on U21 pin 4.                                  */
 
 &gpio3 {
-	bt_aud_in {
+	bt-aud-in-hog {
 		gpio-hog;
 		gpios = <16 GPIO_ACTIVE_HIGH>;
 		output-low;
diff --git a/arch/arm/boot/dts/am335x-icev2.dts b/arch/arm/boot/dts/am335x-icev2.dts
index e923d065304d..5e598ac96dcc 100644
--- a/arch/arm/boot/dts/am335x-icev2.dts
+++ b/arch/arm/boot/dts/am335x-icev2.dts
@@ -458,14 +458,14 @@ &uart3 {
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
index 1eaa26533466..2bfe60d32783 100644
--- a/arch/arm/boot/dts/am335x-shc.dts
+++ b/arch/arm/boot/dts/am335x-shc.dts
@@ -140,14 +140,14 @@ ehrpwm1: pwm@200 {
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
@@ -156,14 +156,14 @@ hmtc_prog {
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

