Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 949AB5938C5
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243360AbiHOSdz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243219AbiHOSd1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:33:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF86D3719F;
        Mon, 15 Aug 2022 11:21:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 905A160693;
        Mon, 15 Aug 2022 18:21:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E48EC433D6;
        Mon, 15 Aug 2022 18:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587710;
        bh=fS200tmG1/qu40YRV2CzAxh546mfr79e1vNI/1oiZX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c2kWeJ1mr3W6kEo0S48+4ltOAuhOSDQebeYpH7bzRINPuTl7+7UoIlPumjPUR2OOW
         SH/7NsQG4uBLOffZV/jD0qblSyFCm1j1vdM3xQ1286MaUAsYSt8vFpQohQX2MjBShI
         4yBG1moSjY2TeI01frPCVdWLbEKpPB3VQ0cQx1nU=
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
Subject: [PATCH 5.15 171/779] arm64: dts: mt8192: Fix idle-states nodes naming scheme
Date:   Mon, 15 Aug 2022 19:56:55 +0200
Message-Id: <20220815180344.607206440@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
index cb1e46d2c1ba..a57ac5163acc 100644
--- a/arch/arm64/boot/dts/mediatek/mt8192.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8192.dtsi
@@ -39,7 +39,7 @@ cpu0: cpu@0 {
 			reg = <0x000>;
 			enable-method = "psci";
 			clock-frequency = <1701000000>;
-			cpu-idle-states = <&cpuoff_l &clusteroff_l>;
+			cpu-idle-states = <&cpu_sleep_l &cluster_sleep_l>;
 			next-level-cache = <&l2_0>;
 			capacity-dmips-mhz = <530>;
 		};
@@ -50,7 +50,7 @@ cpu1: cpu@100 {
 			reg = <0x100>;
 			enable-method = "psci";
 			clock-frequency = <1701000000>;
-			cpu-idle-states = <&cpuoff_l &clusteroff_l>;
+			cpu-idle-states = <&cpu_sleep_l &cluster_sleep_l>;
 			next-level-cache = <&l2_0>;
 			capacity-dmips-mhz = <530>;
 		};
@@ -61,7 +61,7 @@ cpu2: cpu@200 {
 			reg = <0x200>;
 			enable-method = "psci";
 			clock-frequency = <1701000000>;
-			cpu-idle-states = <&cpuoff_l &clusteroff_l>;
+			cpu-idle-states = <&cpu_sleep_l &cluster_sleep_l>;
 			next-level-cache = <&l2_0>;
 			capacity-dmips-mhz = <530>;
 		};
@@ -72,7 +72,7 @@ cpu3: cpu@300 {
 			reg = <0x300>;
 			enable-method = "psci";
 			clock-frequency = <1701000000>;
-			cpu-idle-states = <&cpuoff_l &clusteroff_l>;
+			cpu-idle-states = <&cpu_sleep_l &cluster_sleep_l>;
 			next-level-cache = <&l2_0>;
 			capacity-dmips-mhz = <530>;
 		};
@@ -83,7 +83,7 @@ cpu4: cpu@400 {
 			reg = <0x400>;
 			enable-method = "psci";
 			clock-frequency = <2171000000>;
-			cpu-idle-states = <&cpuoff_b &clusteroff_b>;
+			cpu-idle-states = <&cpu_sleep_b &cluster_sleep_b>;
 			next-level-cache = <&l2_1>;
 			capacity-dmips-mhz = <1024>;
 		};
@@ -94,7 +94,7 @@ cpu5: cpu@500 {
 			reg = <0x500>;
 			enable-method = "psci";
 			clock-frequency = <2171000000>;
-			cpu-idle-states = <&cpuoff_b &clusteroff_b>;
+			cpu-idle-states = <&cpu_sleep_b &cluster_sleep_b>;
 			next-level-cache = <&l2_1>;
 			capacity-dmips-mhz = <1024>;
 		};
@@ -105,7 +105,7 @@ cpu6: cpu@600 {
 			reg = <0x600>;
 			enable-method = "psci";
 			clock-frequency = <2171000000>;
-			cpu-idle-states = <&cpuoff_b &clusteroff_b>;
+			cpu-idle-states = <&cpu_sleep_b &cluster_sleep_b>;
 			next-level-cache = <&l2_1>;
 			capacity-dmips-mhz = <1024>;
 		};
@@ -116,7 +116,7 @@ cpu7: cpu@700 {
 			reg = <0x700>;
 			enable-method = "psci";
 			clock-frequency = <2171000000>;
-			cpu-idle-states = <&cpuoff_b &clusteroff_b>;
+			cpu-idle-states = <&cpu_sleep_b &cluster_sleep_b>;
 			next-level-cache = <&l2_1>;
 			capacity-dmips-mhz = <1024>;
 		};
@@ -169,7 +169,7 @@ l3_0: l3-cache {
 
 		idle-states {
 			entry-method = "arm,psci";
-			cpuoff_l: cpuoff_l {
+			cpu_sleep_l: cpu-sleep-l {
 				compatible = "arm,idle-state";
 				arm,psci-suspend-param = <0x00010001>;
 				local-timer-stop;
@@ -177,7 +177,7 @@ cpuoff_l: cpuoff_l {
 				exit-latency-us = <140>;
 				min-residency-us = <780>;
 			};
-			cpuoff_b: cpuoff_b {
+			cpu_sleep_b: cpu-sleep-b {
 				compatible = "arm,idle-state";
 				arm,psci-suspend-param = <0x00010001>;
 				local-timer-stop;
@@ -185,7 +185,7 @@ cpuoff_b: cpuoff_b {
 				exit-latency-us = <145>;
 				min-residency-us = <720>;
 			};
-			clusteroff_l: clusteroff_l {
+			cluster_sleep_l: cluster-sleep-l {
 				compatible = "arm,idle-state";
 				arm,psci-suspend-param = <0x01010002>;
 				local-timer-stop;
@@ -193,7 +193,7 @@ clusteroff_l: clusteroff_l {
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



