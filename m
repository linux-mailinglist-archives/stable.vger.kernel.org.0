Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C27DC4DC6C3
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 13:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234286AbiCQMzt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 08:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235051AbiCQMyb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 08:54:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 755A83B00E;
        Thu, 17 Mar 2022 05:53:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BE20B81E5C;
        Thu, 17 Mar 2022 12:53:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D9D6C340ED;
        Thu, 17 Mar 2022 12:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647521592;
        bh=j1bNvp8+7Dxv3PwhV/qjUZjvW3kzu3o9Fl0oVcTEDKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BMyGKRREKbFX71SoEskw3R9dSrBjhPpRlCt8E1Semmf77szEtmDRoCTFFT97hv0l0
         pn1dM5RHiaLR54f0frc2h3BFlT+34srMhDO2WO+t6fQaVEAUh0fqWgNGiG1itLfhSu
         5WgRpvUxjow8hBDMKb9jpFaNtdyXYCUW5R68X0zo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frank Wunderlich <frank-w@public-files.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 02/28] arm64: dts: rockchip: fix dma-controller node names on rk356x
Date:   Thu, 17 Mar 2022 13:45:53 +0100
Message-Id: <20220317124526.839790483@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220317124526.768423926@linuxfoundation.org>
References: <20220317124526.768423926@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -647,7 +647,7 @@
 		status = "disabled";
 	};
 
-	dmac0: dmac@fe530000 {
+	dmac0: dma-controller@fe530000 {
 		compatible = "arm,pl330", "arm,primecell";
 		reg = <0x0 0xfe530000 0x0 0x4000>;
 		interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>,
@@ -658,7 +658,7 @@
 		#dma-cells = <1>;
 	};
 
-	dmac1: dmac@fe550000 {
+	dmac1: dma-controller@fe550000 {
 		compatible = "arm,pl330", "arm,primecell";
 		reg = <0x0 0xfe550000 0x0 0x4000>;
 		interrupts = <GIC_SPI 16 IRQ_TYPE_LEVEL_HIGH>,
-- 
2.34.1



