Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5DC4F27EC
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233293AbiDEIJn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235388AbiDEH7l (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:59:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C422257B01;
        Tue,  5 Apr 2022 00:54:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B6A9B81BAF;
        Tue,  5 Apr 2022 07:54:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C931BC340EE;
        Tue,  5 Apr 2022 07:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145247;
        bh=PdTl2gDBiABNcwodj9dveqVoYd5A27vl2BOyA9QCatM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SFpW4COP+tYwt3rp5cSitkOPYaD36VFj13StkpFMBRvHuZp0Da5tOQ6MrR3Ysi8pT
         jOdtyB8cr0GOIvV+o6MFHqa4YmKeWQXDeA3RW6r8tbehzL3pZRNbe5i/zZ8r5ms3kk
         qBcb0FZlQk5pBTDbkDLJrNjUQnAwJsEJrEZboPxw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, devicetree@vger.kernel.org,
        Maulik Shah <quic_mkshah@quicinc.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0337/1126] arm64: dts: qcom: sm8450: Update cpuidle states parameters
Date:   Tue,  5 Apr 2022 09:18:04 +0200
Message-Id: <20220405070417.507344638@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Maulik Shah <quic_mkshah@quicinc.com>

[ Upstream commit 6574702b0d394d2acc9ff808c4a79df8b9999173 ]

This change updates/corrects below cpuidle parameters

1. entry-latency, exit-latency and residency for various idle states.
2. arm,psci-suspend-param which is same for CLUSTER_SLEEP_0/1 states.
3. Add CLUSTER_SLEEP_1 in CLUSTER_PD.

Cc: devicetree@vger.kernel.org
Fixes: 5188049c9b36 ("arm64: dts: qcom: Add base SM8450 DTSI")
Signed-off-by: Maulik Shah <quic_mkshah@quicinc.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
[bjorn: Split domain-idle-states, per Ulf's request]
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/1641749107-31979-5-git-send-email-quic_mkshah@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8450.dtsi | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
index 02b97e838c47..9ee055143f8a 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -203,9 +203,9 @@
 				compatible = "arm,idle-state";
 				idle-state-name = "silver-rail-power-collapse";
 				arm,psci-suspend-param = <0x40000004>;
-				entry-latency-us = <274>;
-				exit-latency-us = <480>;
-				min-residency-us = <3934>;
+				entry-latency-us = <800>;
+				exit-latency-us = <750>;
+				min-residency-us = <4090>;
 				local-timer-stop;
 			};
 
@@ -213,9 +213,9 @@
 				compatible = "arm,idle-state";
 				idle-state-name = "gold-rail-power-collapse";
 				arm,psci-suspend-param = <0x40000004>;
-				entry-latency-us = <327>;
-				exit-latency-us = <1502>;
-				min-residency-us = <4488>;
+				entry-latency-us = <600>;
+				exit-latency-us = <1550>;
+				min-residency-us = <4791>;
 				local-timer-stop;
 			};
 		};
@@ -224,10 +224,10 @@
 			CLUSTER_SLEEP_0: cluster-sleep-0 {
 				compatible = "domain-idle-state";
 				idle-state-name = "cluster-l3-off";
-				arm,psci-suspend-param = <0x4100c344>;
-				entry-latency-us = <584>;
-				exit-latency-us = <2332>;
-				min-residency-us = <6118>;
+				arm,psci-suspend-param = <0x41000044>;
+				entry-latency-us = <1050>;
+				exit-latency-us = <2500>;
+				min-residency-us = <5309>;
 				local-timer-stop;
 			};
 
@@ -235,9 +235,9 @@
 				compatible = "domain-idle-state";
 				idle-state-name = "cluster-power-collapse";
 				arm,psci-suspend-param = <0x4100c344>;
-				entry-latency-us = <2893>;
-				exit-latency-us = <4023>;
-				min-residency-us = <9987>;
+				entry-latency-us = <2700>;
+				exit-latency-us = <3500>;
+				min-residency-us = <13959>;
 				local-timer-stop;
 			};
 		};
@@ -315,7 +315,7 @@
 
 		CLUSTER_PD: cpu-cluster0 {
 			#power-domain-cells = <0>;
-			domain-idle-states = <&CLUSTER_SLEEP_0>;
+			domain-idle-states = <&CLUSTER_SLEEP_0>, <&CLUSTER_SLEEP_1>;
 		};
 	};
 
-- 
2.34.1



