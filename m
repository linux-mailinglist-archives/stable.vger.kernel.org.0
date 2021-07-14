Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5CF3C8DA9
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhGNTpZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:45:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:36706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236285AbhGNToo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:44:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A41E2613CF;
        Wed, 14 Jul 2021 19:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291681;
        bh=j+ghxRSB+Zf13R52bbUgHYMI9a2I/UTfm6xTrGUq3zk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o0Hkt5LVKzUoX9IQAJ/UGvUEYUF+TP0Ww1TUFIuc0ExEZlok4dOl+cc/dVKoa/wAc
         ILheGi+92Aw7s0VuRoY+F2nPOeyKR8DbBZ+HODoZnMMR5cd+MGreuo5wC0BbeItFgN
         dOv6ggBi6+0ND6S6u7F2c6SdXyfi0+fspd4WAYpInPMxTcG2hw+9sPpON0XHCS/PGA
         Lms1w/TGBLIDN+F+GJe+JCJqGFZZpD2lZjgSNkgzJ94ltu6fZRUADR+X9NHbrE4nzo
         pGrzy+XUF2bscjLvC9nEhMIpnQ1ywNtktwbel6Vnjl0TEhiPS/vf7Qr+FqAdYWskyz
         ihCahnfU1ElZg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sebastian Reichel <sebastian.reichel@collabora.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 031/102] ARM: dts: ux500: Rename gpio-controller node
Date:   Wed, 14 Jul 2021 15:39:24 -0400
Message-Id: <20210714194036.53141-31-sashal@kernel.org>
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

From: Sebastian Reichel <sebastian.reichel@collabora.com>

[ Upstream commit 4917b702818872fdf2a9973705af3aa7d3d1f19e ]

Rename the AB8500 gpio controller node from ab8500-gpio to
ab8500-gpiocontroller, since -gpio is a common suffix for
gpio consumers.

Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ste-ab8500.dtsi      | 2 +-
 arch/arm/boot/dts/ste-ab8505.dtsi      | 2 +-
 arch/arm/boot/dts/ste-href-ab8500.dtsi | 2 +-
 arch/arm/boot/dts/ste-href.dtsi        | 2 +-
 arch/arm/boot/dts/ste-snowball.dts     | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/ste-ab8500.dtsi b/arch/arm/boot/dts/ste-ab8500.dtsi
index 5c5a5a2dadfc..00765c1c111d 100644
--- a/arch/arm/boot/dts/ste-ab8500.dtsi
+++ b/arch/arm/boot/dts/ste-ab8500.dtsi
@@ -34,7 +34,7 @@ ab8500_clock: clock-controller {
 					#clock-cells = <1>;
 				};
 
-				ab8500_gpio: ab8500-gpio {
+				ab8500_gpio: ab8500-gpiocontroller {
 					compatible = "stericsson,ab8500-gpio";
 					gpio-controller;
 					#gpio-cells = <2>;
diff --git a/arch/arm/boot/dts/ste-ab8505.dtsi b/arch/arm/boot/dts/ste-ab8505.dtsi
index 3380afa74c14..0defc15b9bbc 100644
--- a/arch/arm/boot/dts/ste-ab8505.dtsi
+++ b/arch/arm/boot/dts/ste-ab8505.dtsi
@@ -31,7 +31,7 @@ ab8500_clock: clock-controller {
 					#clock-cells = <1>;
 				};
 
-				ab8505_gpio: ab8505-gpio {
+				ab8505_gpio: ab8505-gpiocontroller {
 					compatible = "stericsson,ab8505-gpio";
 					gpio-controller;
 					#gpio-cells = <2>;
diff --git a/arch/arm/boot/dts/ste-href-ab8500.dtsi b/arch/arm/boot/dts/ste-href-ab8500.dtsi
index 4946743de7b9..3ccb7b5c7162 100644
--- a/arch/arm/boot/dts/ste-href-ab8500.dtsi
+++ b/arch/arm/boot/dts/ste-href-ab8500.dtsi
@@ -9,7 +9,7 @@ / {
 	soc {
 		prcmu@80157000 {
 			ab8500 {
-				ab8500-gpio {
+				ab8500-gpiocontroller {
 					/* Hog a few default settings */
 					pinctrl-names = "default";
 					pinctrl-0 = <&gpio2_default_mode>,
diff --git a/arch/arm/boot/dts/ste-href.dtsi b/arch/arm/boot/dts/ste-href.dtsi
index 83b179692dff..7566b4963ef6 100644
--- a/arch/arm/boot/dts/ste-href.dtsi
+++ b/arch/arm/boot/dts/ste-href.dtsi
@@ -202,7 +202,7 @@ msp3: msp@80125000 {
 
 		prcmu@80157000 {
 			ab8500 {
-				ab8500-gpio {
+				ab8500-gpiocontroller {
 				};
 
 				ab8500_usb {
diff --git a/arch/arm/boot/dts/ste-snowball.dts b/arch/arm/boot/dts/ste-snowball.dts
index b344b3748143..40f1d7c9c1d4 100644
--- a/arch/arm/boot/dts/ste-snowball.dts
+++ b/arch/arm/boot/dts/ste-snowball.dts
@@ -376,7 +376,7 @@ spi@80002000 {
 
 		prcmu@80157000 {
 			ab8500 {
-				ab8500-gpio {
+				ab8500-gpiocontroller {
 					/*
 					 * AB8500 GPIOs are numbered starting from 1, so the first
 					 * index 0 is what in the datasheet is called "GPIO1", and
-- 
2.30.2

