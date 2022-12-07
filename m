Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1DE645BC4
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 15:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbiLGOAf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 09:00:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbiLGOAE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 09:00:04 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B81985CD0E
        for <stable@vger.kernel.org>; Wed,  7 Dec 2022 06:00:00 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id v13-20020a17090a6b0d00b00219c3be9830so1707728pjj.4
        for <stable@vger.kernel.org>; Wed, 07 Dec 2022 06:00:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iUBfene/cnQwgTF0aG4S0NjKk1KSg5LGCh8ripuPt50=;
        b=H8wT7XpkqvaHjQ6Po/goMKj6V6jL/8Ey8Hf+GqZvdwrHx75UStaopLvvwyARJc7qO5
         5UoJNpiMgUPfBpM1ZyE6UT7VLrFXYXeoGRckbpFv5xvbBUxLlTvOj8sqS5KRCwaQ1Fzi
         qztmo5Z4rB7+/QyLfJCSJIa1uG7AvVCX3XtsZI2rC5nfb6nvLpRJVPky+FSR204kiFNF
         BhDV1+OswALIVZavXenT6tiQ01rKxTbsg/oMCnlYCKLWTf2TB5yWAC2oFsw/AWa0/HNF
         z0gAf7S5LzBhpitYnxVtjOdLT50vK76PfjLoQfcJFur8TtrtNyauTbmHDx3nnT3sDQXT
         x+vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iUBfene/cnQwgTF0aG4S0NjKk1KSg5LGCh8ripuPt50=;
        b=k1WbTEd6MB++F8wsI3ywX38de7dGhbZC0j34Z2xZDWaMQGldi0gcSHb3DOMqIoD9wd
         96Sv2M2Vg32a39p+lrdllIiTFRGyh3xLYydWqZ6OUr5DwYXp2yuEPnptvbskpXnmzO6m
         Gy5moy6C++14Br+HtYqDitW5siuCAyQ54hqHy5ismZzXOc+NiK8z6Hkqc4UHW32R+6F7
         yVSq9qYGxVfZ7wv+QE4il8+cSuntPdI9Nl0+0Pg+avqg8B4r37EZMd3yDdOYnZ5EPW+y
         TP5ttGhADlJsSilYLDWzd5JkoaQHW7HN7rkm5RL9MEvlHCEqfE7f5EG/E31tXrLvNtw5
         8syg==
X-Gm-Message-State: ANoB5pkRSDRkjoDU8+AZPyh5wkBJXURUN4k1kp7BEizd1UoKvlWaCa1g
        DYVzXFEQB2S6XzeaPHb8oj3/
X-Google-Smtp-Source: AA0mqf6BwCJ/ScoZvW+2XcQjX3QSYrL5niNqC+Kve9LZHguQz+jHID3tQYcmqCpRfB+QgrDtXk0OYg==
X-Received: by 2002:a17:90a:3da1:b0:219:61e5:4994 with SMTP id i30-20020a17090a3da100b0021961e54994mr37329693pjc.213.1670421600398;
        Wed, 07 Dec 2022 06:00:00 -0800 (PST)
Received: from localhost.localdomain ([117.216.123.5])
        by smtp.gmail.com with ESMTPSA id c18-20020a170902d49200b00186b69157ecsm14720160plg.202.2022.12.07.05.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 05:59:59 -0800 (PST)
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
Subject: [PATCH 04/12] arm64: dts: qcom: sc7180: Fix the base addresses of LLCC banks
Date:   Wed,  7 Dec 2022 19:29:13 +0530
Message-Id: <20221207135922.314827-5-manivannan.sadhasivam@linaro.org>
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

On SC7180, there is only one LLCC bank available. So let's just pass that
as "llcc0_base".

Cc: <stable@vger.kernel.org> # 5.6
Fixes: c831fa299996 ("arm64: dts: qcom: sc7180: Add Last level cache controller node")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 arch/arm64/boot/dts/qcom/sc7180.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
index f71cf21a8dd8..f861f692c9b1 100644
--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -2759,7 +2759,7 @@ dc_noc: interconnect@9160000 {
 		system-cache-controller@9200000 {
 			compatible = "qcom,sc7180-llcc";
 			reg = <0 0x09200000 0 0x50000>, <0 0x09600000 0 0x50000>;
-			reg-names = "llcc_base", "llcc_broadcast_base";
+			reg-names = "llcc0_base", "llcc_broadcast_base";
 			interrupts = <GIC_SPI 582 IRQ_TYPE_LEVEL_HIGH>;
 		};
 
-- 
2.25.1

