Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99B1E6905F2
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 11:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbjBIK7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 05:59:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbjBIK71 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 05:59:27 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2640D5B741
        for <stable@vger.kernel.org>; Thu,  9 Feb 2023 02:58:57 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id by3so36458wrb.10
        for <stable@vger.kernel.org>; Thu, 09 Feb 2023 02:58:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NW8d1CGtjwetV0FuZkQ8UhJ3cZd+mwFPksIQWf8yAmE=;
        b=B96HxkHRe0ODPHdHscD7CraXhoQabYh/jYhraIHmKZSjuk7OYhDWLhqUwwiBaWdCvY
         5cUoXXGJfV6Jppkxl3xdPR397G62eBk0Yw2Pdq2pGMSPxSq6p0jf24EcoNSBLTskJ/jL
         2o4cA7swb5lcbD2TBPyauQJfDhuxVPIfTOflDQZqMylYhhPO6C01SDS5im0A5UfuEtF6
         KpyAv4BzC5gfOz8ZscsVooPY09tcHrSVGlHfi40s3p2gl5R9VBD/QVWBFfAlFwL0sxez
         9vt3XgY/DEGkuxBjrXr1CS+OHDAmwtgJsUqVDmxpfx/rLbALclyPhsmKnxQf9tXdX6sg
         LKwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NW8d1CGtjwetV0FuZkQ8UhJ3cZd+mwFPksIQWf8yAmE=;
        b=psMS2w4ewFBc4PsUBIZax56nC7F7HgJxpum5Q0oQLCRnULZdy2TVGgiTpzL4pAHdZb
         oqqiFkyMw01pywd8k3Rg772Y93JyxOqWJ0yeUvE/TVtAQdNcMN+ZCdqI2kNYdwfTbIGV
         /b/8OxSqhthfvGtFnNIHKis7BDkdQP4BKWgY/nxzH5qeNCNFA3wbLQnKS2X7Rpw3GAPe
         xLKDNS10q+8vtGBwuc9hRvvqQosZi9G2cOyq2/NoLIf/TkokH9F4zSBLLsU6LlqRmZwV
         cJ3aGXK17lCMDgRszgxm9RbAg2/1f/cUwXOqJUysCdF7CX/iVhzG7Ao+BPqSarwbAtow
         5Cog==
X-Gm-Message-State: AO0yUKXBWgC3FnZ2YZ5EUl1koTf7V+IyX7RR0bzA88TqMW7bItsf99Ok
        wWnh2HPkHx97hw+Ois0EicY83w==
X-Google-Smtp-Source: AK7set+ahucFx9qwKF5jFDEGGE2FLbmQxxpbsz9rVs7KPuuc3z5kvcheSAqtDhXNbkN2UiEi5tX1Qw==
X-Received: by 2002:adf:d0c7:0:b0:2c3:d9cf:f406 with SMTP id z7-20020adfd0c7000000b002c3d9cff406mr10226041wrh.13.1675940332010;
        Thu, 09 Feb 2023 02:58:52 -0800 (PST)
Received: from krzk-bin.. ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id g7-20020a5d6987000000b002be063f6820sm927987wru.81.2023.02.09.02.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 02:58:51 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Anand Moon <linux.amoon@gmail.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH 4/6] ARM: dts: exynos: correct TMU phandle in Odroid XU
Date:   Thu,  9 Feb 2023 11:58:39 +0100
Message-Id: <20230209105841.779596-4-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209105841.779596-1-krzysztof.kozlowski@linaro.org>
References: <20230209105841.779596-1-krzysztof.kozlowski@linaro.org>
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

TMU node uses 0 as thermal-sensor-cells, thus thermal zone referencing
it must not have an argument to phandle.  Since thermal-sensors property
is already defined in included exynosi5410.dtsi, drop it from
exynos5410-odroidxu.dts to fix the error and remoev redundancy.

Fixes: 88644b4c750b ("ARM: dts: exynos: Configure PWM, usb3503, PMIC and thermal on Odroid XU board")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 arch/arm/boot/dts/exynos5410-odroidxu.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos5410-odroidxu.dts b/arch/arm/boot/dts/exynos5410-odroidxu.dts
index 232561620da2..6ddd1dd2fb0b 100644
--- a/arch/arm/boot/dts/exynos5410-odroidxu.dts
+++ b/arch/arm/boot/dts/exynos5410-odroidxu.dts
@@ -120,7 +120,6 @@ &clock_audss {
 };
 
 &cpu0_thermal {
-	thermal-sensors = <&tmu_cpu0 0>;
 	polling-delay-passive = <0>;
 	polling-delay = <0>;
 
-- 
2.34.1

