Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40E484ADF27
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 18:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244414AbiBHRTO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 12:19:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235886AbiBHRTO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 12:19:14 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA5AC061578
        for <stable@vger.kernel.org>; Tue,  8 Feb 2022 09:19:13 -0800 (PST)
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 259DF3FFE1
        for <stable@vger.kernel.org>; Tue,  8 Feb 2022 17:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1644340752;
        bh=ljNZXcV6Ym7/PH8vFjEM0hkawYJJLcPyRUsIX2ztPxc=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=MnenrchCcxbLqRXNFVnXEZWrQFjXNDWsAnL6fDhWQwsDq5xhJ1xfBVYZrF+M+ILbe
         D/zcwNuiJwNb2GigcGJ+tSIzvk/Kf0sNhjchrTu6oLe9DHlaqzP8FNi8z5D1CGTyZP
         KJZj8XSM25br/gafWV8rEIx+I6+Det9UJpfpOC31IF/MQGW2h7AAu82dgv0OukQQWQ
         mCcjUUdFziRn2jdxa0yN4rVXa7rXKgcJWBFYyPKvq11PZJVtsCNsPydiOF1ju1qOVm
         kmSVMfkA6e3Wnk19AMsQs43A/iXypgFjZeI1YNkJWErMJ3tdCwbPV/E29l0fnTtJFe
         5L7HMGWXdaDGA==
Received: by mail-ej1-f72.google.com with SMTP id hr36-20020a1709073fa400b006cd2c703959so889064ejc.14
        for <stable@vger.kernel.org>; Tue, 08 Feb 2022 09:19:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ljNZXcV6Ym7/PH8vFjEM0hkawYJJLcPyRUsIX2ztPxc=;
        b=5OsQTqR24zO3qa/7+28qnk+oCnM+nVf81FAiJBARr/ZrTHS1iMNW+d3/bt3vnV4HFh
         rEDG7tT3Woov6ORoDi7NNFbEghAVrRt+zUWFeTWmk2zfW64+1fpW2ft3Fjd0Q8g23Wv5
         k3RRkSZ4voIuZsXuQadLW4g/IygX17mn77CqDeou/UiliBEOa+tCfbuKHNp9YnHeXXhQ
         Teyelnv5/T9KNA5RWGkfVI0lsX/QTZKD50ms2n1YTdH3z/dwwg9cnIGtPADYnIx8JYMi
         eWN8P8uoIpWSgA7FbbYQOtKQVWaB8cKfrzeAtHXWK3y2mNxlF+baMBGv+zJ0VdUq/QVM
         ULTQ==
X-Gm-Message-State: AOAM531EAV83Hcjtwkb/83Lns4RjDyAk05bp5Pr96bxamxHrM325psfn
        f93HlbIY1r9L7N3tySdEieYHr/oeW4JpATzNTKW+tS/gP4i0CnROXUaxWRp2W4E/GzxWyaqyXHN
        ap0X+VFFRoecIzNERRoYVDH53C8XcAlhwOQ==
X-Received: by 2002:a50:fb94:: with SMTP id e20mr5723255edq.292.1644340751869;
        Tue, 08 Feb 2022 09:19:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzFtmSCjrFuZnV5QFldxP4RqEiUiHOeP0ej5h/rJ0gsHHDMvXDxxIkOQXiY9qgzDn7rJ1eDKQ==
X-Received: by 2002:a50:fb94:: with SMTP id e20mr5723234edq.292.1644340751717;
        Tue, 08 Feb 2022 09:19:11 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-168-84.adslplus.ch. [188.155.168.84])
        by smtp.gmail.com with ESMTPSA id r10sm5125550ejy.148.2022.02.08.09.19.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 09:19:11 -0800 (PST)
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
Subject: [PATCH 01/10] ARM: dts: exynos: add missing HDMI supplies on SMDK5250
Date:   Tue,  8 Feb 2022 18:18:14 +0100
Message-Id: <20220208171823.226211-2-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220208171823.226211-1-krzysztof.kozlowski@canonical.com>
References: <20220208171823.226211-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add required VDD supplies to HDMI block on SMDK5250.  Without them, the
HDMI driver won't probe.  Because of lack of schematics, use same
supplies as on Arndale 5250 board (voltage matches).

Cc: <stable@vger.kernel.org> # v3.15+
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 arch/arm/boot/dts/exynos5250-smdk5250.dts | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts b/arch/arm/boot/dts/exynos5250-smdk5250.dts
index 65d2474f83eb..21fbbf3d8684 100644
--- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
+++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
@@ -118,6 +118,9 @@ &hdmi {
 	status = "okay";
 	ddc = <&i2c_2>;
 	hpd-gpios = <&gpx3 7 GPIO_ACTIVE_HIGH>;
+	vdd-supply = <&ldo8_reg>;
+	vdd_osc-supply = <&ldo10_reg>;
+	vdd_pll-supply = <&ldo8_reg>;
 };
 
 &i2c_0 {
-- 
2.32.0

