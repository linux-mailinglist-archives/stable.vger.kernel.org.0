Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC1B3C90A1
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238481AbhGNTzx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:55:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:48272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241362AbhGNTuc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:50:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1562C60FF2;
        Wed, 14 Jul 2021 19:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626292060;
        bh=EXhHI7jorFRcEWlmSUnB3RqJumsy5nh0j0TqdVDLdhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LdyzkmtqwOXjZIBjs1h+dHwQZ5DfHYA6gpjXxRkN19ljDu9nZKoSvk5U0PQQWb2JH
         jSlb1VAwHCJKVoDA2erbgqSOw6nuFVXsw2r+GKeD7i/S87/pujtzDMbDluGKAAZOGx
         ChIwN3dSViNMBu3No/FjVbBVlejNMuGKJvhG9VSXH9aDtWX2Xo6cv2KghABh0XV5ja
         7KJSJLPcjKrn9U3C5n8pLVr0HI27WbgxgevVHQikd2Fd1myN+YjDChelWbjTn5MJx/
         aCihf43biHabqoU3YojK6PZT5/hLPY+b/lzdMPF04J/2Auq286qfvmg/fucU0kiEG+
         50fmFVVrXPU1g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 11/28] ARM: dts: BCM63xx: Fix NAND nodes names
Date:   Wed, 14 Jul 2021 15:47:06 -0400
Message-Id: <20210714194723.55677-11-sashal@kernel.org>
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

[ Upstream commit 75e2f012f6e34b93124d1d86eaa8f27df48e9ea0 ]

This matches nand-controller.yaml requirements.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm63138.dtsi    | 2 +-
 arch/arm/boot/dts/bcm963138dvt.dts | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/bcm63138.dtsi b/arch/arm/boot/dts/bcm63138.dtsi
index 6df61518776f..557098f5c8d5 100644
--- a/arch/arm/boot/dts/bcm63138.dtsi
+++ b/arch/arm/boot/dts/bcm63138.dtsi
@@ -175,7 +175,7 @@ serial1: serial@620 {
 			status = "disabled";
 		};
 
-		nand: nand@2000 {
+		nand_controller: nand-controller@2000 {
 			#address-cells = <1>;
 			#size-cells = <0>;
 			compatible = "brcm,nand-bcm63138", "brcm,brcmnand-v7.0", "brcm,brcmnand";
diff --git a/arch/arm/boot/dts/bcm963138dvt.dts b/arch/arm/boot/dts/bcm963138dvt.dts
index c61673638fa8..5445fccec5a5 100644
--- a/arch/arm/boot/dts/bcm963138dvt.dts
+++ b/arch/arm/boot/dts/bcm963138dvt.dts
@@ -30,10 +30,10 @@ &serial1 {
 	status = "okay";
 };
 
-&nand {
+&nand_controller {
 	status = "okay";
 
-	nandcs@0 {
+	nand@0 {
 		compatible = "brcm,nandcs";
 		reg = <0>;
 		nand-ecc-strength = <4>;
-- 
2.30.2

