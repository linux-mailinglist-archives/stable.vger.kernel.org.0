Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB916AE874
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbjCGRP7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:15:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbjCGRPg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:15:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E190E1E5D5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:11:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E05961505
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:11:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73509C433EF;
        Tue,  7 Mar 2023 17:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209063;
        bh=pcAvCmtEK7hqKR0X7Ny7+M8coIvredWSY0lPj2rEGXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BAzF8KUoxEwi0l/LJ+AfMgs8bAv0XCO1d88ZPJXT1GZPIxKguoRYMr3xAjzB0Mgd0
         B3ZwgbJnvskldkHFpK7RLKuaTeEHJ9rOq2VmuvcdfRjck+ieoNlqTyXoBBm5sfNIIa
         OwAozgFfFuz6F781Gd40O0ZG8/clDrE+hOdK91F0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0099/1001] arm64: dts: mt8186: Fix CPU map for single-cluster SoC
Date:   Tue,  7 Mar 2023 17:47:51 +0100
Message-Id: <20230307170026.463517516@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 1c473804b0c8a68c6ef2cf519b38ec6725ca4aa5 ]

MT8186 features the ARM DynamIQ technology and combines both two
Cortex-A76 (big) and six Cortex-A55 (LITTLE) CPUs in one cluster:
fix the CPU map to reflect that.

Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Fixes: 2e78620b1350 ("arm64: dts: Add MediaTek MT8186 dts and evaluation board and Makefile")
Link: https://lore.kernel.org/r/20230126103526.417039-4-angelogioacchino.delregno@collabora.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8186.dtsi | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8186.dtsi b/arch/arm64/boot/dts/mediatek/mt8186.dtsi
index 857b0c22422f4..0d8d2799d86d1 100644
--- a/arch/arm64/boot/dts/mediatek/mt8186.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8186.dtsi
@@ -47,14 +47,12 @@ core4 {
 				core5 {
 					cpu = <&cpu5>;
 				};
-			};
 
-			cluster1 {
-				core0 {
+				core6 {
 					cpu = <&cpu6>;
 				};
 
-				core1 {
+				core7 {
 					cpu = <&cpu7>;
 				};
 			};
-- 
2.39.2



