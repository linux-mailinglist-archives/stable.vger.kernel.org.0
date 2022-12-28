Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5210F65782E
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233044AbiL1OsT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:48:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233098AbiL1Orx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:47:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485871183A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:47:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCA27B81710
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:47:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 353DAC433D2;
        Wed, 28 Dec 2022 14:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672238869;
        bh=WEmTKAh+yQ4BBPrEBaGs+/pD5VE6wJurxv04t/LRfQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pd3IpVHPo6nf6/T4W/drw7sN2m1Ch4Lc0dbqPEYP3t1opcOjm7EG+j04p2AzQL9eg
         ZgLsslQNC9fezrKS7hZayE2nEUVbJ4p63d+hTTtc3mjkMXSXPW3B30k8fdr1eF1pOo
         w4aeLs0KMw4KGD0tgpXYH6jIDvgF9Mzt00sj8lFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 040/731] arm64: dts: mt2712e: Fix unit_address_vs_reg warning for oscillators
Date:   Wed, 28 Dec 2022 15:32:27 +0100
Message-Id: <20221228144257.716687349@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit e4495a0a8b3d84816c9a46edf3ce060bbf267475 ]

Rename the fixed-clock oscillators to remove the unit address.

This solves unit_address_vs_reg warnings.

Fixes: 5d4839709c8e ("arm64: dts: mt2712: Add clock controller device nodes")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20221013152212.416661-4-angelogioacchino.delregno@collabora.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt2712e.dtsi | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt2712e.dtsi b/arch/arm64/boot/dts/mediatek/mt2712e.dtsi
index a9cca9c146fd..1c55689383b8 100644
--- a/arch/arm64/boot/dts/mediatek/mt2712e.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt2712e.dtsi
@@ -160,70 +160,70 @@ sys_clk: dummyclk {
 		#clock-cells = <0>;
 	};
 
-	clk26m: oscillator@0 {
+	clk26m: oscillator-26m {
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
 		clock-frequency = <26000000>;
 		clock-output-names = "clk26m";
 	};
 
-	clk32k: oscillator@1 {
+	clk32k: oscillator-32k {
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
 		clock-frequency = <32768>;
 		clock-output-names = "clk32k";
 	};
 
-	clkfpc: oscillator@2 {
+	clkfpc: oscillator-50m {
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
 		clock-frequency = <50000000>;
 		clock-output-names = "clkfpc";
 	};
 
-	clkaud_ext_i_0: oscillator@3 {
+	clkaud_ext_i_0: oscillator-aud0 {
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
 		clock-frequency = <6500000>;
 		clock-output-names = "clkaud_ext_i_0";
 	};
 
-	clkaud_ext_i_1: oscillator@4 {
+	clkaud_ext_i_1: oscillator-aud1 {
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
 		clock-frequency = <196608000>;
 		clock-output-names = "clkaud_ext_i_1";
 	};
 
-	clkaud_ext_i_2: oscillator@5 {
+	clkaud_ext_i_2: oscillator-aud2 {
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
 		clock-frequency = <180633600>;
 		clock-output-names = "clkaud_ext_i_2";
 	};
 
-	clki2si0_mck_i: oscillator@6 {
+	clki2si0_mck_i: oscillator-i2s0 {
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
 		clock-frequency = <30000000>;
 		clock-output-names = "clki2si0_mck_i";
 	};
 
-	clki2si1_mck_i: oscillator@7 {
+	clki2si1_mck_i: oscillator-i2s1 {
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
 		clock-frequency = <30000000>;
 		clock-output-names = "clki2si1_mck_i";
 	};
 
-	clki2si2_mck_i: oscillator@8 {
+	clki2si2_mck_i: oscillator-i2s2 {
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
 		clock-frequency = <30000000>;
 		clock-output-names = "clki2si2_mck_i";
 	};
 
-	clktdmin_mclk_i: oscillator@9 {
+	clktdmin_mclk_i: oscillator-mclk {
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
 		clock-frequency = <30000000>;
-- 
2.35.1



