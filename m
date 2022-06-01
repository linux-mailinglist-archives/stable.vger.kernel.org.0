Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E533E53A773
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354080AbiFAOB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355090AbiFAOBR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:01:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65D4292D1C;
        Wed,  1 Jun 2022 06:57:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F2836149F;
        Wed,  1 Jun 2022 13:57:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4927C36AE2;
        Wed,  1 Jun 2022 13:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091826;
        bh=TincU48qiU403YeYmoXveeSxoB8H+arboGKvNQg07k8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p45MNYyfVZwXCTLeiItR2Bzyq22V6kj/KvSfWCK3rYmQRXkAV4cWdkkIqGDn4D68l
         BRjoh95ugxNAoJ9+MzzNs5fzHYaECxFylEQAtP57nuQOHP1BHVyIUXxgtS6xaYnPUq
         fI5+OHJd3uvZJ4d420OTU5Ba8slEwBRoZfBsGEhVW6AeCcFWpx7nK18D1p8jKjCR6b
         qmIuitHveS/YnEtMlyhIpvZgwMK17FnHPp0JOkc4bv1W1frPhDvpBikF8P8x+dINOQ
         J4ebQqUb2jsKNA+/TXtcXGpEZI2Iu584Tv5XUzleDQizyl6jzeUWEEvYqJUzGLBSQx
         XPlUllhVM/h9A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 21/37] ARM: dts: exynos: add atmel,24c128 fallback to Samsung EEPROM
Date:   Wed,  1 Jun 2022 09:56:06 -0400
Message-Id: <20220601135622.2003939-21-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135622.2003939-1-sashal@kernel.org>
References: <20220601135622.2003939-1-sashal@kernel.org>
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
index f042954bdfa5..e4861415a0fe 100644
--- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
+++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
@@ -129,7 +129,7 @@ &i2c_0 {
 	samsung,i2c-max-bus-freq = <20000>;
 
 	eeprom@50 {
-		compatible = "samsung,s524ad0xd1";
+		compatible = "samsung,s524ad0xd1", "atmel,24c128";
 		reg = <0x50>;
 	};
 
@@ -289,7 +289,7 @@ &i2c_1 {
 	samsung,i2c-max-bus-freq = <20000>;
 
 	eeprom@51 {
-		compatible = "samsung,s524ad0xd1";
+		compatible = "samsung,s524ad0xd1", "atmel,24c128";
 		reg = <0x51>;
 	};
 
-- 
2.35.1

