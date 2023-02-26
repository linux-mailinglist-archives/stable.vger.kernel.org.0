Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C568F6A2D81
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 04:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbjBZDni (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Feb 2023 22:43:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbjBZDnd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Feb 2023 22:43:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E549215146;
        Sat, 25 Feb 2023 19:43:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDDA060BD4;
        Sun, 26 Feb 2023 03:43:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E2BCC4339E;
        Sun, 26 Feb 2023 03:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677382987;
        bh=Swp9cal23T3bRtttDRGQ8Yv4EpqIDlMRm6uqrJbkTY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aIySZE2k/gA5qCgOce4zO3FVo2PQr4bz7HmZ1l1jDgPMKa323maT0ySSsmviVD6nB
         05CERTkYLzwxM+BJBpdxXin7ELZl/3AY9h8DHA+cOPpnTf5vz+2kaW9z5dF6Hzqyk/
         ItVNz+sN2xz6LxIbTZr1b3R35Y0ojhBwUY7FDSqZDwL2u5naUt4cnRourF/ajOBgWU
         IXzVg76x67zJQ6cTJ+Dtxr3kYiI5f5CpRMfjTqHLT+VjWulExn01VdAB0QpKh50k8s
         Fd4u8+Clm5kymAgfCtXb2yXa98IlSojTPIo+w5/fd61rQqGK539SEDw36SD2fGHmAr
         q1AZ72kjHn9jA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Markuss Broks <markuss.broks@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 06/21] ARM: dts: exynos: Use Exynos5420 compatible for the MIPI video phy
Date:   Sat, 25 Feb 2023 22:42:41 -0500
Message-Id: <20230226034256.771769-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226034256.771769-1-sashal@kernel.org>
References: <20230226034256.771769-1-sashal@kernel.org>
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
index 9f2523a873d9d..62263eb91b3cc 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -592,7 +592,7 @@ dp_phy: dp-video-phy {
 		};
 
 		mipi_phy: mipi-video-phy {
-			compatible = "samsung,s5pv210-mipi-video-phy";
+			compatible = "samsung,exynos5420-mipi-video-phy";
 			syscon = <&pmu_system_controller>;
 			#phy-cells = <1>;
 		};
-- 
2.39.0

