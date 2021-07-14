Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5184C3C8F45
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241365AbhGNTwP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:52:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235803AbhGNTsr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:48:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA6EB61402;
        Wed, 14 Jul 2021 19:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291836;
        bh=7lcPWf3wZRfK+H9bwkya6bRuladn8RNSUn5Y8jRll8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CAHE0cHp32AuRLhHEixT31OoLq4onjeJY5IEu1keGRsnMVJYQWVqBEK53baqu+9YU
         CMBVptQfInzp4d3iYOp34DDKyToJVkU5vKWzz85NmvhDTfnt7HEYJXSc6b9J1EuLB0
         HyCnHJg27OcPeBWe8g0i0JcLrn7L8+7omRQc46jl11aU7UUrRjS+cez6mah770Fc4d
         ucKtWX4fTh42BY+8vQj82DnxujAdtsxiBuFjjv+GMyWCo40i8aQWtUKx6TAvRGH8Ib
         Sas6OYta41pb6iwskDOv4RLCVj1MfFEahRVqucI3Vt6CH9EjUGB6quzqo0oGQphOlm
         1DHUMsJVrtNtA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 34/88] ARM: dts: am437x: align gpio hog names with dt-schema
Date:   Wed, 14 Jul 2021 15:42:09 -0400
Message-Id: <20210714194303.54028-34-sashal@kernel.org>
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
index 6e4d05d649e9..45cbc7fb557a 100644
--- a/arch/arm/boot/dts/am437x-gp-evm.dts
+++ b/arch/arm/boot/dts/am437x-gp-evm.dts
@@ -786,7 +786,7 @@ &gpio0 {
 	pinctrl-0 = <&gpio0_pins>;
 	status = "okay";
 
-	p23 {
+	sel-emmc-nand-hog {
 		gpio-hog;
 		gpios = <23 GPIO_ACTIVE_HIGH>;
 		/* SelEMMCorNAND selects between eMMC and NAND:
@@ -819,7 +819,7 @@ &gpio5 {
 	status = "okay";
 	ti,no-reset-on-init;
 
-	p8 {
+	sel-lcd-hdmi-hog {
 		/*
 		 * SelLCDorHDMI selects between display and audio paths:
 		 * Low: HDMI display with audio via HDMI
diff --git a/arch/arm/boot/dts/am43x-epos-evm.dts b/arch/arm/boot/dts/am43x-epos-evm.dts
index f517d1e843cf..d717d5ada812 100644
--- a/arch/arm/boot/dts/am43x-epos-evm.dts
+++ b/arch/arm/boot/dts/am43x-epos-evm.dts
@@ -725,7 +725,7 @@ &gpio2 {
 	pinctrl-0 = <&display_mux_pins>;
 	status = "okay";
 
-	p1 {
+	sel-lcd-hdmi-hog {
 		/*
 		 * SelLCDorHDMI selects between display and audio paths:
 		 * Low: HDMI display with audio via HDMI
-- 
2.30.2

