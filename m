Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9E475944B7
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346419AbiHOW22 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351083AbiHOW1e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:27:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868DA422E4;
        Mon, 15 Aug 2022 12:47:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 232BF6122B;
        Mon, 15 Aug 2022 19:47:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13803C433C1;
        Mon, 15 Aug 2022 19:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592826;
        bh=vqJjCMDqvWGP/37g/8tBgDb5TlWKENjQTGDkXK8Ik5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oAR0V26ww6itSjzz0+U2mkLSSMEDP43uE2n0zxD3Es3Prlb5Cm9nMY5KzIhl4JEQy
         I17YeXe+Mx0hrEneSBmfEtQvl8Ijy4I14DqEWLeJiBAjrbLwJwLuXWKGz9MztGGgOf
         bS9SVLqc9X2QmID0TgWBvWNJ2xiJT1MTGYlpRiEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0170/1157] ARM: dts: ux500: Fix Janice accelerometer mounting matrix
Date:   Mon, 15 Aug 2022 19:52:06 +0200
Message-Id: <20220815180446.523239858@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



