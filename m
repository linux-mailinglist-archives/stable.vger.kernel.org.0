Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C02553A6CD
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 15:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346897AbiFANzt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 09:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353717AbiFANzX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 09:55:23 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E65328DDF2;
        Wed,  1 Jun 2022 06:54:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 71DB5CE1A23;
        Wed,  1 Jun 2022 13:54:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE10C34119;
        Wed,  1 Jun 2022 13:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091667;
        bh=cxgcH3SBCy9umCZCgXiZp8Edk8+bIdtQdn75xOEmsXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DW1nxVViUr15aDfQgHMZ3GQgpQyoun7Ltm3hyoPFIX4MLnPMvM1OVfzCb0y2vx/f7
         3MsDLKWrd8pqIrOVZASXyfwOVMkKU8mQplCToRnA02lbRlST3vC3Lpuzl7gqx1iFQ9
         SV17/buWf0Sysbz4dbG291IRtABRWGkBNNoB/JbZdCj9v2mWRjQOqlK/37CpO7x6ow
         nzd5+wDF4/6mCj7qAXbrsP7GEqBI1gXtJz9Q4XDwa94njeo0huO1ht5nL7CRUIUz2+
         DWnfnHl5SzMn2NX1Fig4VAccIgVLl1nNDNVND3EpH7eC8D7UVdQh3dFXsSvQCHFKS/
         NQyFi5YnoADSQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 04/48] ARM: dts: socfpga: align interrupt controller node name with dtschema
Date:   Wed,  1 Jun 2022 09:53:37 -0400
Message-Id: <20220601135421.2003328-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135421.2003328-1-sashal@kernel.org>
References: <20220601135421.2003328-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit c9bdd50d2019f78bf4c1f6a79254c27771901023 ]

Fixes dtbs_check warnings like:

  $nodename:0: 'intc@fffed000' does not match '^interrupt-controller(@[0-9a-f,]+)*$'

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Acked-by: Dinh Nguyen <dinguyen@kernel.org>
Link: https://lore.kernel.org/r/20220317115705.450427-2-krzysztof.kozlowski@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/socfpga.dtsi         | 2 +-
 arch/arm/boot/dts/socfpga_arria10.dtsi | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
index 7c1d6423d7f8..b8c5dd7860cb 100644
--- a/arch/arm/boot/dts/socfpga.dtsi
+++ b/arch/arm/boot/dts/socfpga.dtsi
@@ -46,7 +46,7 @@ pmu: pmu@ff111000 {
 		      <0xff113000 0x1000>;
 	};
 
-	intc: intc@fffed000 {
+	intc: interrupt-controller@fffed000 {
 		compatible = "arm,cortex-a9-gic";
 		#interrupt-cells = <3>;
 		interrupt-controller;
diff --git a/arch/arm/boot/dts/socfpga_arria10.dtsi b/arch/arm/boot/dts/socfpga_arria10.dtsi
index 3ba431dfa8c9..f1e50d2e623a 100644
--- a/arch/arm/boot/dts/socfpga_arria10.dtsi
+++ b/arch/arm/boot/dts/socfpga_arria10.dtsi
@@ -38,7 +38,7 @@ pmu: pmu@ff111000 {
 		      <0xff113000 0x1000>;
 	};
 
-	intc: intc@ffffd000 {
+	intc: interrupt-controller@ffffd000 {
 		compatible = "arm,cortex-a9-gic";
 		#interrupt-cells = <3>;
 		interrupt-controller;
-- 
2.35.1

