Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48D765F117F
	for <lists+stable@lfdr.de>; Fri, 30 Sep 2022 20:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbiI3SWV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Sep 2022 14:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232258AbiI3SWT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Sep 2022 14:22:19 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 178F711471D
        for <stable@vger.kernel.org>; Fri, 30 Sep 2022 11:22:18 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id c2so1727651lfb.10
        for <stable@vger.kernel.org>; Fri, 30 Sep 2022 11:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=qOwce3cEbih9Al4+rrBeBjbrUDrdESaUBOONsswRH18=;
        b=TJUTHvBv9t0a94mTdKx3raSLmjza7mXiZ7hPLA76nVC3K4RSIJhweXyJcHghE+g+Ot
         SOBp2DZD+L2GFlwHZRTy9Q7GljKxEqWFECTYIxHIeAQfO9/BJccMNpzTOfuxWxwKULb6
         4cAD4u28h9LzYIc6/AiKzFrsw0H7NKPSEZqUhKAeQIxCHjasqwXrCrABpVEvTZ3A32M6
         4dXNGnGa897jd+Mz60erG+sjRSTNc4P3dxSzb84o4vtcAmlvmADy8+kr5O/Qn12A+R0I
         F9JEvJkq4Mwe0QSrH1vrIr6+5EoOp0ynnNBvglJh0yHZNAOOIcodbL75FNcDiwmgYRHr
         Rjew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=qOwce3cEbih9Al4+rrBeBjbrUDrdESaUBOONsswRH18=;
        b=wR3GCNgzU4cyVeLW8ZBjJ6+/LuZt7qua81AqUe9wDFS16W6XlqGOSJdGOwCdql7xih
         EMoY4gv8pzJcx36zYab8LwyGG2ScHSbFdFygT3uSZyu+XlPbZa3tRhiAjYB7pBmGdq4H
         PBANnKJ3fF+3pSTYXsDpLiAgTPkHLMdGniZ9vDYYl6Wvv/TzLMVlBGIdzsV1WobAlAlM
         GTJN7AsgkO2YgaxOGVr4S+q0dTfSDGlzWBr6Vo2Xq1RYwA6RfzBj8JXK9quqNTkaZ2Qj
         TDAvJ58HvUNoT9RuiqchkrJNSuLcqkSrLRxeR/Smw31hK7whDeNBU/iKKclbf/dvrUB9
         2eJw==
X-Gm-Message-State: ACrzQf36IAovASJyCcT1TpqPrablITQa9yyTcb8y2yMQ+hmvDk0wfZ6J
        bwERWyaDbemMIRywnw9Ye4RfOg==
X-Google-Smtp-Source: AMsMyM64IQG25D+tyo0s9ADwpxq+8SPR20fjm8X/3G5F8BzxzAEbuWqkU9XuWeGPK0C7SOLmBic3nw==
X-Received: by 2002:a05:6512:130a:b0:4a1:d80d:95e with SMTP id x10-20020a056512130a00b004a1d80d095emr3520425lfu.565.1664562136371;
        Fri, 30 Sep 2022 11:22:16 -0700 (PDT)
Received: from krzk-bin.. (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id x22-20020ac25dd6000000b00499b726508csm364006lfq.250.2022.09.30.11.22.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 11:22:15 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Rob Clark <robdclark@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH 1/3] arm64: dts: qcom: sdm630: fix UART1 pin bias
Date:   Fri, 30 Sep 2022 20:22:10 +0200
Message-Id: <20220930182212.209804-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There is no "bias-no-pull" property.  Assume intentions were disabling
bias.

Fixes: b190fb010664 ("arm64: dts: qcom: sdm630: Add sdm630 dts file")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

---

Not tested on hardware.
---
 arch/arm64/boot/dts/qcom/sdm630.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm630.dtsi b/arch/arm64/boot/dts/qcom/sdm630.dtsi
index b51b85f583e5..e119060ac56c 100644
--- a/arch/arm64/boot/dts/qcom/sdm630.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm630.dtsi
@@ -779,7 +779,7 @@ rx-cts-rts {
 					pins = "gpio17", "gpio18", "gpio19";
 					function = "gpio";
 					drive-strength = <2>;
-					bias-no-pull;
+					bias-disable;
 				};
 			};
 
-- 
2.34.1

