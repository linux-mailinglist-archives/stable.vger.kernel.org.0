Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 109A04D3458
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235723AbiCIQYr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:24:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238078AbiCIQVQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:21:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7449D151699;
        Wed,  9 Mar 2022 08:18:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16AEDB82020;
        Wed,  9 Mar 2022 16:18:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2906EC340E8;
        Wed,  9 Mar 2022 16:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646842691;
        bh=hBO+Z4ugMvpVWK+SiJzxvBOYoKrrv4UqPCDWbEkNog4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m8LHmJx/KkcmLxnooNtPQA5l6RGHDpFP3/+Fny+YQyVZeUPmfLJpqJy/ssepCZElD
         jWvTI2PWaGcKzfghEtsp6TcaRP2SoN654VW077bC7n7p5w5jpJWDveFoyzcvqR3Xsv
         jkEbwuVlyzGtoBnYT3vpHYKziXEJDCJ0uqf+BsO14nqVPl4UYZDE/1kBy1ZfRryy7x
         iE4QhzUmLgzBX4CxSEDYaOI4Tt9SCxVSpMZ/YYJlIJBtrWUoOtkK+RLgmXaUku1+wa
         sCPGQB1u1R3iL5ufBX4O0TkU0ZhOo7mbAadpFs/DxRwwZXZCheyI9NmcZg5lf4LYOo
         zyTiE++S/kcXw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Corentin Labbe <clabbe@baylibre.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 10/27] ARM: dts: rockchip: fix a typo on rk3288 crypto-controller
Date:   Wed,  9 Mar 2022 11:16:47 -0500
Message-Id: <20220309161711.135679-10-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220309161711.135679-1-sashal@kernel.org>
References: <20220309161711.135679-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corentin Labbe <clabbe@baylibre.com>

[ Upstream commit 3916c3619599a3970d3e6f98fb430b7c46266ada ]

crypto-controller had a typo, fix it.
In the same time, rename it to just crypto

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Link: https://lore.kernel.org/r/20220209120355.1985707-1-clabbe@baylibre.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rk3288.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index aaaa61875701..45a9d9b908d2 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -971,7 +971,7 @@ i2s: i2s@ff890000 {
 		status = "disabled";
 	};
 
-	crypto: cypto-controller@ff8a0000 {
+	crypto: crypto@ff8a0000 {
 		compatible = "rockchip,rk3288-crypto";
 		reg = <0x0 0xff8a0000 0x0 0x4000>;
 		interrupts = <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>;
-- 
2.34.1

