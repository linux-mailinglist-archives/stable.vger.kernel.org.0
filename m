Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35C0D29BAEF
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802724AbgJ0PvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:51:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:43092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1802190AbgJ0Pp5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:45:57 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60AB321D42;
        Tue, 27 Oct 2020 15:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813556;
        bh=8SNNtuzrARVvmIzrpEB5X660higLB/V4bop+H40E/jk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gGlkl4FgBoRFRsZn61zHsGPFP7yLUv2By+xKcq8J5aYK6aUxRHEqrLONv6xPWSfqE
         uD6sp9lTFDb9VzJKm8G2jMUuslf5WNfcueFoFusWaERDRtLWOb3ZD+DAzcWJ1F1uIe
         cuCtIUnFElYuq68dDGsd1mHIxkprwEzIDoj+jz8o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 592/757] arm64: dts: qcom: msm8992: Fix UART interrupt property
Date:   Tue, 27 Oct 2020 14:54:02 +0100
Message-Id: <20201027135518.304282419@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit aa551bd7a04159cf2ca8806abe5da8012b59d058 ]

"interrupt" is not a valid property.

Fixes: 7f8bcc0c4cfe ("arm64: dts: qcom: msm8992: Add BLSP2_UART2 and I2C nodes")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20200829111209.32685-1-krzk@kernel.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8992.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8992.dtsi b/arch/arm64/boot/dts/qcom/msm8992.dtsi
index 188fff2095f11..8626b3a50eda7 100644
--- a/arch/arm64/boot/dts/qcom/msm8992.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8992.dtsi
@@ -335,7 +335,7 @@ blsp_i2c6: i2c@f9928000 {
 		blsp2_uart2: serial@f995e000 {
 			compatible = "qcom,msm-uartdm-v1.4", "qcom,msm-uartdm";
 			reg = <0xf995e000 0x1000>;
-			interrupt = <GIC_SPI 146 IRQ_TYPE_LEVEL_LOW>;
+			interrupts = <GIC_SPI 146 IRQ_TYPE_LEVEL_LOW>;
 			clock-names = "core", "iface";
 			clocks = <&gcc GCC_BLSP2_UART2_APPS_CLK>,
 				<&gcc GCC_BLSP2_AHB_CLK>;
-- 
2.25.1



