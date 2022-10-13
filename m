Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 818585FD042
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbiJMAZR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231276AbiJMAYM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:24:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FFD112344F;
        Wed, 12 Oct 2022 17:22:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28AC8616EE;
        Thu, 13 Oct 2022 00:22:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF9FC433C1;
        Thu, 13 Oct 2022 00:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620567;
        bh=G51MCD2AWfWPqZVPP8/x7FUWdHLTCTvBUkDb5r8072U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nSVMCTpjkZCexDjYDTkTUm/veOxbLHtYEwDxZfCKoSW8S9SzvJqN4kxcNCA0SS1h6
         Xw0vnOuqwrZjdnVvhlxRS1lPf96blkxBAusjDiG/FD7qKPnFWjGvn+usXeS6aqohrs
         n6pIY4f3fy0fpt5cU3ar+KHpriahs4z2fh9zjDiLvLQTlp3ctruxjBnnYSuCIA73b7
         l0RRh7trR90wGBMwNGf5jZAnMySFEX+AFBk9sUE5j/W+Bi+tmpaFWNu4mbj472jwLk
         w7awW38IFIai880bxkM+L9SSE/4pYdeuqSRChsDheAaalZl/QQqgSTWROLsAHEMgRF
         0ec21SNehS8tA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, shawnguo@kernel.org,
        l.stach@pengutronix.de, peng.fan@nxp.com,
        laurent.pinchart@ideasonboard.com, marex@denx.de,
        festevam@gmail.com, hongxing.zhu@nxp.com,
        paul.elder@ideasonboard.com, Markus.Niebel@ew.tq-group.com,
        aford173@gmail.com, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 31/47] arm64: dts: imx8mp: Add snps,gfladj-refclk-lpm-sel quirk to USB nodes
Date:   Wed, 12 Oct 2022 20:21:06 -0400
Message-Id: <20221013002124.1894077-31-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013002124.1894077-1-sashal@kernel.org>
References: <20221013002124.1894077-1-sashal@kernel.org>
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
index 9b07b26230a1..664177ed38d3 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
@@ -912,7 +912,7 @@ usb_dwc3_0: usb@38100000 {
 				interrupts = <GIC_SPI 40 IRQ_TYPE_LEVEL_HIGH>;
 				phys = <&usb3_phy0>, <&usb3_phy0>;
 				phy-names = "usb2-phy", "usb3-phy";
-				snps,dis-u2-freeclk-exists-quirk;
+				snps,gfladj-refclk-lpm-sel-quirk;
 			};
 
 		};
@@ -953,7 +953,7 @@ usb_dwc3_1: usb@38200000 {
 				interrupts = <GIC_SPI 41 IRQ_TYPE_LEVEL_HIGH>;
 				phys = <&usb3_phy1>, <&usb3_phy1>;
 				phy-names = "usb2-phy", "usb3-phy";
-				snps,dis-u2-freeclk-exists-quirk;
+				snps,gfladj-refclk-lpm-sel-quirk;
 			};
 		};
 
-- 
2.35.1

