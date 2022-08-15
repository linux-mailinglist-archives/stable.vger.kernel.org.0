Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2566D593731
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242848AbiHOSbk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243074AbiHOSaj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:30:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C532C135;
        Mon, 15 Aug 2022 11:20:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FAEB60ED3;
        Mon, 15 Aug 2022 18:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AC98C433C1;
        Mon, 15 Aug 2022 18:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587617;
        bh=N2/qNlfn1NrRpb3l/ZqIDoo9ANS0WmXcev3dBXNe8Vk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qq3HotghUgYPURxWXmxak9B/mNeNSLcb/rXqz+HwjJ0ME1PfTd8NCX47g5diGXSiF
         XSDCcF2eM+7Znwqr0iqjks3WCGZIxwnQW1jzAUQQ9z2PTg+KldoUaCa4LDwhvWFPJ+
         lxwpSRv7qKJX9rG4hYG6rldFeKd/9IyYRYe0a3Ts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 140/779] ARM: dts: qcom: sdx55: Fix the IRQ trigger type for UART
Date:   Mon, 15 Aug 2022 19:56:24 +0200
Message-Id: <20220815180343.299410608@linuxfoundation.org>
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



