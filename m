Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C46245743A5
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237672AbiGNEhl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236220AbiGNEhF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:37:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D3B93D5BC;
        Wed, 13 Jul 2022 21:26:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 345CC61E5C;
        Thu, 14 Jul 2022 04:26:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88B57C34115;
        Thu, 14 Jul 2022 04:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772809;
        bh=aluQHv286Aoi7OvfkwIRBdVBjt90I8dJ2JRkySyyPDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=da5umemMxuTgC2fXlSYefTw32rEI4k0zILX2v9X19llq61A6mIX7Sw2J4cmzc/gsT
         eNK0Xp7Ubzxb7/OnxUBw9/Xdkm+3wRicsymtkzVgHEIWSEJ8aNmJ28WF4DPdfjoFoC
         XTty2cNceiDIHFlgMpBbYDH61eVi75MRbIV00UaTheEwKkLIbI+F9tjawMQk/Yy0RL
         T5TJKXJPUcMj6F4LYkx93jrCCuK+NhvU5uRdoteHPaaZLaVE55OyUQnGqVWsoLzM/r
         5RFZ3gZpTgfjqAUU3lld3sRuh1TiMwHHeH/IxDFY1kHfEy6EU0pX/x78kJZY04rQ8D
         QyRevyxX6k1eg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gabriel Fernandez <gabriel.fernandez@foss.st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, mcoquelin.stm32@gmail.com,
        devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 5/6] ARM: dts: stm32: use the correct clock source for CEC on stm32mp151
Date:   Thu, 14 Jul 2022 00:26:35 -0400
Message-Id: <20220714042637.282511-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714042637.282511-1-sashal@kernel.org>
References: <20220714042637.282511-1-sashal@kernel.org>
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

From: Gabriel Fernandez <gabriel.fernandez@foss.st.com>

[ Upstream commit 78ece8cce1ba0c3f3e5a7c6c1b914b3794f04c44 ]

The peripheral clock of CEC is not LSE but CEC.

Signed-off-by: Gabriel Fernandez <gabriel.fernandez@foss.st.com>
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp157c.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/stm32mp157c.dtsi b/arch/arm/boot/dts/stm32mp157c.dtsi
index 4278a4b22860..7c5b2727ba2e 100644
--- a/arch/arm/boot/dts/stm32mp157c.dtsi
+++ b/arch/arm/boot/dts/stm32mp157c.dtsi
@@ -413,7 +413,7 @@ cec: cec@40016000 {
 			compatible = "st,stm32-cec";
 			reg = <0x40016000 0x400>;
 			interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc CEC_K>, <&clk_lse>;
+			clocks = <&rcc CEC_K>, <&rcc CEC>;
 			clock-names = "cec", "hdmi-cec";
 			status = "disabled";
 		};
-- 
2.35.1

