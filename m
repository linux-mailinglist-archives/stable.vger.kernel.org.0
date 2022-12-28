Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44EAE657985
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233426AbiL1PCs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:02:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233453AbiL1PCW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:02:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F68B13D17
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:01:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B8A961365
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:01:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E4AAC433D2;
        Wed, 28 Dec 2022 15:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239714;
        bh=+e4kKoYMfsgLA0QIIilo188036g+bAIfSq9Ae03fcaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u3TTUHHGxVS5DLe7sZgb/754DyAmZFvYSg9iTeGxs6rgxrueWt+UCFyXpQRTSiis2
         Ni562vnIpruf3vwzouK9BSZrlV8B5gPS68tvFcEHQXvGEeSiZsANi7e70oox7CFlRj
         Zbgc5Mhb5O6T4BpP66uXBWKgpUqwSt11kIGEGkXA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0067/1073] arm64: dts: mediatek: pumpkin-common: Fix devicetree warnings
Date:   Wed, 28 Dec 2022 15:27:35 +0100
Message-Id: <20221228144329.907804859@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 509438336ce75c8b4e6ce8e8d507dc77d0783bdd ]

Fix the pinctrl submodes and optee node to remove unneeded unit address,
fixing all unit_address_vs_reg warnings.

Fixes: 9983822c8cf9 ("arm64: dts: mediatek: add pumpkin board dts")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20221013152212.416661-8-angelogioacchino.delregno@collabora.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi b/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
index 8ee1529683a3..ec8dfb3d1c6d 100644
--- a/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
+++ b/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
@@ -17,7 +17,7 @@ chosen {
 	};
 
 	firmware {
-		optee: optee@4fd00000 {
+		optee: optee {
 			compatible = "linaro,optee-tz";
 			method = "smc";
 		};
@@ -209,7 +209,7 @@ pins_cmd_dat {
 		};
 	};
 
-	i2c0_pins_a: i2c0@0 {
+	i2c0_pins_a: i2c0 {
 		pins1 {
 			pinmux = <MT8516_PIN_58_SDA0__FUNC_SDA0_0>,
 				 <MT8516_PIN_59_SCL0__FUNC_SCL0_0>;
@@ -217,7 +217,7 @@ pins1 {
 		};
 	};
 
-	i2c2_pins_a: i2c2@0 {
+	i2c2_pins_a: i2c2 {
 		pins1 {
 			pinmux = <MT8516_PIN_60_SDA2__FUNC_SDA2_0>,
 				 <MT8516_PIN_61_SCL2__FUNC_SCL2_0>;
-- 
2.35.1



