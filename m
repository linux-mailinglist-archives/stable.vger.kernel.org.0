Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0CF63C90BA
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237177AbhGNT4N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:56:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:49182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233384AbhGNTvF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:51:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36F21613F6;
        Wed, 14 Jul 2021 19:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626292093;
        bh=n8HgM6WO45WIlTe1BG2AxxEVNh9IpZpYOvrLwQTKtSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TJiy75/Ob1m+LejGIfMN52JiLnzSEbjgsySJ4rlAKDx7dTCzoM944G0atFdZfdDfS
         jskAgvf3pCG8RD6DRZwG75dz0K2vhGaez2N+vXzUUGOkTDyq1tIzX45ZImsb4+XbYY
         o+jFGXXAbiP1yF/8n6JgLE7IHLAdMFJiasuCLKWg0AZWj7Y9hfK59xuG+sl4fGEXyw
         Jk8l8mUU8GvYNCdAIjINspk5FY9RJFtpSem3CFNUO+uPgltrkZ68bBSeZ91VW7Oq+G
         3CMXFjZNLCWuQY96yex600PYNgFdOlXwbtGCneve0sWIPDVIzVobZ+ez3PHKYTx5IH
         x56ePImgmWaAw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 04/18] ARM: brcmstb: dts: fix NAND nodes names
Date:   Wed, 14 Jul 2021 15:47:52 -0400
Message-Id: <20210714194806.55962-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194806.55962-1-sashal@kernel.org>
References: <20210714194806.55962-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 9a800ce1aada6e0f56b78e4713f4858c8990c1f7 ]

This matches nand-controller.yaml requirements.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm7445-bcm97445svmb.dts | 4 ++--
 arch/arm/boot/dts/bcm7445.dtsi             | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/bcm7445-bcm97445svmb.dts b/arch/arm/boot/dts/bcm7445-bcm97445svmb.dts
index 0bb8d17e4c2d..e51c9b079432 100644
--- a/arch/arm/boot/dts/bcm7445-bcm97445svmb.dts
+++ b/arch/arm/boot/dts/bcm7445-bcm97445svmb.dts
@@ -13,10 +13,10 @@ memory {
 	};
 };
 
-&nand {
+&nand_controller {
 	status = "okay";
 
-	nandcs@1 {
+	nand@1 {
 		compatible = "brcm,nandcs";
 		reg = <1>;
 		nand-ecc-step-size = <512>;
diff --git a/arch/arm/boot/dts/bcm7445.dtsi b/arch/arm/boot/dts/bcm7445.dtsi
index 4791321969b3..3f002f2047f1 100644
--- a/arch/arm/boot/dts/bcm7445.dtsi
+++ b/arch/arm/boot/dts/bcm7445.dtsi
@@ -149,7 +149,7 @@ aon-ctrl@410000 {
 			reg-names = "aon-ctrl", "aon-sram";
 		};
 
-		nand: nand@3e2800 {
+		nand_controller: nand-controller@3e2800 {
 			status = "disabled";
 			#address-cells = <1>;
 			#size-cells = <0>;
-- 
2.30.2

