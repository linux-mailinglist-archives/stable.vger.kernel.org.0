Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4625B5B7041
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233245AbiIMOY2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233602AbiIMOXn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:23:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1CF46611D;
        Tue, 13 Sep 2022 07:15:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36414B80F93;
        Tue, 13 Sep 2022 14:13:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F864C433D6;
        Tue, 13 Sep 2022 14:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078430;
        bh=qiNP1EN35BQ2uOOE53fVzgIM1KsEWHBKlWm1htUMrGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zr1Hq3H/gN8xhBgplD8YQVpXtXjf9tp6iCBxdT50vACxsq8vO7WN7NB3x7fhdw1rO
         F5QDpNZoe5roLBxNkEBCXdF53LAoFhVDcMe0UPtci8WTdRngJ5k3GheSzKrZjExnUU
         1AC/MeIAXhudjoJsP+CvzCmT0ldmxSVrBfKXrwbs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 100/192] ARM: dts: at91: sama7g5ek: specify proper regulator output ranges
Date:   Tue, 13 Sep 2022 16:03:26 +0200
Message-Id: <20220913140414.952097745@linuxfoundation.org>
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
index 103544620fd7c..b261b4da08502 100644
--- a/arch/arm/boot/dts/at91-sama7g5ek.dts
+++ b/arch/arm/boot/dts/at91-sama7g5ek.dts
@@ -244,8 +244,8 @@
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
@@ -264,8 +264,8 @@
 
 				vddioddr: VDD_DDR {
 					regulator-name = "VDD_DDR";
-					regulator-min-microvolt = <1300000>;
-					regulator-max-microvolt = <1450000>;
+					regulator-min-microvolt = <1350000>;
+					regulator-max-microvolt = <1350000>;
 					regulator-initial-mode = <2>;
 					regulator-allowed-modes = <2>, <4>;
 					regulator-always-on;
@@ -285,8 +285,8 @@
 
 				vddcore: VDD_CORE {
 					regulator-name = "VDD_CORE";
-					regulator-min-microvolt = <1100000>;
-					regulator-max-microvolt = <1850000>;
+					regulator-min-microvolt = <1150000>;
+					regulator-max-microvolt = <1150000>;
 					regulator-initial-mode = <2>;
 					regulator-allowed-modes = <2>, <4>;
 					regulator-always-on;
@@ -306,7 +306,7 @@
 				vddcpu: VDD_OTHER {
 					regulator-name = "VDD_OTHER";
 					regulator-min-microvolt = <1050000>;
-					regulator-max-microvolt = <1850000>;
+					regulator-max-microvolt = <1250000>;
 					regulator-initial-mode = <2>;
 					regulator-allowed-modes = <2>, <4>;
 					regulator-ramp-delay = <3125>;
@@ -326,8 +326,8 @@
 
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



