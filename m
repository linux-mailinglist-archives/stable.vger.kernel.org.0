Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70AD9428F7B
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237048AbhJKN7L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:59:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:41206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236639AbhJKNzc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:55:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FBD860EDF;
        Mon, 11 Oct 2021 13:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960379;
        bh=OhHlDJEgEyHTNtH/kZ6F6w+c6LvVOlveu3Mg2Jlz9mg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nh3BQ0ZoXa4TT0wT0dGiOZJbibLRwrp9EXx/RkQ1Zh8ohieawDki6xBLQinXUgXO8
         Tr2kU6nZgdRzS8mjeSVDd/fJHjKpknVVbjqm8TQ7fF6LPsK3zQKcGAcRtmI0gf1u3h
         UIsPnTMpOgkuSt8hpF7WUq2fGc8sudHgMMVun4KA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 44/83] arm64: dts: ls1028a: add missing CAN nodes
Date:   Mon, 11 Oct 2021 15:46:04 +0200
Message-Id: <20211011134509.928975328@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134508.362906295@linuxfoundation.org>
References: <20211011134508.362906295@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

[ Upstream commit 04fa4f03e3533f51b4db19cb487435f5862a0514 ]

The LS1028A has two FlexCAN controller. These are compatible with
the ones from the LX2160A. Add the nodes.

The first controller was tested on the Kontron sl28 board.

Signed-off-by: Michael Walle <michael@walle.cc>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
index 5f42904d53ab..580690057601 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
@@ -386,6 +386,24 @@
 			status = "disabled";
 		};
 
+		can0: can@2180000 {
+			compatible = "fsl,ls1028ar1-flexcan", "fsl,lx2160ar1-flexcan";
+			reg = <0x0 0x2180000 0x0 0x10000>;
+			interrupts = <GIC_SPI 21 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&sysclk>, <&clockgen 4 1>;
+			clock-names = "ipg", "per";
+			status = "disabled";
+		};
+
+		can1: can@2190000 {
+			compatible = "fsl,ls1028ar1-flexcan", "fsl,lx2160ar1-flexcan";
+			reg = <0x0 0x2190000 0x0 0x10000>;
+			interrupts = <GIC_SPI 22 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&sysclk>, <&clockgen 4 1>;
+			clock-names = "ipg", "per";
+			status = "disabled";
+		};
+
 		duart0: serial@21c0500 {
 			compatible = "fsl,ns16550", "ns16550a";
 			reg = <0x00 0x21c0500 0x0 0x100>;
-- 
2.33.0



