Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 354595B7151
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234247AbiIMOgM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234143AbiIMOfL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:35:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE3186526B;
        Tue, 13 Sep 2022 07:20:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEB85614B0;
        Tue, 13 Sep 2022 14:18:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA03CC433C1;
        Tue, 13 Sep 2022 14:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078738;
        bh=CBO3TCOWh/DXPy4PCC85CrWuQrKGGpIDuhFaDzTf4Ng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pGzYrVnsf7GARUCLdusk5oWxjNb1dC3JyAYCoGuVcn/ZHa9SZYjsnv8qldpVJEkoH
         /zd1QrJUKkfeIiZdU+19t3ZquH5SdyYqn2uwr++YhtHnh6FtgtoFeaVWWpy59pn5Qg
         2ycGh2Im23ZIl2g73y2vLqcgec5k+N2XCHaJYzPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 063/121] ARM: dts: at91: sama5d27_wlsom1: specify proper regulator output ranges
Date:   Tue, 13 Sep 2022 16:04:14 +0200
Message-Id: <20220913140400.074592051@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
References: <20220913140357.323297659@linuxfoundation.org>
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

[ Upstream commit addf7efec23af2b67547800aa232d551945e7de2 ]

Min and max output ranges of regulators need to satisfy board
requirements not PMIC requirements. Thus adjust device tree to
cope with this.

Fixes: 5d4c3cfb63fe ("ARM: dts: at91: sama5d27_wlsom1: add SAMA5D27 wlsom1 and wlsom1-ek")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20220826083927.3107272-5-claudiu.beznea@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/at91-sama5d27_wlsom1.dtsi | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm/boot/dts/at91-sama5d27_wlsom1.dtsi b/arch/arm/boot/dts/at91-sama5d27_wlsom1.dtsi
index 025a78310e3ab..70513caf3e8d0 100644
--- a/arch/arm/boot/dts/at91-sama5d27_wlsom1.dtsi
+++ b/arch/arm/boot/dts/at91-sama5d27_wlsom1.dtsi
@@ -68,8 +68,8 @@
 		regulators {
 			vdd_3v3: VDD_IO {
 				regulator-name = "VDD_IO";
-				regulator-min-microvolt = <1200000>;
-				regulator-max-microvolt = <3700000>;
+				regulator-min-microvolt = <3300000>;
+				regulator-max-microvolt = <3300000>;
 				regulator-initial-mode = <2>;
 				regulator-allowed-modes = <2>, <4>;
 				regulator-always-on;
@@ -87,8 +87,8 @@
 
 			vddio_ddr: VDD_DDR {
 				regulator-name = "VDD_DDR";
-				regulator-min-microvolt = <600000>;
-				regulator-max-microvolt = <1850000>;
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <1200000>;
 				regulator-initial-mode = <2>;
 				regulator-allowed-modes = <2>, <4>;
 				regulator-always-on;
@@ -110,8 +110,8 @@
 
 			vdd_core: VDD_CORE {
 				regulator-name = "VDD_CORE";
-				regulator-min-microvolt = <600000>;
-				regulator-max-microvolt = <1850000>;
+				regulator-min-microvolt = <1250000>;
+				regulator-max-microvolt = <1250000>;
 				regulator-initial-mode = <2>;
 				regulator-allowed-modes = <2>, <4>;
 				regulator-always-on;
@@ -152,8 +152,8 @@
 
 			LDO1 {
 				regulator-name = "LDO1";
-				regulator-min-microvolt = <1200000>;
-				regulator-max-microvolt = <3700000>;
+				regulator-min-microvolt = <3300000>;
+				regulator-max-microvolt = <3300000>;
 				regulator-always-on;
 
 				regulator-state-standby {
@@ -167,8 +167,8 @@
 
 			LDO2 {
 				regulator-name = "LDO2";
-				regulator-min-microvolt = <1200000>;
-				regulator-max-microvolt = <3700000>;
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <3300000>;
 				regulator-always-on;
 
 				regulator-state-standby {
-- 
2.35.1



