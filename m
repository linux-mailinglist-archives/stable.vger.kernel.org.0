Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E54A25FB626
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 17:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbiJKPAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 11:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231467AbiJKO7W (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:59:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE1A9F766;
        Tue, 11 Oct 2022 07:54:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C609611EB;
        Tue, 11 Oct 2022 14:54:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19055C433B5;
        Tue, 11 Oct 2022 14:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665500044;
        bh=ZQxCrqe83RlkDC++6J1jVdxhHLtzx0Lj5bY0zzqwKNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jsRIcocvZNdxKt30iceSBGB//NqryqFyo+8cVhK+FjNB5wHcyb+w0uIbZbE71795W
         umUi8p0qa8K/fqo9L1K+66uDPtx7LEEo4GGPeAT9CWKmYXcTb5Xdinhk3gCExohgz3
         IPEdSQdgNMGAS7wMRzDAhYG0VKiYaSHmg1LrfZDvrAXB1rXhZH/XD2DsjzMp7bz1Qm
         m/NiAO99XA3VhJu8DqRoUjqnQSMILvCbh5o5fGWGmK/nMuTZLu+9RjOyoZcTjtSsvu
         uwbipEQmDSox7ZC9HUqMZy6hw+2q/1B7o/gQyVnsSObXTkCop7brIJOaPQhf+y/MWb
         qEI50TLcerXtQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 04/11] ARM: dts: imx6dl: add missing properties for sram
Date:   Tue, 11 Oct 2022 10:53:51 -0400
Message-Id: <20221011145358.1624959-4-sashal@kernel.org>
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

[ Upstream commit f5848b95633d598bacf0500e0108dc5961af88c0 ]

All 3 properties are required by sram.yaml. Fixes the dtbs_check warning:
sram@900000: '#address-cells' is a required property
sram@900000: '#size-cells' is a required property
sram@900000: 'ranges' is a required property

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6dl.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/imx6dl.dtsi b/arch/arm/boot/dts/imx6dl.dtsi
index f0607eb41df4..079f77c7e0f0 100644
--- a/arch/arm/boot/dts/imx6dl.dtsi
+++ b/arch/arm/boot/dts/imx6dl.dtsi
@@ -81,6 +81,9 @@ soc {
 		ocram: sram@900000 {
 			compatible = "mmio-sram";
 			reg = <0x00900000 0x20000>;
+			ranges = <0 0x00900000 0x20000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 			clocks = <&clks IMX6QDL_CLK_OCRAM>;
 		};
 
-- 
2.35.1

