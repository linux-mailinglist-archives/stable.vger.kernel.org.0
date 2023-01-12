Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1F926673D0
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 14:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233418AbjALN7B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 08:59:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233591AbjALN7A (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 08:59:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 003194FD43
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 05:58:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8A06B81E69
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 13:58:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B82CCC433D2;
        Thu, 12 Jan 2023 13:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673531936;
        bh=7jwwmwTuB25zG8hPI463ozNE0Nb6QUudG6CV8pzKtmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V/EVGwfpQI+M9xk1vwwgslEWGWtcvQ6/SwFopdXHVisZFs16E5dUnUblwV1ClF+Ib
         DYOVYFXYXfWyHrYj77DwUijiIrg2g+B9IkLf3xUHFSNfY61004jtvbqDkRZnpCJiKT
         qu4sJ00fFxREZSDbC/plSb/zl1hYDy99lsTjkBpw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 003/783] arm64: dts: qcom: msm8996: fix GPU OPP table
Date:   Thu, 12 Jan 2023 14:45:19 +0100
Message-Id: <20230112135524.326805981@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index ef5d03a15069..bc140269e4cc 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -651,17 +651,17 @@ gpu_opp_table: opp-table {
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



