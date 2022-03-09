Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE5264D346D
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235387AbiCIQZG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:25:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237900AbiCIQVI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:21:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6B81451E9;
        Wed,  9 Mar 2022 08:17:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 389296194C;
        Wed,  9 Mar 2022 16:17:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ACAEC340E8;
        Wed,  9 Mar 2022 16:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646842641;
        bh=Uy23ZolzuI1RPojDcKbOT+RVaAD15FgdKsEPlpak3Ic=;
        h=From:To:Cc:Subject:Date:From;
        b=eu0cq5nKT9mDIwdLPyvYdQTNAswY1B78OWx2tcL6BIfIwnHkxuSvqApH3+DxXfxJ0
         TZMrrNRknAoVmgLlpOfD9jnFaa77aQonVMrFsRZno/6vjlyimcwiJKnC2ljQ9fcRr2
         u0RaBwM4N8JxJKo5RKIlG/lKrcE06LIKurW2lnmVZPhimcl6z8QAAEJFtnrIZMmLrs
         IEpI9pUDr0YTEgiRksdRgRAroOx4BdBSwcC9u777Cxtk/Ib8YHCs/eENePFztwzbEg
         GuHclo8r7fzDf8D+4mvKHqJYIlz2GgL80h8hud/Qtjr0IcpDH0Drad27SmhUE5OBkt
         YHjLzCzzBiGFA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        pgwipeout@gmail.com, cl@rock-chips.com,
        michael.riesch@wolfvision.net, frattaroli.nicolas@gmail.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.16 01/27] arm64: dts: rockchip: fix dma-controller node names on rk356x
Date:   Wed,  9 Mar 2022 11:16:38 -0500
Message-Id: <20220309161711.135679-1-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frank Wunderlich <frank-w@public-files.de>

[ Upstream commit 2ddd96aadbd0412040ef49eda94549c32de6c92c ]

DMA-Cotrollers defined in rk356x.dtsi do not match the pattern in bindings.

arch/arm64/boot/dts/rockchip/rk3568-evb1-v10.dt.yaml:
  dmac@fe530000: $nodename:0: 'dmac@fe530000' does not match '^dma-controller(@.*)?$'
	From schema: Documentation/devicetree/bindings/dma/arm,pl330.yaml
arch/arm64/boot/dts/rockchip/rk3568-evb1-v10.dt.yaml:
  dmac@fe550000: $nodename:0: 'dmac@fe550000' does not match '^dma-controller(@.*)?$'
	From schema: Documentation/devicetree/bindings/dma/arm,pl330.yaml

This Patch fixes it.

Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
Link: https://lore.kernel.org/r/20220123133615.135789-1-linux@fw-web.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk356x.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk356x.dtsi b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
index 46d9552f6028..688e3585525a 100644
--- a/arch/arm64/boot/dts/rockchip/rk356x.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
@@ -647,7 +647,7 @@ &i2s1m0_sdo0   &i2s1m0_sdo1
 		status = "disabled";
 	};
 
-	dmac0: dmac@fe530000 {
+	dmac0: dma-controller@fe530000 {
 		compatible = "arm,pl330", "arm,primecell";
 		reg = <0x0 0xfe530000 0x0 0x4000>;
 		interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>,
@@ -658,7 +658,7 @@ dmac0: dmac@fe530000 {
 		#dma-cells = <1>;
 	};
 
-	dmac1: dmac@fe550000 {
+	dmac1: dma-controller@fe550000 {
 		compatible = "arm,pl330", "arm,primecell";
 		reg = <0x0 0xfe550000 0x0 0x4000>;
 		interrupts = <GIC_SPI 16 IRQ_TYPE_LEVEL_HIGH>,
-- 
2.34.1

