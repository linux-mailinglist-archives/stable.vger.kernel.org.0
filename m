Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9D5E53A8B2
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355161AbiFAOLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354527AbiFAOJq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:09:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA309EE3D;
        Wed,  1 Jun 2022 07:01:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8447D615B9;
        Wed,  1 Jun 2022 14:01:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C83E8C34119;
        Wed,  1 Jun 2022 14:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654092072;
        bh=q7D1XW9aWhBwvhJGCOL3qoKPqRJ93+derL17oDq8N5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BVCLxS5cF6pEykKgUhRCZ9R/QUAkP1P/g54llfDva7FmeYuRNWoXBWhVwKgHtivbx
         OOA1kps7by5nhb6yxIVUP3szXHZ4bherT90sAN4dVE1Y7OOQnJVpMGR7COkaMcwgi9
         Tl01v2lcyIB5lKkC9K07XcyVpofU2janlFhn23molNoBbLj2Mi1hbVx3ywwjVZQ2Ja
         LLlZKhcN6pONSPkmHDlUEL8RT2YhSFjispkszIpkGbHZAzBNXFicdJxD8oD1fIJqRM
         j9KjVPHp/NH66D/womvNahL+WkogSwiiCGlOb4OJVaA4MOjrZy/k6xGGiSbAt4fD1w
         ZXdl7G8ekDM+g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 06/11] ARM: dts: exynos: add atmel,24c128 fallback to Samsung EEPROM
Date:   Wed,  1 Jun 2022 10:00:55 -0400
Message-Id: <20220601140100.2005469-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601140100.2005469-1-sashal@kernel.org>
References: <20220601140100.2005469-1-sashal@kernel.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit f038e8186fbc5723d7d38c6fa1d342945107347e ]

The Samsung s524ad0xd1 EEPROM should use atmel,24c128 fallback,
according to the AT24 EEPROM bindings.

Reported-by: Rob Herring <robh@kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20220426183443.243113-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos5250-smdk5250.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts b/arch/arm/boot/dts/exynos5250-smdk5250.dts
index 54e79f6887ff..3dda0569f86a 100644
--- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
+++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
@@ -129,7 +129,7 @@ &i2c_0 {
 	samsung,i2c-max-bus-freq = <20000>;
 
 	eeprom@50 {
-		compatible = "samsung,s524ad0xd1";
+		compatible = "samsung,s524ad0xd1", "atmel,24c128";
 		reg = <0x50>;
 	};
 
@@ -288,7 +288,7 @@ &i2c_1 {
 	samsung,i2c-max-bus-freq = <20000>;
 
 	eeprom@51 {
-		compatible = "samsung,s524ad0xd1";
+		compatible = "samsung,s524ad0xd1", "atmel,24c128";
 		reg = <0x51>;
 	};
 
-- 
2.35.1

