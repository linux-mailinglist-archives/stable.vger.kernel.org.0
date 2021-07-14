Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E24DE3C8FD7
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240466AbhGNTx0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:53:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:46320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240551AbhGNTtw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:49:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFE3B61435;
        Wed, 14 Jul 2021 19:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291937;
        bh=x+qdZzgSdk3d/ojZFp62G+S3M5I1KK3oAlR4rrJvUFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RnuGdHBafA4ladKhsDXe80d+h/v0ZHBGHiGyOB34ZiGjGpV9nLTsKYKGg7SNWdoYh
         oWOKIpDLD/6oWr9yo5ni9q7w/5z20CiOb4JmRoPDfzCYmzNgoVLSSh1XV3Yj8hXaNk
         awooeQkugdYEITh9L1ZZdCRsLJjonfu+cw/o6Om57rEZIwRrG82w7om5EqVkMYLvr9
         asMamDOY6n24iTVp5b/bim680Q/igKpz24zxyvtsQu/75EL6Lk0UzxR6PQ81iGb3iv
         gRU5WvetdrnB4wXjsU6uuE4GjjKaq37HV45MqLZ7/3Aru9kpZcjMtXAo5BTmfZKB1V
         xP4Hwwe7mINCg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 16/51] ARM: dts: BCM63xx: Fix NAND nodes names
Date:   Wed, 14 Jul 2021 15:44:38 -0400
Message-Id: <20210714194513.54827-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194513.54827-1-sashal@kernel.org>
References: <20210714194513.54827-1-sashal@kernel.org>
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
index 9c0325cf9e22..cca49a2e2d62 100644
--- a/arch/arm/boot/dts/bcm63138.dtsi
+++ b/arch/arm/boot/dts/bcm63138.dtsi
@@ -203,7 +203,7 @@ serial1: serial@620 {
 			status = "disabled";
 		};
 
-		nand: nand@2000 {
+		nand_controller: nand-controller@2000 {
 			#address-cells = <1>;
 			#size-cells = <0>;
 			compatible = "brcm,nand-bcm63138", "brcm,brcmnand-v7.0", "brcm,brcmnand";
diff --git a/arch/arm/boot/dts/bcm963138dvt.dts b/arch/arm/boot/dts/bcm963138dvt.dts
index 5b177274f182..df5c8ab90627 100644
--- a/arch/arm/boot/dts/bcm963138dvt.dts
+++ b/arch/arm/boot/dts/bcm963138dvt.dts
@@ -31,10 +31,10 @@ &serial1 {
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

