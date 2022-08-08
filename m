Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62CCE58BF09
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242350AbiHHBfL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242253AbiHHBeF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:34:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0D7DEE8;
        Sun,  7 Aug 2022 18:32:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF15660DFF;
        Mon,  8 Aug 2022 01:32:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE45C433C1;
        Mon,  8 Aug 2022 01:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922374;
        bh=nlvKCtKla5kzKvpADjbRfX6eL02KfVOgVuCh6HScQpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ukxH+H+Df8XokZuW7l4WCH8kJvjCDwlFjszZN2LWT4dze/+cZmoboMy8DSa6jQdsZ
         MlReQzfq3fe5SBq4Rqbd5f23MT79moOLcL65zE94YsMw2uFpvzD+BctA42qNyjCUey
         YmGps15Knd6KkxABYPUCQs7dBgHsvGZtYPC5wlYzj2pbRVCIrhVwahgEsnxu2xvZiv
         Pu6wXVovP4yUsiAhowEOI/HwXXolp3N+/ZxTQ8cermZ0hgkWKx2ou0ze7TgSLkrwjZ
         4wK0bC2JBkAMnIz+NAhl/i7vA5GminBCyr8ZPOevyPVVQGRu+4TiUfEZZK+1WBvOaV
         whDCR1bGuRibg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 31/58] ARM: dts: ux500: Fix Codina accelerometer mounting matrix
Date:   Sun,  7 Aug 2022 21:30:49 -0400
Message-Id: <20220808013118.313965-31-sashal@kernel.org>
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

[ Upstream commit 0b2152e428ab91533a02888ff24e52e788dc4637 ]

This was fixed wrong so fix it again. Now verified by using
iio-sensor-proxy monitor-sensor test program.

Link: https://lore.kernel.org/r/20220611204249.472250-1-linus.walleij@linaro.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ste-ux500-samsung-codina.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/ste-ux500-samsung-codina.dts b/arch/arm/boot/dts/ste-ux500-samsung-codina.dts
index b6746ac167bc..5f41256d7f4b 100644
--- a/arch/arm/boot/dts/ste-ux500-samsung-codina.dts
+++ b/arch/arm/boot/dts/ste-ux500-samsung-codina.dts
@@ -598,8 +598,8 @@ lisd3dh@19 {
 				reg = <0x19>;
 				vdd-supply = <&ab8500_ldo_aux1_reg>; // 3V
 				vddio-supply = <&ab8500_ldo_aux2_reg>; // 1.8V
-				mount-matrix = "0", "-1", "0",
-					       "1", "0", "0",
+				mount-matrix = "0", "1", "0",
+					       "-1", "0", "0",
 					       "0", "0", "1";
 			};
 		};
-- 
2.35.1

