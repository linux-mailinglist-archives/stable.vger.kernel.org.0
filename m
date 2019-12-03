Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3AD4111C17
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbfLCWkJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:40:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:51924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728347AbfLCWkJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:40:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 153DB20862;
        Tue,  3 Dec 2019 22:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412808;
        bh=XvQ9NfBL+EK23l2Iyl98LW3G6qs6QdmuhwboJ0xde/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fk9uEisCa3dCallMc+cqUYm5OKfp2urBoaTqkFEDeXj1YxwPCo6R/noDuhgp8IKH/
         uGB25+XTTlKL6ZcI/Y9vhw3v1R65JiYpbp+JrlkiWRgFcZ6cxaOZ5IcsOHk3fi57IY
         q5kmbHHepiw2l6OiIKlZnoKAQbQM4acAI+xVV8tw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 024/135] arm64: dts: imx8mm: fix compatible string for sdma
Date:   Tue,  3 Dec 2019 23:34:24 +0100
Message-Id: <20191203213010.261622371@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit e346ff93f02b1ba81e976d4e67ec56582dbdf7f1 ]

SDMA in i.MX8MM should use same configuration as i.MX8MQ
So need to change compatible string to be "fsl,imx8mq-sdma".

Fixes: a05ea40eb384 ("arm64: dts: imx: Add i.mx8mm dtsi support")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm.dtsi b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
index 0d0a6543e5db2..a9824b862c419 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
@@ -370,7 +370,7 @@
 			};
 
 			sdma2: dma-controller@302c0000 {
-				compatible = "fsl,imx8mm-sdma", "fsl,imx7d-sdma";
+				compatible = "fsl,imx8mm-sdma", "fsl,imx8mq-sdma";
 				reg = <0x302c0000 0x10000>;
 				interrupts = <GIC_SPI 103 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clk IMX8MM_CLK_SDMA2_ROOT>,
@@ -381,7 +381,7 @@
 			};
 
 			sdma3: dma-controller@302b0000 {
-				compatible = "fsl,imx8mm-sdma", "fsl,imx7d-sdma";
+				compatible = "fsl,imx8mm-sdma", "fsl,imx8mq-sdma";
 				reg = <0x302b0000 0x10000>;
 				interrupts = <GIC_SPI 34 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clk IMX8MM_CLK_SDMA3_ROOT>,
@@ -693,7 +693,7 @@
 			};
 
 			sdma1: dma-controller@30bd0000 {
-				compatible = "fsl,imx8mm-sdma", "fsl,imx7d-sdma";
+				compatible = "fsl,imx8mm-sdma", "fsl,imx8mq-sdma";
 				reg = <0x30bd0000 0x10000>;
 				interrupts = <GIC_SPI 2 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clk IMX8MM_CLK_SDMA1_ROOT>,
-- 
2.20.1



