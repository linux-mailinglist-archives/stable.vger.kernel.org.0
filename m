Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCF9A3C90C2
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240627AbhGNT4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:56:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:48778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239185AbhGNTvM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:51:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F36D613DC;
        Wed, 14 Jul 2021 19:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626292100;
        bh=Q34D6jpjc9Bc/3lXm7wONvbtovNzfupe0fYvYWFrlks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lC8Lh+W/OHFdkz94hOI3f2gw6mk07wn3XrfLk8JmsAU4HJeVGY2lRQIJ931HaZsj2
         ck77GaeYkyKEx2jZSrlbPY3CrPyuA0qMvSupkpgURKGoM+8f7CmehvBkZKRf4H23qD
         OojfCLJL9fpjdVDNMLpkiNf2BVZb3c3QdrB2fTMnJ9Fe1QkkR5zsGQXsZBl97pefcd
         BcyhrDumEKcoDxlze6zy1Ri6kDScwvgAe98eVAXad0Kw/RyVCZMFIGaT/ucRAsF2ix
         aI9QsstBju/K0vq7Uyke9kzgqLpwCoGUKvHPJF/pRFNb1Fn3z2DcfO631JgaTagh1V
         i8cGJuaNOwQZg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 09/18] ARM: dts: am437x: align gpio hog names with dt-schema
Date:   Wed, 14 Jul 2021 15:47:57 -0400
Message-Id: <20210714194806.55962-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194806.55962-1-sashal@kernel.org>
References: <20210714194806.55962-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit bd551acdde3ad40da1a97391abd6e0db7852bf66 ]

The GPIO Hog dt-schema node naming convention expect GPIO hogs node names
to end with a 'hog' suffix.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/am437x-gp-evm.dts  | 4 ++--
 arch/arm/boot/dts/am43x-epos-evm.dts | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/am437x-gp-evm.dts b/arch/arm/boot/dts/am437x-gp-evm.dts
index b55c094893c6..58c3bda82e00 100644
--- a/arch/arm/boot/dts/am437x-gp-evm.dts
+++ b/arch/arm/boot/dts/am437x-gp-evm.dts
@@ -665,7 +665,7 @@ &gpio0 {
 	pinctrl-0 = <&gpio0_pins>;
 	status = "okay";
 
-	p23 {
+	sel-emmc-nand-hog {
 		gpio-hog;
 		gpios = <23 GPIO_ACTIVE_HIGH>;
 		/* SelEMMCorNAND selects between eMMC and NAND:
@@ -698,7 +698,7 @@ &gpio5 {
 	status = "okay";
 	ti,no-reset-on-init;
 
-	p8 {
+	sel-lcd-hdmi-hog {
 		/*
 		 * SelLCDorHDMI selects between display and audio paths:
 		 * Low: HDMI display with audio via HDMI
diff --git a/arch/arm/boot/dts/am43x-epos-evm.dts b/arch/arm/boot/dts/am43x-epos-evm.dts
index 21918807c9f6..a5a403231c39 100644
--- a/arch/arm/boot/dts/am43x-epos-evm.dts
+++ b/arch/arm/boot/dts/am43x-epos-evm.dts
@@ -529,7 +529,7 @@ &gpio2 {
 	pinctrl-0 = <&display_mux_pins>;
 	status = "okay";
 
-	p1 {
+	sel-lcd-hdmi-hog {
 		/*
 		 * SelLCDorHDMI selects between display and audio paths:
 		 * Low: HDMI display with audio via HDMI
-- 
2.30.2

