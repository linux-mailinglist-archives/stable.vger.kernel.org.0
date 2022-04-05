Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C25854F3868
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357282AbiDELXN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349478AbiDEJtz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3DB0B67;
        Tue,  5 Apr 2022 02:47:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0D8EB818F3;
        Tue,  5 Apr 2022 09:47:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 208F1C385A2;
        Tue,  5 Apr 2022 09:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152024;
        bh=MwpI0A3swHzrHWq8nSzg3WNEjrJHPUTBAbo9N7PY73M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=den/OtFFWaOo+pCn56yGY/f1HMDnlcSyoUlADv2Bd0rrtiJ50NRVh/2D5V4/dkgE+
         ndRoMduGCB6Pa45xWOt8OZUp2YiitCO0u7SmafUdqHhXvBfA81cZ2TkniN3gT7lnk1
         J3ce5d0Gzp8kZiOXelT3Ti/Sb4naYDhT2hXeJZig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 628/913] staging: mt7621-dts: fix formatting
Date:   Tue,  5 Apr 2022 09:28:10 +0200
Message-Id: <20220405070358.663025839@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Arınç ÜNAL <arinc.unal@arinc9.com>

[ Upstream commit 7eeec44d33f6be7caca4fe9ca4e653cf315a36c1 ]

Fix formatting on mt7621.dtsi.

Reviewed-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Link: https://lore.kernel.org/r/20220125153903.1469-2-arinc.unal@arinc9.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/mt7621-dts/mt7621.dtsi | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/mt7621-dts/mt7621.dtsi b/drivers/staging/mt7621-dts/mt7621.dtsi
index eeabe9c0f4fb..eca384cdec39 100644
--- a/drivers/staging/mt7621-dts/mt7621.dtsi
+++ b/drivers/staging/mt7621-dts/mt7621.dtsi
@@ -36,9 +36,9 @@
 		regulator-max-microvolt = <3300000>;
 		enable-active-high;
 		regulator-always-on;
-	  };
+	};
 
-	  mmc_fixed_1v8_io: fixedregulator@1 {
+	mmc_fixed_1v8_io: fixedregulator@1 {
 		compatible = "regulator-fixed";
 		regulator-name = "mmc_io";
 		regulator-min-microvolt = <1800000>;
@@ -391,17 +391,18 @@
 
 		mediatek,ethsys = <&sysc>;
 
-
 		gmac0: mac@0 {
 			compatible = "mediatek,eth-mac";
 			reg = <0>;
 			phy-mode = "rgmii";
+
 			fixed-link {
 				speed = <1000>;
 				full-duplex;
 				pause;
 			};
 		};
+
 		gmac1: mac@1 {
 			compatible = "mediatek,eth-mac";
 			reg = <1>;
@@ -409,6 +410,7 @@
 			phy-mode = "rgmii-rxid";
 			phy-handle = <&phy_external>;
 		};
+
 		mdio-bus {
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -439,36 +441,43 @@
 					#address-cells = <1>;
 					#size-cells = <0>;
 					reg = <0>;
+
 					port@0 {
 						status = "off";
 						reg = <0>;
 						label = "lan0";
 					};
+
 					port@1 {
 						status = "off";
 						reg = <1>;
 						label = "lan1";
 					};
+
 					port@2 {
 						status = "off";
 						reg = <2>;
 						label = "lan2";
 					};
+
 					port@3 {
 						status = "off";
 						reg = <3>;
 						label = "lan3";
 					};
+
 					port@4 {
 						status = "off";
 						reg = <4>;
 						label = "lan4";
 					};
+
 					port@6 {
 						reg = <6>;
 						label = "cpu";
 						ethernet = <&gmac0>;
 						phy-mode = "trgmii";
+
 						fixed-link {
 							speed = <1000>;
 							full-duplex;
-- 
2.34.1



