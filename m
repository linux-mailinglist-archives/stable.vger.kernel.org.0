Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96B4958C0A3
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243401AbiHHBxC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243494AbiHHBvG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:51:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB30DCE3E;
        Sun,  7 Aug 2022 18:38:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A0AFB80E16;
        Mon,  8 Aug 2022 01:38:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 394C6C433D7;
        Mon,  8 Aug 2022 01:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922684;
        bh=kIWsF77zWPnhFX+qG0aWMe2sCIO7+gDIJgIDthFSsDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lj0a6kSGUCoJCW4Q7T6DZdwse91vl0se0aD4dnLXg2kuecaTZCb04eV/5I6m8PRyn
         fgJDHUqq1bdHZvp8KaZ6ju9O/izHnj5p1/XXJVt0yZbYMsptESbXshn/wgSBcEDAgs
         Evk/YFCgM/tSVR58QdH+m7PJ5btC1yLvQSgo9N0dmUW7izWpQH1hhfOs5QGklRiFza
         7dFSqHty4O9n4Z8KwjepDXpr8VbqIn3iiRzpNEBNFMurzXWNrZZgZ4FUQ2Kuay9k6r
         I+kCzFHbsVPyrMz0iCeRsC/tVcsjSZteK1xCkiTQzMUttgppfH9KGhLNYck9mShfwm
         Jmb5PChNZVNpA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 13/29] ARM: dts: imx6ul: fix csi node compatible
Date:   Sun,  7 Aug 2022 21:37:23 -0400
Message-Id: <20220808013741.316026-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013741.316026-1-sashal@kernel.org>
References: <20220808013741.316026-1-sashal@kernel.org>
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
index 1474985b9908..8e6079a68022 100644
--- a/arch/arm/boot/dts/imx6ul.dtsi
+++ b/arch/arm/boot/dts/imx6ul.dtsi
@@ -995,7 +995,7 @@ cpu_speed_grade: speed-grade@10 {
 			};
 
 			csi: csi@21c4000 {
-				compatible = "fsl,imx6ul-csi", "fsl,imx7-csi";
+				compatible = "fsl,imx6ul-csi";
 				reg = <0x021c4000 0x4000>;
 				interrupts = <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clks IMX6UL_CLK_CSI>;
-- 
2.35.1

