Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4585D6AEE27
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbjCGSKB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:10:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232408AbjCGSJY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:09:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 914A39EF5D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:03:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 317E3B819C2
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:03:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B79C433EF;
        Tue,  7 Mar 2023 18:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212225;
        bh=ljZjyTQsxVP30oF7K+QaQZ/2RsjXiKWXtTh4xk9w4LE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r854Dg9SH616uMqeSBEYxO7ZfmRk/osMW5IzOwXUO/9obYKM1ydja3C7rL+Uj2J1S
         xgWWy/JWfoF52HBAHRGBaFnMNOsJrxkcnROz7hCHagZrgPumBKBf4LmnC0sIegD+Dx
         MQRCVWBnnlgLBC+2FmDgyJ8PA9O35mJl5RSWXNOQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 077/885] arm64: dts: mt8195: Fix CPU map for single-cluster SoC
Date:   Tue,  7 Mar 2023 17:50:11 +0100
Message-Id: <20230307170005.136362784@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

[ Upstream commit cc4f0b13a887b483faa45084616998a21b63889d ]

MT8195 features the ARM DynamIQ technology and combines both four
Cortex-A78 (big) and four Cortex-A55 (LITTLE) CPUs in one cluster:
fix the CPU map to reflect that.

Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Fixes: 37f2582883be ("arm64: dts: Add mediatek SoC mt8195 and evaluation board")
Link: https://lore.kernel.org/r/20230126103526.417039-2-angelogioacchino.delregno@collabora.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8195.dtsi | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8195.dtsi b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
index 6dad8aaee436c..774c2de1fd01e 100644
--- a/arch/arm64/boot/dts/mediatek/mt8195.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
@@ -150,22 +150,20 @@ core2 {
 				core3 {
 					cpu = <&cpu3>;
 				};
-			};
 
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



