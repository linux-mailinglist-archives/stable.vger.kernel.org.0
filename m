Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C960915E9FF
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:11:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403982AbgBNRKo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:10:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:42260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392184AbgBNQNf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:13:35 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68962246CC;
        Fri, 14 Feb 2020 16:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696814;
        bh=fA51Coas5M5iE9zV5U1GOTR6u7PvxMHrAhjVPey+Hw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e83WxdJKZSG5cnXcvwIMhun58O1IvrzzjTpjcD7IRRqxlUUMtYniZbEXkom4HNglA
         5iebQA3D7h7AgTVuWJipcrLGvXoI/x4C+xs/3xEW7pmKvEq6k937iuqsFIgwvq3gNR
         NIkg4WZOayZg2J0oQna2w10W8AKWA69EmZi/jl60=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ingo van Lil <inguin@gmx.de>, Peter Rosin <peda@axentia.se>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 083/252] ARM: dts: at91: Reenable UART TX pull-ups
Date:   Fri, 14 Feb 2020 11:08:58 -0500
Message-Id: <20200214161147.15842-83-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ingo van Lil <inguin@gmx.de>

[ Upstream commit 9d39d86cd4af2b17b970d63307daad71f563d207 ]

Pull-ups for SAM9 UART/USART TX lines were disabled in a previous
commit. However, several chips in the SAM9 family require pull-ups to
prevent the TX lines from falling (and causing an endless break
condition) when the transceiver is disabled.

From the SAM9G20 datasheet, 32.5.1: "To prevent the TXD line from
falling when the USART is disabled, the use of an internal pull up
is mandatory.". This commit reenables the pull-ups for all chips having
that sentence in their datasheets.

Fixes: 5e04822f7db5 ("ARM: dts: at91: fixes uart pinctrl, set pullup on rx, clear pullup on tx")
Signed-off-by: Ingo van Lil <inguin@gmx.de>
Cc: Peter Rosin <peda@axentia.se>
Link: https://lore.kernel.org/r/20191203142147.875227-1-inguin@gmx.de
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/at91sam9260.dtsi | 12 ++++++------
 arch/arm/boot/dts/at91sam9261.dtsi |  6 +++---
 arch/arm/boot/dts/at91sam9263.dtsi |  6 +++---
 arch/arm/boot/dts/at91sam9g45.dtsi |  8 ++++----
 arch/arm/boot/dts/at91sam9rl.dtsi  |  8 ++++----
 5 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9260.dtsi b/arch/arm/boot/dts/at91sam9260.dtsi
