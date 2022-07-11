Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2805D56FB87
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232469AbiGKJbw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:31:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232238AbiGKJbW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:31:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1D23ED70;
        Mon, 11 Jul 2022 02:17:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F12D661257;
        Mon, 11 Jul 2022 09:16:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07883C341C0;
        Mon, 11 Jul 2022 09:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531019;
        bh=Ydhnk3Ka6/gypkyrryB/mwM0eu6Jyl/rqSPH0WbVd+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P2ki8QpHCiq7zgfHkk77qya8yIlKB2JRmPydE6WG5yjFmsboAfrx2Wq5gH29DrbAO
         PIdjdWjJZ+2A7g0JFVMOIBkxt5Cvxr5QiNdJJ9WgAPHTXmbhoRalHTvtHti/xiGD4d
         JLx7riLEFcP0k0hz4qM6t1iMZkJyIN0iXG0bDV48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 066/112] arm64: dts: imx8mp-phyboard-pollux-rdk: correct eqos pad settings
Date:   Mon, 11 Jul 2022 11:07:06 +0200
Message-Id: <20220711090551.447345801@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UPPERCASE_50_75
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit bae4de618efe1c41d34aa2e6cef8b08e46256667 ]

BIT3 and BIT0 are reserved bits, should not touch.

Fixes: 6f96852619d5 ("arm64: dts: freescale: Add support EQOS MAC on phyBOARD-Pollux-i.MX8MP")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../freescale/imx8mp-phyboard-pollux-rdk.dts  | 28 +++++++++----------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-phyboard-pollux-rdk.dts b/arch/arm64/boot/dts/freescale/imx8mp-phyboard-pollux-rdk.dts
index e34076954897..cefd3d36f93f 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-phyboard-pollux-rdk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-phyboard-pollux-rdk.dts
@@ -116,20 +116,20 @@
 &iomuxc {
 	pinctrl_eqos: eqosgrp {
 		fsl,pins = <
-			MX8MP_IOMUXC_ENET_MDC__ENET_QOS_MDC			0x3
-			MX8MP_IOMUXC_ENET_MDIO__ENET_QOS_MDIO			0x3
-			MX8MP_IOMUXC_ENET_RD0__ENET_QOS_RGMII_RD0		0x91
-			MX8MP_IOMUXC_ENET_RD1__ENET_QOS_RGMII_RD1		0x91
-			MX8MP_IOMUXC_ENET_RD2__ENET_QOS_RGMII_RD2		0x91
-			MX8MP_IOMUXC_ENET_RD3__ENET_QOS_RGMII_RD3		0x91
-			MX8MP_IOMUXC_ENET_RXC__CCM_ENET_QOS_CLOCK_GENERATE_RX_CLK	0x91
-			MX8MP_IOMUXC_ENET_RX_CTL__ENET_QOS_RGMII_RX_CTL		0x91
-			MX8MP_IOMUXC_ENET_TD0__ENET_QOS_RGMII_TD0		0x1f
-			MX8MP_IOMUXC_ENET_TD1__ENET_QOS_RGMII_TD1		0x1f
-			MX8MP_IOMUXC_ENET_TD2__ENET_QOS_RGMII_TD2		0x1f
-			MX8MP_IOMUXC_ENET_TD3__ENET_QOS_RGMII_TD3		0x1f
-			MX8MP_IOMUXC_ENET_TX_CTL__ENET_QOS_RGMII_TX_CTL		0x1f
-			MX8MP_IOMUXC_ENET_TXC__CCM_ENET_QOS_CLOCK_GENERATE_TX_CLK	0x1f
+			MX8MP_IOMUXC_ENET_MDC__ENET_QOS_MDC			0x2
+			MX8MP_IOMUXC_ENET_MDIO__ENET_QOS_MDIO			0x2
+			MX8MP_IOMUXC_ENET_RD0__ENET_QOS_RGMII_RD0		0x90
+			MX8MP_IOMUXC_ENET_RD1__ENET_QOS_RGMII_RD1		0x90
+			MX8MP_IOMUXC_ENET_RD2__ENET_QOS_RGMII_RD2		0x90
+			MX8MP_IOMUXC_ENET_RD3__ENET_QOS_RGMII_RD3		0x90
+			MX8MP_IOMUXC_ENET_RXC__CCM_ENET_QOS_CLOCK_GENERATE_RX_CLK	0x90
+			MX8MP_IOMUXC_ENET_RX_CTL__ENET_QOS_RGMII_RX_CTL		0x90
+			MX8MP_IOMUXC_ENET_TD0__ENET_QOS_RGMII_TD0		0x16
+			MX8MP_IOMUXC_ENET_TD1__ENET_QOS_RGMII_TD1		0x16
+			MX8MP_IOMUXC_ENET_TD2__ENET_QOS_RGMII_TD2		0x16
+			MX8MP_IOMUXC_ENET_TD3__ENET_QOS_RGMII_TD3		0x16
+			MX8MP_IOMUXC_ENET_TX_CTL__ENET_QOS_RGMII_TX_CTL		0x16
+			MX8MP_IOMUXC_ENET_TXC__CCM_ENET_QOS_CLOCK_GENERATE_TX_CLK	0x16
 			MX8MP_IOMUXC_SAI1_MCLK__GPIO4_IO20			0x10
 		>;
 	};
-- 
2.35.1



