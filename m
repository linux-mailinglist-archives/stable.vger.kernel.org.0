Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7152067AE9F
	for <lists+stable@lfdr.de>; Wed, 25 Jan 2023 10:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233453AbjAYJpy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Jan 2023 04:45:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235285AbjAYJpw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Jan 2023 04:45:52 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B98A939B8D
        for <stable@vger.kernel.org>; Wed, 25 Jan 2023 01:45:26 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id k16so13282946wms.2
        for <stable@vger.kernel.org>; Wed, 25 Jan 2023 01:45:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ztfbDoxGkDtDmGmBYfiBuBdnAIcB0uPVrA/v1nCpTCQ=;
        b=FsdNwkstyvELDGvtDJLlGrYXxXaw+Yd/rnWhJQdaClPX/6nI30z3KrEYdR1blg0yas
         HnJqJNdicB2Y8z/DDK7cVk2GiT1P7gjMOafnUgCU0NdWgPooizBy+2uA1TaqDKFCkYQ4
         irODL2cF7vLmfyvfA9kfkYlL5hsV7FQVZXfrMZZXT6qtD+IiBn/Rpi/dmW/ITImzx5FV
         7X34wUvBf1FSmcmnHVYSOCK+yAE4jsrYCXGyXWeyVCaWpPs3BMk/qPl05Y12+5WnXY0h
         khowzHbFZk9pHgh4AwlV3zTopNMsDH6el5kMsATONevRApwi4JSZVR7MKxQ4GRf1+AXf
         zN2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ztfbDoxGkDtDmGmBYfiBuBdnAIcB0uPVrA/v1nCpTCQ=;
        b=Odl2kSla8ubPaJRAgG70zxGRhQ1j0T98p3G85vG3MGAmJbv1WpaR0DSt6mrffof9g+
         cqSsEEmhhVmkbBRj2DMsiTBFKARtEQG0FvdORH+HBVoSDafunaFWFw8I5C4krSoC/y9p
         PyZ+GQ/xTftyZX1xdzVxO4i9Ov9tmtPDrBIx+e9tDGbuCGysNwcg0H30Eewp8zQhgxkr
         /IxmMKcnlKBIMJp/SYwpcrvX4kF3PHOulOUifSS9IbSY3I8vqkQDvRcgBcknjEIeP2Sh
         E+CzD1XmJUwoahsOWdsKoG6gbDnSxCvbGZ2o4au6tE4IPqq5XGZMIfOvRH6RCXOyzwzh
         JWog==
X-Gm-Message-State: AFqh2koAGlsXRpM8PNfdJsuxnstiE7g0Wb0/KKh5KNrj8inuiqr8+I9G
        zXlgJJyY+HVhbqE+KsLTjeGgyw==
X-Google-Smtp-Source: AMrXdXsh2igFfleXr30Bewy8M0jQBLxP7I9V02wCXUXTYQcHNQM6+J0AOl+0hWI7jdNJPkdu81Wrsg==
X-Received: by 2002:a05:600c:4e05:b0:3c6:e61e:ae71 with SMTP id b5-20020a05600c4e0500b003c6e61eae71mr32485060wmq.1.1674639922588;
        Wed, 25 Jan 2023 01:45:22 -0800 (PST)
Received: from krzk-bin.. ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id fl22-20020a05600c0b9600b003d1e3b1624dsm1419238wmb.2.2023.01.25.01.45.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 01:45:22 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     replicant@osuosl.org, phone-devel@vger.kernel.org,
        ~postmarketos/upstreaming@lists.sr.ht,
        =?UTF-8?q?Martin=20J=C3=BCcker?= <martin.juecker@gmail.com>,
        Henrik Grimler <henrik@grimler.se>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH 1/9] ARM: dts: exynos: correct HDMI phy compatible in Exynos4
Date:   Wed, 25 Jan 2023 10:45:05 +0100
Message-Id: <20230125094513.155063-1-krzysztof.kozlowski@linaro.org>
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

The HDMI phy compatible was missing vendor prefix.

Fixes: ed80d4cab772 ("ARM: dts: add hdmi related nodes for exynos4 SoCs")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 arch/arm/boot/dts/exynos4.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
index 55afe9972460..d1adaee2af58 100644
--- a/arch/arm/boot/dts/exynos4.dtsi
+++ b/arch/arm/boot/dts/exynos4.dtsi
@@ -605,7 +605,7 @@ i2c_8: i2c@138e0000 {
 			status = "disabled";
 
 			hdmi_i2c_phy: hdmiphy@38 {
-				compatible = "exynos4210-hdmiphy";
+				compatible = "samsung,exynos4210-hdmiphy";
 				reg = <0x38>;
 			};
 		};
-- 
2.34.1

