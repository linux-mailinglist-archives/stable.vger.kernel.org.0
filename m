Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7441C3D27A9
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbhGVPwH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:52:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:54926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229837AbhGVPwG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:52:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E3AC61353;
        Thu, 22 Jul 2021 16:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971560;
        bh=wVyccyobmz7/CFF8QnrwUJDpJW1OH0nkl8KRnURzRrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BOCdcm2m6BNEb9q1n0wT3DJAH6c4vkFDTZh31pQMPhPDAsmDJTDItBUndC0I57SZV
         96GzsdnQzbPBKN1vVdhW9CakeF7c8L+i8IO/SrKle4x/S9f3ebnxSYcYSt6xNI06q4
         f3yzNdNSdgAg67yR9DPcU9L00wLk3s1qmY7Ywt48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 13/71] ARM: brcmstb: dts: fix NAND nodes names
Date:   Thu, 22 Jul 2021 18:30:48 +0200
Message-Id: <20210722155618.319154762@linuxfoundation.org>
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
@@ -14,10 +14,10 @@
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
@@ -148,7 +148,7 @@
 			reg-names = "aon-ctrl", "aon-sram";
 		};
 
-		nand: nand@3e2800 {
+		nand_controller: nand-controller@3e2800 {
 			status = "disabled";
 			#address-cells = <1>;
 			#size-cells = <0>;
-- 
2.30.2



