Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1DFF5A3CE0
	for <lists+stable@lfdr.de>; Sun, 28 Aug 2022 10:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233466AbiH1Ioi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Aug 2022 04:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233683AbiH1IoT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Aug 2022 04:44:19 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21EF52ED5D
        for <stable@vger.kernel.org>; Sun, 28 Aug 2022 01:43:59 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id h8so3775098lfm.8
        for <stable@vger.kernel.org>; Sun, 28 Aug 2022 01:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=pn7zvEd3qTCZPHapj3e/ijoqlm/5im0DzgowdUXAlAI=;
        b=Lz3WrfhXkzIRS8bEalzlXs7j0WJcoeUYdm7OFa/L6Bm76eUH0C1zlQAtOCa1iKQ9Wa
         CNUM+6trWOrjooxmULMpMW1eCAT8f76Gt82GWXaeNABrsVWP7pWq+ATwNgIPr6giMgeS
         hw4+hA8B8OH0Rh1J9rZeNcqoPu1KRaspi5BoWuyuyQWBvmNouuRXrjMR8MjpNHBJZbOZ
         ZbUP95O5czqWXPEgNVOwug/Nhw0UL9VF0WkMuz+50PdPg3nYLU4TCRZxFZamxUeN8jtp
         5btPq+C2DQjlOG5AphE727IFJltqIEekIUEmvNKd3nTO9UeghqRWwgA3kfYN3ZsUwFji
         3nYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=pn7zvEd3qTCZPHapj3e/ijoqlm/5im0DzgowdUXAlAI=;
        b=Za44VfSDpdTqXus0dQH0C31RgXFaiIW/pQiPSyL6TEfZ4YuJX5Jkd3CDtMQ8uNh/PE
         JfXcF+1ZYrbJToJXU1xSmkfWCOOGQkxGt9dg7BeappeZjwf17LvtWXSn3r0p9WmtDzk5
         ZoBPulwXhE1bNR0nSV92L7MkFFfx/+2w/ftnSgTmAA8lROBttbRht+jFej8bOXzyS3zD
         pmSRXJP7ZF83Jph1pl28NlpszG65oG7VNStUB1U7bDpVUzm3nmwEjREbI7FtWlgT3rdh
         x0j3sRf0QNs8nvZsAXuKshMKYvSVtU4SUa0zcyv6LaBxvmQWd2w8jPUB1PZnMycoVPTj
         gJTg==
X-Gm-Message-State: ACgBeo2Lw2XWSB+UyMl1s4w7kG+ChDYpSeDjljopzgTE+LpIuxUzBSLG
        aPmx/wBNJkLiar1gcWWvkR9a/g==
X-Google-Smtp-Source: AA6agR77tlbUMZ14mX/MWczEvMCzVIt2a2+PjmMM/c+NYBUHzbY/V3W8Gf0gLMfxtDW1uQsmFdGbpg==
X-Received: by 2002:a05:6512:13a4:b0:479:3b9f:f13c with SMTP id p36-20020a05651213a400b004793b9ff13cmr4575623lfa.380.1661676239359;
        Sun, 28 Aug 2022 01:43:59 -0700 (PDT)
Received: from krzk-bin.starman.ee (82.131.98.15.cable.starman.ee. [82.131.98.15])
        by smtp.gmail.com with ESMTPSA id c6-20020ac25f66000000b0048afe02c925sm890114lfc.219.2022.08.28.01.43.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Aug 2022 01:43:58 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Lee Jones <lee@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        David Heidelberg <david@ixit.cz>,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH 12/14] arm64: dts: qcom: sdm845-mtp: correct ADC settle time
Date:   Sun, 28 Aug 2022 11:43:39 +0300
Message-Id: <20220828084341.112146-13-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220828084341.112146-1-krzysztof.kozlowski@linaro.org>
References: <20220828084341.112146-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The PMIC's VADC property for settle time is qcom,hw-settle-time, not
qcom,hw-settle-time-us.  The latter is used in PMIC's TM ADC.

  qcom/sdm845-mtp.dtb: pmic@0: adc@3100:adc-chan@4c: 'qcom,hw-settle-time-us' does not match any of the regexes: 'pinctrl-[0-9]+'

Fixes: d5e12f3823ae ("arm64: dts: qcom: sdm845: mtp: Add vadc channels and thermal zones")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 arch/arm64/boot/dts/qcom/sdm845-mtp.dts | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-mtp.dts b/arch/arm64/boot/dts/qcom/sdm845-mtp.dts
index 7713e8060c5b..de2d10e0315a 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-mtp.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-mtp.dts
@@ -536,42 +536,42 @@ adc-chan@4c {
 		reg = <ADC5_XO_THERM_100K_PU>;
 		label = "xo_therm";
 		qcom,ratiometric;
-		qcom,hw-settle-time-us = <200>;
+		qcom,hw-settle-time = <200>;
 	};
 
 	adc-chan@4d {
 		reg = <ADC5_AMUX_THM1_100K_PU>;
 		label = "msm_therm";
 		qcom,ratiometric;
-		qcom,hw-settle-time-us = <200>;
+		qcom,hw-settle-time = <200>;
 	};
 
 	adc-chan@4f {
 		reg = <ADC5_AMUX_THM3_100K_PU>;
 		label = "pa_therm1";
 		qcom,ratiometric;
-		qcom,hw-settle-time-us = <200>;
+		qcom,hw-settle-time = <200>;
 	};
 
 	adc-chan@51 {
 		reg = <ADC5_AMUX_THM5_100K_PU>;
 		label = "quiet_therm";
 		qcom,ratiometric;
-		qcom,hw-settle-time-us = <200>;
+		qcom,hw-settle-time = <200>;
 	};
 
 	adc-chan@83 {
 		reg = <ADC5_VPH_PWR>;
 		label = "vph_pwr";
 		qcom,ratiometric;
-		qcom,hw-settle-time-us = <200>;
+		qcom,hw-settle-time = <200>;
 	};
 
 	adc-chan@85 {
 		reg = <ADC5_VCOIN>;
 		label = "vcoin";
 		qcom,ratiometric;
-		qcom,hw-settle-time-us = <200>;
+		qcom,hw-settle-time = <200>;
 	};
 };
 
-- 
2.34.1

