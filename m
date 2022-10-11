Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3DF15FB784
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 17:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbiJKPmj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 11:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbiJKPmN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 11:42:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB9615048E;
        Tue, 11 Oct 2022 08:32:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74497B81649;
        Tue, 11 Oct 2022 14:54:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E6A2C433D6;
        Tue, 11 Oct 2022 14:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665500047;
        bh=3GjPyAmSfFqiANTkNsZUz1uZ5A2yd/1Sz2ZG9FjE2d8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RqYB3UtghQi4zoX/AEiVpq0ZQu1Ge/ynCf2Gwo53E+5zwtOiU/aaUELo7ag/EpHc7
         OqrAkLvXG03epy4ysqrPE/l+xm2azbwVInGknPa0ZM6iwsTf0RiPzBQWyiaza09zuI
         WYoiPzfRh742NTn/EYutO7RYWP3JCA5/CeGq2V/Al4EysUSeXzhNtY3zZdzPjXFZ19
         GD5JIO60CQESb3kIfmMppA/chpgB30usiv502QyEsyEn//HBozj3wjoTAf4aJxkJxg
         f5SjjDppB3hSOun2/uUIGakDHnaM9tq5eIKg9a1gS5WdPNQ84eAIFTpE3UMI7JqRPd
         HjIKQj+dro3XA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 06/11] ARM: dts: imx6sl: add missing properties for sram
Date:   Tue, 11 Oct 2022 10:53:53 -0400
Message-Id: <20221011145358.1624959-6-sashal@kernel.org>
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
index 9d19183f40e1..afde0ed6d71a 100644
--- a/arch/arm/boot/dts/imx6sl.dtsi
+++ b/arch/arm/boot/dts/imx6sl.dtsi
@@ -118,6 +118,9 @@ soc {
 		ocram: sram@900000 {
 			compatible = "mmio-sram";
 			reg = <0x00900000 0x20000>;
+			ranges = <0 0x00900000 0x20000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 			clocks = <&clks IMX6SL_CLK_OCRAM>;
 		};
 
-- 
2.35.1

