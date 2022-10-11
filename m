Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3E295FB743
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 17:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbiJKPbi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 11:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231612AbiJKPbM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 11:31:12 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F82B3B12;
        Tue, 11 Oct 2022 08:20:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3D878CE1892;
        Tue, 11 Oct 2022 14:54:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9C8AC43154;
        Tue, 11 Oct 2022 14:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665500070;
        bh=1gCf0Nuygm6EJw8q2Swz17zA+gcy83lmdcqc+7kFrMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SPo1RPkKrtCfzgSjjrIB1C8cT5Lz7XXB734XjXLcEUBVIb6CO5TUZaJ+01Kxqsca8
         RcTRFnxrXHAcAeySMeuD0XYkG+/bEIlttJDo0q+5dNPjDvhnNHooOAtZUGDoHm+YUL
         +qJE1F8WoC8swWvE81n5MS19mPgxf1VFWPDGk14paWsmlsdFlwqvQHg2LmvMNxiDrg
         gRQ6oP9NGsueHYvnHTTzgjY+d2f3oU1lw3oc7L5mOG0fVnAdfqvyDnIR8vlVwnj84N
         jiT7+iNmi3dMXuLBnkSk0wejJsTsXH2tawETusBsP4Tbwmw2ZwKhE33HzQJvqOHxmt
         MYc/qI8QOzRzA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.9 3/6] ARM: dts: imx6dl: add missing properties for sram
Date:   Tue, 11 Oct 2022 10:54:22 -0400
Message-Id: <20221011145425.1625494-3-sashal@kernel.org>
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
index 7aa120fbdc71..82a7d5b68da7 100644
--- a/arch/arm/boot/dts/imx6dl.dtsi
+++ b/arch/arm/boot/dts/imx6dl.dtsi
@@ -63,6 +63,9 @@ soc {
 		ocram: sram@00900000 {
 			compatible = "mmio-sram";
 			reg = <0x00900000 0x20000>;
+			ranges = <0 0x00900000 0x20000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 			clocks = <&clks IMX6QDL_CLK_OCRAM>;
 		};
 
-- 
2.35.1

