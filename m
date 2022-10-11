Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0B95FB635
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 17:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbiJKPBc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 11:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231615AbiJKO7r (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:59:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 977A21EAC2;
        Tue, 11 Oct 2022 07:55:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A1C8611D8;
        Tue, 11 Oct 2022 14:54:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28897C433D7;
        Tue, 11 Oct 2022 14:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665500072;
        bh=QElekDW4RQwTZw/rD+piVKqTV/6amdNQ0tPASv6NPe4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fQEHzwSOA+tsnif0oiqTeC3LuNJRsCWdOQAJ5oruqR91gwYTLF09jlEE+B6Bn9P/l
         AleChm6ln1QsRdUSUEqrJdSpsXrdVPncmP65gsvRsFg+vUZaUNdt9f79FbAPRbOOBH
         MhfbHAuNYR9WXuB1pRj+fqhhLeuoqNGUVy8oOgBDfALUx6beFCAzEBY+1kxLVhvO5Y
         uh7PnTsMTmjMvk4/jdJebTrSokYT96NxsJKs1C/X4WGGfwIKc7Yb7M3Cjm70TUYj9W
         9BLfDqyNZvktc3Z2Gk91m8dGb6sBnbN9ffdsoYzTvKNNuTykYgAYE8aTeHGhEnssQg
         xjNcvHFovUzcQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.9 5/6] ARM: dts: imx6sl: add missing properties for sram
Date:   Tue, 11 Oct 2022 10:54:24 -0400
Message-Id: <20221011145425.1625494-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145425.1625494-1-sashal@kernel.org>
References: <20221011145425.1625494-1-sashal@kernel.org>
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

[ Upstream commit 60c9213a1d9941a8b33db570796c3f9be8984974 ]

All 3 properties are required by sram.yaml. Fixes the dtbs_check warning:
sram@900000: '#address-cells' is a required property
sram@900000: '#size-cells' is a required property
sram@900000: 'ranges' is a required property

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6sl.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/imx6sl.dtsi b/arch/arm/boot/dts/imx6sl.dtsi
index a2c76797e871..a9a53a78de03 100644
--- a/arch/arm/boot/dts/imx6sl.dtsi
+++ b/arch/arm/boot/dts/imx6sl.dtsi
@@ -102,6 +102,9 @@ soc {
 		ocram: sram@00900000 {
 			compatible = "mmio-sram";
 			reg = <0x00900000 0x20000>;
+			ranges = <0 0x00900000 0x20000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 			clocks = <&clks IMX6SL_CLK_OCRAM>;
 		};
 
-- 
2.35.1

