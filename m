Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7C60645BC8
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 15:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbiLGOAn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 09:00:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbiLGOAM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 09:00:12 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45D915C0F6
        for <stable@vger.kernel.org>; Wed,  7 Dec 2022 06:00:07 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id v3so16462226pgh.4
        for <stable@vger.kernel.org>; Wed, 07 Dec 2022 06:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5n0Bzk4oRcwoQ/X+7mKiinSvd0WlsPB4Sg7t77MHfrg=;
        b=bDfohewvK322PkyoaoeVx5utUGw02oRSdwD7E5T8JwmGQGI+eGv/eQmEAHEeI4vGL5
         hZP4IorHbJ7MPDJkhHCOylqWDMSvmVSbLnJFLDTIEgY332WwAzDu189nbcYWtp+S4rNi
         z9STzDjpH/T0zBBOuHixzfS0FAqQNeMFZQf32hyw3yJhIIa909ZYhOuXKdNHbdafKcCl
         x4pcKDcJrV4bKkKB5rVESJiPcJMHfFC9n+KwxTy5Um5J2DkyeLigZnE0kjnzUawwxsDi
         JpmdU2q2fGPdoQvAiatfiJlIBZ+xxYPaPQ/CgfmUda81/rErjmpxirMtZgJtL6fg1qta
         Tq1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5n0Bzk4oRcwoQ/X+7mKiinSvd0WlsPB4Sg7t77MHfrg=;
        b=2ODFxXd3GVmUtWCY2Yh8LZCxeQ4W57SfFwfGHQAT3YkQUsrDdZa1lxJi4UKf8peDmJ
         kFOTxz5A1ELNzsMDdPFcVj8xPV/E6CCdQ+FhOG1sEIY0Ngyjy2tUxloflVurW4TmSnzq
         mlagLo9tWrTRacXmbfy9hDvUqHIJuHNEUyno1nXszozBEB+cMbY2+XvJA6KlOP1VEv2b
         G0N5eA4WD0zClLso0BWDw6lkM/QDosqg/f7kiM5p2hTk9CInWa7XlARb1sLioJTA2859
         Tz0aPyUghT5usjI5tNXOHkrVj/yFO9Hgaaf4WpCV2PKBn1uf92UiKmhlTx6jupFjS5rD
         uY7A==
X-Gm-Message-State: ANoB5pkY+EJnt+7DzmlQ4dGcXa8UmpbPmw3OunI0S9bqHHFIq78QElnf
        43Ee+cfq1ohyvwduc9W9gPKt
X-Google-Smtp-Source: AA0mqf7B1Q/KziWYaacazkXY2TuYKm/263tGdPPAdJ/GFN2M21J5u/BfEWI8V+2vKrdEBpBV0oyxOQ==
X-Received: by 2002:a63:5b4d:0:b0:478:ae0a:bd86 with SMTP id l13-20020a635b4d000000b00478ae0abd86mr15223904pgm.239.1670421606382;
        Wed, 07 Dec 2022 06:00:06 -0800 (PST)
Received: from localhost.localdomain ([117.216.123.5])
        by smtp.gmail.com with ESMTPSA id c18-20020a170902d49200b00186b69157ecsm14720160plg.202.2022.12.07.06.00.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 06:00:05 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     andersson@kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, bp@alien8.de,
        tony.luck@intel.com
Cc:     quic_saipraka@quicinc.com, konrad.dybcio@linaro.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        james.morse@arm.com, mchehab@kernel.org, rric@kernel.org,
        linux-edac@vger.kernel.org, quic_ppareek@quicinc.com,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH 05/12] arm64: dts: qcom: sc7280: Fix the base addresses of LLCC banks
Date:   Wed,  7 Dec 2022 19:29:14 +0530
Message-Id: <20221207135922.314827-6-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221207135922.314827-1-manivannan.sadhasivam@linaro.org>
References: <20221207135922.314827-1-manivannan.sadhasivam@linaro.org>
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

The LLCC block has several banks each with a different base address
and holes in between. So it is not a correct approach to cover these
banks with a single offset/size. Instead, the individual bank's base
address needs to be specified in devicetree with the exact size.

While at it, let's also fix the size of the llcc_broadcast_base to cover
the whole region.

Cc: <stable@vger.kernel.org> # 5.13
Fixes: 0392968dbe09 ("arm64: dts: qcom: sc7280: Add device tree node for LLCC")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 arch/arm64/boot/dts/qcom/sc7280.dtsi | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index 0adf13399e64..6c6eb6f4f650 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -3579,8 +3579,9 @@ gem_noc: interconnect@9100000 {
 
 		system-cache-controller@9200000 {
 			compatible = "qcom,sc7280-llcc";
-			reg = <0 0x09200000 0 0xd0000>, <0 0x09600000 0 0x50000>;
-			reg-names = "llcc_base", "llcc_broadcast_base";
+			reg = <0 0x09200000 0 0x58000>, <0 0x09280000 0 0x58000>,
+			      <0 0x09600000 0 0x58000>;
+			reg-names = "llcc0_base", "llcc1_base", "llcc_broadcast_base";
 			interrupts = <GIC_SPI 582 IRQ_TYPE_LEVEL_HIGH>;
 		};
 
-- 
2.25.1

