Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6485B6FF4
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233265AbiIMOUh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233631AbiIMOTa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:19:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEC9A6554D;
        Tue, 13 Sep 2022 07:14:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E965D614BF;
        Tue, 13 Sep 2022 14:12:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F3DC433D6;
        Tue, 13 Sep 2022 14:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078335;
        bh=2cjLzHeM7fhmB3xd2aDQKEP365VwPf3JGgTV/saPUFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s5Kx5xHxJTQg5fwZwiyN1cTS6I6GztA3cAWKRjfL7ENhyGWepD9qb+ZhWytRZIX+x
         RQDKQkxZVlUHB/D6Qt7Q73VOpW9LSpPe50IRfuktRvE5wSRVmiHxZFXvnOp4IKHlcF
         U9P8YOiLM/y9bz/uj2VsRHUYjLE5vt2T5pbOENFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 099/192] ARM: dts: at91: sama5d2_icp: specify proper regulator output ranges
Date:   Tue, 13 Sep 2022 16:03:25 +0200
Message-Id: <20220913140414.902256391@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
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

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit 7737d93666eea282febf95e5fa3b3fde1f2549f3 ]

Min and max output ranges of regulators need to satisfy board
requirements not PMIC requirements. Thus adjust device tree to
cope with this.

Fixes: 68a95ef72cef ("ARM: dts: at91: sama5d2-icp: add SAMA5D2-ICP")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20220826083927.3107272-6-claudiu.beznea@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/at91-sama5d2_icp.dts | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm/boot/dts/at91-sama5d2_icp.dts b/arch/arm/boot/dts/at91-sama5d2_icp.dts
index 164201a8fbf2d..64d5ae179bec9 100644
--- a/arch/arm/boot/dts/at91-sama5d2_icp.dts
+++ b/arch/arm/boot/dts/at91-sama5d2_icp.dts
@@ -197,8 +197,8 @@
 			regulators {
 				vdd_io_reg: VDD_IO {
 					regulator-name = "VDD_IO";
-					regulator-min-microvolt = <1200000>;
-					regulator-max-microvolt = <3700000>;
+					regulator-min-microvolt = <3300000>;
+					regulator-max-microvolt = <3300000>;
 					regulator-initial-mode = <2>;
 					regulator-allowed-modes = <2>, <4>;
 					regulator-always-on;
@@ -216,8 +216,8 @@
 
 				VDD_DDR {
 					regulator-name = "VDD_DDR";
-					regulator-min-microvolt = <600000>;
-					regulator-max-microvolt = <1850000>;
+					regulator-min-microvolt = <1350000>;
+					regulator-max-microvolt = <1350000>;
 					regulator-initial-mode = <2>;
 					regulator-allowed-modes = <2>, <4>;
 					regulator-always-on;
@@ -235,8 +235,8 @@
 
 				VDD_CORE {
 					regulator-name = "VDD_CORE";
-					regulator-min-microvolt = <600000>;
-					regulator-max-microvolt = <1850000>;
+					regulator-min-microvolt = <1250000>;
+					regulator-max-microvolt = <1250000>;
 					regulator-initial-mode = <2>;
 					regulator-allowed-modes = <2>, <4>;
 					regulator-always-on;
@@ -273,8 +273,8 @@
 
 				LDO1 {
 					regulator-name = "LDO1";
-					regulator-min-microvolt = <1200000>;
-					regulator-max-microvolt = <3700000>;
+					regulator-min-microvolt = <2500000>;
+					regulator-max-microvolt = <2500000>;
 					regulator-always-on;
 
 					regulator-state-standby {
@@ -288,8 +288,8 @@
 
 				LDO2 {
 					regulator-name = "LDO2";
-					regulator-min-microvolt = <1200000>;
-					regulator-max-microvolt = <3700000>;
+					regulator-min-microvolt = <3300000>;
+					regulator-max-microvolt = <3300000>;
 					regulator-always-on;
 
 					regulator-state-standby {
-- 
2.35.1



