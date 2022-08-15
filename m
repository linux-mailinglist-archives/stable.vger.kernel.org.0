Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 044B4594375
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348454AbiHOWag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351101AbiHOW1g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:27:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D38C422F6;
        Mon, 15 Aug 2022 12:47:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 274D0B80EAB;
        Mon, 15 Aug 2022 19:47:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FFA5C43141;
        Mon, 15 Aug 2022 19:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592835;
        bh=nlvKCtKla5kzKvpADjbRfX6eL02KfVOgVuCh6HScQpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BJSnwUdL+Ce2PUaRGzPOhdOHVXp1K0wK8DDD5FKzzVN976JYqy+aTujithDJzXbd8
         80S20K+hN++ihZnq40dClA7L3ZeOhU1nd+3BeypIVgz/gX9KQZDtgbKDXZYGJgran0
         dcDQEiwMS3M35UoZALZr2sWmOYqAbo6J+51h5tac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0171/1157] ARM: dts: ux500: Fix Codina accelerometer mounting matrix
Date:   Mon, 15 Aug 2022 19:52:07 +0200
Message-Id: <20220815180446.564850502@linuxfoundation.org>
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



