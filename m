Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37BF25FD026
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbiJMAYt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbiJMAXd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:23:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA7E7694D;
        Wed, 12 Oct 2022 17:20:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F3E7B81CD1;
        Thu, 13 Oct 2022 00:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 492F4C433D7;
        Thu, 13 Oct 2022 00:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620418;
        bh=DT34wFDOhYtkYS2iDOEeLPykJkGmz98cX+en54BTCts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FZMCubUWLSelRAETLBw79tz38bZjRHMKyeFm7ZVOZxeJPHMmBW/BwrASnmM2qEaX2
         UVkqPHDkGOmDBcO7MbRqUO1k8WaIpwf2leQLSDmmKwwwpVD/ywpOnvLgQ+aijHTUCz
         X/nTnDH2QLyNN5XQgaeRsyp92Ub+1yxvjSt49Zw1Jk1CI0VK0Q9kPvailwNrActskY
         wkOfm+IymdQQuTFEBi+GmVKP/vsOaijn8bTKD6+0TZfSAa3OEay+ruFYWYb1k8JpGO
         wAfeWbXskwYG9QCchCAilzT++iD+MH0JjRsbEDeDl4qAjymZdHg13XWtAW6C6Penk+
         K1rUTWVbavScg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, shawnguo@kernel.org,
        l.stach@pengutronix.de, laurent.pinchart@ideasonboard.com,
        peng.fan@nxp.com, marex@denx.de, festevam@gmail.com,
        qiangqing.zhang@nxp.com, hongxing.zhu@nxp.com,
        paul.elder@ideasonboard.com, Markus.Niebel@ew.tq-group.com,
        aford173@gmail.com, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.19 39/63] arm64: dts: imx8mp: Add snps,gfladj-refclk-lpm-sel quirk to USB nodes
Date:   Wed, 12 Oct 2022 20:18:13 -0400
Message-Id: <20221013001842.1893243-39-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013001842.1893243-1-sashal@kernel.org>
References: <20221013001842.1893243-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 5c3d5ecf48ab06c709c012bf1e8f0c91e1fcd7ad ]

With this set the SOF/ITP counter is based on ref_clk when 2.0 ports are
suspended.
snps,dis-u2-freeclk-exists-quirk can be removed as
snps,gfladj-refclk-lpm-sel also clears the free running clock configuration
bit.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://lore.kernel.org/r/20220915062855.751881-4-alexander.stein@ew.tq-group.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp.dtsi b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
index 410d0d5e6f1e..7faf2d71ba4f 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
@@ -1168,7 +1168,7 @@ usb_dwc3_0: usb@38100000 {
 				interrupts = <GIC_SPI 40 IRQ_TYPE_LEVEL_HIGH>;
 				phys = <&usb3_phy0>, <&usb3_phy0>;
 				phy-names = "usb2-phy", "usb3-phy";
-				snps,dis-u2-freeclk-exists-quirk;
+				snps,gfladj-refclk-lpm-sel-quirk;
 			};
 
 		};
@@ -1210,7 +1210,7 @@ usb_dwc3_1: usb@38200000 {
 				interrupts = <GIC_SPI 41 IRQ_TYPE_LEVEL_HIGH>;
 				phys = <&usb3_phy1>, <&usb3_phy1>;
 				phy-names = "usb2-phy", "usb3-phy";
-				snps,dis-u2-freeclk-exists-quirk;
+				snps,gfladj-refclk-lpm-sel-quirk;
 			};
 		};
 
-- 
2.35.1

