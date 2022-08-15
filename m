Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3B405936CB
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242615AbiHOSj3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242071AbiHOSiq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:38:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DAEC2E69C;
        Mon, 15 Aug 2022 11:23:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CB46B81076;
        Mon, 15 Aug 2022 18:23:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FFCBC433C1;
        Mon, 15 Aug 2022 18:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587824;
        bh=yDgY5W1PnCPm4orjU4IIcbM58OJihAcMZtViHJqbfQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0KepEXYhVF+WW3qF0b7Zhcb3NLtr3UP/tgYq+WQKh6KDKgyYwaHFgbRfi4qYfF8PS
         1SZSDc5wTwuqgbCulPi0gYH6oe92eQB/sAp+z/cLFU+IDZoMWNgEPeceZboTRIZdAH
         AIuSlRvfCnU7gZK1JytGTa6G4jd8at8h7HWik2DE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Weiss <luca@z3ntu.xyz>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 189/779] ARM: dts: qcom-msm8974: fix irq type on blsp2_uart1
Date:   Mon, 15 Aug 2022 19:57:13 +0200
Message-Id: <20220815180345.333091971@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Weiss <luca@z3ntu.xyz>

[ Upstream commit ab1489017aa7a9f02e24bee73cf9ec8079cd3909 ]

IRQ_TYPE_NONE is invalid, so use the correct interrupt type.

Signed-off-by: Luca Weiss <luca@z3ntu.xyz>
Fixes: b05f82b152c9 ("ARM: dts: qcom: msm8974: Add blsp2_uart7 for bluetooth on sirius")
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220522083618.17894-1-luca@z3ntu.xyz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-msm8974.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/qcom-msm8974.dtsi b/arch/arm/boot/dts/qcom-msm8974.dtsi
index 2b01bc29ddf2..05d51839d40a 100644
--- a/arch/arm/boot/dts/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
@@ -718,7 +718,7 @@ blsp1_uart2: serial@f991e000 {
 		blsp2_uart7: serial@f995d000 {
 			compatible = "qcom,msm-uartdm-v1.4", "qcom,msm-uartdm";
 			reg = <0xf995d000 0x1000>;
-			interrupts = <GIC_SPI 113 IRQ_TYPE_NONE>;
+			interrupts = <GIC_SPI 113 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&gcc GCC_BLSP2_UART1_APPS_CLK>, <&gcc GCC_BLSP2_AHB_CLK>;
 			clock-names = "core", "iface";
 			status = "disabled";
-- 
2.35.1



