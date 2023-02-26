Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5562E6A2D98
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 04:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbjBZDoT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Feb 2023 22:44:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbjBZDn7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Feb 2023 22:43:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D0E199F;
        Sat, 25 Feb 2023 19:43:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2206BB80B88;
        Sun, 26 Feb 2023 03:43:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A8B6C433D2;
        Sun, 26 Feb 2023 03:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677383003;
        bh=OEnsKvdIGTG7q7AsXdoOikj6+xhLB298GVG6F/Sn51s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LtJDjJunIj+sqC1382sA993eKPO6SQXRnLYIynu8fC7E6yI32z/OU5yG1Ms0KzYsj
         QYsViGjl7Dj4EskCYyNoU5xCrbwOSCcQfSL/Z7i7HNF9Wc4EgxnrMPDgDayYhs7VPK
         GUHwl++Qj9vA1nRkNUIgzZ2KO0msLPLCFUivdbSlXqQnJeLuIeaFTIRaaihFECCObj
         UF6lfNO5jJw/mB1SG5pmFoHXCbJao2fCOXYgscq2kQPtGr0mXOf8eqjtHcQSVR7xH1
         kAXUlAxGPgRLL8OnSl70CRVNPNML0Ji4KBmymMVpcc8ll7ubC/me4NeVOSaEL0oos8
         ualmlVz0dpjTg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Michal Simek <michal.simek@amd.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, michal.simek@xilinx.com,
        laurent.pinchart@ideasonboard.com, robert.hancock@calian.com,
        harini.katakam@amd.com, m.tretter@pengutronix.de,
        piyush.mehta@xilinx.com, tanmay.shah@amd.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.1 15/21] arm64: zynqmp: Enable hs termination flag for USB dwc3 controller
Date:   Sat, 25 Feb 2023 22:42:50 -0500
Message-Id: <20230226034256.771769-15-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226034256.771769-1-sashal@kernel.org>
References: <20230226034256.771769-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

[ Upstream commit 32405e532d358a2f9d4befae928b9883c8597616 ]

Since we need to support legacy phys with the dwc3 controller,
we enable this quirk on the zynqmp platforms.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Link: https://lore.kernel.org/r/20221023215649.221726-1-m.grzeschik@pengutronix.de
Signed-off-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
index a549265e55f6e..7c1af75f33a05 100644
--- a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
+++ b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
@@ -825,6 +825,7 @@ dwc3_0: usb@fe200000 {
 				clock-names = "bus_early", "ref";
 				iommus = <&smmu 0x860>;
 				snps,quirk-frame-length-adjustment = <0x20>;
+				snps,resume-hs-terminations;
 				/* dma-coherent; */
 			};
 		};
@@ -851,6 +852,7 @@ dwc3_1: usb@fe300000 {
 				clock-names = "bus_early", "ref";
 				iommus = <&smmu 0x861>;
 				snps,quirk-frame-length-adjustment = <0x20>;
+				snps,resume-hs-terminations;
 				/* dma-coherent; */
 			};
 		};
-- 
2.39.0

