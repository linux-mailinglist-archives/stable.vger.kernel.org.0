Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 229746357EB
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237235AbiKWJrE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:47:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238003AbiKWJqs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:46:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFCB81157BD
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:43:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC1A3B81EF3
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:43:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B10C433D6;
        Wed, 23 Nov 2022 09:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196630;
        bh=dks9UQgC0TZgBkgbXyd+ksFi4atRYJN5DNMUNJF0bmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J1GGtd6oSKRtn2wrFtBMLnkvs521Asne8vzbiTDGScffgpj9sc71d5NwpskilYe0p
         EVuMjFU/k+IszNWWkatSmyGgL4WI0iQEmn3NID/R1Awf6UKXQassN3eHfxjeFvLbqq
         TRU19zAs/jsgPKEoBdY0mtaqepqE0m/fHaaGL0eU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Satya Priya <quic_c_skakit@quicinc.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 085/314] arm64: dts: qcom: sc7280: Add the reset reg for lpass audiocc on SC7280
Date:   Wed, 23 Nov 2022 09:48:50 +0100
Message-Id: <20221123084629.326103231@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Satya Priya <quic_c_skakit@quicinc.com>

[ Upstream commit cb1d0aaa674e99957b85af570cb2730145af01df ]

Add the reset register offset for clock gating.

Fixes: 9499240d15f2 ("arm64: dts: qcom: sc7280: Add lpasscore & lpassaudio clock controllers")
Signed-off-by: Satya Priya <quic_c_skakit@quicinc.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/1663674495-25748-1-git-send-email-quic_c_skakit@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280.dtsi | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index 51ed691075ad..b3c3844f97a0 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -2177,7 +2177,8 @@ lpasscc: lpasscc@3000000 {
 
 		lpass_audiocc: clock-controller@3300000 {
 			compatible = "qcom,sc7280-lpassaudiocc";
-			reg = <0 0x03300000 0 0x30000>;
+			reg = <0 0x03300000 0 0x30000>,
+			      <0 0x032a9000 0 0x1000>;
 			clocks = <&rpmhcc RPMH_CXO_CLK>,
 			       <&lpass_aon LPASS_AON_CC_MAIN_RCG_CLK_SRC>;
 			clock-names = "bi_tcxo", "lpass_aon_cc_main_rcg_clk_src";
-- 
2.35.1



