Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C30A75799AB
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238093AbiGSMFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238460AbiGSMEl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:04:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47934D173;
        Tue, 19 Jul 2022 05:00:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 296D461655;
        Tue, 19 Jul 2022 12:00:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5961C341C6;
        Tue, 19 Jul 2022 12:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232035;
        bh=unMjRxV9B57/SVaAiTiFqUzSDFDTbSuXiPtR/Jf1iHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=trc2HGd080FFcVabFIRX0tdmN+6p4nFFaCK3Ts3S4WkjcaJrncWIXPSSKcZerySpQ
         xaM6GgfhzZT331tLW27GUvEJlMyqysVUnlJNRB0gZZGk3eK4kKg9RsnY6FTflrtyuV
         Q74UiQoy7pZJfXNWxxcTF+U4RGX3s1pSkXWKyTHM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gabriel Fernandez <gabriel.fernandez@foss.st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 39/48] ARM: dts: stm32: use the correct clock source for CEC on stm32mp151
Date:   Tue, 19 Jul 2022 13:54:16 +0200
Message-Id: <20220719114523.296524674@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114518.915546280@linuxfoundation.org>
References: <20220719114518.915546280@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
@@ -413,7 +413,7 @@
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



