Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09BC85F1182
	for <lists+stable@lfdr.de>; Fri, 30 Sep 2022 20:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbiI3SWX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Sep 2022 14:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232303AbiI3SWV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Sep 2022 14:22:21 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7039511471D
        for <stable@vger.kernel.org>; Fri, 30 Sep 2022 11:22:20 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id c7so5606962ljm.12
        for <stable@vger.kernel.org>; Fri, 30 Sep 2022 11:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=xucbshqtPxo9cvxwjd8q1MdIp+hMmj2ePAEJAVAWIxY=;
        b=HdiW1OgHdfQkgeOkLCxD4ZMHkLEXW9XiOa3CBQjwFZrJvFftiMDEimMeUcNhs+6xth
         0ATZAPIgjrhUvvhp0LaV7lfnxYENPWD7w+koUIlzMM5k3N7WyBLJ0n+Cdt6s2843wm/r
         U0s9o8tiVlE8FL1WxztP+iXh251520hftFjAWN3bAsVgwty3dxUKhPLsbcT3G/wbJG/f
         JnJbS068emnkGJL6h09509PINt1vfWnTBkD6hlWTk5IIYqKarFPCbBpxgZgeCi2M8IIo
         s8QxRlUfzR7LrnpFhfj3oAJkXICrOnPRKWlHtAG1FMKwyZWFRvcCeF4+6iVptoWZKgJZ
         M2Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=xucbshqtPxo9cvxwjd8q1MdIp+hMmj2ePAEJAVAWIxY=;
        b=5jJEp0TRqYBmla/cuzBooJM6/9NOyKIHLqoG1M2lK0KeKeGhPphhsNzJJb4DgKOqXr
         tVtZVqhKGZOIMurObfzU7Cj97JmzJ6EPBYoCzz57k7+Vx87l583hTFdI82IyVii5YTEL
         NHzZ0iQRkG+6UiTcioCKAvtWVjipm8vbbS1Y9h02BF+C6uNMCm15MXXroHVmtPMciPU2
         dvML5oUg1B6TB+gcHAroqwz6T5phbVFrZb1wu7hh+zcgO5z6qHiYeYqTcWBeD0+4GZTH
         vSoziWab0JZeB70vc/yi3a+jc9k56F2TyCeb8zz4nV4/FGIxwTm/ruK7QZN0xwA/owTe
         4usg==
X-Gm-Message-State: ACrzQf1eZhmGZ723JSJRcHgKahTCYA+S9SB17LfuKds5w0r25ha52jEJ
        /kRKX4E1dezdrHi0MC51+qfv9A==
X-Google-Smtp-Source: AMsMyM62SIX8aVQpvtKUgiuFCYyzbcd0t/d72wKATfsgaZOjjTZi73+WQeTpib2BSMko2jrzn0Pfgw==
X-Received: by 2002:a2e:b74f:0:b0:26c:426c:60fc with SMTP id k15-20020a2eb74f000000b0026c426c60fcmr3322993ljo.432.1664562138673;
        Fri, 30 Sep 2022 11:22:18 -0700 (PDT)
Received: from krzk-bin.. (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id x22-20020ac25dd6000000b00499b726508csm364006lfq.250.2022.09.30.11.22.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 11:22:18 -0700 (PDT)
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
Subject: [PATCH 3/3] arm64: dts: qcom: sdm845-cheza: fix AP suspend pin bias
Date:   Fri, 30 Sep 2022 20:22:12 +0200
Message-Id: <20220930182212.209804-3-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220930182212.209804-1-krzysztof.kozlowski@linaro.org>
References: <20220930182212.209804-1-krzysztof.kozlowski@linaro.org>
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

Fixes: 79e7739f7b87 ("arm64: dts: qcom: sdm845-cheza: add initial cheza dt")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

---

Not tested on hardware.
---
 arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi b/arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi
index b5eb8f7eca1d..b5f11fbcc300 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi
@@ -1436,7 +1436,7 @@ ap_suspend_l_assert: ap_suspend_l_assert {
 		config {
 			pins = "gpio126";
 			function = "gpio";
-			bias-no-pull;
+			bias-disable;
 			drive-strength = <2>;
 			output-low;
 		};
@@ -1446,7 +1446,7 @@ ap_suspend_l_deassert: ap_suspend_l_deassert {
 		config {
 			pins = "gpio126";
 			function = "gpio";
-			bias-no-pull;
+			bias-disable;
 			drive-strength = <2>;
 			output-high;
 		};
-- 
2.34.1

