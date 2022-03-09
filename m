Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1ABC4D3476
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234557AbiCIQZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:25:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238032AbiCIQVO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:21:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3778B2BB01;
        Wed,  9 Mar 2022 08:17:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13DC2B821FD;
        Wed,  9 Mar 2022 16:17:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED288C340EC;
        Wed,  9 Mar 2022 16:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646842672;
        bh=7D3pUXqXjHzFHv7MUp8ajskK4tYH1lFUmXAWGDVys2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d24K6rXBeFma+DRehRgtoQeVRn0TxhhzldaBLecJfNcmWoTW5UfD7wpwpEVG6NTXV
         Q1eCK+cSzqnUzvMDeOjkyFiRZSAbXZ3FXI4/D/UrT9MowVS60lNiDPuEL5KyhVwg3Q
         2xu7Ci4+XYkJ5zvcVp2FOJmq4J+J9cwtb65qGquVOc0eIJYMNtkuig+/jhXOz83oOU
         0Z7NLUYdJ1bXr0ptfjThYO+o8kinTuKtl7WVNWALbBmPEocjh0T1DL1L5CMM0CnbIh
         46Ov5mXs1X0e32N+EY7ak98yUgvk94/ocd/9LDPm++F1Q3Sqq0WvNMg3lgz70ynYBy
         dQ04hkD6cCINQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        jbx6244@gmail.com, benjamin.gaignard@collabora.com,
        jon.lin@rock-chips.com, paul.kocialkowski@bootlin.com,
        macromorgan@hotmail.com, maccraft123mc@gmail.com,
        zhangqing@rock-chips.com, davem@davemloft.net, knaerzche@gmail.com,
        cnemo@tutanota.com, ezequiel@vanguardiasur.com.ar,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.16 06/27] arm64: dts: rockchip: align pl330 node name with dtschema
Date:   Wed,  9 Mar 2022 11:16:43 -0500
Message-Id: <20220309161711.135679-6-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220309161711.135679-1-sashal@kernel.org>
References: <20220309161711.135679-1-sashal@kernel.org>
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
@@ -711,7 +711,7 @@ rktimer: timer@ff210000 {
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
@@ -489,7 +489,7 @@ pwm3: pwm@ff1b0030 {
 		status = "disabled";
 	};
 
-	dmac: dmac@ff1f0000 {
+	dmac: dma-controller@ff1f0000 {
 		compatible = "arm,pl330", "arm,primecell";
 		reg = <0x0 0xff1f0000 0x0 0x4000>;
 		interrupts = <GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>,
-- 
2.34.1

