Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8645FB67D
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 17:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbiJKPFy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 11:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231823AbiJKPEN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 11:04:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02394A50FC;
        Tue, 11 Oct 2022 07:59:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18732611EC;
        Tue, 11 Oct 2022 14:54:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4744C43143;
        Tue, 11 Oct 2022 14:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665500062;
        bh=z1nZ5R0Es66jpD56Q/P7v3Ds575aQ9G/uGoybDehYUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k0CbvEwKLIFRwn9pE2PENMj7T3P2L4/gfgsIhP4eccsUFYiJTmEOcWAl72zocaUY6
         iBNVbI/C8y7t1qs7QhWAZSNbyB4F5ZLfnImHQbPn16sS0nVtw0o1dL1ERhzoAd4ji4
         cD68YzRvhNcFRx5zhkZshFPjpJaeUxljNhDzWGuSQpBGpUB1yx9iBrNcN6jP1LKr8q
         8kLqScTI3Wa8tKFoORVKASXCTIv03j7sfy4s12VvMjfyPJJaXPCIYp5Yr+zFDQzPCP
         x37nIxeixMj8A3mNn7GBwkd0IOgXZ18R3RPjSyOWwcOfF/f58whox5Qfwz/b90EVer
         f0kHxTLYP4jFQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 5/7] ARM: dts: imx6qp: add missing properties for sram
Date:   Tue, 11 Oct 2022 10:54:12 -0400
Message-Id: <20221011145414.1625237-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145414.1625237-1-sashal@kernel.org>
References: <20221011145414.1625237-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 088fe5237435ee2f7ed4450519b2ef58b94c832f ]

All 3 properties are required by sram.yaml. Fixes the dtbs_check warning:
sram@940000: '#address-cells' is a required property
sram@940000: '#size-cells' is a required property
sram@940000: 'ranges' is a required property

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qp.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/imx6qp.dtsi b/arch/arm/boot/dts/imx6qp.dtsi
index 299d863690c5..6cf0f9e18b70 100644
--- a/arch/arm/boot/dts/imx6qp.dtsi
+++ b/arch/arm/boot/dts/imx6qp.dtsi
@@ -47,12 +47,18 @@ soc {
 		ocram2: sram@00940000 {
 			compatible = "mmio-sram";
 			reg = <0x00940000 0x20000>;
+			ranges = <0 0x00940000 0x20000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 			clocks = <&clks IMX6QDL_CLK_OCRAM>;
 		};
 
 		ocram3: sram@00960000 {
 			compatible = "mmio-sram";
 			reg = <0x00960000 0x20000>;
+			ranges = <0 0x00960000 0x20000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 			clocks = <&clks IMX6QDL_CLK_OCRAM>;
 		};
 
-- 
2.35.1

