Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB794ADF40
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 18:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234241AbiBHRTR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 12:19:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359824AbiBHRTQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 12:19:16 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E1EEC06157B
        for <stable@vger.kernel.org>; Tue,  8 Feb 2022 09:19:15 -0800 (PST)
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 217B73F1E7
        for <stable@vger.kernel.org>; Tue,  8 Feb 2022 17:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1644340754;
        bh=VHcPmkTeJVNyntx2kBlzhzsUutabuRvxOsRCpNXtu84=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=eE06Fj4wsqL95Vd+feFDIykqxaN7KL2zmkLVutUvtJFuC1G/3vQiFAMOY7AuREyle
         22aMTq1RepW7dXoFMxxhYYs/rA0M424g/3puGRengNeLOvqP15OZY80NoB4a9zvvbs
         e6e8Pe/NkcuSFdigFayGrq9hFt5ui/pHH8qz1bNcbaAuP0nb/asGXMSxQpVFmoysq7
         L5vbblG1Czn5LC0/PxM13Zo/nTd0w/aP43vGIib0Baz07kVIkyoy4z4o/LFYIQe9fG
         5ZYLd7fxCIg9PiQ2P5equNqHeqe56eps8JguIYE3SovCg6XvfQIL9Dh4kSQewXJbVo
         iQx2deKWRg0zg==
Received: by mail-ej1-f69.google.com with SMTP id 13-20020a170906328d00b006982d0888a4so5990265ejw.9
        for <stable@vger.kernel.org>; Tue, 08 Feb 2022 09:19:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VHcPmkTeJVNyntx2kBlzhzsUutabuRvxOsRCpNXtu84=;
        b=Y1YALU8ly8exmtfups7VoWHE6v++ZN1IS+f8b6Sn/+2w7gVsnyS0GyYTuK7XQ2pq8R
         4YcNXHGy6GWxh2Rx/YFNyKQHJbYqYooTwOii7KWgMFz5iusN04pXTYuFDC5vW5Wnkkac
         CYqFtXudWrdQHljBhPHU7oMc2rHLag2m9uDT26i8+TQLRKQ3OcC61JFb0WV7KKBK1l38
         OEz346CI0QshZ3dBTYsiVdhQHxUtL5Q7ToS2R8jaQqVVFZNRj22dnbl7LrpA2rCF9S2x
         R/SWH8wmXdgK+w1Q9Uy0rDSNHhMpDQUoW8gyzinPp+eqV91P/HBW3/inrlPQ5FrowQtu
         0khg==
X-Gm-Message-State: AOAM533JFamyTVlA4qoK6F76EIyPHJrUXJpGPIpknCpV/3Xy73zAH8OQ
        RkWnNfyTu/iqmqMSI1IWImTLylV4HFLhY+v/vyriWgNn68rL4wGhh/nL4+Go/A5HGoy0bv2sr0U
        zcsRS4R7q48I8OURha6UMlJWYbDjd3LAq4w==
X-Received: by 2002:aa7:dd88:: with SMTP id g8mr5421153edv.437.1644340753083;
        Tue, 08 Feb 2022 09:19:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzu+cFFUCenp9+7nbzSzHf1p2aHa5gSlHKLF75wAskvl768sx1e6yjGcesa9sVQ2V3f6PILbQ==
X-Received: by 2002:aa7:dd88:: with SMTP id g8mr5421132edv.437.1644340752936;
        Tue, 08 Feb 2022 09:19:12 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-168-84.adslplus.ch. [188.155.168.84])
        by smtp.gmail.com with ESMTPSA id r10sm5125550ejy.148.2022.02.08.09.19.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 09:19:12 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Inki Dae <inki.dae@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>, dri-devel@lists.freedesktop.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH 02/10] ARM: dts: exynos: add missing HDMI supplies on SMDK5420
Date:   Tue,  8 Feb 2022 18:18:15 +0100
Message-Id: <20220208171823.226211-3-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220208171823.226211-1-krzysztof.kozlowski@canonical.com>
References: <20220208171823.226211-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add required VDD supplies to HDMI block on SMDK5420.  Without them, the
HDMI driver won't probe.  Because of lack of schematics, use same
supplies as on Arndale Octa and Odroid XU3 boards (voltage matches).

Cc: <stable@vger.kernel.org> # v3.15+
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 arch/arm/boot/dts/exynos5420-smdk5420.dts | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5420-smdk5420.dts b/arch/arm/boot/dts/exynos5420-smdk5420.dts
index 2978b5775a6d..4d7b6d9008a7 100644
--- a/arch/arm/boot/dts/exynos5420-smdk5420.dts
+++ b/arch/arm/boot/dts/exynos5420-smdk5420.dts
@@ -124,6 +124,9 @@ &hdmi {
 	hpd-gpios = <&gpx3 7 GPIO_ACTIVE_HIGH>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&hdmi_hpd_irq>;
+	vdd-supply = <&ldo6_reg>;
+	vdd_osc-supply = <&ldo7_reg>;
+	vdd_pll-supply = <&ldo6_reg>;
 };
 
 &hsi2c_4 {
-- 
2.32.0

