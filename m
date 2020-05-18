Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1A5E1D82C8
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732015AbgERR7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:59:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:39368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732014AbgERR7M (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:59:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAEA0207D3;
        Mon, 18 May 2020 17:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824752;
        bh=ZHobTLHe8zeHCbBSAE8eFwEmwmHHNRo2N/t8g3ZARIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=URPEvkfHjU3yi62gkhA8H7aGKVRSua9Nkk3EsOZ2iUj9Zw0FfYfRgSCevr8rKCI0M
         b2eBQFq5W1O9DxlaccRpnlVZICL5VMLCiA15ujz0S55ea2xvQCQzIDJ+TOboOrVV0J
         hqzXOpcEkfDTJmlrrfh27UiMcM2I75ftOgIGMUAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Ford <aford173@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.4 137/147] arm64: dts: imx8mn: Change SDMA1 ahb clock for imx8mn
Date:   Mon, 18 May 2020 19:37:40 +0200
Message-Id: <20200518173530.237924524@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Ford <aford173@gmail.com>

commit 15ddc3e17aec0de4c69d595b873e184432b9791d upstream.

Using SDMA1 with UART1 is causing a "Timeout waiting for CH0" error.
This patch changes to ahb clock from SDMA1_ROOT to AHB which fixes the
timeout error.

Fixes: 6c3debcbae47 ("arm64: dts: freescale: Add i.MX8MN dtsi support")

Signed-off-by: Adam Ford <aford173@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/freescale/imx8mn.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/freescale/imx8mn.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mn.dtsi
@@ -616,7 +616,7 @@
 				reg = <0x30bd0000 0x10000>;
 				interrupts = <GIC_SPI 2 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clk IMX8MN_CLK_SDMA1_ROOT>,
-					 <&clk IMX8MN_CLK_SDMA1_ROOT>;
+					 <&clk IMX8MN_CLK_AHB>;
 				clock-names = "ipg", "ahb";
 				#dma-cells = <3>;
 				fsl,sdma-ram-script-name = "imx/sdma/sdma-imx7d.bin";


