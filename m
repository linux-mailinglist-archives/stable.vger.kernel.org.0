Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60EF65BC54E
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 11:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiISJ0n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Sep 2022 05:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbiISJ01 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Sep 2022 05:26:27 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9691D13F93
        for <stable@vger.kernel.org>; Mon, 19 Sep 2022 02:26:14 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id z25so45982975lfr.2
        for <stable@vger.kernel.org>; Mon, 19 Sep 2022 02:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=jY+Ll13EtSRSZqnmg84nXEpRI5JPJFL45ThtkhHD7KI=;
        b=iPQXCgVBFXLvMxnb88A4Y4RN5PzkIam2LLZcTdRInoXsFgMvIObqNBroT5awBiVcie
         O+6QZAHwTU3Vobun0dFUoyqIFjwOEFSSRPWRQuKLQ3dMRxDJ5mkhoGQDVUpFKN73wXlz
         Ewh0gLZ2/fgNEOVMVMCihScz9/kCxWfRQ4YP0ivCwwQQhB97xMIE+17+09a6zC4VhI9U
         V7mtNW8OKatFR0FnNZfmD9mrU2Jhad6EBQRJ8I33ttkvrdOzL/No7GtN3L1E2FNDHBxL
         2WlP8c8WhlPHe6ksnOZg47vq2OgM+jHEXxSMgR5UzBfNwmS63X8i7C/sgTz3KDGOoqGv
         2c2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=jY+Ll13EtSRSZqnmg84nXEpRI5JPJFL45ThtkhHD7KI=;
        b=TJi+HUKvQeQR5eayRF7+HV4EK9fj48CyuX4ZuEYQgmD7cHxNNNJDp5Yg7JqSHwMi15
         AqJ6N1OviSRzilf9f4dwbczL4Dc9UxftKJVYnr6b15PiddRQDyB7KCzY5J/39NSv0amm
         gNGIB3fR/IkwB9Tjm8ySc7dQSnyIp4qxJ67q3ti4z9ZrSufRU173grh1BPQvqzmyzlSZ
         Z4Mo2oQ1PnJWhqNWZlMZyFwHpfFPaO0lAm1+uP8u4ZZ0dXdvA9yj4CPKQzWeDAT5OJhs
         pLkjq3hbT7nrVZpQohBOvnyZZ8KT6ZfFz/TKGOPh+/sqMIDdDKn//i4rgXqJf4LEO1ox
         FEdA==
X-Gm-Message-State: ACrzQf1TkFvjQWgvUdE0yh+knx/OdA4xg9yOmKEI+/N/7e4Xv8SEGDxX
        qSgC0gZLsx9LE7LHGNiBxdsByaLTNg/yjg==
X-Google-Smtp-Source: AMsMyM5MJF/RfYu/oQl/cdxpkdj09uQXUbkrbUPkQ8D7A7YH66uz6kxyHI2Xt1ZWdna8RAWRIJ5kbQ==
X-Received: by 2002:a05:6512:3403:b0:48c:9727:50b0 with SMTP id i3-20020a056512340300b0048c972750b0mr5623241lfr.309.1663579572956;
        Mon, 19 Sep 2022 02:26:12 -0700 (PDT)
Received: from fedora.ideon.se ([85.235.10.227])
        by smtp.gmail.com with ESMTPSA id o20-20020ac24bd4000000b0049c29292250sm3829456lfq.149.2022.09.19.02.26.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 02:26:12 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     arm@kernel.org, soc@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH] ARM: dts: integrator: Tag PCI host with device_type
Date:   Mon, 19 Sep 2022 11:26:08 +0200
Message-Id: <20220919092608.813511-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.37.3
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

The DT parser is dependent on the PCI device being tagged as
device_type = "pci" in order to parse memory ranges properly.
Fix this up.

Cc: stable@vger.kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ARM SoC folks: please apply this directly for fixes.
---
 arch/arm/boot/dts/integratorap.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/integratorap.dts b/arch/arm/boot/dts/integratorap.dts
index 9b652cc27b14..c983435ed492 100644
--- a/arch/arm/boot/dts/integratorap.dts
+++ b/arch/arm/boot/dts/integratorap.dts
@@ -160,6 +160,7 @@ pic: pic@14000000 {
 
 	pci: pciv3@62000000 {
 		compatible = "arm,integrator-ap-pci", "v3,v360epc-pci";
+		device_type = "pci";
 		#interrupt-cells = <1>;
 		#size-cells = <2>;
 		#address-cells = <3>;
-- 
2.37.3

