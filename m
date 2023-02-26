Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95E2E6A2DC2
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 04:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbjBZDpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Feb 2023 22:45:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjBZDpb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Feb 2023 22:45:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94CB812852;
        Sat, 25 Feb 2023 19:44:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46BDF60C03;
        Sun, 26 Feb 2023 03:44:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD9B9C433D2;
        Sun, 26 Feb 2023 03:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677383042;
        bh=QSNTpjZSumIBJf3HpIerNjKg3HarKEJVJPi7CF0/eW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g3RXGc8Uy28+QCd6F7C4ccyzBGwUS3cDxG8KkMrOtFa803XiZDhKedIBwDA3f/bua
         C7c6NCRNBz/6R6ALy4psjKWcVHcOzEQPD4BBp7FveCgGwixy22umSsyTcBIKhmyLCQ
         /g9OCpMTZIuy3xGw0lNHigR++wcnzKTGelQfMaPvfjwhQZ5PA7Sruac5R/A9cNaR4Q
         4QWqotLMSVsvf+RG6rAXe521OvtSOPvtQl2eJQgw/FFTOS8yXOB3HPIiBtPjH4M0+u
         uJ2TltoD2j7NM6WsBCLMFkV1ofCe6n1BzfS2N9z9uyzrzwlfjoDTvUTCzqI1ngIl1I
         kdJky5MHFdXbw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Markuss Broks <markuss.broks@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 2/6] ARM: dts: exynos: Use Exynos5420 compatible for the MIPI video phy
Date:   Sat, 25 Feb 2023 22:43:54 -0500
Message-Id: <20230226034359.773806-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226034359.773806-1-sashal@kernel.org>
References: <20230226034359.773806-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Markuss Broks <markuss.broks@gmail.com>

[ Upstream commit 5d5aa219a790d61cad2c38e1aa32058f16ad2f0b ]

For some reason, the driver adding support for Exynos5420 MIPI phy
back in 2016 wasn't used on Exynos5420, which caused a kernel panic.
Add the proper compatible for it.

Signed-off-by: Markuss Broks <markuss.broks@gmail.com>
Link: https://lore.kernel.org/r/20230121201844.46872-2-markuss.broks@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos5420.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index e23e8ffb093fa..4fb4804830afe 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -602,7 +602,7 @@ dp_phy: dp-video-phy {
 		};
 
 		mipi_phy: mipi-video-phy {
-			compatible = "samsung,s5pv210-mipi-video-phy";
+			compatible = "samsung,exynos5420-mipi-video-phy";
 			syscon = <&pmu_system_controller>;
 			#phy-cells = <1>;
 		};
-- 
2.39.0

