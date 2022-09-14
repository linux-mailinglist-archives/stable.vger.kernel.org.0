Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A58FE5B83EF
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 11:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbiINJFx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 05:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbiINJEw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 05:04:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B735E754B9;
        Wed, 14 Sep 2022 02:02:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E4DEB816A9;
        Wed, 14 Sep 2022 09:02:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3358C433D7;
        Wed, 14 Sep 2022 09:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663146148;
        bh=UJz4aN/zdRRoD8mU+4qWJUCxaeD7+BrOWhvFIVTF5ZY=;
        h=From:To:Cc:Subject:Date:From;
        b=NQ3rub8p3E7vJe85wJCr5q5sXa4qgClvk6QULL6Vws8liAHY0ihtXOd2cLQ8ilobj
         RIqYhqUgLGOrBRhwHkEujuGzZ2cmj7yCmP0n+/XPKzOBdZOaihESxuBa/k3QJziozF
         Hf3o/kl1uzWuyco5GEqGykpOBHFDb38UNkWPU+j+MqST0q034djzGvCtths30AxM4Z
         y/T6ZUaY16uLQjn6rx1jmEp3WzF8a9A0LsRJBa2C9bFM5uXlOQ6jG4gdUm+LshI4cE
         bxtI1JdS4hJdTraDWnm1XnEAX9Na0w7GafT0pYVpa1jVxorjeb6fjaHRtdDT+xUDGB
         l/mFAlKHGX17w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jassi Brar <jaswinder.singh@linaro.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>, liviu.dudau@arm.com,
        lpieralisi@kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 01/16] arm64: dts: juno: Add missing MHU secure-irq
Date:   Wed, 14 Sep 2022 05:02:09 -0400
Message-Id: <20220914090224.470913-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Jassi Brar <jaswinder.singh@linaro.org>

[ Upstream commit 422ab8fe15e30066d4c8e236b747c77069bfca45 ]

The MHU secure interrupt exists physically but is missing in the DT node.

Specify the interrupt in DT node to fix a warning on Arm Juno board:
   mhu@2b1f0000: interrupts: [[0, 36, 4], [0, 35, 4]] is too short

Link: https://lore.kernel.org/r/20220801141005.599258-1-jassisinghbrar@gmail.com
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/arm/juno-base.dtsi | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/arm/juno-base.dtsi b/arch/arm64/boot/dts/arm/juno-base.dtsi
index a2635b14da309..34e5549ea748a 100644
--- a/arch/arm64/boot/dts/arm/juno-base.dtsi
+++ b/arch/arm64/boot/dts/arm/juno-base.dtsi
@@ -26,7 +26,8 @@ mailbox: mhu@2b1f0000 {
 		compatible = "arm,mhu", "arm,primecell";
 		reg = <0x0 0x2b1f0000 0x0 0x1000>;
 		interrupts = <GIC_SPI 36 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>;
+			     <GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
 		#mbox-cells = <1>;
 		clocks = <&soc_refclk100mhz>;
 		clock-names = "apb_pclk";
-- 
2.35.1

