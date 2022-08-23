Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38D4959D4C8
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243646AbiHWIe1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344319AbiHWIcY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:32:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C50167175;
        Tue, 23 Aug 2022 01:16:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A26361228;
        Tue, 23 Aug 2022 08:15:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86DBEC433D6;
        Tue, 23 Aug 2022 08:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242547;
        bh=NoLqcpS0ng+Lbg3o1rbtMkbo2kGPL0fu1NrGMr0k/Mk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OGSg/mWYz5OgZM1cBgjQF9rXh2JteRQrGUL9euce9MfVQcJ7TnKTMWWyCx5B5sqA3
         dk5toUCpO/rjIkscaVTsDJEXCwC7F6RiYl20Lci3ofQPrUg1uleP8J1na1QQx1IGKC
         +M3x7LyLCNHIl2KQa/tatee6HMNP23T+aFGoYHco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 5.19 135/365] dt-bindings: opp: opp-v2-kryo-cpu: Fix example binding checks
Date:   Tue, 23 Aug 2022 10:00:36 +0200
Message-Id: <20220823080123.850327587@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

commit 3b4916a6e422394aa129fe9b204f4d489ae484a6 upstream.

Adding missing compat entries to the cpufreq node
Documentation/devicetree/bindings/cpufreq/qcom-cpufreq-nvmem.yaml shows up
a dt_binding_check in this file.

opp-v2-kryo-cpu.example.dtb: /: cpus:cpu@0: 'power-domains' is a required property
opp-v2-kryo-cpu.example.dtb: /: cpus:cpu@0: 'power-domain-names' is a required property
opp-v2-kryo-cpu.example.dtb: /: opp-table-0:opp-307200000: 'required-opps' is a required property

Fixes: ec24d1d55469 ("dt-bindings: opp: Convert qcom-nvmem-cpufreq to DT schema")
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../devicetree/bindings/opp/opp-v2-kryo-cpu.yaml  | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/Documentation/devicetree/bindings/opp/opp-v2-kryo-cpu.yaml b/Documentation/devicetree/bindings/opp/opp-v2-kryo-cpu.yaml
index 30f7b596d609..59663e897dae 100644
--- a/Documentation/devicetree/bindings/opp/opp-v2-kryo-cpu.yaml
+++ b/Documentation/devicetree/bindings/opp/opp-v2-kryo-cpu.yaml
@@ -98,6 +98,8 @@ examples:
                 capacity-dmips-mhz = <1024>;
                 clocks = <&kryocc 0>;
                 operating-points-v2 = <&cluster0_opp>;
+                power-domains = <&cpr>;
+                power-domain-names = "cpr";
                 #cooling-cells = <2>;
                 next-level-cache = <&L2_0>;
                 L2_0: l2-cache {
@@ -115,6 +117,8 @@ examples:
                 capacity-dmips-mhz = <1024>;
                 clocks = <&kryocc 0>;
                 operating-points-v2 = <&cluster0_opp>;
+                power-domains = <&cpr>;
+                power-domain-names = "cpr";
                 #cooling-cells = <2>;
                 next-level-cache = <&L2_0>;
             };
@@ -128,6 +132,8 @@ examples:
                 capacity-dmips-mhz = <1024>;
                 clocks = <&kryocc 1>;
                 operating-points-v2 = <&cluster1_opp>;
+                power-domains = <&cpr>;
+                power-domain-names = "cpr";
                 #cooling-cells = <2>;
                 next-level-cache = <&L2_1>;
                 L2_1: l2-cache {
@@ -145,6 +151,8 @@ examples:
                 capacity-dmips-mhz = <1024>;
                 clocks = <&kryocc 1>;
                 operating-points-v2 = <&cluster1_opp>;
+                power-domains = <&cpr>;
+                power-domain-names = "cpr";
                 #cooling-cells = <2>;
                 next-level-cache = <&L2_1>;
             };
@@ -182,18 +190,21 @@ examples:
                 opp-microvolt = <905000 905000 1140000>;
                 opp-supported-hw = <0x7>;
                 clock-latency-ns = <200000>;
+                required-opps = <&cpr_opp1>;
             };
             opp-1401600000 {
                 opp-hz = /bits/ 64 <1401600000>;
                 opp-microvolt = <1140000 905000 1140000>;
                 opp-supported-hw = <0x5>;
                 clock-latency-ns = <200000>;
+                required-opps = <&cpr_opp2>;
             };
             opp-1593600000 {
                 opp-hz = /bits/ 64 <1593600000>;
                 opp-microvolt = <1140000 905000 1140000>;
                 opp-supported-hw = <0x1>;
                 clock-latency-ns = <200000>;
+                required-opps = <&cpr_opp3>;
             };
         };
 
@@ -207,24 +218,28 @@ examples:
                 opp-microvolt = <905000 905000 1140000>;
                 opp-supported-hw = <0x7>;
                 clock-latency-ns = <200000>;
+                required-opps = <&cpr_opp1>;
             };
             opp-1804800000 {
                 opp-hz = /bits/ 64 <1804800000>;
                 opp-microvolt = <1140000 905000 1140000>;
                 opp-supported-hw = <0x6>;
                 clock-latency-ns = <200000>;
+                required-opps = <&cpr_opp4>;
             };
             opp-1900800000 {
                 opp-hz = /bits/ 64 <1900800000>;
                 opp-microvolt = <1140000 905000 1140000>;
                 opp-supported-hw = <0x4>;
                 clock-latency-ns = <200000>;
+                required-opps = <&cpr_opp5>;
             };
             opp-2150400000 {
                 opp-hz = /bits/ 64 <2150400000>;
                 opp-microvolt = <1140000 905000 1140000>;
                 opp-supported-hw = <0x1>;
                 clock-latency-ns = <200000>;
+                required-opps = <&cpr_opp6>;
             };
         };
 
-- 
2.37.2



