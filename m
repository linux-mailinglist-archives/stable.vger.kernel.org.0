Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFD5458BEF3
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242293AbiHHBee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241832AbiHHBdb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:33:31 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB6BBE39;
        Sun,  7 Aug 2022 18:32:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0679FCE0FDC;
        Mon,  8 Aug 2022 01:32:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6415FC433B5;
        Mon,  8 Aug 2022 01:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922360;
        bh=iErS5oo2Oc5DNTVd9UDyKVUFsYmh4vo+LGU2SJ245lM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NfzpMTMeW2G0q0j38IrztcXs4twViC3CSHmeCSHTfgOC+DuCG8OlYbN80FfN1bqsP
         FuK4Fi8MxBgrYapd/yc+9At4ogiuHitNpCRHU4Iqb3ows+mPbaq1/GcPKVBAurnzFS
         AUkz3bzN7sH75uNUbKKaM2YPYd4QP/3monHQ4xgcs0c8s+eloeLuIQ7bOe92wexZVu
         jqvCGjujVp6s7knSXwWwm64ieibmM6Igx1BLr2AOeoIl9XLmjk/zhxmeMugV/va7xg
         0rgG5UQ9eIdqxWvcZXft+idCpBzfy/jh2MCYGhOIDG/gsqKT+2Jks+uOsfydkv5W2j
         VjuGeBjbFfjow==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.19 23/58] ARM: dts: imx6ul: add missing properties for sram
Date:   Sun,  7 Aug 2022 21:30:41 -0400
Message-Id: <20220808013118.313965-23-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013118.313965-1-sashal@kernel.org>
References: <20220808013118.313965-1-sashal@kernel.org>
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

