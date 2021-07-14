Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2AA3C8EAF
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbhGNTss (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:48:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:38672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238414AbhGNTrq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:47:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F08E61407;
        Wed, 14 Jul 2021 19:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291809;
        bh=dumczC+bSItUFokwnf1JtchFKI5EZs3VRWdzdaiVhvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HiKzUZIchO5gejT27bIMfJWbQnETfALRY3GRCw5NtPH+rlSWB2fGlWENpFXKjbDhy
         NOidvtvli4XQyPaBhEDXu2XrjYxGyw8akg9JqehshIfBjL8BUPwi6JaaZQ+HKZNrSj
         7L4ZdKuA0z1mCeTXi+YD8QpRt8AxVbRgvVaCDoKw/CKeFEayEJFrtmI5Y2aPcimzcC
         4lfJ4JP6x/5dpIPNanGWevI3fGMWV52weXQgGIyOqRV+5WwdRlsP+K0GTV3BXARSXX
         Y62bPqN6XcvbPVT2Ikk1niNG8wIrovQZapJ+Gjqu6rysEWY9A8OP5PI56TvDyuHXto
         VniPoeiMeWk9A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 15/88] ARM: brcmstb: dts: fix NAND nodes names
Date:   Wed, 14 Jul 2021 15:41:50 -0400
Message-Id: <20210714194303.54028-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194303.54028-1-sashal@kernel.org>
References: <20210714194303.54028-1-sashal@kernel.org>
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
index 8313b7cad542..f92d2cf85972 100644
--- a/arch/arm/boot/dts/bcm7445-bcm97445svmb.dts
+++ b/arch/arm/boot/dts/bcm7445-bcm97445svmb.dts
@@ -14,10 +14,10 @@ memory@0 {
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
index 58f67c9b830b..5ac2042515b8 100644
--- a/arch/arm/boot/dts/bcm7445.dtsi
+++ b/arch/arm/boot/dts/bcm7445.dtsi
@@ -148,7 +148,7 @@ aon-ctrl@410000 {
 			reg-names = "aon-ctrl", "aon-sram";
 		};
 
-		nand: nand@3e2800 {
+		nand_controller: nand-controller@3e2800 {
 			status = "disabled";
 			#address-cells = <1>;
 			#size-cells = <0>;
-- 
2.30.2

