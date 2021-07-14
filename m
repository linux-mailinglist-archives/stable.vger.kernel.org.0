Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 719603C8F42
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241341AbhGNTwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:52:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:45690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238832AbhGNTso (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:48:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89A51613F9;
        Wed, 14 Jul 2021 19:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291835;
        bh=JHMHx19zVrV434m+crZ6x4tmXsd9HIpWzGS7dA8vWes=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Atjx74+LatxUQXzre0hvUBuXuJTDRNZT6P87ELlsLhmGZY0ScV2IM3L2rPjllQsNd
         Kyh/p/GpuyfLopx/5xANKIgAhjep4vr1bTUu9MVuciy5g15QFFwI1ax/VvRyeHyvz6
         Evvi1Kec2UaNnWujEUBU8cWdI0c3o/7cSmMHszGdwCUVM10+Vol30IP3HGFf3LkvpX
         NwgRyUDMIv4kXP21MZrGtSymE8Ji01l45bpkEyFCVHq7YeX/arn+jDpiKZJijrHKuv
         50RIflcHp5bcEBOQtEzZNQxfCvhl4ySxzV0gNmjs6nDBAdQ2UAnIFgroilaZKzEerG
         W3VGv3Pl+B8QQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 33/88] ARM: dts: am335x: align GPIO hog names with dt-schema
Date:   Wed, 14 Jul 2021 15:42:08 -0400
Message-Id: <20210714194303.54028-33-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194303.54028-1-sashal@kernel.org>
References: <20210714194303.54028-1-sashal@kernel.org>
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
index c696d57cf364..239b32a04eb4 100644
--- a/arch/arm/boot/dts/am335x-boneblue.dts
+++ b/arch/arm/boot/dts/am335x-boneblue.dts
@@ -412,7 +412,7 @@ &dcan1 {
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
index b958ab56a412..ed45079a68ff 100644
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

