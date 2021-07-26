Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 655903D5E15
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235751AbhGZPF1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:05:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:45650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235989AbhGZPFJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:05:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7CA560F37;
        Mon, 26 Jul 2021 15:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314338;
        bh=NHscwj+qx450u+27BDDfIvG1CM3//fmSA4RZ/fI/3bI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K04WHfYdcngsN69MgldGENcdk0qCx9mAPEiKl6X3gFpu5NVV6kpJj7oZqUviHMdfY
         Q+hquME+VoemlJGwYCXvGyK8rcjh84cL/EoHTg+j24+h35BPLDSY2nyKGy8t68856u
         sEuZoQrfUFpnFBqU8m5ijcRG5dTMAsVudFhoPLGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 11/82] ARM: dts: BCM63xx: Fix NAND nodes names
Date:   Mon, 26 Jul 2021 17:38:11 +0200
Message-Id: <20210726153828.523143482@linuxfoundation.org>
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
@@ -175,7 +175,7 @@
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
@@ -30,10 +30,10 @@
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



