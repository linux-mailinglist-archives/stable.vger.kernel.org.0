Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7FE96A2D75
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 04:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbjBZDnJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Feb 2023 22:43:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbjBZDmy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Feb 2023 22:42:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB9D31448F;
        Sat, 25 Feb 2023 19:42:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D8DE60BC9;
        Sun, 26 Feb 2023 03:42:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7D34C433EF;
        Sun, 26 Feb 2023 03:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677382943;
        bh=icuXx2EmTsyNRovRKCl2AQPqBveRL9Gl4mQfb+1b+oI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tTuTs2z++LdnHu81AzMhYlYTB8Hs3i24Mcb3zIpj18mjiQzm7IrcRSdmcuZ1OJv28
         E4nYqZrDq+EiaMy4HmaRdD5S7YzkMRhMVWxfReROg7hzRlemQnkfyCLbMxFbQOZ3ee
         mmd9BzNrcSVnquKtQscQdFVQXaXCpd52+5j+nyW2oLWzNTzNfGrllcA0+RHlgwNdcy
         wk8AC1/acLa7rwxQrHvgp6/ipZ5llsJJjjjNTVoAPNVKiqm/pSH3Ar+sLh64DRbNtC
         SNLNhes6EmKsXDIhopvRj5pbVcB8jP9mY+pGZak15LR1Rn4MRGgUxHSgxsVmI9h4p8
         9s6FE+GSnV0Yw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Michal Simek <michal.simek@amd.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, michal.simek@xilinx.com,
        laurent.pinchart@ideasonboard.com, tanmay.shah@amd.com,
        harini.katakam@amd.com, mathieu.poirier@linaro.org,
        piyush.mehta@xilinx.com, robert.hancock@calian.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.2 15/21] arm64: zynqmp: Enable hs termination flag for USB dwc3 controller
Date:   Sat, 25 Feb 2023 22:41:44 -0500
Message-Id: <20230226034150.771411-15-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226034150.771411-1-sashal@kernel.org>
References: <20230226034150.771411-1-sashal@kernel.org>
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
index 4325cb8526edc..f92df478f0eea 100644
--- a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
+++ b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
@@ -858,6 +858,7 @@ dwc3_0: usb@fe200000 {
 				clock-names = "bus_early", "ref";
 				iommus = <&smmu 0x860>;
 				snps,quirk-frame-length-adjustment = <0x20>;
+				snps,resume-hs-terminations;
 				/* dma-coherent; */
 			};
 		};
@@ -884,6 +885,7 @@ dwc3_1: usb@fe300000 {
 				clock-names = "bus_early", "ref";
 				iommus = <&smmu 0x861>;
 				snps,quirk-frame-length-adjustment = <0x20>;
+				snps,resume-hs-terminations;
 				/* dma-coherent; */
 			};
 		};
-- 
2.39.0

