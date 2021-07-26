Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02D8F3D5DAA
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235496AbhGZPDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:03:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:42226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235729AbhGZPCr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:02:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEB1A60F37;
        Mon, 26 Jul 2021 15:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314193;
        bh=PP7emg3R96vM45QcvloT7IHz1px/K67vO41LxLVoiiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O8S9ESgD0ib9xy+Sk++ryIOK/3h6iif4ZVNsVg9Jwi/RpdDCIBIyMsEAb6136DjAt
         KYRigUW8GTMkGe8T5ctpgW3qeik90S/fm8dHSt+8x4ns1hODvAS57rGm5QNNHwI+nq
         Pxxnvt2ASKzNJDZV1a6FCptSacI6dRlFXFqRI0Ao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 05/60] ARM: dts: BCM63xx: Fix NAND nodes names
Date:   Mon, 26 Jul 2021 17:38:19 +0200
Message-Id: <20210726153825.040787515@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153824.868160836@linuxfoundation.org>
References: <20210726153824.868160836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -174,7 +174,7 @@
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
@@ -29,10 +29,10 @@
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



