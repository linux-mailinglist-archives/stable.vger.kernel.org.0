Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A33B03C909B
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238903AbhGNTzr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:55:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:45124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241259AbhGNTu3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:50:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 199EF613CA;
        Wed, 14 Jul 2021 19:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626292055;
        bh=RXx4TKXUitAf+azuu6hDSms9AQKWG0fAwf4MMjYp0vs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LBvJjrjV4pqED0bKRPt9mTkkPOpwUatJMSj4/UJkxFRLnhZ7EBI2iVBVZPRiY7X1g
         etDQNwVZu695inUhSgUR8d9yfuBfaE0TDoqkwOya+06Cc+18X3KUMy+OB9FGyHVvqm
         qfKgi0uQtoaUiNI1J5BvEjp3fiDZDEs5uangpe1ThRQpyYJy2KeKw4/sYRSO87+BzU
         rFwN5Bwvz13iwyaRMYWVg2VXEFnDWY7Jww6ZyfAcQqG28MFrFYaBYpsATFbzCEMaCT
         uBlCDxqkd/xHc6Djl8gt/HGCjTrkG1J+Y6CkkzcHp1sWH+6OoUqXITR+i/IP+Xvw2h
         GXomWOhjP+NPw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 08/28] ARM: brcmstb: dts: fix NAND nodes names
Date:   Wed, 14 Jul 2021 15:47:03 -0400
Message-Id: <20210714194723.55677-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194723.55677-1-sashal@kernel.org>
References: <20210714194723.55677-1-sashal@kernel.org>
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
index 8006c69a3fdf..5931c0288283 100644
--- a/arch/arm/boot/dts/bcm7445-bcm97445svmb.dts
+++ b/arch/arm/boot/dts/bcm7445-bcm97445svmb.dts
@@ -14,10 +14,10 @@ memory {
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
index c859aa6f358c..b06845e92acd 100644
--- a/arch/arm/boot/dts/bcm7445.dtsi
+++ b/arch/arm/boot/dts/bcm7445.dtsi
@@ -150,7 +150,7 @@ aon-ctrl@410000 {
 			reg-names = "aon-ctrl", "aon-sram";
 		};
 
-		nand: nand@3e2800 {
+		nand_controller: nand-controller@3e2800 {
 			status = "disabled";
 			#address-cells = <1>;
 			#size-cells = <0>;
-- 
2.30.2

