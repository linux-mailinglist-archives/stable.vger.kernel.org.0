Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 065FA58BF06
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242342AbiHHBfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242101AbiHHBeE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:34:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747D0DEFD;
        Sun,  7 Aug 2022 18:32:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5817C60DDA;
        Mon,  8 Aug 2022 01:32:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB9C1C43141;
        Mon,  8 Aug 2022 01:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922372;
        bh=vqJjCMDqvWGP/37g/8tBgDb5TlWKENjQTGDkXK8Ik5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LQtJYAkW3eMX7CWdUJ5rG3Z5l5m5JsRChSMMbxPT/9wah5IScimR4KvV5T9HbaRkM
         03KZxfksjX2UUgQZx4T7qIZ6w1xxMgsKKnc5acHNoxF+Spaj0FjbxenXeYJqbpxRvY
         Q0gmsiB32eukdsPujYbWgy8Bso0eCLd8xq/m5zw2GRPDE4nloHH1u/StXNh8okoCSX
         UvBCiCUcdttzFoPH2bxzehU7sFyt0ZbpoEcPK12MVnc3Oi5Ysb4DKcYXRBqYb/ujdP
         R4hVCY5fR9jVo42t8b9H8iiMAg+7MSrZyAHRJmbpBcnvXlyfalL34LojppVy8YOgrg
         TkQWpxehbcnZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 30/58] ARM: dts: ux500: Fix Janice accelerometer mounting matrix
Date:   Sun,  7 Aug 2022 21:30:48 -0400
Message-Id: <20220808013118.313965-30-sashal@kernel.org>
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

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 013fda41c03e6bcb3dc416669187b609e9e5fdbc ]

This was fixed wrong so fix it again. Now verified by using
iio-sensor-proxy monitor-sensor test program.

Link: https://lore.kernel.org/r/20220609083516.329281-1-linus.walleij@linaro.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ste-ux500-samsung-janice.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/ste-ux500-samsung-janice.dts b/arch/arm/boot/dts/ste-ux500-samsung-janice.dts
index e6d4fd0eb5f4..ed5c79c3d04b 100644
--- a/arch/arm/boot/dts/ste-ux500-samsung-janice.dts
+++ b/arch/arm/boot/dts/ste-ux500-samsung-janice.dts
@@ -633,8 +633,8 @@ i2c-gate {
 					accelerometer@8 {
 						compatible = "bosch,bma222";
 						reg = <0x08>;
-						mount-matrix = "0", "1", "0",
-							       "-1", "0", "0",
+						mount-matrix = "0", "-1", "0",
+							       "1", "0", "0",
 							       "0", "0", "1";
 						vddio-supply = <&ab8500_ldo_aux2_reg>; // 1.8V
 						vdd-supply = <&ab8500_ldo_aux1_reg>; // 3V
-- 
2.35.1

