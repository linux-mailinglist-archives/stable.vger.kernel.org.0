Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7847E4F44ED
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 00:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383513AbiDEMZz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358776AbiDELRa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 07:17:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D29ADFD51;
        Tue,  5 Apr 2022 03:19:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39A7E616D7;
        Tue,  5 Apr 2022 10:19:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD345C385A0;
        Tue,  5 Apr 2022 10:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153979;
        bh=doFdCtirsCr3zu50yEaZSjJt03wOx+ybpOZv91v/DDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IwOl03rZGHk1HysvhB9WPz/BdRLjW8LPQXwMMMpREO9eXCrREVoRkx/lyHz4yFhws
         lKxPn2GNe44duteHyrKO6iswzeajESaJZyVkHleLP5SJVaxrOLUd9wPu0J6JQADaEI
         xgQGwwv3t5ZsmVTke7eNwGI+V5MfcbhHsf/DzUDk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 415/599] staging: mt7621-dts: fix formatting
Date:   Tue,  5 Apr 2022 09:31:49 +0200
Message-Id: <20220405070311.181902471@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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
index 27222f7b246f..50f6d89f4673 100644
--- a/drivers/staging/mt7621-dts/mt7621.dtsi
+++ b/drivers/staging/mt7621-dts/mt7621.dtsi
@@ -56,9 +56,9 @@
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
@@ -412,17 +412,18 @@
 
 		mediatek,ethsys = <&ethsys>;
 
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
@@ -430,6 +431,7 @@
 			phy-mode = "rgmii-rxid";
 			phy-handle = <&phy_external>;
 		};
+
 		mdio-bus {
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -456,36 +458,43 @@
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



