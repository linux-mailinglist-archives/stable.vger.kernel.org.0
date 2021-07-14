Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9A43C8D97
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236538AbhGNTpO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:45:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:38712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236645AbhGNToK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:44:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BC42613DC;
        Wed, 14 Jul 2021 19:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291662;
        bh=MnkZqjfaEZebjtwblUsWzU5f/OOwRtIiyMkh/TTg7Zs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RtN41EkxOVaBgjvQM5xKQAs8pkUps6ktwkbJqb2Jg75nVcZ2GC5FSUm+2ngW0ttnA
         SCzQV6O6u/lwAyklWCP5DohBRJ75p1ZRmQo8I+asWV2FJdLFugPXeECfktvxJ8ILkP
         e6ixXic/ZcdGCwpnMjCmvSgQIqj8Bx3mURg2affVoYzuH+Kuhp/G3pXSXwMKmxsWVz
         A2/6dw/2SD9TVU8FOgvY4wCEYgHaekinuDaOckifnXzOD5ypA+ehMGSxlFQB6BIE61
         wBhu50MsgwKkOo7o6mhmK9WQnLFZ+tarmBy2FjlvyVcA7kIo+tOjRXEGyv/COGmjbD
         7F1PVg2qh1nEA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 018/102] ARM: Cygnus: dts: fix NAND nodes names
Date:   Wed, 14 Jul 2021 15:39:11 -0400
Message-Id: <20210714194036.53141-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194036.53141-1-sashal@kernel.org>
References: <20210714194036.53141-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit e256b48a3b07ee1ae4bfa60abbf509ba8e386862 ]

This matches nand-controller.yaml requirements.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm-cygnus.dtsi      | 2 +-
 arch/arm/boot/dts/bcm911360_entphn.dts | 4 ++--
 arch/arm/boot/dts/bcm958300k.dts       | 4 ++--
 arch/arm/boot/dts/bcm958305k.dts       | 4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm/boot/dts/bcm-cygnus.dtsi b/arch/arm/boot/dts/bcm-cygnus.dtsi
index 0025c88f660c..8ecb7861ce10 100644
--- a/arch/arm/boot/dts/bcm-cygnus.dtsi
+++ b/arch/arm/boot/dts/bcm-cygnus.dtsi
@@ -460,7 +460,7 @@ sdhci1: sdhci@18043000 {
 			status = "disabled";
 		};
 
-		nand: nand@18046000 {
+		nand_controller: nand-controller@18046000 {
 			compatible = "brcm,nand-iproc", "brcm,brcmnand-v6.1";
 			reg = <0x18046000 0x600>, <0xf8105408 0x600>,
 			      <0x18046f00 0x20>;
diff --git a/arch/arm/boot/dts/bcm911360_entphn.dts b/arch/arm/boot/dts/bcm911360_entphn.dts
index b2d323f4a5ab..a76c74b44bba 100644
--- a/arch/arm/boot/dts/bcm911360_entphn.dts
+++ b/arch/arm/boot/dts/bcm911360_entphn.dts
@@ -82,8 +82,8 @@ &uart3 {
 	status = "okay";
 };
 
-&nand {
-	nandcs@1 {
+&nand_controller {
+	nand@1 {
 		compatible = "brcm,nandcs";
 		reg = <0>;
 		nand-on-flash-bbt;
diff --git a/arch/arm/boot/dts/bcm958300k.dts b/arch/arm/boot/dts/bcm958300k.dts
index b4a1392bd5a6..dda3e11b711f 100644
--- a/arch/arm/boot/dts/bcm958300k.dts
+++ b/arch/arm/boot/dts/bcm958300k.dts
@@ -60,8 +60,8 @@ &uart3 {
 	status = "okay";
 };
 
-&nand {
-	nandcs@1 {
+&nand_controller {
+	nand@1 {
 		compatible = "brcm,nandcs";
 		reg = <0>;
 		nand-on-flash-bbt;
diff --git a/arch/arm/boot/dts/bcm958305k.dts b/arch/arm/boot/dts/bcm958305k.dts
index 3378683321d3..ea3c6b88b313 100644
--- a/arch/arm/boot/dts/bcm958305k.dts
+++ b/arch/arm/boot/dts/bcm958305k.dts
@@ -68,8 +68,8 @@ &uart3 {
 	status = "okay";
 };
 
-&nand {
-	nandcs@1 {
+&nand_controller {
+	nand@1 {
 		compatible = "brcm,nandcs";
 		reg = <0>;
 		nand-on-flash-bbt;
-- 
2.30.2

