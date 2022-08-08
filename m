Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1D258BFAC
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242741AbiHHBmb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242984AbiHHBl2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:41:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E4E38AF;
        Sun,  7 Aug 2022 18:35:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE78FB80881;
        Mon,  8 Aug 2022 01:35:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7073C433D6;
        Mon,  8 Aug 2022 01:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922512;
        bh=XCWAe+TX+STk2CgGyIQqKEwSwuQ88kPWq1dpJ9MZDvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pn/jx3J32tbdfkmCBGKDtpmv8236A87rYlic/csf8r9mcWfwurB3Eck6/xZK9CFmh
         L5LDFBbHPH9m+C59zKUlgl65/oONIz7r3k1Tl/9xs9kGb6V3dBUFlH7AkHCssKUq/D
         4lhG/fTPYrZDluRfSRNeBg7Kbp0XCLSVUo5T3H+rQwtR14yM2MXHqD7YVxzj8mdOZn
         p+8sQbLeyltCcY7GhmRC79gaV+EJJtWLlhzPdvne4M8FlxHr9sOE7cHGbF9K6jY7Nv
         S2LbPut8GSUrhXcTdkVPQK+4FovX0F6dPl0AOvuKMu1B4NKoOWV43FQja9sm4/+Wnd
         KxH9QGMqVfJQA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 31/53] ARM: dts: ux500: Fix Gavini accelerometer mounting matrix
Date:   Sun,  7 Aug 2022 21:33:26 -0400
Message-Id: <20220808013350.314757-31-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013350.314757-1-sashal@kernel.org>
References: <20220808013350.314757-1-sashal@kernel.org>
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
index fd170974765f..149838b5f9c1 100644
--- a/arch/arm/boot/dts/ste-ux500-samsung-gavini.dts
+++ b/arch/arm/boot/dts/ste-ux500-samsung-gavini.dts
@@ -523,8 +523,8 @@ i2c-gate {
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

