Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A420F3D5E13
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236105AbhGZPFV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:05:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:45582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235576AbhGZPFH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:05:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C66F60FC4;
        Mon, 26 Jul 2021 15:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314336;
        bh=qQFiQ0lKE+qkq1V1h683RdQXj75iUND3pfAIjPHGCtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OT9V+W94BSOStwP+rgoF9NWyHvyGRN0v6K2CzqBWqsqUg/CL1sZ3ttxvrhw2oOZhO
         7n9fq/Mz1HlhSEJLLa+akOdM+4T2RvYDCT8o3Fakly61WZ3h5i2uy6XtPyJt57/88F
         82Dn6x3mOJJXE30Yg0sr8MZR3jy7JJKmmYC/CCic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 10/82] ARM: NSP: dts: fix NAND nodes names
Date:   Mon, 26 Jul 2021 17:38:10 +0200
Message-Id: <20210726153828.492368047@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153828.144714469@linuxfoundation.org>
References: <20210726153828.144714469@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 0484594be733d5cdf976f55a2d4e8d887f351b69 ]

This matches nand-controller.yaml requirements.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm-nsp.dtsi     | 2 +-
 arch/arm/boot/dts/bcm958522er.dts  | 4 ++--
 arch/arm/boot/dts/bcm958525er.dts  | 4 ++--
 arch/arm/boot/dts/bcm958525xmc.dts | 4 ++--
 arch/arm/boot/dts/bcm958622hr.dts  | 4 ++--
 arch/arm/boot/dts/bcm958623hr.dts  | 4 ++--
 arch/arm/boot/dts/bcm958625hr.dts  | 4 ++--
 arch/arm/boot/dts/bcm958625k.dts   | 4 ++--
 arch/arm/boot/dts/bcm988312hr.dts  | 4 ++--
 9 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/arch/arm/boot/dts/bcm-nsp.dtsi b/arch/arm/boot/dts/bcm-nsp.dtsi
index e975f9cabe84..3bd3412b29a8 100644
--- a/arch/arm/boot/dts/bcm-nsp.dtsi
+++ b/arch/arm/boot/dts/bcm-nsp.dtsi
@@ -259,7 +259,7 @@
 			dma-coherent;
 		};
 
-		nand: nand@26000 {
+		nand_controller: nand-controller@26000 {
 			compatible = "brcm,nand-iproc", "brcm,brcmnand-v6.1";
 			reg = <0x026000 0x600>,
 			      <0x11b408 0x600>,
diff --git a/arch/arm/boot/dts/bcm958522er.dts b/arch/arm/boot/dts/bcm958522er.dts
index f9dd342cc2ae..56f9181975b1 100644
--- a/arch/arm/boot/dts/bcm958522er.dts
+++ b/arch/arm/boot/dts/bcm958522er.dts
@@ -74,8 +74,8 @@
 	status = "okay";
 };
 
-&nand {
-	nandcs@0 {
+&nand_controller {
+	nand@0 {
 		compatible = "brcm,nandcs";
 		reg = <0>;
 		nand-on-flash-bbt;
diff --git a/arch/arm/boot/dts/bcm958525er.dts b/arch/arm/boot/dts/bcm958525er.dts
index 374508a9cfbf..93a3e23ec7ae 100644
--- a/arch/arm/boot/dts/bcm958525er.dts
+++ b/arch/arm/boot/dts/bcm958525er.dts
@@ -74,8 +74,8 @@
 	status = "okay";
 };
 
-&nand {
-	nandcs@0 {
+&nand_controller {
+	nand@0 {
 		compatible = "brcm,nandcs";
 		reg = <0>;
 		nand-on-flash-bbt;
diff --git a/arch/arm/boot/dts/bcm958525xmc.dts b/arch/arm/boot/dts/bcm958525xmc.dts
index 403250c5ad8e..fad974212d8a 100644
--- a/arch/arm/boot/dts/bcm958525xmc.dts
+++ b/arch/arm/boot/dts/bcm958525xmc.dts
@@ -90,8 +90,8 @@
 	};
 };
 
-&nand {
-	nandcs@0 {
+&nand_controller {
+	nand@0 {
 		compatible = "brcm,nandcs";
 		reg = <0>;
 		nand-on-flash-bbt;
diff --git a/arch/arm/boot/dts/bcm958622hr.dts b/arch/arm/boot/dts/bcm958622hr.dts
index fd8b8c689ffe..26b5ed56b604 100644
--- a/arch/arm/boot/dts/bcm958622hr.dts
+++ b/arch/arm/boot/dts/bcm958622hr.dts
@@ -78,8 +78,8 @@
 	status = "okay";
 };
 
-&nand {
-	nandcs@0 {
+&nand_controller {
+	nand@0 {
 		compatible = "brcm,nandcs";
 		reg = <0>;
 		nand-on-flash-bbt;
diff --git a/arch/arm/boot/dts/bcm958623hr.dts b/arch/arm/boot/dts/bcm958623hr.dts
index b8bde13de90a..789fb77e17ad 100644
--- a/arch/arm/boot/dts/bcm958623hr.dts
+++ b/arch/arm/boot/dts/bcm958623hr.dts
@@ -78,8 +78,8 @@
 	status = "okay";
 };
 
-&nand {
-	nandcs@0 {
+&nand_controller {
+	nand@0 {
 		compatible = "brcm,nandcs";
 		reg = <0>;
 		nand-on-flash-bbt;
diff --git a/arch/arm/boot/dts/bcm958625hr.dts b/arch/arm/boot/dts/bcm958625hr.dts
index f0e2008f7490..88d51eb3083d 100644
--- a/arch/arm/boot/dts/bcm958625hr.dts
+++ b/arch/arm/boot/dts/bcm958625hr.dts
@@ -76,8 +76,8 @@
 	status = "okay";
 };
 
-&nand {
-	nandcs@0 {
+&nand_controller {
+	nand@0 {
 		compatible = "brcm,nandcs";
 		reg = <0>;
 		nand-on-flash-bbt;
diff --git a/arch/arm/boot/dts/bcm958625k.dts b/arch/arm/boot/dts/bcm958625k.dts
index 2cf2392483b2..22d321e06a31 100644
--- a/arch/arm/boot/dts/bcm958625k.dts
+++ b/arch/arm/boot/dts/bcm958625k.dts
@@ -69,8 +69,8 @@
 	status = "okay";
 };
 
-&nand {
-	nandcs@0 {
+&nand_controller {
+	nand@0 {
 		compatible = "brcm,nandcs";
 		reg = <0>;
 		nand-on-flash-bbt;
diff --git a/arch/arm/boot/dts/bcm988312hr.dts b/arch/arm/boot/dts/bcm988312hr.dts
index bce251a68591..b62b91fa942f 100644
--- a/arch/arm/boot/dts/bcm988312hr.dts
+++ b/arch/arm/boot/dts/bcm988312hr.dts
@@ -78,8 +78,8 @@
 	status = "okay";
 };
 
-&nand {
-	nandcs@0 {
+&nand_controller {
+	nand@0 {
 		compatible = "brcm,nandcs";
 		reg = <0>;
 		nand-on-flash-bbt;
-- 
2.30.2



