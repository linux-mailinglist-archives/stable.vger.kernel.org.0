Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 269B4593EE8
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346035AbiHOUrS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346739AbiHOUqj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:46:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 499E3B6D35;
        Mon, 15 Aug 2022 12:08:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D86C2606A1;
        Mon, 15 Aug 2022 19:08:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C21E9C433D6;
        Mon, 15 Aug 2022 19:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590516;
        bh=S479fwfCAHX9xtmUdxRoDRXhSxE0n2j7OXnPombf3gM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=npAJCvbAWoh1pN1V1kQVkqF3Mz6jM0k524g52OeLW2mTT+hH4WRLsmhAocuQK7RfC
         8TR/OXHDkQaZ4nxipQy1oPFv33K9zrCO/P9rFNaw7jVLjFqr3wFh7fcJFl/J2qi9/U
         VCTAOJAWddRqnNnHs12tdWv0TAfO7i9/ga24WH0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Weiss <luca@z3ntu.xyz>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0284/1095] ARM: dts: qcom: msm8974-FP2: Add supplies for remoteprocs
Date:   Mon, 15 Aug 2022 19:54:43 +0200
Message-Id: <20220815180441.533759595@linuxfoundation.org>
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

From: Luca Weiss <luca@z3ntu.xyz>

[ Upstream commit fb5e339fb1bc9eb7f34b341d995e4ab39c03588e ]

Those were removed from msm8974.dtsi as part of a recent cleanup commit,
so add them back for FP2.

Signed-off-by: Luca Weiss <luca@z3ntu.xyz>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220421214243.352469-3-luca@z3ntu.xyz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-msm8974-fairphone-fp2.dts | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-msm8974-fairphone-fp2.dts b/arch/arm/boot/dts/qcom-msm8974-fairphone-fp2.dts
index d6799a1b820b..32975f56f896 100644
--- a/arch/arm/boot/dts/qcom-msm8974-fairphone-fp2.dts
+++ b/arch/arm/boot/dts/qcom-msm8974-fairphone-fp2.dts
@@ -131,6 +131,17 @@ wcnss {
 	};
 };
 
+&remoteproc_adsp {
+	cx-supply = <&pm8841_s2>;
+};
+
+&remoteproc_mss {
+	cx-supply = <&pm8841_s2>;
+	mss-supply = <&pm8841_s3>;
+	mx-supply = <&pm8841_s1>;
+	pll-supply = <&pm8941_l12>;
+};
+
 &rpm_requests {
 	pm8841-regulators {
 		compatible = "qcom,rpm-pm8841-regulators";
-- 
2.35.1



