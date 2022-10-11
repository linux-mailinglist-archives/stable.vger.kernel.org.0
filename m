Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 018BB5FB698
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 17:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbiJKPHs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 11:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231520AbiJKPHW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 11:07:22 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47934A59B9;
        Tue, 11 Oct 2022 08:00:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 49AB7CE1888;
        Tue, 11 Oct 2022 14:53:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C96C433D6;
        Tue, 11 Oct 2022 14:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665500031;
        bh=jOnvxPOlS7nQTT9ZZlU3TtblQ0j6+VfiHg7bt6mihaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZZnykGs6CSHuoT9YOj68qj5a4sjlDG1JmVsbBWqTN+kfz4owh6sIemXDqcgdw//eP
         sFg6TeH+T5n7UY1egrWuFeDCDbAqOQ7qtcVqrloxFK3w6ehxOwJKcFApCy/RdDiabw
         WTDnx1FfB2G3gXR6lOozZ3bQGuP3JvfS8APl8mENeqmeJZGFjiXhxFVo2tTfQ1c2od
         5Aw2A6JIi/ZQz9BkjxLysdjdqEdU/hYpgEOyZ8cU31TS6yrAazT5LmWETjYTJq0B+A
         TPJymmcqhDidJewDqhPRE8WH6soHn2Xk8oN+/muNNflR5V5SVaUJgwL98AqkX39iIo
         TGE1LA0pgTOHQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 09/13] ARM: dts: imx6sx: add missing properties for sram
Date:   Tue, 11 Oct 2022 10:53:34 -0400
Message-Id: <20221011145338.1624591-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145338.1624591-1-sashal@kernel.org>
References: <20221011145338.1624591-1-sashal@kernel.org>
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

[ Upstream commit 415432c008b2bce8138841356ba444631cabaa50 ]

All 3 properties are required by sram.yaml. Fixes the dtbs_check warning:
sram@900000: '#address-cells' is a required property
sram@900000: '#size-cells' is a required property
sram@900000: 'ranges' is a required property

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6sx.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/imx6sx.dtsi b/arch/arm/boot/dts/imx6sx.dtsi
index 531a52c1e987..b3e24d8bd299 100644
--- a/arch/arm/boot/dts/imx6sx.dtsi
+++ b/arch/arm/boot/dts/imx6sx.dtsi
@@ -163,12 +163,18 @@ soc {
 		ocram_s: sram@8f8000 {
 			compatible = "mmio-sram";
 			reg = <0x008f8000 0x4000>;
+			ranges = <0 0x008f8000 0x4000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 			clocks = <&clks IMX6SX_CLK_OCRAM_S>;
 		};
 
 		ocram: sram@900000 {
 			compatible = "mmio-sram";
 			reg = <0x00900000 0x20000>;
+			ranges = <0 0x00900000 0x20000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 			clocks = <&clks IMX6SX_CLK_OCRAM>;
 		};
 
-- 
2.35.1

