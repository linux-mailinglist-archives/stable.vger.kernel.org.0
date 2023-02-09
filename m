Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E459B6905E6
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 11:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbjBIK7X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 05:59:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjBIK7W (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 05:59:22 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CBE923852
        for <stable@vger.kernel.org>; Thu,  9 Feb 2023 02:58:52 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id y1so1365605wru.2
        for <stable@vger.kernel.org>; Thu, 09 Feb 2023 02:58:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DqyCPgVLwr/SMq8TuN0141mNn36IMKTzmD9m9yiTvNc=;
        b=fA3Jvt2bYKWJ7esxt2t/Bo3yI38SKiWE7LAJlanQzF79L666FMJQix/t+LsEqsNGlS
         HTMlbITLH5cF8YZYpcP707M8gTq337sMZc52HP4mURLTGxW2g9KHbpqlUlZX1ocacNN9
         i4M0gXNqr5ikGf1vOTF/INyqycnxYa7OWDPvSYXsawer5gJmN+N+YBNWTSb1GY/FR83F
         V/d1icJ5kihlSjGETHgDOl0ryWAgiPIAMQ9UQzcZJcQN7glXWM4IOqFofX924eYo9qwb
         TuU+OVVB8HcWePNmo3kE9qiuudkKkBe4TQ+010xk0+ad+ORniEjOfbyrBdy4KZSlBHUP
         n14A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DqyCPgVLwr/SMq8TuN0141mNn36IMKTzmD9m9yiTvNc=;
        b=JDZ5oJDpokgvp1OF2yzhrsCvLR86e0e/xoMmEc/TmGlsHEpcbbyPvpH/mIOki0Slmu
         5Gw7IAPVpG/MljCgkZWJnxHGU/T1ODOiWr9vdzfiFQuWfpvxBeBUlprUNWKdaGrhZWHU
         WaqslWudIT2NZ1QFBYY/VMfXg8xjCjfZU5NlDF0YHUeuKlrOyQLJJJmwc/AVWjgMNZnN
         c42Gm+KFbbbCZu4eo2ooXIyG79lD8bE5/BQtiQzTibarPfBLmFsm/qj4PfMxC/7/1GpQ
         6gkCqWjawvNz7wvVox5qR+YT6rx/svVgY2n9jtmqJ854Iq+JUvT02GURWv/KsjVETehO
         8Usw==
X-Gm-Message-State: AO0yUKX8LXbP6O8cmvQ2pMopJgU0d55XVLK+GUrIzJxGwNXExeiaLI9+
        Jcp3Y79jJ9OQ6gs6d2ZL0P+NaA==
X-Google-Smtp-Source: AK7set8AkDnBCYmDcO6b3+VQdgZz3RfH1PnwGDouui/n0lah+W4ABazpObkRkPUukQpoD5bEZTKQLg==
X-Received: by 2002:a5d:6842:0:b0:2bf:ae1e:84d2 with SMTP id o2-20020a5d6842000000b002bfae1e84d2mr9990867wrw.12.1675940329234;
        Thu, 09 Feb 2023 02:58:49 -0800 (PST)
Received: from krzk-bin.. ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id g7-20020a5d6987000000b002be063f6820sm927987wru.81.2023.02.09.02.58.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 02:58:48 -0800 (PST)
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
Subject: [PATCH 2/6] ARM: dts: exynos: correct TMU phandle in Exynos4210
Date:   Thu,  9 Feb 2023 11:58:37 +0100
Message-Id: <20230209105841.779596-2-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209105841.779596-1-krzysztof.kozlowski@linaro.org>
References: <20230209105841.779596-1-krzysztof.kozlowski@linaro.org>
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

TMU node uses 0 as thermal-sensor-cells, thus thermal zone referencing
it must not have an argument to phandle.  Since thermal-sensors property is
already defined in included exynos4-cpu-thermal.dtsi, drop it from
exynos4210.dtsi to fix the error and remoev redundancy.

Fixes: 9843a2236003 ("ARM: dts: Provide dt bindings identical for Exynos TMU")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 arch/arm/boot/dts/exynos4210.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos4210.dtsi b/arch/arm/boot/dts/exynos4210.dtsi
index 5a1ec714c612..0e27c3375e2e 100644
--- a/arch/arm/boot/dts/exynos4210.dtsi
+++ b/arch/arm/boot/dts/exynos4210.dtsi
@@ -393,7 +393,6 @@ &cpu_alert2 {
 &cpu_thermal {
 	polling-delay-passive = <0>;
 	polling-delay = <0>;
-	thermal-sensors = <&tmu 0>;
 };
 
 &gic {
-- 
2.34.1

