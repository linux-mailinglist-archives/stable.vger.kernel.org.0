Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8739F594660
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351929AbiHOWyb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351974AbiHOWw3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:52:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35AE6139DB7;
        Mon, 15 Aug 2022 12:54:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EED99B80EAD;
        Mon, 15 Aug 2022 19:54:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57EBCC433D6;
        Mon, 15 Aug 2022 19:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593278;
        bh=/cGEn+6BCeTjq2+UqwOMiLt2G6tohuKeiGuDl+l7d1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L8TmRXjBbEfbVoKMG+540Aj7CTKG06hg9RDPtt/zvtjZ6j/1y3zfaReM7fqaT2I3S
         HfyQN15771iSk8Kn4YCCsynRyrzxClikJRdCCsbkULBUYjLsXTNUvfgZDYJcPRyX+4
         Bb0KqKvj7pGSLLJrxYyIanviTs5b4Xfg6/NwpGCw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Weiss <luca@z3ntu.xyz>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0240/1157] ARM: dts: qcom-msm8974: fix irq type on blsp2_uart1
Date:   Mon, 15 Aug 2022 19:53:16 +0200
Message-Id: <20220815180449.157971905@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index c3b8a6d63027..ce9cb5e4e95d 100644
--- a/arch/arm/boot/dts/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
@@ -580,7 +580,7 @@ blsp2_dma: dma-controller@f9944000 {
 		blsp2_uart1: serial@f995d000 {
 			compatible = "qcom,msm-uartdm-v1.4", "qcom,msm-uartdm";
 			reg = <0xf995d000 0x1000>;
-			interrupts = <GIC_SPI 113 IRQ_TYPE_NONE>;
+			interrupts = <GIC_SPI 113 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&gcc GCC_BLSP2_UART1_APPS_CLK>, <&gcc GCC_BLSP2_AHB_CLK>;
 			clock-names = "core", "iface";
 			pinctrl-names = "default", "sleep";
-- 
2.35.1



