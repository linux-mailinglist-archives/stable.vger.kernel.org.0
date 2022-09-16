Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3AA5BAB02
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbiIPKTs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231795AbiIPKSs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:18:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF45B029D;
        Fri, 16 Sep 2022 03:12:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D02E61F48;
        Fri, 16 Sep 2022 10:12:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01646C43470;
        Fri, 16 Sep 2022 10:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663323126;
        bh=mTZV9uIoiN3zypdx+uxbkdn32avLDqSrpGnceQ7EIvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kgr9x2R5RLDJG8UorrDowkZHSAxE+COq9/jefYC8KPCKhjn45vCWtAj/WlpvULbSw
         nVgler4negBTJz/0Dp74PGUKW17F3Q3GVZLz2OdK5a5bg+kaVeOZBqf/S+x6aSZUsS
         y3le844OuA3DVbbcUhdzhpWie5hr/F3IGBwWakqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 06/35] ARM: dts: at91: sama7g5ek: specify proper regulator output ranges
Date:   Fri, 16 Sep 2022 12:08:29 +0200
Message-Id: <20220916100447.204243843@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100446.916515275@linuxfoundation.org>
References: <20220916100446.916515275@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit 7f41d52ced9e1b7ed4ff8e1ae9cacbf46b64e6db ]

Min and max output ranges of regulators need to satisfy board
requirements not PMIC requirements. Thus adjust device tree to
cope with this.

Fixes: 7540629e2fc7 ("ARM: dts: at91: add sama7g5 SoC DT and sama7g5-ek")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20220826083927.3107272-7-claudiu.beznea@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/at91-sama7g5ek.dts | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm/boot/dts/at91-sama7g5ek.dts b/arch/arm/boot/dts/at91-sama7g5ek.dts
index be51c1dbb4595..2038e387be288 100644
--- a/arch/arm/boot/dts/at91-sama7g5ek.dts
+++ b/arch/arm/boot/dts/at91-sama7g5ek.dts
@@ -169,8 +169,8 @@
 			regulators {
 				vdd_3v3: VDD_IO {
 					regulator-name = "VDD_IO";
-					regulator-min-microvolt = <1200000>;
-					regulator-max-microvolt = <3700000>;
+					regulator-min-microvolt = <3300000>;
+					regulator-max-microvolt = <3300000>;
 					regulator-initial-mode = <2>;
 					regulator-allowed-modes = <2>, <4>;
 					regulator-always-on;
@@ -188,8 +188,8 @@
 
 				vddioddr: VDD_DDR {
 					regulator-name = "VDD_DDR";
-					regulator-min-microvolt = <1300000>;
-					regulator-max-microvolt = <1450000>;
+					regulator-min-microvolt = <1350000>;
+					regulator-max-microvolt = <1350000>;
 					regulator-initial-mode = <2>;
 					regulator-allowed-modes = <2>, <4>;
 					regulator-always-on;
@@ -209,8 +209,8 @@
 
 				vddcore: VDD_CORE {
 					regulator-name = "VDD_CORE";
-					regulator-min-microvolt = <1100000>;
-					regulator-max-microvolt = <1850000>;
+					regulator-min-microvolt = <1150000>;
+					regulator-max-microvolt = <1150000>;
 					regulator-initial-mode = <2>;
 					regulator-allowed-modes = <2>, <4>;
 					regulator-always-on;
@@ -229,7 +229,7 @@
 				vddcpu: VDD_OTHER {
 					regulator-name = "VDD_OTHER";
 					regulator-min-microvolt = <1050000>;
-					regulator-max-microvolt = <1850000>;
+					regulator-max-microvolt = <1250000>;
 					regulator-initial-mode = <2>;
 					regulator-allowed-modes = <2>, <4>;
 					regulator-ramp-delay = <3125>;
@@ -248,8 +248,8 @@
 
 				vldo1: LDO1 {
 					regulator-name = "LDO1";
-					regulator-min-microvolt = <1200000>;
-					regulator-max-microvolt = <3700000>;
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
 					regulator-always-on;
 
 					regulator-state-standby {
-- 
2.35.1



