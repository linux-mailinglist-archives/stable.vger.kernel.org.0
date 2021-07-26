Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 803343D5EA0
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237379AbhGZPLK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:11:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:48546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236503AbhGZPJZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:09:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7985860F02;
        Mon, 26 Jul 2021 15:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314584;
        bh=tZtAH8fajDgXLgop1oexVHHyMx75YxJsqv3w+QF4O6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b7BUrVOej4Cekmfa9OXhNVlexr4lz3itL+IhQz36aqu5Im5LpF1C+IbLvWs/MK72u
         PxK3IQiRYTQEHadLnj7T5f7W0DjwGtetWPfUD32lYKcZaDM99KzMz/fCnqmlKnwLwp
         W3mtL+79+QX1B2Qtc/GAZRQ158FQ87D2zqvX50eU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 018/120] ARM: dts: stm32: fix gpio-keys node on STM32 MCU boards
Date:   Mon, 26 Jul 2021 17:37:50 +0200
Message-Id: <20210726153832.957048496@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153832.339431936@linuxfoundation.org>
References: <20210726153832.339431936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Torgue <alexandre.torgue@foss.st.com>

[ Upstream commit bf24b91f4baf7e421c770a1d9c7d381b10206ac9 ]

Fix following warning observed with "make dtbs_check W=1" command.
It concerns f429 eval and disco boards, f769 disco board.

Warning (unit_address_vs_reg): /gpio_keys/button@0: node has a unit name,
but no reg or ranges property

Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32429i-eval.dts  | 8 +++-----
 arch/arm/boot/dts/stm32746g-eval.dts  | 6 ++----
 arch/arm/boot/dts/stm32f429-disco.dts | 6 ++----
 arch/arm/boot/dts/stm32f469-disco.dts | 6 ++----
 arch/arm/boot/dts/stm32f769-disco.dts | 6 ++----
 5 files changed, 11 insertions(+), 21 deletions(-)

diff --git a/arch/arm/boot/dts/stm32429i-eval.dts b/arch/arm/boot/dts/stm32429i-eval.dts
index 7eb786a2d624..f5429e495024 100644
--- a/arch/arm/boot/dts/stm32429i-eval.dts
+++ b/arch/arm/boot/dts/stm32429i-eval.dts
@@ -111,17 +111,15 @@
 		};
 	};
 
-	gpio_keys {
+	gpio-keys {
 		compatible = "gpio-keys";
-		#address-cells = <1>;
-		#size-cells = <0>;
 		autorepeat;
-		button@0 {
+		button-0 {
 			label = "Wake up";
 			linux,code = <KEY_WAKEUP>;
 			gpios = <&gpioa 0 0>;
 		};
-		button@1 {
+		button-1 {
 			label = "Tamper";
 			linux,code = <KEY_RESTART>;
 			gpios = <&gpioc 13 0>;
diff --git a/arch/arm/boot/dts/stm32746g-eval.dts b/arch/arm/boot/dts/stm32746g-eval.dts
index 8c081eaf20fe..f99b5df4c12f 100644
--- a/arch/arm/boot/dts/stm32746g-eval.dts
+++ b/arch/arm/boot/dts/stm32746g-eval.dts
@@ -73,12 +73,10 @@
 		};
 	};
 
-	gpio_keys {
+	gpio-keys {
 		compatible = "gpio-keys";
-		#address-cells = <1>;
-		#size-cells = <0>;
 		autorepeat;
-		button@0 {
+		button-0 {
 			label = "Wake up";
 			linux,code = <KEY_WAKEUP>;
 			gpios = <&gpioc 13 0>;
diff --git a/arch/arm/boot/dts/stm32f429-disco.dts b/arch/arm/boot/dts/stm32f429-disco.dts
index 5ceb2cf3777f..bcf2a5cfd6b2 100644
--- a/arch/arm/boot/dts/stm32f429-disco.dts
+++ b/arch/arm/boot/dts/stm32f429-disco.dts
@@ -78,12 +78,10 @@
 		};
 	};
 
-	gpio_keys {
+	gpio-keys {
 		compatible = "gpio-keys";
-		#address-cells = <1>;
-		#size-cells = <0>;
 		autorepeat;
-		button@0 {
+		button-0 {
 			label = "User";
 			linux,code = <KEY_HOME>;
 			gpios = <&gpioa 0 0>;
diff --git a/arch/arm/boot/dts/stm32f469-disco.dts b/arch/arm/boot/dts/stm32f469-disco.dts
index eea979ef5512..881210d820bb 100644
--- a/arch/arm/boot/dts/stm32f469-disco.dts
+++ b/arch/arm/boot/dts/stm32f469-disco.dts
@@ -103,12 +103,10 @@
 		};
 	};
 
-	gpio_keys {
+	gpio-keys {
 		compatible = "gpio-keys";
-		#address-cells = <1>;
-		#size-cells = <0>;
 		autorepeat;
-		button@0 {
+		button-0 {
 			label = "User";
 			linux,code = <KEY_WAKEUP>;
 			gpios = <&gpioa 0 GPIO_ACTIVE_HIGH>;
diff --git a/arch/arm/boot/dts/stm32f769-disco.dts b/arch/arm/boot/dts/stm32f769-disco.dts
index 677276ba4dbe..80516f44bb19 100644
--- a/arch/arm/boot/dts/stm32f769-disco.dts
+++ b/arch/arm/boot/dts/stm32f769-disco.dts
@@ -74,12 +74,10 @@
 		};
 	};
 
-	gpio_keys {
+	gpio-keys {
 		compatible = "gpio-keys";
-		#address-cells = <1>;
-		#size-cells = <0>;
 		autorepeat;
-		button@0 {
+		button-0 {
 			label = "User";
 			linux,code = <KEY_HOME>;
 			gpios = <&gpioa 0 GPIO_ACTIVE_HIGH>;
-- 
2.30.2



