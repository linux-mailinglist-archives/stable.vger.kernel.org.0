Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A169E64F5BD
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 01:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbiLQAM1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 19:12:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiLQALj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 19:11:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1EEDE1A;
        Fri, 16 Dec 2022 16:10:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91DD4B81E56;
        Sat, 17 Dec 2022 00:10:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E35BC433D2;
        Sat, 17 Dec 2022 00:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671235837;
        bh=szzF0nqELXBbcHSgIINGEe0Mevl8C6tCferRbhARNgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y7LRS/cdlcbrPVF8I8rIUebVeGu7loiZ+rk+Fa43TWUHMG4y8oLf2lAbCxKkXidt/
         PxhAc0w5kYKODP6T5UdZQ1D/cCDrk9hxeKYuD7Z4kcObQY6oqXScuQQSZxS4izKpaH
         rgjA/VJukfsynFg8Z5EZXNw4bOdfDLUey1nwHKMHhEO1CCGeIp3SGe9rE5vrIRjiVl
         6d4Oc+T2rQYoxueoqXGSUnQuZRYV4/dKJUOLh3Sj3Ia7ZXVs85LFInx1TxcBd1ATsF
         +BDvOg3BvPUsBMkO/GGhX13cNnctagAz4YgVbm96HJGtjt6lLb9kP/8m28RWGvY2hG
         PONoQWPnGgb0Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marijn Suijten <marijn.suijten@somainline.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Luca Weiss <luca.weiss@fairphone.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 8/8] arm64: dts: qcom: sm6350: Add apps_smmu with streamID to SDHCI 1/2 nodes
Date:   Fri, 16 Dec 2022 19:10:12 -0500
Message-Id: <20221217001013.41239-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221217001013.41239-1-sashal@kernel.org>
References: <20221217001013.41239-1-sashal@kernel.org>
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

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit 7372b944a6ba5ac86628eaacc89ed4f103435cb9 ]

When enabling the APPS SMMU the mainline driver reconfigures the SMMU
from its bootloader configuration, losing the stream mapping for (among
which) the SDHCI hardware and breaking its ADMA feature.  This feature
can be disabled with:

    sdhci.debug_quirks=0x40

But it is of course desired to have this feature enabled and working
through the SMMU.

Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Reviewed-by: Luca Weiss <luca.weiss@fairphone.com>
Tested-by: Luca Weiss <luca.weiss@fairphone.com> # sm7225-fairphone-fp4
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221030073232.22726-11-marijn.suijten@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6350.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm6350.dtsi b/arch/arm64/boot/dts/qcom/sm6350.dtsi
index d06aefdf3d9e..f4cf49b4848b 100644
--- a/arch/arm64/boot/dts/qcom/sm6350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6350.dtsi
@@ -482,6 +482,7 @@ sdhc_1: mmc@7c4000 {
 			interrupts = <GIC_SPI 641 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 644 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "hc_irq", "pwr_irq";
+			iommus = <&apps_smmu 0x60 0x0>;
 
 			clocks = <&gcc GCC_SDCC1_AHB_CLK>,
 				 <&gcc GCC_SDCC1_APPS_CLK>,
@@ -928,6 +929,7 @@ sdhc_2: mmc@8804000 {
 			interrupts = <GIC_SPI 204 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 222 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "hc_irq", "pwr_irq";
+			iommus = <&apps_smmu 0x560 0x0>;
 
 			clocks = <&gcc GCC_SDCC2_AHB_CLK>,
 				 <&gcc GCC_SDCC2_APPS_CLK>,
-- 
2.35.1

