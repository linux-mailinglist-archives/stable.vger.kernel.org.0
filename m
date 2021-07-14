Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CAA33C9041
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241064AbhGNTyK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:54:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:45586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241058AbhGNTuW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:50:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1A73613E3;
        Wed, 14 Jul 2021 19:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626292003;
        bh=EXhHI7jorFRcEWlmSUnB3RqJumsy5nh0j0TqdVDLdhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nf08aeWSti1uVNIRhfffHSzzXfHmQBeyf+/mC/Bx6JFaLJFHhtUWGj1S4DnAtfKqn
         aIQUnfIeMcUcUh1HLOR4jvUcIA8fBKll3yeKUipZGCoyXf6K8VCm7cbmbgvdD0xYXX
         c6wJLvcfVxRUV+2EWf7sirD/kRvOLCojfACQu1meyx0t7GP7wtcG0i11FSt7dzfHP4
         DTNGSidGM/uY2RmFKqTTt9G8zxj0ESvDFMw3YyWQlANHVqh4hXfbLrfYLrVaA3Ii2k
         IMWXm5eh6AkZTOiSG0T5Q6cnMshBc6mFqZCF4mBesvJIMldes1nQtgxa5WkL2moR1a
         5BpumQcbULAQA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 13/39] ARM: dts: BCM63xx: Fix NAND nodes names
Date:   Wed, 14 Jul 2021 15:45:58 -0400
Message-Id: <20210714194625.55303-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194625.55303-1-sashal@kernel.org>
References: <20210714194625.55303-1-sashal@kernel.org>
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

