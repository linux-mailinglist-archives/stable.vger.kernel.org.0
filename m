Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F965594358
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350515AbiHOWmq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350812AbiHOWko (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:40:44 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33B94DB3A;
        Mon, 15 Aug 2022 12:52:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 662E5CE1262;
        Mon, 15 Aug 2022 19:52:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55B5DC433C1;
        Mon, 15 Aug 2022 19:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593119;
        bh=y00JDlmXaOUG89+arkkzRd59IEcKQ9D8Us7X+XR4hQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hG0YsDD6w1Y0Gkg5lfSJ7oGpYUBGRJa+ljUbHnUqz1b8IMNnQJ9DCkif2kcYafq8w
         sBe50AplLZkeWgAuHcVAwIl2wfF293cSstxsZfFpVqMbEdnGhLmpfluX3z98YonmV1
         NNFgpsC5u75AcbErKJ5RzdX5bMAunGYneqLQSrAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" 
        <nfraprado@collabora.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0217/1157] arm64: dts: mt8192: Fix idle-states nodes naming scheme
Date:   Mon, 15 Aug 2022 19:52:53 +0200
Message-Id: <20220815180448.278004903@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAD_ENC_HEADER,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit 399e23ad51caaf62400a531c9268ad3c453c3d76 ]

Tweak the name of the idle-states subnodes so that they follow the
binding pattern, getting rid of dtbs_check warnings.

Only the usage of "-" in the name was necessary, but "off" was also
exchanged for "sleep" since that seems to be a more common wording in
other dts files.

Fixes: 9260918d3a4f ("arm64: dts: mt8192: Add cpu-idle-states")
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20220617233150.2466344-2-nfraprado@collabora.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8192.dtsi | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8192.dtsi b/arch/arm64/boot/dts/mediatek/mt8192.dtsi
index 733aec2e7f77..c739e910883a 100644
--- a/arch/arm64/boot/dts/mediatek/mt8192.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8192.dtsi
@@ -43,7 +43,7 @@ cpu0: cpu@0 {
 			reg = <0x000>;
 			enable-method = "psci";
 			clock-frequency = <1701000000>;
-			cpu-idle-states = <&cpuoff_l &clusteroff_l>;
+			cpu-idle-states = <&cpu_sleep_l &cluster_sleep_l>;
 			next-level-cache = <&l2_0>;
 			capacity-dmips-mhz = <530>;
 		};
@@ -54,7 +54,7 @@ cpu1: cpu@100 {
 			reg = <0x100>;
 			enable-method = "psci";
 			clock-frequency = <1701000000>;
-			cpu-idle-states = <&cpuoff_l &clusteroff_l>;
+			cpu-idle-states = <&cpu_sleep_l &cluster_sleep_l>;
 			next-level-cache = <&l2_0>;
 			capacity-dmips-mhz = <530>;
 		};
@@ -65,7 +65,7 @@ cpu2: cpu@200 {
 			reg = <0x200>;
 			enable-method = "psci";
 			clock-frequency = <1701000000>;
-			cpu-idle-states = <&cpuoff_l &clusteroff_l>;
+			cpu-idle-states = <&cpu_sleep_l &cluster_sleep_l>;
 			next-level-cache = <&l2_0>;
 			capacity-dmips-mhz = <530>;
 		};
@@ -76,7 +76,7 @@ cpu3: cpu@300 {
 			reg = <0x300>;
 			enable-method = "psci";
 			clock-frequency = <1701000000>;
-			cpu-idle-states = <&cpuoff_l &clusteroff_l>;
+			cpu-idle-states = <&cpu_sleep_l &cluster_sleep_l>;
 			next-level-cache = <&l2_0>;
 			capacity-dmips-mhz = <530>;
 		};
@@ -87,7 +87,7 @@ cpu4: cpu@400 {
 			reg = <0x400>;
 			enable-method = "psci";
 			clock-frequency = <2171000000>;
-			cpu-idle-states = <&cpuoff_b &clusteroff_b>;
+			cpu-idle-states = <&cpu_sleep_b &cluster_sleep_b>;
 			next-level-cache = <&l2_1>;
 			capacity-dmips-mhz = <1024>;
 		};
@@ -98,7 +98,7 @@ cpu5: cpu@500 {
 			reg = <0x500>;
 			enable-method = "psci";
 			clock-frequency = <2171000000>;
-			cpu-idle-states = <&cpuoff_b &clusteroff_b>;
+			cpu-idle-states = <&cpu_sleep_b &cluster_sleep_b>;
 			next-level-cache = <&l2_1>;
 			capacity-dmips-mhz = <1024>;
 		};
@@ -109,7 +109,7 @@ cpu6: cpu@600 {
 			reg = <0x600>;
 			enable-method = "psci";
 			clock-frequency = <2171000000>;
-			cpu-idle-states = <&cpuoff_b &clusteroff_b>;
+			cpu-idle-states = <&cpu_sleep_b &cluster_sleep_b>;
 			next-level-cache = <&l2_1>;
 			capacity-dmips-mhz = <1024>;
 		};
@@ -120,7 +120,7 @@ cpu7: cpu@700 {
 			reg = <0x700>;
 			enable-method = "psci";
 			clock-frequency = <2171000000>;
-			cpu-idle-states = <&cpuoff_b &clusteroff_b>;
+			cpu-idle-states = <&cpu_sleep_b &cluster_sleep_b>;
 			next-level-cache = <&l2_1>;
 			capacity-dmips-mhz = <1024>;
 		};
@@ -173,7 +173,7 @@ l3_0: l3-cache {
 
 		idle-states {
 			entry-method = "arm,psci";
-			cpuoff_l: cpuoff_l {
+			cpu_sleep_l: cpu-sleep-l {
 				compatible = "arm,idle-state";
 				arm,psci-suspend-param = <0x00010001>;
 				local-timer-stop;
@@ -181,7 +181,7 @@ cpuoff_l: cpuoff_l {
 				exit-latency-us = <140>;
 				min-residency-us = <780>;
 			};
-			cpuoff_b: cpuoff_b {
+			cpu_sleep_b: cpu-sleep-b {
 				compatible = "arm,idle-state";
 				arm,psci-suspend-param = <0x00010001>;
 				local-timer-stop;
@@ -189,7 +189,7 @@ cpuoff_b: cpuoff_b {
 				exit-latency-us = <145>;
 				min-residency-us = <720>;
 			};
-			clusteroff_l: clusteroff_l {
+			cluster_sleep_l: cluster-sleep-l {
 				compatible = "arm,idle-state";
 				arm,psci-suspend-param = <0x01010002>;
 				local-timer-stop;
@@ -197,7 +197,7 @@ clusteroff_l: clusteroff_l {
 				exit-latency-us = <155>;
 				min-residency-us = <860>;
 			};
-			clusteroff_b: clusteroff_b {
+			cluster_sleep_b: cluster-sleep-b {
 				compatible = "arm,idle-state";
 				arm,psci-suspend-param = <0x01010002>;
 				local-timer-stop;
-- 
2.35.1



