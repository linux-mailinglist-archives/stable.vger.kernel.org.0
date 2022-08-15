Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA09A593E1D
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344258AbiHOUhB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346007AbiHOUei (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:34:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF994D16B;
        Mon, 15 Aug 2022 12:06:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 755F2B81104;
        Mon, 15 Aug 2022 19:06:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D37C433D6;
        Mon, 15 Aug 2022 19:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590374;
        bh=eYdIiq6i7+oz5kC9QwEqKLyINkLBLeu8q8JqoqMwYYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ukW9UwdhDLduxJyF34lC/+cNsy/6OSCliNuOAgmzK4bxEsfxvPM3KBJOiSiSbaBPH
         wRIddZuURn8ICYRGIEdSjdqs6GFKqCUmYKVMkvAbAB/o4tzWsgJCWjFKa76MQ5cedS
         7K1QcrLp2Hw9mtM7wCU0zfCyt0ezY4lZrYa6lDPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Weiss <luca@z3ntu.xyz>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0240/1095] ARM: dts: qcom-msm8974: fix irq type on blsp2_uart1
Date:   Mon, 15 Aug 2022 19:53:59 +0200
Message-Id: <20220815180439.717676342@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
index 0091a4c29fff..ed3e46e7f96d 100644
--- a/arch/arm/boot/dts/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
@@ -562,7 +562,7 @@ blsp2_dma: dma-controller@f9944000 {
 		blsp2_uart1: serial@f995d000 {
 			compatible = "qcom,msm-uartdm-v1.4", "qcom,msm-uartdm";
 			reg = <0xf995d000 0x1000>;
-			interrupts = <GIC_SPI 113 IRQ_TYPE_NONE>;
+			interrupts = <GIC_SPI 113 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&gcc GCC_BLSP2_UART1_APPS_CLK>, <&gcc GCC_BLSP2_AHB_CLK>;
 			clock-names = "core", "iface";
 			status = "disabled";
-- 
2.35.1



