Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB0D58BFB5
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242622AbiHHBmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243157AbiHHBl4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:41:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B996E13D5E;
        Sun,  7 Aug 2022 18:35:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BFD27B80E06;
        Mon,  8 Aug 2022 01:35:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9D3C4347C;
        Mon,  8 Aug 2022 01:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922524;
        bh=PT+al3/X/j0Hg/eZTwUwoGO/zO2403tlyPrSpTLoZ2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G3Eckr1G5Q40I/vvvgc91JoPmATpJHnJaXHHsGcleC4RjzJH5HJBO0oIfdoSp8h3+
         LhIexENoq7mTCfP1vmXP5Wgkpc/7tjLq84EJXjDSvBvJ38f5bxtLattgzd73ySODFm
         OxEy2VH6IOAy74SAIV7aLLHTid5u/teoctz9DuFelw5lZozW4kN587iWUt/KgZ0GdW
         bxoowcUEeRFQ7Aw4h6KVmtH+oGp+Z2iAEKDTI5YhPgfDSGmJh9ZDoV/kachGKdPdlk
         fDcAx5d5+BznNSLr4yILn/8RtvhdZh0A/nMekypWqfDEYPaVPyh4Gx5JRjwtaNyjfU
         96tsnEm4FEyfg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 40/53] ARM: dts: qcom: sdx55: Fix the IRQ trigger type for UART
Date:   Sun,  7 Aug 2022 21:33:35 -0400
Message-Id: <20220808013350.314757-40-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013350.314757-1-sashal@kernel.org>
References: <20220808013350.314757-1-sashal@kernel.org>
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit ae500b351ab0006d933d804a2b7507fe1e98cecc ]

The trigger type should be LEVEL_HIGH. So fix it!

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220530080842.37024-2-manivannan.sadhasivam@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-sdx55.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/qcom-sdx55.dtsi b/arch/arm/boot/dts/qcom-sdx55.dtsi
index d455795da44c..b75e672c239d 100644
--- a/arch/arm/boot/dts/qcom-sdx55.dtsi
+++ b/arch/arm/boot/dts/qcom-sdx55.dtsi
@@ -206,7 +206,7 @@ gcc: clock-controller@100000 {
 		blsp1_uart3: serial@831000 {
 			compatible = "qcom,msm-uartdm-v1.4", "qcom,msm-uartdm";
 			reg = <0x00831000 0x200>;
-			interrupts = <GIC_SPI 26 IRQ_TYPE_LEVEL_LOW>;
+			interrupts = <GIC_SPI 26 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&gcc 30>,
 				 <&gcc 9>;
 			clock-names = "core", "iface";
-- 
2.35.1

