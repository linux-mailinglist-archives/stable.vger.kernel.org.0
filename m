Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 630E9F54F7
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388842AbfKHS7X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 13:59:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:55014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732877AbfKHS5M (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 13:57:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91A3E20865;
        Fri,  8 Nov 2019 18:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239432;
        bh=0guIy7a25neGWxvY8eDOVnp6P7zOlDJLv5fR2gY7DC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PLCAcBaxwMOhBqrdtQS+4CFCbn4d6KB/r3qD52kf73ondylvSF96XUYvLKH3pIvLf
         iQHv9P9QK5gciqIoatxGXzOl0hu7My7+IPApvmTSxx3fTNY7qtaCLzvjxNEc+XlmCS
         FTyiofBA/EbQRqJKO4TjXPwPBTbFCIQ2uMoNmyyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anson Huang <Anson.Huang@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 11/34] ARM: dts: imx7s: Correct GPTs ipg clock source
Date:   Fri,  8 Nov 2019 19:50:18 +0100
Message-Id: <20191108174631.560071914@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174618.266472504@linuxfoundation.org>
References: <20191108174618.266472504@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



