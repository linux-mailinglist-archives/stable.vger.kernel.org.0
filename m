Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 884BF3C8FEC
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240555AbhGNTxe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:53:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:45586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240652AbhGNTt7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:49:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4058D61443;
        Wed, 14 Jul 2021 19:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291948;
        bh=IJePZ/sCwsqtF2QiD6At5BE13rbflLhIkvUAqVUMLog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qJx+cnHHr1BvxK4mBKIHpLPig6S3ArIuVndGl/m9byHVoSICWz6aUbTUt8lUCtw7b
         LED8Mg1NRmw+8Vr4BVnB5r2lV1MTSS0SsIC6CSwfnJbsuBzJUptTJnZYcCXKmAEqA5
         1R2noebB7ELcA27beaAzvQyAvSiQaKyCFDIRr6lRb6xHNpFDXhZkl6h0KwLFo5dkYW
         0NrvZ8q97BCzerPRLkBG5FqM+TaPAsEOBWdPZ+OVOyBWcINCiGkGySsrCFNyezbpY4
         +ySSBn2X2XU6VZrIZabD2xbW+tweX3fpD1QNhYqyzUmvhBm+AuhhBk6HZfLJzxKrTO
         j3l1TTT/rTkDQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 24/51] ARM: dts: am437x: align gpio hog names with dt-schema
Date:   Wed, 14 Jul 2021 15:44:46 -0400
Message-Id: <20210714194513.54827-24-sashal@kernel.org>
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
index 811c8cae315b..acc4c2760f46 100644
--- a/arch/arm/boot/dts/am437x-gp-evm.dts
+++ b/arch/arm/boot/dts/am437x-gp-evm.dts
@@ -802,7 +802,7 @@ &gpio0 {
 	pinctrl-0 = <&gpio0_pins>;
 	status = "okay";
 
-	p23 {
+	sel-emmc-nand-hog {
 		gpio-hog;
 		gpios = <23 GPIO_ACTIVE_HIGH>;
 		/* SelEMMCorNAND selects between eMMC and NAND:
@@ -835,7 +835,7 @@ &gpio5 {
 	status = "okay";
 	ti,no-reset-on-init;
 
-	p8 {
+	sel-lcd-hdmi-hog {
 		/*
 		 * SelLCDorHDMI selects between display and audio paths:
 		 * Low: HDMI display with audio via HDMI
diff --git a/arch/arm/boot/dts/am43x-epos-evm.dts b/arch/arm/boot/dts/am43x-epos-evm.dts
index a6fbc088daa8..45a44c705a70 100644
--- a/arch/arm/boot/dts/am43x-epos-evm.dts
+++ b/arch/arm/boot/dts/am43x-epos-evm.dts
@@ -717,7 +717,7 @@ &gpio2 {
 	pinctrl-0 = <&display_mux_pins>;
 	status = "okay";
 
-	p1 {
+	sel-lcd-hdmi-hog {
 		/*
 		 * SelLCDorHDMI selects between display and audio paths:
 		 * Low: HDMI display with audio via HDMI
-- 
2.30.2