index 9118e29b6d6ad..3fa6b9fbb8226 100644
--- a/arch/arm/boot/dts/at91sam9260.dtsi
+++ b/arch/arm/boot/dts/at91sam9260.dtsi
@@ -434,7 +434,7 @@
 				usart0 {
 					pinctrl_usart0: usart0-0 {
 						atmel,pins =
-							<AT91_PIOB 4 AT91_PERIPH_A AT91_PINCTRL_NONE
+							<AT91_PIOB 4 AT91_PERIPH_A AT91_PINCTRL_PULL_UP
 							 AT91_PIOB 5 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>;
 					};
 
@@ -468,7 +468,7 @@
 				usart1 {
 					pinctrl_usart1: usart1-0 {
 						atmel,pins =
-							<AT91_PIOB 6 AT91_PERIPH_A AT91_PINCTRL_NONE
+							<AT91_PIOB 6 AT91_PERIPH_A AT91_PINCTRL_PULL_UP
 							 AT91_PIOB 7 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>;
 					};
 
@@ -486,7 +486,7 @@
 				usart2 {
 					pinctrl_usart2: usart2-0 {
 						atmel,pins =
-							<AT91_PIOB 8 AT91_PERIPH_A AT91_PINCTRL_NONE
+							<AT91_PIOB 8 AT91_PERIPH_A AT91_PINCTRL_PULL_UP
 							 AT91_PIOB 9 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>;
 					};
 
@@ -504,7 +504,7 @@
 				usart3 {
 					pinctrl_usart3: usart3-0 {
 						atmel,pins =
-							<AT91_PIOB 10 AT91_PERIPH_A AT91_PINCTRL_NONE
+							<AT91_PIOB 10 AT91_PERIPH_A AT91_PINCTRL_PULL_UP
 							 AT91_PIOB 11 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>;
 					};
 
@@ -522,7 +522,7 @@
 				uart0 {
 					pinctrl_uart0: uart0-0 {
 						atmel,pins =
-							<AT91_PIOA 31 AT91_PERIPH_B AT91_PINCTRL_NONE
+							<AT91_PIOA 31 AT91_PERIPH_B AT91_PINCTRL_PULL_UP
 							 AT91_PIOA 30 AT91_PERIPH_B AT91_PINCTRL_PULL_UP>;
 					};
 				};
@@ -530,7 +530,7 @@
 				uart1 {
 					pinctrl_uart1: uart1-0 {
 						atmel,pins =
-							<AT91_PIOB 12 AT91_PERIPH_A AT91_PINCTRL_NONE
+							<AT91_PIOB 12 AT91_PERIPH_A AT91_PINCTRL_PULL_UP
 							 AT91_PIOB 13 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>;
 					};
 				};
diff --git a/arch/arm/boot/dts/at91sam9261.dtsi b/arch/arm/boot/dts/at91sam9261.dtsi
index 33f09d5ea0201..590d288529978 100644
--- a/arch/arm/boot/dts/at91sam9261.dtsi
+++ b/arch/arm/boot/dts/at91sam9261.dtsi
@@ -328,7 +328,7 @@
 				usart0 {
 					pinctrl_usart0: usart0-0 {
 						atmel,pins =
-							<AT91_PIOC 8 AT91_PERIPH_A AT91_PINCTRL_NONE>,
+							<AT91_PIOC 8 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>,
 							<AT91_PIOC 9 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>;
 					};
 
@@ -346,7 +346,7 @@
 				usart1 {
 					pinctrl_usart1: usart1-0 {
 						atmel,pins =
-							<AT91_PIOC 12 AT91_PERIPH_A AT91_PINCTRL_NONE>,
+							<AT91_PIOC 12 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>,
 							<AT91_PIOC 13 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>;
 					};
 
@@ -364,7 +364,7 @@
 				usart2 {
 					pinctrl_usart2: usart2-0 {
 						atmel,pins =
-							<AT91_PIOC 14 AT91_PERIPH_A AT91_PINCTRL_NONE>,
+							<AT91_PIOC 14 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>,
 							<AT91_PIOC 15 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>;
 					};
 
diff --git a/arch/arm/boot/dts/at91sam9263.dtsi b/arch/arm/boot/dts/at91sam9263.dtsi
index af68a86c99731..745918b977860 100644
--- a/arch/arm/boot/dts/at91sam9263.dtsi
+++ b/arch/arm/boot/dts/at91sam9263.dtsi
@@ -437,7 +437,7 @@
 				usart0 {
 					pinctrl_usart0: usart0-0 {
 						atmel,pins =
-							<AT91_PIOA 26 AT91_PERIPH_A AT91_PINCTRL_NONE
+							<AT91_PIOA 26 AT91_PERIPH_A AT91_PINCTRL_PULL_UP
 							 AT91_PIOA 27 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>;
 					};
 
@@ -455,7 +455,7 @@
 				usart1 {
 					pinctrl_usart1: usart1-0 {
 						atmel,pins =
-							<AT91_PIOD 0 AT91_PERIPH_A AT91_PINCTRL_NONE
+							<AT91_PIOD 0 AT91_PERIPH_A AT91_PINCTRL_PULL_UP
 							 AT91_PIOD 1 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>;
 					};
 
@@ -473,7 +473,7 @@
 				usart2 {
 					pinctrl_usart2: usart2-0 {
 						atmel,pins =
-							<AT91_PIOD 2 AT91_PERIPH_A AT91_PINCTRL_NONE
+							<AT91_PIOD 2 AT91_PERIPH_A AT91_PINCTRL_PULL_UP
 							 AT91_PIOD 3 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>;
 					};
 
diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
index d16db1fa7e15c..ea80a5a127609 100644
--- a/arch/arm/boot/dts/at91sam9g45.dtsi
+++ b/arch/arm/boot/dts/at91sam9g45.dtsi
@@ -555,7 +555,7 @@
 				usart0 {
 					pinctrl_usart0: usart0-0 {
 						atmel,pins =
-							<AT91_PIOB 19 AT91_PERIPH_A AT91_PINCTRL_NONE
+							<AT91_PIOB 19 AT91_PERIPH_A AT91_PINCTRL_PULL_UP
 							 AT91_PIOB 18 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>;
 					};
 
@@ -573,7 +573,7 @@
 				usart1 {
 					pinctrl_usart1: usart1-0 {
 						atmel,pins =
-							<AT91_PIOB 4 AT91_PERIPH_A AT91_PINCTRL_NONE
+							<AT91_PIOB 4 AT91_PERIPH_A AT91_PINCTRL_PULL_UP
 							 AT91_PIOB 5 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>;
 					};
 
@@ -591,7 +591,7 @@
 				usart2 {
 					pinctrl_usart2: usart2-0 {
 						atmel,pins =
-							<AT91_PIOB 6 AT91_PERIPH_A AT91_PINCTRL_NONE
+							<AT91_PIOB 6 AT91_PERIPH_A AT91_PINCTRL_PULL_UP
 							 AT91_PIOB 7 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>;
 					};
 
@@ -609,7 +609,7 @@
 				usart3 {
 					pinctrl_usart3: usart3-0 {
 						atmel,pins =
-							<AT91_PIOB 8 AT91_PERIPH_A AT91_PINCTRL_NONE
+							<AT91_PIOB 8 AT91_PERIPH_A AT91_PINCTRL_PULL_UP
 							 AT91_PIOB 9 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>;
 					};
 
diff --git a/arch/arm/boot/dts/at91sam9rl.dtsi b/arch/arm/boot/dts/at91sam9rl.dtsi
index 8fb22030f00bc..ad495f5a5790f 100644
--- a/arch/arm/boot/dts/at91sam9rl.dtsi
+++ b/arch/arm/boot/dts/at91sam9rl.dtsi
@@ -681,7 +681,7 @@
 				usart0 {
 					pinctrl_usart0: usart0-0 {
 						atmel,pins =
-							<AT91_PIOA 6 AT91_PERIPH_A AT91_PINCTRL_NONE>,
+							<AT91_PIOA 6 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>,
 							<AT91_PIOA 7 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>;
 					};
 
@@ -720,7 +720,7 @@
 				usart1 {
 					pinctrl_usart1: usart1-0 {
 						atmel,pins =
-							<AT91_PIOA 11 AT91_PERIPH_A AT91_PINCTRL_NONE>,
+							<AT91_PIOA 11 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>,
 							<AT91_PIOA 12 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>;
 					};
 
@@ -743,7 +743,7 @@
 				usart2 {
 					pinctrl_usart2: usart2-0 {
 						atmel,pins =
-							<AT91_PIOA 13 AT91_PERIPH_A AT91_PINCTRL_NONE>,
+							<AT91_PIOA 13 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>,
 							<AT91_PIOA 14 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>;
 					};
 
@@ -766,7 +766,7 @@
 				usart3 {
 					pinctrl_usart3: usart3-0 {
 						atmel,pins =
-							<AT91_PIOB 0 AT91_PERIPH_A AT91_PINCTRL_NONE>,
+							<AT91_PIOB 0 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>,
 							<AT91_PIOB 1 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>;
 					};
 
-- 
2.20.1

