Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA8F5F9DE2
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 13:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232364AbiJJLrB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 07:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232255AbiJJLqd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 07:46:33 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6ABE5A3EB
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 04:46:30 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id ay9so6322672qtb.0
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 04:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Br7tB+B/b1lsHyK3uSbrfuW30x/mi1CJ7kEqJlTgUNg=;
        b=zqdVaDMT0Es+8NgRCwsRfwih7xbsyw7OIbnsVIPEURFeCTa7sVZNzWit5tNToqNP/v
         NzxuGjYnPSGLFv//0ZLwtZBy4xFsqG7tAc63iF4gxnt6tIIITyci8B2HgRRIBG5IXkgm
         nbFoiwAN7EKAVCrYwKpz1uLA4mNA0yDujkJ5kWC6s6eKWx5YwfaB810sTw+uZwTf/zqV
         mjQGXMD1rpCSv/Et15HyVmWJoKaOOl/IvlGob13meRRyqKtpMkU39YXn2a3aKDr7fG0E
         zIiqc0P49G4qV81DTMEjc2/BBc2zLCEe0oFB5n6CPwHpEvLFPVWlyt6NxSf08X9GUKGI
         AmEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Br7tB+B/b1lsHyK3uSbrfuW30x/mi1CJ7kEqJlTgUNg=;
        b=ilJFXpk2STB1KlQ5zG90HdV3M+ftcKr0UNECpD48LqjPyP4FDEm5zVdgQkvc4i0rFE
         RIkV0NVh7tHEknKWzL+zD7CnGcqez97gX/Q8ROAgkjRA+4wjlvDA9g2k3q86C6ukgXYs
         nxayofUrG2VeR4a9hFbwurscfb16hte+p3eL3KTXV2jquNzVRmMpJ1RKu68cCqp4S+6z
         qu53rRU1QDQ2rAdoCYSb9NAYsc4LQdEvLE28J2P+F78MMau+avd3oHQKScXf9uLVZy5O
         P/R9eQEY4yW4pap2QcS6+RDryUGuAUdZvrVm4ENnKL89CI/GH+N5tejD9IDi+QCehBwH
         YNZA==
X-Gm-Message-State: ACrzQf0asqPUgMs2WxnxZXu7g1qDNba9gLtxLk/LiLCuvKsDddrkEZKS
        y3yNaKUUmFxrH//m76leqxjxwA==
X-Google-Smtp-Source: AMsMyM4kiikilACw9fT+71Uk2EaNqSUQH4o6E9MLtVC9lkBqlECeevu5GJMF39gOy7AcRXkZM165nw==
X-Received: by 2002:ac8:5c45:0:b0:35c:cd2c:c8f8 with SMTP id j5-20020ac85c45000000b0035ccd2cc8f8mr14123609qtj.105.1665402390323;
        Mon, 10 Oct 2022 04:46:30 -0700 (PDT)
Received: from krzk-bin.home (cpe-72-225-192-120.nyc.res.rr.com. [72.225.192.120])
        by smtp.gmail.com with ESMTPSA id s12-20020a05622a178c00b003972790deb9sm6698707qtk.84.2022.10.10.04.46.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 04:46:29 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Rob Clark <robdclark@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Vinod Koul <vkoul@kernel.org>, Xilin Wu <wuxilin123@gmail.com>,
        Molly Sophia <mollysophia379@gmail.com>,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH v2 5/6] arm64: dts: qcom: sdm850-samsung-w737: correct I2C12 pins drive strength
Date:   Mon, 10 Oct 2022 07:44:16 -0400
Message-Id: <20221010114417.29859-5-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221010114417.29859-1-krzysztof.kozlowski@linaro.org>
References: <20221010114417.29859-1-krzysztof.kozlowski@linaro.org>
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

Fixes: d4b341269efb ("arm64: dts: qcom: Add support for Samsung Galaxy Book2")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>

---

Changes since v1:
1. Add tags.
---
 arch/arm64/boot/dts/qcom/sdm850-samsung-w737.dts | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm850-samsung-w737.dts b/arch/arm64/boot/dts/qcom/sdm850-samsung-w737.dts
index f954fe5cb61a..d028a7eb364a 100644
--- a/arch/arm64/boot/dts/qcom/sdm850-samsung-w737.dts
+++ b/arch/arm64/boot/dts/qcom/sdm850-samsung-w737.dts
@@ -415,8 +415,10 @@ pinconf {
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

