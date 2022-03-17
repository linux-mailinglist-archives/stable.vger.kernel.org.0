Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 823524DC70D
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 13:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234238AbiCQM4m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 08:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234272AbiCQM4C (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 08:56:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5465DDAFD0;
        Thu, 17 Mar 2022 05:54:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D822BB81E8F;
        Thu, 17 Mar 2022 12:54:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0115AC340E9;
        Thu, 17 Mar 2022 12:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647521649;
        bh=uhdsoUxxt7mQ3PMpzNkAu4PksDbXgWyjX6865DxB0aM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wpnZT4lPkjhHpa9X7lHp96GIPA6Bx4kAOj6Zi32MkEaoudp3StG/UCzywZxTjkvYC
         Q37K0ypN81cp1VmcRiAbXLTic/YshKLGowjr8PoK1HyMpAfAzz6C/QF63VDOKcsFe5
         ZnBgrHhDzFIZP4hm36t/729gmn2N0x3codFcbFkQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 07/28] arm64: dts: rockchip: align pl330 node name with dtschema
Date:   Thu, 17 Mar 2022 13:45:58 +0100
Message-Id: <20220317124526.980463534@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

[ Upstream commit 8fd9415042826c7609c588e5ef45f3e84237785f ]

Fixes dtbs_check warnings like:

  dmac@ff240000: $nodename:0: 'dmac@ff240000' does not match '^dma-controller(@.*)?$'

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Link: https://lore.kernel.org/r/20220129175429.298836-1-krzysztof.kozlowski@canonical.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/px30.dtsi   | 2 +-
 arch/arm64/boot/dts/rockchip/rk3328.dtsi | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/px30.dtsi b/arch/arm64/boot/dts/rockchip/px30.dtsi
index 00f50b05d55a..b72874c16a71 100644
--- a/arch/arm64/boot/dts/rockchip/px30.dtsi
+++ b/arch/arm64/boot/dts/rockchip/px30.dtsi
@@ -711,7 +711,7 @@
 		clock-names = "pclk", "timer";
 	};
 
-	dmac: dmac@ff240000 {
+	dmac: dma-controller@ff240000 {
 		compatible = "arm,pl330", "arm,primecell";
 		reg = <0x0 0xff240000 0x0 0x4000>;
 		interrupts = <GIC_SPI 1 IRQ_TYPE_LEVEL_HIGH>,
diff --git a/arch/arm64/boot/dts/rockchip/rk3328.dtsi b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
index 39db0b85b4da..b822533dc7f1 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
@@ -489,7 +489,7 @@
 		status = "disabled";
 	};
 
-	dmac: dmac@ff1f0000 {
+	dmac: dma-controller@ff1f0000 {
 		compatible = "arm,pl330", "arm,primecell";
 		reg = <0x0 0xff1f0000 0x0 0x4000>;
 		interrupts = <GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>,
-- 
2.34.1



