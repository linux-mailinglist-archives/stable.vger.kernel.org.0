Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7DBD5B8392
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 11:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiINJBX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 05:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiINJBM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 05:01:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC051F2F2;
        Wed, 14 Sep 2022 02:01:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74CF1B816A9;
        Wed, 14 Sep 2022 09:01:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2886C433C1;
        Wed, 14 Sep 2022 09:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663146069;
        bh=tuq12uiHXCIaOV0yOG2YnavzeCeNFrj76CmV14UkXi0=;
        h=From:To:Cc:Subject:Date:From;
        b=iFDh1dh4CHiv2dLavIwUdHFbwAK0tx0+rTfa3TzqLrmt6UXE3dMPjEJZbGTux3zWL
         aHEOxQ/oNbS8OC6SyqF8t/j0rebEgcLlF1dfWV+OpHKyDlwWPtaAq7QKHEKe65vpTg
         6XGfY/tsWOeAroAgZq9yQEY2P9dLL9ElauR7irsdgYG4ACiGvuQAs7Nm2WcYFMpa4d
         YYVDP4njWAXAQ8FFbw8o1baVHXG1zyCHzAhQCV2fF2bIYLTX88aEpNP5FPho/GR6JF
         hFOCKiCjAUMLo0QqbJvs0VDupsTRzz3gKy6ObTWhEFPb5xHSUs3fSg0g/hd7Q/ISC2
         soD2DfjPwtLjw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jassi Brar <jaswinder.singh@linaro.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>, liviu.dudau@arm.com,
        lpieralisi@kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 01/22] arm64: dts: juno: Add missing MHU secure-irq
Date:   Wed, 14 Sep 2022 05:00:42 -0400
Message-Id: <20220914090103.470630-1-sashal@kernel.org>
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
index 065381c1cbf5a..b5039d6a1d1d1 100644
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

