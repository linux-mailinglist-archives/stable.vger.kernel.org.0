Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 216A36AEDFC
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbjCGSIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:08:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232333AbjCGSIf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:08:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C9CCAA276
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:02:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF42EB8184E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:02:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07439C433EF;
        Tue,  7 Mar 2023 18:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212157;
        bh=UZxM7+bT71Dgy83bdohcWlm3OEw/8x0nTjlbBh/+eXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x0i6OsAOQHFUYaVnhFcCPNomhENkPX+wrLaxAaJWfbe1vh4b+NcE3utJCPXtPFLbQ
         Z8ALA2k3rigUsa87ENZwXoQJLeI8JCbdwSzUwLb6Flrvzr4sFfJkloCpea3gj9oo66
         T6Lq9IhNdfj7HNslQYxnmTBr4yNqp1lgzc3ZwTjA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Konrad Dybcio <konrad.dybcio@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 096/885] arm64: dts: qcom: msm8992-*: Fix up comments
Date:   Tue,  7 Mar 2023 17:50:30 +0100
Message-Id: <20230307170006.010256436@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 290d43062d261cebd17ff590dc91f1d1e3fe6eed ]

Make sure all multiline C-style commends begin with just '/*' with
the comment text starting on a new line.

Also, trim off downstream regulator properties from comments to prevent
them from accidentally landing into mainline one day..

Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221107145522.6706-9-konrad.dybcio@linaro.org
Stable-dep-of: 2866527093dd ("arm64: dts: qcom: msm8992-lg-bullhead: Enable regulators")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/qcom/msm8992-lg-bullhead-rev-10.dts   |  3 +-
 .../dts/qcom/msm8992-lg-bullhead-rev-101.dts  |  3 +-
 .../boot/dts/qcom/msm8992-lg-bullhead.dtsi    | 41 ++++++++++---------
 arch/arm64/boot/dts/qcom/msm8992.dtsi         |  3 +-
 4 files changed, 28 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead-rev-10.dts b/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead-rev-10.dts
index 7e6bce4af4410..4159fc35571a6 100644
--- a/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead-rev-10.dts
+++ b/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead-rev-10.dts
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* Copyright (c) Jean Thomas <virgule@jeanthomas.me>
+/*
+ * Copyright (c) Jean Thomas <virgule@jeanthomas.me>
  */
 
 /dts-v1/;
diff --git a/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead-rev-101.dts b/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead-rev-101.dts
index e6a5ebd30e2f5..ad9702dd171be 100644
--- a/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead-rev-101.dts
+++ b/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead-rev-101.dts
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* Copyright (c) Jean Thomas <virgule@jeanthomas.me>
+/*
+ * Copyright (c) Jean Thomas <virgule@jeanthomas.me>
  */
 
 /dts-v1/;
diff --git a/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi b/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi
index d1962dc24bb7e..db05dc3ba16df 100644
--- a/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* Copyright (c) 2015, LGE Inc. All rights reserved.
+/*
+ * Copyright (c) 2015, LGE Inc. All rights reserved.
  * Copyright (c) 2016, The Linux Foundation. All rights reserved.
  * Copyright (c) 2021-2022, Petr Vorel <petr.vorel@gmail.com>
  * Copyright (c) 2022, Dominik Kobinski <dominikkobinski314@gmail.com>
@@ -250,9 +251,11 @@ pm8994_l25: l25 {
 		};
 
 		pm8994_l26: l26 {
-			/* TODO: value from downstream
-			regulator-min-microvolt = <987500>;
-			fails to apply */
+			/*
+			 * TODO: value from downstream
+			 * regulator-min-microvolt = <987500>;
+			 * fails to apply
+			 */
 		};
 
 		pm8994_l27: l27 {
@@ -266,19 +269,19 @@ pm8994_l28: l28 {
 		};
 
 		pm8994_l29: l29 {
-			/* TODO: Unsupported voltage range.
-			regulator-min-microvolt = <2800000>;
-			regulator-max-microvolt = <2800000>;
-			qcom,init-voltage = <2800000>;
-			*/
+			/*
+			 * TODO: Unsupported voltage range.
+			 * regulator-min-microvolt = <2800000>;
+			 * regulator-max-microvolt = <2800000>;
+			 */
 		};
 
 		pm8994_l30: l30 {
-			/* TODO: get this verified
-			regulator-min-microvolt = <1800000>;
-			regulator-max-microvolt = <1800000>;
-			qcom,init-voltage = <1800000>;
-			*/
+			/*
+			 * TODO: get this verified
+			 * regulator-min-microvolt = <1800000>;
+			 * regulator-max-microvolt = <1800000>;
+			 */
 		};
 
 		pm8994_l31: l31 {
@@ -287,11 +290,11 @@ pm8994_l31: l31 {
 		};
 
 		pm8994_l32: l32 {
-			/* TODO: get this verified
-			regulator-min-microvolt = <1800000>;
-			regulator-max-microvolt = <1800000>;
-			qcom,init-voltage = <1800000>;
-			*/
+			/*
+			 * TODO: get this verified
+			 * regulator-min-microvolt = <1800000>;
+			 * regulator-max-microvolt = <1800000>;
+			 */
 		};
 	};
 
diff --git a/arch/arm64/boot/dts/qcom/msm8992.dtsi b/arch/arm64/boot/dts/qcom/msm8992.dtsi
index f4be09fc1b151..02fc3795dbfd7 100644
--- a/arch/arm64/boot/dts/qcom/msm8992.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8992.dtsi
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* Copyright (c) 2013-2016, The Linux Foundation. All rights reserved.
+/*
+ * Copyright (c) 2013-2016, The Linux Foundation. All rights reserved.
  */
 
 #include "msm8994.dtsi"
-- 
2.39.2



