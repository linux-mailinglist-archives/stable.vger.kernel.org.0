Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A41313C90AA
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238811AbhGNT4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:56:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:48474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241458AbhGNTuk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:50:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FAEB613CA;
        Wed, 14 Jul 2021 19:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626292068;
        bh=1sjKisESjwAAkTQcNsd10kK3PjY5oPlcYTv9XsrWVxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dcF6RVlrJ0YuY+9pR6yk2VDSA1QrfCbxYYox+cpodyu+6G87wuQoeH8f6Kloqw6SP
         u4zuiDDYzHxQP4mVwrfqgVcCQD0WzNrdkRoT1JjhQPozl2S6MUD3Wqsh64lv4NWhIF
         NcddyEgOpSOQlmVybt8w4k6p672n1yiclwL03MaMMY0reidPt6/b4XkZ2XghtfOlvE
         qFg/wRf2tFx8d68Eb2TX0BaGKBkgCYwCM/WbQpLC9bMGEct2BWVP8fufuVwHllULHH
         PS/WinY3U9QMlcaX7u+NkIF4abspTub29Lwj/cWk5lXt0bXXUhZ9hANeD+xRdFGLWq
         tR0tNVoNZh5vg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 16/28] ARM: dts: am437x: align gpio hog names with dt-schema
Date:   Wed, 14 Jul 2021 15:47:11 -0400
Message-Id: <20210714194723.55677-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194723.55677-1-sashal@kernel.org>
References: <20210714194723.55677-1-sashal@kernel.org>
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
index 051823b7e5a1..f36cb4105d18 100644
--- a/arch/arm/boot/dts/am437x-gp-evm.dts
+++ b/arch/arm/boot/dts/am437x-gp-evm.dts
@@ -696,7 +696,7 @@ &gpio0 {
 	pinctrl-0 = <&gpio0_pins>;
 	status = "okay";
 
-	p23 {
+	sel-emmc-nand-hog {
 		gpio-hog;
 		gpios = <23 GPIO_ACTIVE_HIGH>;
 		/* SelEMMCorNAND selects between eMMC and NAND:
@@ -729,7 +729,7 @@ &gpio5 {
 	status = "okay";
 	ti,no-reset-on-init;
 
-	p8 {
+	sel-lcd-hdmi-hog {
 		/*
 		 * SelLCDorHDMI selects between display and audio paths:
 		 * Low: HDMI display with audio via HDMI
diff --git a/arch/arm/boot/dts/am43x-epos-evm.dts b/arch/arm/boot/dts/am43x-epos-evm.dts
index c4279b0b9f12..22ab85fa895d 100644
--- a/arch/arm/boot/dts/am43x-epos-evm.dts
+++ b/arch/arm/boot/dts/am43x-epos-evm.dts
@@ -527,7 +527,7 @@ &gpio2 {
 	pinctrl-0 = <&display_mux_pins>;
 	status = "okay";
 
-	p1 {
+	sel-lcd-hdmi-hog {
 		/*
 		 * SelLCDorHDMI selects between display and audio paths:
 		 * Low: HDMI display with audio via HDMI
-- 
2.30.2

