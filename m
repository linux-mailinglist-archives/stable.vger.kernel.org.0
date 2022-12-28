Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1304657819
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232924AbiL1OsD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:48:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233044AbiL1Orh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:47:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E94C31209A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:46:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 887EF6154C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:46:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A6FC433D2;
        Wed, 28 Dec 2022 14:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672238813;
        bh=5JZHmcmcfT7DwKMbrzGvZFxRQEpKQM7s9md3eNOtSYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SNJSrM2mMPGa4SNKAbDEKRLXYkc6rwFCUg73WLiSz1AqA4wT494tBBDSA9c3/81Su
         ms4tjf0mdmGYDuAEEPmaEwvfXkpBzmBCURI8pt6BVl1ikf1SttAPZAW5E0IgrGk4OE
         ypfBEj13Mt2Dcck5Jm1bPFdwl/wyxGNWZ3+5gHKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 007/731] arm64: dts: qcom: msm8996: fix GPU OPP table
Date:   Wed, 28 Dec 2022 15:31:54 +0100
Message-Id: <20221228144256.752675111@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 0d440d811e6e2f37093e54db55bc27fe66678170 ]

Fix Adreno OPP table according to the msm-3.18. Enable 624 MHz for the
speed bin 3 and 560 MHz for bins 2 and 3.

Fixes: 69cc3114ab0f ("arm64: dts: Add Adreno GPU definitions")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20220724140421.1933004-7-dmitry.baryshkov@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8996.dtsi | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
index 032c6cd635e2..70187fd03a26 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -995,17 +995,17 @@ gpu_opp_table: opp-table {
 				compatible  ="operating-points-v2";
 
 				/*
-				 * 624Mhz and 560Mhz are only available on speed
-				 * bin (1 << 0). All the rest are available on
-				 * all bins of the hardware
+				 * 624Mhz is only available on speed bins 0 and 3.
+				 * 560Mhz is only available on speed bins 0, 2 and 3.
+				 * All the rest are available on all bins of the hardware.
 				 */
 				opp-624000000 {
 					opp-hz = /bits/ 64 <624000000>;
-					opp-supported-hw = <0x01>;
+					opp-supported-hw = <0x09>;
 				};
 				opp-560000000 {
 					opp-hz = /bits/ 64 <560000000>;
-					opp-supported-hw = <0x01>;
+					opp-supported-hw = <0x0d>;
 				};
 				opp-510000000 {
 					opp-hz = /bits/ 64 <510000000>;
-- 
2.35.1



