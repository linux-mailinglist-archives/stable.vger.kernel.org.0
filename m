Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03C2258C034
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242888AbiHHBtL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243166AbiHHBs2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:48:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E2617044;
        Sun,  7 Aug 2022 18:37:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2021CB80E0F;
        Mon,  8 Aug 2022 01:37:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6749C43142;
        Mon,  8 Aug 2022 01:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922622;
        bh=WLBCrM/2MNW4QA9FhDNcKjSDCznDM6dNFAbB2HXEapw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RlTKWJ2ehVNyUuQuDEnLOi39xi+vo4iuoqkNj2MTBzm2D7gp7gkpuLyFW4tXaaG+3
         sEvGTn37+X0/RbnhueWZ9uDKTlrZQgMCKpLU4eXhcxl3/wwm/+n/3vS4L4hFgLArp/
         nGkhMsgosGKoueotj4/KqY4WCfPlHGPZ2megudkrfBGagTopk7+vppBd+qp/w+L5Tb
         POfhrg08WyUrMg76M6eEjwkc/vp2IZUhbPhCeoV/Xwb8yMIqoaZHi71uX9miqFo542
         5lIOy9ngzZnur4VUYR0KLEbcog5Nn1UyJEmIeU9GUIQmYoGInyBvPRbidnEYrnYz+4
         IrHFNfula7d0w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 25/45] ARM: dts: ux500: Fix Codina accelerometer mounting matrix
Date:   Sun,  7 Aug 2022 21:35:29 -0400
Message-Id: <20220808013551.315446-25-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013551.315446-1-sashal@kernel.org>
References: <20220808013551.315446-1-sashal@kernel.org>
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
index 952606e607ed..ce62ba877da1 100644
--- a/arch/arm/boot/dts/ste-ux500-samsung-codina.dts
+++ b/arch/arm/boot/dts/ste-ux500-samsung-codina.dts
@@ -544,8 +544,8 @@ lisd3dh@19 {
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

