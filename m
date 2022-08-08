Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACEEF58BF85
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242580AbiHHBmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242810AbiHHBlD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:41:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C414212AB6;
        Sun,  7 Aug 2022 18:35:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6ED8060E08;
        Mon,  8 Aug 2022 01:34:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF12DC433D7;
        Mon,  8 Aug 2022 01:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922498;
        bh=iErS5oo2Oc5DNTVd9UDyKVUFsYmh4vo+LGU2SJ245lM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A3iLjyIFTaB6dmSdimB8kcLYZGKsMN3FeeD2s70x6cgENoTl3CFNj7hL32k22M76k
         q660B78oN0V+3gHbvRxmmcBuA7NoTUftsJqIXmTYYRVFyvPCHEjCJr4pI8ApQ7rj+T
         fxl2QtBjZLs0BHH0+07pcaWmp4vR4PKGuGHmQEUebzK+nonQILmKCyDQQSQ6t8F1Tl
         AQPFFt8Y/9NC8hMNFLv58pzIUXDmQm+/SGzTvsCrojRxXkibYyf54GY6zr+z2eZUoz
         75GfH6AdIZcFNiZXb2v2hbBxqfb0DioH42AdVRt4qBxbc120H7XLNuRrD1lEdHRVVX
         gwg7h2avK8hLg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.18 22/53] ARM: dts: imx6ul: add missing properties for sram
Date:   Sun,  7 Aug 2022 21:33:17 -0400
Message-Id: <20220808013350.314757-22-sashal@kernel.org>
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

[ Upstream commit 5655699cf5cff9f4c4ee703792156bdd05d1addf ]

All 3 properties are required by sram.yaml. Fixes the dtbs_check
warning:
sram@900000: '#address-cells' is a required property
sram@900000: '#size-cells' is a required property
sram@900000: 'ranges' is a required property

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6ul.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/imx6ul.dtsi b/arch/arm/boot/dts/imx6ul.dtsi
index afeec01f6522..1d435a46fc5c 100644
--- a/arch/arm/boot/dts/imx6ul.dtsi
+++ b/arch/arm/boot/dts/imx6ul.dtsi
@@ -149,6 +149,9 @@ soc {
 		ocram: sram@900000 {
 			compatible = "mmio-sram";
 			reg = <0x00900000 0x20000>;
+			ranges = <0 0x00900000 0x20000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 		};
 
 		intc: interrupt-controller@a01000 {
-- 
2.35.1

