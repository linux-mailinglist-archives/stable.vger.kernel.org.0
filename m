Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4EA145501
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729043AbgAVNSF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:18:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:33714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725790AbgAVNSF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:18:05 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7553224696;
        Wed, 22 Jan 2020 13:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699084;
        bh=iAZqCwI1XOyl2WpXl06mssrMZh83k6NYphTFN7bo9bU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XZQow0schJUDfwUeAi0q2w49TB/0XEBpG313Ytaxqt4bTe3twFDJZ3H+L2IMBRGqn
         tUCyrI7Hfhv8m0B1XuKPaxRlr0vMzYP6ituCEYAxWjF0EqwAnJRYfU5rfp9rUa0/Ks
         wa2kLvH1SbW0nQnGsGDzWLQCXBLKCbC8ynEikK7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Ford <aford173@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.4 008/222] arm64: dts: imx8mm: Change SDMA1 ahb clock for imx8mm
Date:   Wed, 22 Jan 2020 10:26:34 +0100
Message-Id: <20200122092833.958795642@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Ford <aford173@gmail.com>

commit 24a572bf67994223e722cadfe663e15ba221882a upstream.

Using SDMA1 with UART1 is causing a "Timeout waiting for CH0" error.
This patch changes to ahb clock from SDMA1_ROOT to AHB which
fixes the timeout error.

Fixes:  a05ea40eb384 ("arm64: dts: imx: Add i.mx8mm dtsi support")
Signed-off-by: Adam Ford <aford173@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/freescale/imx8mm.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/freescale/imx8mm.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
@@ -741,7 +741,7 @@
 				reg = <0x30bd0000 0x10000>;
 				interrupts = <GIC_SPI 2 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clk IMX8MM_CLK_SDMA1_ROOT>,
-					 <&clk IMX8MM_CLK_SDMA1_ROOT>;
+					 <&clk IMX8MM_CLK_AHB>;
 				clock-names = "ipg", "ahb";
 				#dma-cells = <3>;
 				fsl,sdma-ram-script-name = "imx/sdma/sdma-imx7d.bin";


