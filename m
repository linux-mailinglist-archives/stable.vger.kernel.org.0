Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F415626B3EE
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbgIOXM7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:12:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:48814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727275AbgIOOki (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:40:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBBA122583;
        Tue, 15 Sep 2020 14:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180235;
        bh=ODkGlafivrbgVxFbMH60BR9FR335qBpk4erVbgKVjIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m42nY/TWD6v5xYlFVwtd0p95vRorz32xxCuvNSkchvyQUPWQgF4uvIuLZjieLmzb/
         KljNlXD96mgpJXzsecm5P1RHpPMw6nW/CZc1HesRtzntvd1JoN/ZzCvi/MPoITB6y2
         LLpRZbQ7nXeVYVVL/+KBmNMtIe5hUkf6LgH6WFLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Gong <yibin.gong@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.8 162/177] arm64: dts: imx8mp: correct sdma1 clk setting
Date:   Tue, 15 Sep 2020 16:13:53 +0200
Message-Id: <20200915140701.459326292@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Gong <yibin.gong@nxp.com>

commit 66138621f2473e29625dfa6bb229872203b71b90 upstream.

Correct sdma1 ahb clk, otherwise wrong 1:1 clk ratio will be chosed so
that sdma1 function broken. sdma1 should use 1:2 clk, while sdma2/3 use
1:1.

Fixes: 6d9b8d20431f ("arm64: dts: freescale: Add i.MX8MP dtsi support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Robin Gong <yibin.gong@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/freescale/imx8mp.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/freescale/imx8mp.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
@@ -688,7 +688,7 @@
 				reg = <0x30bd0000 0x10000>;
 				interrupts = <GIC_SPI 2 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clk IMX8MP_CLK_SDMA1_ROOT>,
-					 <&clk IMX8MP_CLK_SDMA1_ROOT>;
+					 <&clk IMX8MP_CLK_AHB>;
 				clock-names = "ipg", "ahb";
 				#dma-cells = <3>;
 				fsl,sdma-ram-script-name = "imx/sdma/sdma-imx7d.bin";


