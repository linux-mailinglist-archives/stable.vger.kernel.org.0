Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94C8E58C041
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243223AbiHHBtg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243180AbiHHBsm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:48:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4201658D;
        Sun,  7 Aug 2022 18:37:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4ED860DF5;
        Mon,  8 Aug 2022 01:37:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26EBBC433D7;
        Mon,  8 Aug 2022 01:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922635;
        bh=N2/qNlfn1NrRpb3l/ZqIDoo9ANS0WmXcev3dBXNe8Vk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YCSPxOo/1BvhnmeBxmzRdIvUjoMlohoj9N32iVUL9Km1ZbbHVo2N7io2r7hUFSQqU
         /VcVQSAjbr7yt0ghTFStPqwU0B+uP9qsxlQuYQq/i9CfBYftWwlZrpd7ouoBKTNg88
         YCGoWEuLeZgp/sgOgdVGDGuod9ifbthlLWYKvnKA0gDrfcWIMILJNr1rleE+XWdW3Y
         Z1igCvVNjIbZ+BQvtuOE8w9fo7FmxSLQLR3/i+jJAC+EeJNs3ezXzUm6WwO2OnWrxY
         O+SrrcoFjJC+cQTAWlOzawyQahgxcwnEbyoL2ORR2ApxNyR+7x4uAVTYq/fAciJ7lx
         UWcG+XoPxfYjQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 34/45] ARM: dts: qcom: sdx55: Fix the IRQ trigger type for UART
Date:   Sun,  7 Aug 2022 21:35:38 -0400
Message-Id: <20220808013551.315446-34-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013551.315446-1-sashal@kernel.org>
References: <20220808013551.315446-1-sashal@kernel.org>
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
index b5b784c5c65e..0e76d03087fe 100644
--- a/arch/arm/boot/dts/qcom-sdx55.dtsi
+++ b/arch/arm/boot/dts/qcom-sdx55.dtsi
@@ -205,7 +205,7 @@ gcc: clock-controller@100000 {
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

