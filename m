Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D518593E4E
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345007AbiHOUj5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345874AbiHOUhw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:37:52 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C5FAE20B;
        Mon, 15 Aug 2022 12:07:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AE54FCE1087;
        Mon, 15 Aug 2022 19:07:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DEBCC433C1;
        Mon, 15 Aug 2022 19:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590428;
        bh=O3JKpxMBdBMlzcnXK+pT01181eyK9/vtz6/V4r6tbU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uj+/OKeWj9JvscvpFcqswh6JmkEWLV0ZJbSaw5mzBOout4d9oScOcX5HNDCMYIU7G
         Vmm/qIr8P83tBzyfmwybzh18rfe/yJ6LjLDjumSlYhnruwfRLyBKizqf7lYGsGNi5n
         3Ra7xzkOnB3znDrpv+7MKUduNDxG1WstFHdmfruk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0256/1095] arm64: dts: qcom: sm6125: Append -state suffix to pinctrl nodes
Date:   Mon, 15 Aug 2022 19:54:15 +0200
Message-Id: <20220815180440.335917253@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit cbfb5668aece448877fa7826cde81c9d06f4a4ac ]

According to qcom,sm6125-pinctrl.yaml all nodes inside the tlmm must be
suffixed by -state:

    qcom/sm6125-sony-xperia-seine-pdx201.dtb: pinctrl@500000: 'sdc2-off', 'sdc2-on' do not match any of the regexes: '-state$', 'pinctrl-[0-9]+'

The label names have been updated to match, going from sdc2_state_X to
sdc2_X_state.

Fixes: cff4bbaf2a2d ("arm64: dts: qcom: Add support for SM6125")
Fixes: 82e1783890b7 ("arm64: dts: qcom: sm6125: Add support for Sony Xperia 10II")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220508100336.127176-2-marijn.suijten@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/qcom/sm6125-sony-xperia-seine-pdx201.dts     | 4 ++--
 arch/arm64/boot/dts/qcom/sm6125.dtsi                      | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm6125-sony-xperia-seine-pdx201.dts b/arch/arm64/boot/dts/qcom/sm6125-sony-xperia-seine-pdx201.dts
index 4916e6c8b625..038970c0b68e 100644
--- a/arch/arm64/boot/dts/qcom/sm6125-sony-xperia-seine-pdx201.dts
+++ b/arch/arm64/boot/dts/qcom/sm6125-sony-xperia-seine-pdx201.dts
@@ -88,7 +88,7 @@ &hsusb_phy1 {
 	status = "okay";
 };
 
-&sdc2_state_off {
+&sdc2_off_state {
 	sd-cd {
 		pins = "gpio98";
 		drive-strength = <2>;
@@ -96,7 +96,7 @@ sd-cd {
 	};
 };
 
-&sdc2_state_on {
+&sdc2_on_state {
 	sd-cd {
 		pins = "gpio98";
 		drive-strength = <2>;
diff --git a/arch/arm64/boot/dts/qcom/sm6125.dtsi b/arch/arm64/boot/dts/qcom/sm6125.dtsi
index 3fadf5196c4d..e601b9bfdc04 100644
--- a/arch/arm64/boot/dts/qcom/sm6125.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6125.dtsi
@@ -386,7 +386,7 @@ tlmm: pinctrl@500000 {
 			interrupt-controller;
 			#interrupt-cells = <2>;
 
-			sdc2_state_off: sdc2-off {
+			sdc2_off_state: sdc2-off-state {
 				clk {
 					pins = "sdc2_clk";
 					drive-strength = <2>;
@@ -406,7 +406,7 @@ data {
 				};
 			};
 
-			sdc2_state_on: sdc2-on {
+			sdc2_on_state: sdc2-on-state {
 				clk {
 					pins = "sdc2_clk";
 					drive-strength = <16>;
@@ -490,8 +490,8 @@ sdhc_2: sdhci@4784000 {
 				 <&xo_board>;
 			clock-names = "iface", "core", "xo";
 
-			pinctrl-0 = <&sdc2_state_on>;
-			pinctrl-1 = <&sdc2_state_off>;
+			pinctrl-0 = <&sdc2_on_state>;
+			pinctrl-1 = <&sdc2_off_state>;
 			pinctrl-names = "default", "sleep";
 
 			power-domains = <&rpmpd SM6125_VDDCX>;
-- 
2.35.1



