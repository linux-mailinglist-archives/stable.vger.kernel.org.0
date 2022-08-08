Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7369158BF9E
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242718AbiHHBmY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242846AbiHHBlK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:41:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F2212D20;
        Sun,  7 Aug 2022 18:35:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8885960E09;
        Mon,  8 Aug 2022 01:35:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12AECC433B5;
        Mon,  8 Aug 2022 01:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922503;
        bh=EixTL5yY3x6DpFjd9mtu7FvtvO6e++FT6rEJn0V1IyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b1t+p5ZiLh+jWZrKWTRaNZdBgvNtOS41BXIajYvbuLZzEwCWuzGxaRwOLL7bCkNGY
         +7NCBKZimqCxSmxfxZEy773qfdLB2xW3MofBKUnE+uL4RPEWQ498INbNlk1IYzUVi/
         GdDi4fAvsSMPgEegBtQQnzGPkmdj1MJLNocpY8tsKBZE0gmuVIvtAWUgWH1QsHJB02
         Sy0RSqC9XGOwzxuRtBjhpR+bMiFO0kkAEBik522YwgFaFKA85tLXqNpciF0onlB8Oi
         kNSD55WJBGYRdXRwqfsWZmiNqieljsUlSoWvAYZO5mpBSXAHuzpin+oPT8f5ytneHC
         9XkOVf3ik9Nwg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.18 25/53] ARM: dts: imx6ul: fix csi node compatible
Date:   Sun,  7 Aug 2022 21:33:20 -0400
Message-Id: <20220808013350.314757-25-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013350.314757-1-sashal@kernel.org>
References: <20220808013350.314757-1-sashal@kernel.org>
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

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit e0aca931a2c7c29c88ebf37f9c3cd045e083483d ]

"fsl,imx6ul-csi" was never listed as compatible to "fsl,imx7-csi", neither
in yaml bindings, nor previous txt binding. Remove the imx7 part. Fixes
the dt schema check warning:
csi@21c4000: compatible: 'oneOf' conditional failed, one must be fixed:
['fsl,imx6ul-csi', 'fsl,imx7-csi'] is too long
Additional items are not allowed ('fsl,imx7-csi' was unexpected)
'fsl,imx8mm-csi' was expected

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6ul.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6ul.dtsi b/arch/arm/boot/dts/imx6ul.dtsi
index df8b4ad62418..367657a9a99f 100644
--- a/arch/arm/boot/dts/imx6ul.dtsi
+++ b/arch/arm/boot/dts/imx6ul.dtsi
@@ -999,7 +999,7 @@ cpu_speed_grade: speed-grade@10 {
 			};
 
 			csi: csi@21c4000 {
-				compatible = "fsl,imx6ul-csi", "fsl,imx7-csi";
+				compatible = "fsl,imx6ul-csi";
 				reg = <0x021c4000 0x4000>;
 				interrupts = <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clks IMX6UL_CLK_CSI>;
-- 
2.35.1

