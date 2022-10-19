Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD1D6047EA
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233435AbiJSNq6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233212AbiJSNpv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:45:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C06B21DED5F;
        Wed, 19 Oct 2022 06:32:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4CF83B8242D;
        Wed, 19 Oct 2022 08:57:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BFACC433C1;
        Wed, 19 Oct 2022 08:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169837;
        bh=PYvTOfK5/ovQoOBElMYI9WPaPBV5gZLqnys7E0w5Q0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l1JS7WIiulMo/GcZnRTN5NkpwNMQScKvW9UXeIYFHehp7j5dpUo9xR5yDtJ0nnVgp
         sCu87T8xHd4Xty3Cm8IJOX/sNGxH8pkqkAZlucWe+ip24ls2znQyWhmX/iqUCSUieG
         d5mhoxJ4/ynToAfiSthyLYy9EDkQirgjXTJULdyg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taniya Das <quic_tdas@quicinc.com>,
        Satya Priya <quic_c_skakit@quicinc.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 428/862] arm64: dts: qcom: sc7280: Update lpasscore node
Date:   Wed, 19 Oct 2022 10:28:35 +0200
Message-Id: <20221019083308.876840938@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Satya Priya <quic_c_skakit@quicinc.com>

[ Upstream commit d9a1e922730389afc425f2250de361b7f07acdbc ]

To maintain consistency with other lpass nodes(lpass_audiocc,
lpass_aon and lpass_hm), update lpasscore to lpass_core.

Fixes: 9499240d15f2 ("arm64: dts: qcom: sc7280: Add lpasscore & lpassaudio clock controllers")
Signed-off-by: Taniya Das <quic_tdas@quicinc.com>
Signed-off-by: Satya Priya <quic_c_skakit@quicinc.com>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/1660107909-27947-4-git-send-email-quic_c_skakit@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index 1d48f92a2982..51ed691075ad 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -2191,13 +2191,13 @@
 			reg = <0 0x03380000 0 0x30000>;
 			clocks = <&rpmhcc RPMH_CXO_CLK>,
 			       <&rpmhcc RPMH_CXO_CLK_A>,
-			       <&lpasscore LPASS_CORE_CC_CORE_CLK>;
+			       <&lpass_core LPASS_CORE_CC_CORE_CLK>;
 			clock-names = "bi_tcxo", "bi_tcxo_ao", "iface";
 			#clock-cells = <1>;
 			#power-domain-cells = <1>;
 		};
 
-		lpasscore: clock-controller@3900000 {
+		lpass_core: clock-controller@3900000 {
 			compatible = "qcom,sc7280-lpasscorecc";
 			reg = <0 0x03900000 0 0x50000>;
 			clocks = <&rpmhcc RPMH_CXO_CLK>;
-- 
2.35.1



