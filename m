Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D19C3C8FE7
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240531AbhGNTxc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:53:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:47012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240651AbhGNTt7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:49:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2D236143D;
        Wed, 14 Jul 2021 19:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291946;
        bh=Zk6TdY4OBTNzN3hkr90jIgLtff7IykMudgWbaa+DDkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JcNvLrW5YFJ40JMqzKIz09LvUg6zYtZGG0pMqomjkWz7s/eTwLddC4ld9X75UgP15
         FJb1Dl7nY9PyeeN+1m45fzlheOv+3C2lsE/LvSUlguKYuYqcyJjQAhP9CycSNXWg1I
         xNOZw9IuN6+CWSRUtxH3X7jVNZloIr3EqpkmKGIBnRlIIQAw2ySf8wXm6FLgvAVH6k
         xekddJjrChLgK+UHC97eAj6YH/4tX/ec3amN66cjaVOX56eLWMBeikoPSDsBYoi5LX
         Zj85yxsxVhvjN2RKaIrr/ZY07kboqSVzgFIGpjpTv08/d+AjJaf9W0KqDLGAsjPBx+
         cxc3DM2ERxmWg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 23/51] ARM: dts: am335x: align GPIO hog names with dt-schema
Date:   Wed, 14 Jul 2021 15:44:45 -0400
Message-Id: <20210714194513.54827-23-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194513.54827-1-sashal@kernel.org>
References: <20210714194513.54827-1-sashal@kernel.org>
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
index 3124d94c0b3c..3056c3e3e312 100644
--- a/arch/arm/boot/dts/am335x-boneblack-wireless.dts
+++ b/arch/arm/boot/dts/am335x-boneblack-wireless.dts
@@ -102,7 +102,7 @@ bluetooth {
 };
 
 &gpio3 {
-	ls_buf_en {
+	ls-buf-en-hog {
 		gpio-hog;
 		gpios = <10 GPIO_ACTIVE_HIGH>;
 		output-high;
diff --git a/arch/arm/boot/dts/am335x-boneblue.dts b/arch/arm/boot/dts/am335x-boneblue.dts
index 2f6652ef9a15..8b98aa2d9588 100644
--- a/arch/arm/boot/dts/am335x-boneblue.dts
+++ b/arch/arm/boot/dts/am335x-boneblue.dts
@@ -435,7 +435,7 @@ &dcan1 {
 };
 
 &gpio3 {
-	ls_buf_en {
+	ls-buf-en-hog {
 		gpio-hog;
 		gpios = <10 GPIO_ACTIVE_HIGH>;
 		output-high;
diff --git a/arch/arm/boot/dts/am335x-bonegreen-wireless.dts b/arch/arm/boot/dts/am335x-bonegreen-wireless.dts
index 4092cd193b8a..8d85c6a851c3 100644
--- a/arch/arm/boot/dts/am335x-bonegreen-wireless.dts
+++ b/arch/arm/boot/dts/am335x-bonegreen-wireless.dts
@@ -102,7 +102,7 @@ bluetooth {
 };
 
 &gpio1 {
-	ls_buf_en {
+	ls-buf-en-hog {
 		gpio-hog;
 		gpios = <29 GPIO_ACTIVE_HIGH>;
 		output-high;
@@ -119,7 +119,7 @@ ls_buf_en {
 /* an external pulldown on U21 pin 4.                                  */
 
 &gpio3 {
-	bt_aud_in {
+	bt-aud-in-hog {
 		gpio-hog;
 		gpios = <16 GPIO_ACTIVE_HIGH>;
 		output-low;
diff --git a/arch/arm/boot/dts/am335x-icev2.dts b/arch/arm/boot/dts/am335x-icev2.dts
index 204bccfcc110..1e52dfe4f2d3 100644
--- a/arch/arm/boot/dts/am335x-icev2.dts
+++ b/arch/arm/boot/dts/am335x-icev2.dts
@@ -445,14 +445,14 @@ &uart3 {
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
index 5b0368504015..852cf61478e6 100644
--- a/arch/arm/boot/dts/am335x-shc.dts
+++ b/arch/arm/boot/dts/am335x-shc.dts
@@ -144,14 +144,14 @@ ehrpwm1: pwm@200 {
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
@@ -160,14 +160,14 @@ hmtc_prog {
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

