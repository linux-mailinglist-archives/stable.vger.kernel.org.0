Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 991905FB625
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 17:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbiJKPAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 11:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbiJKO7W (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:59:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BBE29F776;
        Tue, 11 Oct 2022 07:54:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8D25B8163C;
        Tue, 11 Oct 2022 14:54:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98BE1C4347C;
        Tue, 11 Oct 2022 14:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665500048;
        bh=sf1BhSfIdmHSNWJxDrexlCJX7NT42VuDAr23eGuBr98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f5EzC7rUIE1r1dLR1ReJK88RYqjyinzWXTz5L+mdwCFDwjGYOudq0oaSf1O9Wv0+C
         zd3eEIKvsoqpqEk78pus4xS/3I0MoiVUbkdCj9gR4EHtt7gG+FZRG7JLR+4OvE6wyM
         5HfYYgGFVSx4m8KjB2HJdeTTy4UH2MDrOg70lnc88hevcMNWtV0bijmE+0pHB3Dpzr
         T2S1n1zqHPKju3zWl7g1CwXScJJsZbHZBRvZyLTdK+KJLIXzGRqpM0ssjwoEtskY6E
         2MspD3/Vtc2XDRdXR8qHRHoGPT6AlO5BIdkORbiSByzoLXzzBw2I+5++ShR//0o1q/
         +OzLW1H+z+rcw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 07/11] ARM: dts: imx6sll: add missing properties for sram
Date:   Tue, 11 Oct 2022 10:53:54 -0400
Message-Id: <20221011145358.1624959-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145358.1624959-1-sashal@kernel.org>
References: <20221011145358.1624959-1-sashal@kernel.org>
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

[ Upstream commit 7492a83ed9b7a151e2dd11d64b06da7a7f0fa7f9 ]

All 3 properties are required by sram.yaml. Fixes the dtbs_check warning:
sram@900000: '#address-cells' is a required property
sram@900000: '#size-cells' is a required property
sram@900000: 'ranges' is a required property

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6sll.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/imx6sll.dtsi b/arch/arm/boot/dts/imx6sll.dtsi
index 7c7d5c47578e..d7d092a5522a 100644
--- a/arch/arm/boot/dts/imx6sll.dtsi
+++ b/arch/arm/boot/dts/imx6sll.dtsi
@@ -131,6 +131,9 @@ soc {
 		ocram: sram@900000 {
 			compatible = "mmio-sram";
 			reg = <0x00900000 0x20000>;
+			ranges = <0 0x00900000 0x20000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 		};
 
 		L2: l2-cache@a02000 {
-- 
2.35.1

