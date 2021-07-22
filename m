Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EABCF3D27AA
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbhGVPwI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:52:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:55016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229861AbhGVPwI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:52:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C41F66135B;
        Thu, 22 Jul 2021 16:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971563;
        bh=lWeV8RBuJNHFQMIM17dklHD34VVKwMwAXywepvTn/ao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zyZU5qktjTgRmc4R1ZgTOKnxMbGBYfm/BMSQ+wrZbnLTGGfnsza1i6WVWnzASqBHc
         68jxBJ44SsaSCOycb0t5yyqDbxXAWTj+SghIeeaEZ5q5W4PHru2sSz2cHygeLfS+FC
         iLVzPUsegS0JzxliA4n8OK0IzIiXXP+o2d3pIryY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 14/71] ARM: Cygnus: dts: fix NAND nodes names
Date:   Thu, 22 Jul 2021 18:30:49 +0200
Message-Id: <20210722155618.358557925@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155617.865866034@linuxfoundation.org>
References: <20210722155617.865866034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 1bc45cfd5453..9ca7b4241c97 100644
--- a/arch/arm/boot/dts/bcm-cygnus.dtsi
+++ b/arch/arm/boot/dts/bcm-cygnus.dtsi
@@ -460,7 +460,7 @@
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
@@ -82,8 +82,8 @@
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
@@ -60,8 +60,8 @@
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
@@ -68,8 +68,8 @@
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



