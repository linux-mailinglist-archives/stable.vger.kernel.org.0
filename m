Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B37B3D29AF
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235041AbhGVQF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:05:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:40678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233900AbhGVQEI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:04:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 731C9619B4;
        Thu, 22 Jul 2021 16:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972278;
        bh=rn9Udz48rVHFZj1BirUeXvUKeXRIJztrXZPaBTQxx0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2MRBM/7yAx9I2YmWWbcjHPQEFwP2DVBQdktM5sWnzx7HkJ0hHqBzBvXnEkQKCKf8h
         u9MksSRDBr38MPSXUGrNOXKwF1oP/DcL6uhjomxsXqQoV7LHouhSpgIyzw8nA5JUJN
         AWmx86Mq2V2GDX7MrHHCsZxKnRca7hD4VoWTVsZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 053/156] ARM: dts: stm32: fix gpio-keys node on STM32 MCU boards
Date:   Thu, 22 Jul 2021 18:30:28 +0200
Message-Id: <20210722155630.126467756@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
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
index 7e10ae744c9d..9ac1ffe53413 100644
--- a/arch/arm/boot/dts/stm32429i-eval.dts
+++ b/arch/arm/boot/dts/stm32429i-eval.dts
@@ -119,17 +119,15 @@
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
index ca8c192449ee..327613fd9666 100644
--- a/arch/arm/boot/dts/stm32746g-eval.dts
+++ b/arch/arm/boot/dts/stm32746g-eval.dts
@@ -81,12 +81,10 @@
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
index 3dc068b91ca1..075ac57d0bf4 100644
--- a/arch/arm/boot/dts/stm32f429-disco.dts
+++ b/arch/arm/boot/dts/stm32f429-disco.dts
@@ -81,12 +81,10 @@
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
index 2e1b3bbbe4b5..8c982ae79f43 100644
--- a/arch/arm/boot/dts/stm32f469-disco.dts
+++ b/arch/arm/boot/dts/stm32f469-disco.dts
@@ -104,12 +104,10 @@
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
index 0ce7fbc20fa4..be943b701980 100644
--- a/arch/arm/boot/dts/stm32f769-disco.dts
+++ b/arch/arm/boot/dts/stm32f769-disco.dts
@@ -75,12 +75,10 @@
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



