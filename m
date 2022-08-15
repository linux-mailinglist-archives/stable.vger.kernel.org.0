Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5CF3593C6F
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347046AbiHOUX1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347288AbiHOUWM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:22:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4064B0E9;
        Mon, 15 Aug 2022 12:02:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6996B810A1;
        Mon, 15 Aug 2022 19:02:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22404C433C1;
        Mon, 15 Aug 2022 19:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590122;
        bh=fbgxc8V8tdg0LFBq4Z4rM/C3lTyUixrych/GUw3V7aw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OUtlZT4Ijplfw5VAT50C/exJdxExAOOxZNYBQhZoFBMqiVGdWO2R8CFh1k1bNrSsP
         3f419KSPiqnDUfFshzKtO7QE51jrmXP9MSwPNVPoJ+L+vSTNZdEUa/ShUjgD2FyvGq
         n3LQ+jdBdCYjpfmmVOgy3ufCEiJ7Qv+kL9vNODa8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0157/1095] ARM: dts: ux500: Fix Janice accelerometer mounting matrix
Date:   Mon, 15 Aug 2022 19:52:36 +0200
Message-Id: <20220815180436.070537762@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
index 42762bfcd878..2069efb252a7 100644
--- a/arch/arm/boot/dts/ste-ux500-samsung-janice.dts
+++ b/arch/arm/boot/dts/ste-ux500-samsung-janice.dts
@@ -610,8 +610,8 @@ i2c-gate {
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



