Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7A053A65C
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 15:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353473AbiFANw6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 09:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353386AbiFANwZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 09:52:25 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F8392DD56;
        Wed,  1 Jun 2022 06:52:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 81005CE1A21;
        Wed,  1 Jun 2022 13:52:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 194D0C3411D;
        Wed,  1 Jun 2022 13:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091541;
        bh=cxgcH3SBCy9umCZCgXiZp8Edk8+bIdtQdn75xOEmsXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ku185ggBVbJKp9TQvsst2WXva/gxi0M5fwpJOGFZljP8mUZqk19U+4CUVWIx90xfK
         92PY45ZCP+FjowLlQ773OpI89/gZWnw4m5/8R/g0c6uZiRnDVsMfayIeeZprZub/9y
         OEXE7PlTy9fF2XeUgUktZ0ZL1xhEdwrT0vNfVXuzINmKFKJtxvkYfRt9ZWxAQcijHv
         5x4Y5r3IgKhiQ73PimhKLiZp7R6Xzq0WQbxUVjtskDvsp4iwWlb0cHb3BMeLDmkTrt
         QOL1TLBdfTRBhLcgPaivZYc3KZcCwniqUY1B2+87lesF4+soGQPaU7AvUMiW7O7e0c
         RnDWTpxiRh26w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 04/49] ARM: dts: socfpga: align interrupt controller node name with dtschema
Date:   Wed,  1 Jun 2022 09:51:28 -0400
Message-Id: <20220601135214.2002647-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135214.2002647-1-sashal@kernel.org>
References: <20220601135214.2002647-1-sashal@kernel.org>
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

