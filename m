Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB0C73C90BD
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239009AbhGNT4O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:56:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:49262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238756AbhGNTvG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:51:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B92DC613D1;
        Wed, 14 Jul 2021 19:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626292094;
        bh=IsDXt9MRxv2/0Dcd3vFCuFrZl7JfyFY0hH3w3yGDm04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iCvTAhf/7x/hKOXE7inf5ViT5YioYcbcSZvXgif1sBXLCCCviMBkv833AhtmpjkWn
         KgMZ0/VQzp7SmbBgaGYwQKLL+mOR/ZFarnl/PNR5Y3eJpAj5d3W89AgNHHXPMi2PBy
         zLIvgBnPnZv/g1dLOVijSYiEp20Ir2hrFHXuyb6AMWWqTjbArRyG5ysOlUZ1vum2vg
         vI/QC9WkuW8QKEnJhPBOyfwf9IeZX6ukppRyUsLoSxHdNIa2GVVuVqeoKdDmP9Od1E
         B41YfQCa3eC4sdRGVn/Rxjzr3kKdRemK7oPKbgRli26k3zSSs10UVdmP/o6KaYiHVw
         HmFXMDBMc1Szg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 05/18] ARM: dts: BCM63xx: Fix NAND nodes names
Date:   Wed, 14 Jul 2021 15:47:53 -0400
Message-Id: <20210714194806.55962-5-sashal@kernel.org>
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
index 547369c69e96..aedbea888684 100644
--- a/arch/arm/boot/dts/bcm63138.dtsi
+++ b/arch/arm/boot/dts/bcm63138.dtsi
@@ -174,7 +174,7 @@ serial1: serial@620 {
 			status = "disabled";
 		};
 
-		nand: nand@2000 {
+		nand_controller: nand-controller@2000 {
 			#address-cells = <1>;
 			#size-cells = <0>;
 			compatible = "brcm,nand-bcm63138", "brcm,brcmnand-v7.0", "brcm,brcmnand";
diff --git a/arch/arm/boot/dts/bcm963138dvt.dts b/arch/arm/boot/dts/bcm963138dvt.dts
index 370aa2cfddf2..439cff69e948 100644
--- a/arch/arm/boot/dts/bcm963138dvt.dts
+++ b/arch/arm/boot/dts/bcm963138dvt.dts
@@ -29,10 +29,10 @@ &serial1 {
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

