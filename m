Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0185FB6BC
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 17:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231578AbiJKPQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 11:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231580AbiJKPQW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 11:16:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAAF0DB74F;
        Tue, 11 Oct 2022 08:07:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69D1AB81606;
        Tue, 11 Oct 2022 14:53:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36FC4C433B5;
        Tue, 11 Oct 2022 14:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665500002;
        bh=Lp7KBh6939gQjEUolgTlMacMevfze0nsGEuDUNtoudc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EauPrC0rwbznnjEnX6ZgXmWgCLZe1Af5U8UvXU4OYyUFsLslNt4NBk3uu+BaLL3fM
         kmvxhM5Y0kLNfrrIwqKuPkRnByDnQlsewY/d/zZO+2CMq7MmQyOD6tGyYwNLke1kDJ
         wXanE7qEFnSDUdvjNm/Pn/Y8XZMYSgb6Ln62bJMpmo9GPfpNG4eldupaDg/C5voC/f
         pkoi+9Q4U8itguHF+PJ84/pkGiB53eA0ZlPhIVyH1XJ9s0Sx6El8Qr/WBs50k6CdEA
         ixfAAE0mAuAI0AZYkLzFdNWZNWDAupE59ZZO80bn4DX3wXxq4phmkxeg7HfeOpO5Oz
         b1AElpPBkjenA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 06/17] ARM: dts: imx6qp: add missing properties for sram
Date:   Tue, 11 Oct 2022 10:53:01 -0400
Message-Id: <20221011145312.1624341-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145312.1624341-1-sashal@kernel.org>
References: <20221011145312.1624341-1-sashal@kernel.org>
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
index b310f13a53f2..4d23c92aa8a6 100644
--- a/arch/arm/boot/dts/imx6qp.dtsi
+++ b/arch/arm/boot/dts/imx6qp.dtsi
@@ -9,12 +9,18 @@ soc {
 		ocram2: sram@940000 {
 			compatible = "mmio-sram";
 			reg = <0x00940000 0x20000>;
+			ranges = <0 0x00940000 0x20000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 			clocks = <&clks IMX6QDL_CLK_OCRAM>;
 		};
 
 		ocram3: sram@960000 {
 			compatible = "mmio-sram";
 			reg = <0x00960000 0x20000>;
+			ranges = <0 0x00960000 0x20000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 			clocks = <&clks IMX6QDL_CLK_OCRAM>;
 		};
 
-- 
2.35.1

