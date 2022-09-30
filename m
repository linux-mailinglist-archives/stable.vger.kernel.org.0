Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF525F124F
	for <lists+stable@lfdr.de>; Fri, 30 Sep 2022 21:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231654AbiI3TUr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Sep 2022 15:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiI3TUq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Sep 2022 15:20:46 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81ED317F55C
        for <stable@vger.kernel.org>; Fri, 30 Sep 2022 12:20:44 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id bu25so8304902lfb.3
        for <stable@vger.kernel.org>; Fri, 30 Sep 2022 12:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=RLFGquZHj0Qoort9n3TIqjuxvuM8Sj3HTwawtHQ3hBQ=;
        b=Ixn3iKlKgL1xfEseGNeJtk/X9jk40WJPjjLEpZ/GhGJY59lUUsJ/Ko18VfLl8VQF4h
         vQf/O6v3HdBQhis8z97tS4eXCDMJiY7DpmGC//xw1QcdspcIKueFFntOG5F6lMMK9E/R
         9QDmuSSMkmD5qltwE7pa0c+9xMxi6QpNbEeIkfzPFi/Qvy1RASERZuspnIjSmeq4eySy
         OpUAudtWyoHDD/WTTetxsAG+EFwGuK8VUgx9yAGhgsKj2pcDTe9A/wqns1k2ltCtqg+O
         F9M01fwcuBcU39WfekJcyzQz4kdo0SgeTx9lvRu9EIT9WuhXYHHfnvZSZJND26yFaGFl
         492g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=RLFGquZHj0Qoort9n3TIqjuxvuM8Sj3HTwawtHQ3hBQ=;
        b=IuaH3ew7Syjz7jpVtj3huS4GsxbwGIySb6BdVzvVSiQvl9vFM49e1gpp6MWRZN6Bvz
         L7Y0Cjlm3ugk6EiGwcFflrbAiJ3dab0RBXl/OnjgvDhLX42/XeB3AGgmt9zlSV+a0kil
         s3dfjNUwEUJNff2A1a5+pNgQ1NPIpdBrtPQ0hdIEBf7O/K1Pod0yhVA6SrewFFF7qcK4
         cvvZmE1ceN3Ag8lXpF+guyEFXVdYE8nP29E8J5yjIR1tKuw9wcm7T2glmafkzmJ4/KiF
         u3W/oQyUkin2WsIPuxrEcVbTR5jfnUIT8DGE666aVUbR72bRdxLdEeKN/vB/So9kdwJK
         0emA==
X-Gm-Message-State: ACrzQf2sOFgq/C8h0G/8FSrSUzrjT6WFiu4REle1S9LBcu5U66DkLd1o
        W+dRdQd49lb8kPbvRbOudpVVsA==
X-Google-Smtp-Source: AMsMyM4Gf5VZl3X7RWNEzfwB5RKS5JghDorrgS69rrv0d8aEh7BmdZG3mTlw2UB3gOtd7wP7rUkKAg==
X-Received: by 2002:a05:6512:2388:b0:498:f8e3:5a34 with SMTP id c8-20020a056512238800b00498f8e35a34mr4153117lfv.453.1664565642863;
        Fri, 30 Sep 2022 12:20:42 -0700 (PDT)
Received: from krzk-bin.. (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id c17-20020a056512105100b0049fff3f645esm390115lfb.70.2022.09.30.12.20.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 12:20:42 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Vinod Koul <vkoul@kernel.org>,
        Xilin Wu <wuxilin123@gmail.com>,
        Molly Sophia <mollysophia379@gmail.com>,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH 1/3] arm64: dts: qcom: sdm850-lenovo-yoga-c630: correct I2C12 pins drive strength
Date:   Fri, 30 Sep 2022 21:20:37 +0200
Message-Id: <20220930192039.240486-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The pin configuration (done with generic pin controller helpers and
as expressed by bindings) requires children nodes with either:
1. "pins" property and the actual configuration,
2. another set of nodes with above point.

The qup_i2c12_default pin configuration used second method - with a
"pinmux" child.

Fixes: 44acee207844 ("arm64: dts: qcom: Add Lenovo Yoga C630")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
index be59a8ba9c1f..74f43da51fa5 100644
--- a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
+++ b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
@@ -487,8 +487,10 @@ pinconf {
 };
 
 &qup_i2c12_default {
-	drive-strength = <2>;
-	bias-disable;
+	pinmux {
+		drive-strength = <2>;
+		bias-disable;
+	};
 };
 
 &qup_uart6_default {
-- 
2.34.1

