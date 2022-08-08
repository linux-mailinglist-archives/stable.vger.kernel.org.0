Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAAE358BF0B
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242254AbiHHBfV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242184AbiHHBeK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:34:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E81DF16;
        Sun,  7 Aug 2022 18:32:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15FAC60DDB;
        Mon,  8 Aug 2022 01:32:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9365AC433D6;
        Mon,  8 Aug 2022 01:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922375;
        bh=cJdNh/qUxwDopS7V2ZTba4lS6NPW+FxT0xygtFh39bc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IL7zzfzLGUbJVQhiyaZgrJTaoXlVk18aUemKskSiil+44HRC8cc0ohdEyEbR2VxIX
         fqYII43Uc2Qu0mG1zKDaqnvplsR4h92SSf2udaf8eHCHQlR4/BCnGaARGowmD+Xb1Z
         pHXAxL6ihbOVQyAV5YkPEhuLsK7jC/HQWHcz580/Of7a6qnua8gIiAc9zFdsnkIkAe
         HA+i8vWyl7kpJX7kI4qoh98elc9oVPLg6w/HiPCW/GKt9CZML+pTGJf+3XrwHgpIeL
         4gJVbtq2j+C5ZTXGeqQZ9zeptRyMcdu7JxMYYawtIe6UL8TcGagt3IHqPGqQBRDVj0
         F2160EdIlLMtQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 32/58] ARM: dts: ux500: Fix Gavini accelerometer mounting matrix
Date:   Sun,  7 Aug 2022 21:30:50 -0400
Message-Id: <20220808013118.313965-32-sashal@kernel.org>
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

[ Upstream commit e24c75f02a81d6ddac0072cbd7a03e799c19d558 ]

This was fixed wrong so fix it. Now verified by using
iio-sensor-proxy monitor-sensor test program.

Link: https://lore.kernel.org/r/20220611205138.491513-1-linus.walleij@linaro.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ste-ux500-samsung-gavini.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/ste-ux500-samsung-gavini.dts b/arch/arm/boot/dts/ste-ux500-samsung-gavini.dts
index 53062d50e455..806da3fc33cd 100644
--- a/arch/arm/boot/dts/ste-ux500-samsung-gavini.dts
+++ b/arch/arm/boot/dts/ste-ux500-samsung-gavini.dts
@@ -527,8 +527,8 @@ i2c-gate {
 					accelerometer@18 {
 						compatible = "bosch,bma222e";
 						reg = <0x18>;
-						mount-matrix = "0", "1", "0",
-							       "-1", "0", "0",
+						mount-matrix = "0", "-1", "0",
+							       "1", "0", "0",
 							       "0", "0", "1";
 						vddio-supply = <&ab8500_ldo_aux2_reg>; // 1.8V
 						vdd-supply = <&ab8500_ldo_aux1_reg>; // 3V
-- 
2.35.1

