Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A64753D2974
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234001AbhGVQEG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:04:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:40600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233886AbhGVQDK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:03:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E1FC61C24;
        Thu, 22 Jul 2021 16:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972215;
        bh=wZkR7IldDmpEi06StNMyoRbVBefCEwzyaYqeXIebQjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=frPNV5Pgk6cxxd9wIYEQ7owWc0rECF0vcWCzgwTIZPSWSTXcKyV6jIwDXkJLEZ6KS
         pNFcyslQ2xxMQW7BpW9Wgcd0O7U0dvyWbSEaLMgYfC7CDo5Srjq5P46H5GS9f0v3V8
         H8l+BsXm8S0x8+lu73nlwkHILv+DAi/MjiFUAotg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 029/156] ARM: dts: ux500: Rename gpio-controller node
Date:   Thu, 22 Jul 2021 18:30:04 +0200
Message-Id: <20210722155629.355630307@linuxfoundation.org>
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
index f78b41002490..d0fe3f9aa183 100644
--- a/arch/arm/boot/dts/ste-ab8500.dtsi
+++ b/arch/arm/boot/dts/ste-ab8500.dtsi
@@ -34,7 +34,7 @@
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
@@ -31,7 +31,7 @@
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
@@ -9,7 +9,7 @@
 	soc {
 		prcmu@80157000 {
 			ab8500 {
-				ab8500-gpio {
+				ab8500-gpiocontroller {
 					/* Hog a few default settings */
 					pinctrl-names = "default";
 					pinctrl-0 = <&gpio2_default_mode>,
diff --git a/arch/arm/boot/dts/ste-href.dtsi b/arch/arm/boot/dts/ste-href.dtsi
index 13d216192904..c97e8d29004f 100644
--- a/arch/arm/boot/dts/ste-href.dtsi
+++ b/arch/arm/boot/dts/ste-href.dtsi
@@ -209,7 +209,7 @@
 
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
@@ -376,7 +376,7 @@
 
 		prcmu@80157000 {
 			ab8500 {
-				ab8500-gpio {
+				ab8500-gpiocontroller {
 					/*
 					 * AB8500 GPIOs are numbered starting from 1, so the first
 					 * index 0 is what in the datasheet is called "GPIO1", and
-- 
2.30.2



