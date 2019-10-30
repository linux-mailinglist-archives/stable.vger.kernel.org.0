Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 776FEEA08B
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 16:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729078AbfJ3P5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:57:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:59130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729067AbfJ3P5a (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:57:30 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D42921734;
        Wed, 30 Oct 2019 15:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572451049;
        bh=0guIy7a25neGWxvY8eDOVnp6P7zOlDJLv5fR2gY7DC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yj86R2lKxjv18uxwOUX/D95GnfNLDbxPgXJDXMjTp+P18i9wO5b8m3TVhuS5dJ6vU
         JlN2jBTMgo7uXE86qncKi1kLpWh+2zR99hwoxQMuhDaYYG6Mxe/hkLdc00jOPkHMOr
         JnipyBiJE/rZ6qPV9gzJpasSiO7FAp6hlzzswWuA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anson Huang <Anson.Huang@nxp.com>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 11/18] ARM: dts: imx7s: Correct GPT's ipg clock source
Date:   Wed, 30 Oct 2019 11:56:53 -0400
Message-Id: <20191030155700.10748-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030155700.10748-1-sashal@kernel.org>
References: <20191030155700.10748-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anson Huang <Anson.Huang@nxp.com>

[ Upstream commit 252b9e21bcf46b0d16f733f2e42b21fdc60addee ]

i.MX7S/D's GPT ipg clock should be from GPT clock root and
controlled by CCM's GPT CCGR, using correct clock source for
GPT ipg clock instead of IMX7D_CLK_DUMMY.

Fixes: 3ef79ca6bd1d ("ARM: dts: imx7d: use imx7s.dtsi as base device tree")
Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx7s.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
index edc5ddeb851a7..0a7ea1a765f99 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -437,7 +437,7 @@
 				compatible = "fsl,imx7d-gpt", "fsl,imx6sx-gpt";
 				reg = <0x302d0000 0x10000>;
 				interrupts = <GIC_SPI 55 IRQ_TYPE_LEVEL_HIGH>;
-				clocks = <&clks IMX7D_CLK_DUMMY>,
+				clocks = <&clks IMX7D_GPT1_ROOT_CLK>,
 					 <&clks IMX7D_GPT1_ROOT_CLK>;
 				clock-names = "ipg", "per";
 			};
@@ -446,7 +446,7 @@
 				compatible = "fsl,imx7d-gpt", "fsl,imx6sx-gpt";
 				reg = <0x302e0000 0x10000>;
 				interrupts = <GIC_SPI 54 IRQ_TYPE_LEVEL_HIGH>;
-				clocks = <&clks IMX7D_CLK_DUMMY>,
+				clocks = <&clks IMX7D_GPT2_ROOT_CLK>,
 					 <&clks IMX7D_GPT2_ROOT_CLK>;
 				clock-names = "ipg", "per";
 				status = "disabled";
@@ -456,7 +456,7 @@
 				compatible = "fsl,imx7d-gpt", "fsl,imx6sx-gpt";
 				reg = <0x302f0000 0x10000>;
 				interrupts = <GIC_SPI 53 IRQ_TYPE_LEVEL_HIGH>;
-				clocks = <&clks IMX7D_CLK_DUMMY>,
+				clocks = <&clks IMX7D_GPT3_ROOT_CLK>,
 					 <&clks IMX7D_GPT3_ROOT_CLK>;
 				clock-names = "ipg", "per";
 				status = "disabled";
@@ -466,7 +466,7 @@
 				compatible = "fsl,imx7d-gpt", "fsl,imx6sx-gpt";
 				reg = <0x30300000 0x10000>;
 				interrupts = <GIC_SPI 52 IRQ_TYPE_LEVEL_HIGH>;
-				clocks = <&clks IMX7D_CLK_DUMMY>,
+				clocks = <&clks IMX7D_GPT4_ROOT_CLK>,
 					 <&clks IMX7D_GPT4_ROOT_CLK>;
 				clock-names = "ipg", "per";
 				status = "disabled";
-- 
2.20.1

