Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 441966AE873
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjCGRP4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:15:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbjCGRPg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:15:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B718F99666
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:11:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51ADF61506
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:11:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 490F1C433EF;
        Tue,  7 Mar 2023 17:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209060;
        bh=WYywzug2xXiQyWH0zAKhx83L4SXAYhqcMDKlPETsb/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oa8WUf9RGKoMsz8OC+PoKH++9sZ4PaQIkRH8j6kQw3S2GhX9PH7bKvaA55nXj3hD2
         b+vGYn/90/vHah9jGNcITNmZFhWlF64hLPikbIbw37/1eEu4uiXg1iasqC0r9nGo39
         xfDZ3kv7nTPA3eKp/0kaBSHMGxQ1wkA8m0zhcXWo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0098/1001] arm64: dts: mt8192: Fix CPU map for single-cluster SoC
Date:   Tue,  7 Mar 2023 17:47:50 +0100
Message-Id: <20230307170026.425015543@linuxfoundation.org>
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

[ Upstream commit 160ce54d635455ffb5e9b42c5ba9cb9aaa98cdb2 ]

MT8192 features the ARM DynamIQ technology and combines both four
Cortex-A76 (big) and four Cortex-A55 (LITTLE) CPUs in one cluster:
fix the CPU map to reflect that.

Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Fixes: 48489980e27e ("arm64: dts: Add Mediatek SoC MT8192 and evaluation board dts and Makefile")
Link: https://lore.kernel.org/r/20230126103526.417039-3-angelogioacchino.delregno@collabora.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8192.dtsi | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8192.dtsi b/arch/arm64/boot/dts/mediatek/mt8192.dtsi
index 46a1e457fab45..627e3bf1c544b 100644
--- a/arch/arm64/boot/dts/mediatek/mt8192.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8192.dtsi
@@ -158,19 +158,16 @@ core2 {
 				core3 {
 					cpu = <&cpu3>;
 				};
-			};
-
-			cluster1 {
-				core0 {
+				core4 {
 					cpu = <&cpu4>;
 				};
-				core1 {
+				core5 {
 					cpu = <&cpu5>;
 				};
-				core2 {
+				core6 {
 					cpu = <&cpu6>;
 				};
-				core3 {
+				core7 {
 					cpu = <&cpu7>;
 				};
 			};
-- 
2.39.2



