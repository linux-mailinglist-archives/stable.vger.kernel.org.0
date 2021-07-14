Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6DE73C8F32
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239692AbhGNTwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:52:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:45124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237210AbhGNTsT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:48:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EB9261414;
        Wed, 14 Jul 2021 19:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291826;
        bh=gZumkcFqx5VOYFhf8nq7dpfcg4GLXChwe0u7+UbyxAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ilA9Fshu0lMA5eQSAme9G8claB7jh7CDJ1Ez8wKqYqABNs4fRAjGhoMNch6DrCiCU
         GbgD+0eebDwFre1NV/wzEG4QwV0FjQJx7DVqXG7KcPqPU2L6XPcdIy1MALdAB/hseN
         i4RxoWlEvWOJbPKARiZ19gs0heIjAGfW1r0cT/Qh9EaQmHK6P8HV0uJeoJ2XXdbIiF
         2zmVsV/00GII/vRWp7Qaeo4FCbOXo+NStgO6shUunemCipeCCUZ4ahz1H62wHp2MSD
         8nZ+DyyUr5Ggyqn9HTuCIndg0dhPWaUcwSVt36ZI7ZxmV2HjQ1kZbZ5Fo3fpP5XeBz
         5030XGJNP2jWQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sebastian Reichel <sebastian.reichel@collabora.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 26/88] ARM: dts: ux500: Rename gpio-controller node
Date:   Wed, 14 Jul 2021 15:42:01 -0400
Message-Id: <20210714194303.54028-26-sashal@kernel.org>
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
index 5fde474ade22..16d50369226a 100644
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
index dbaedda2824d..8d2cda0b4d62 100644
--- a/arch/arm/boot/dts/ste-ab8505.dtsi
+++ b/arch/arm/boot/dts/ste-ab8505.dtsi
@@ -30,7 +30,7 @@ ab8500_clock: clock-controller {
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
index ff47cbf6ed3b..81e4f6c2f9dd 100644
--- a/arch/arm/boot/dts/ste-href.dtsi
+++ b/arch/arm/boot/dts/ste-href.dtsi
@@ -217,7 +217,7 @@ msp3: msp@80125000 {
 
 		prcmu@80157000 {
 			ab8500 {
-				ab8500-gpio {
+				ab8500-gpiocontroller {
 				};
 
 				ab8500_usb {
diff --git a/arch/arm/boot/dts/ste-snowball.dts b/arch/arm/boot/dts/ste-snowball.dts
index 27d8a07718a0..f6e0d71f6c09 100644
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

