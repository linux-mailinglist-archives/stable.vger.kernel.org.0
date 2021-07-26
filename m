Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B75D83D5D36
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234996AbhGZPAF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:00:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234828AbhGZPAF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:00:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A37360E08;
        Mon, 26 Jul 2021 15:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314034;
        bh=4sbGRXc4eo0oyeIfZXjX8+PY5BgsYFlbgVeD38D2N9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nIIaj/vitDgWK+OxRH2XssCeei89pKgZSmkym6ZMuOFZIlsOX3Ba0xOHzKZ0wKzpb
         RgrWHi+6JCXVJ2SJ1hqBPRINX6iUYhUwFL8xYdoy845Vqn/Yu6jWiFasDEDTA1WZSC
         ptC/U+Diq08XLbKkAKTV6DDfbTxa02bYADQqZLNM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 01/47] ARM: brcmstb: dts: fix NAND nodes names
Date:   Mon, 26 Jul 2021 17:38:19 +0200
Message-Id: <20210726153823.030841804@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153822.980271128@linuxfoundation.org>
References: <20210726153822.980271128@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 0bb8d17e4c2d..e51c9b079432 100644
--- a/arch/arm/boot/dts/bcm7445-bcm97445svmb.dts
+++ b/arch/arm/boot/dts/bcm7445-bcm97445svmb.dts
@@ -13,10 +13,10 @@
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
index 4791321969b3..3f002f2047f1 100644
--- a/arch/arm/boot/dts/bcm7445.dtsi
+++ b/arch/arm/boot/dts/bcm7445.dtsi
@@ -149,7 +149,7 @@
 			reg-names = "aon-ctrl", "aon-sram";
 		};
 
-		nand: nand@3e2800 {
+		nand_controller: nand-controller@3e2800 {
 			status = "disabled";
 			#address-cells = <1>;
 			#size-cells = <0>;
-- 
2.30.2



