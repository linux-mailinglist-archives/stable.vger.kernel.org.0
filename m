Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D123649EE4
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 13:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbiLLMgD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 07:36:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232290AbiLLMfT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 07:35:19 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C4E660C6
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 04:34:41 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id t11-20020a17090a024b00b0021932afece4so15534148pje.5
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 04:34:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zx2M7VMZ7B8c+kUNjbNWr72iqwdGfw5WQdhiPZvJmow=;
        b=ChLTkPtBcMiMzezMr5A2k/fcxzH6GZXKGhXafIdMmQy6P5xxxt3QqlY6ZOdjvKYdIN
         gTsDu0KsZIk9DgOW+KRsCxcvrubIk8wqM8DHr665seHOSOZXZeoRRtJ2S7ghAOKiTbt9
         8DDOCLnvdaXmZvuOG4nah8pl273WS2HWpXWWXi819Jq+mXKfGuJP2MU+LHagr9WmzPvy
         wati+Do384INbDYhAqsCSrN/NCYwhw5llsfJMRWga1SQddsSwPx6ZKsnrNIeCoyG4CRW
         RPbcBlJETeiMZWwg13OAMGT9Mqu1Dl/U88ulbkvtceR1/CujVA9la+MTowRWGxFt1OXi
         fLRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zx2M7VMZ7B8c+kUNjbNWr72iqwdGfw5WQdhiPZvJmow=;
        b=yIWKuEkIrrJjeqf7ybhGv5YLfyyFTPx6ouJfyW4fEVGMmGAQ6HIRuJEjmLWlqi8XfJ
         vnhaoj7sLiHy5ufQ4CQ60j1dR2wLORH9KHiRr9aUxd0C2J5JGERfc/ihQb91OYUYuos1
         jcEX2ocRcUy5LwvLqpGn/ilnxqV82N2o4j7muNT6EERVH+sncFFnd4lyzqQXGbKXz/gB
         niB7kSayN2mFSsM13dctr37IrPGxyw6fbimkUHknHTdB9B4TmfTMKwmItZAACLh4jILv
         p06EA3T5g4DMcFDmhSp9GAP9227bMcn5uWSY0a6IZ348qFPs4ELeyNIYWVSvCCrs4kYh
         OsLg==
X-Gm-Message-State: ANoB5pk4pFU4l4R3QPu0L573ZToVXRYiZqpnNi5gX8r0Sp8+uwItIAwX
        Rcvxs6LEzyuASNDDNMImzUv9
X-Google-Smtp-Source: AA0mqf65ZwsDRJcMCxtsvw68gNbQfCRwWblSmVd+N7SKsXS6LrRiZ0ziBV9T34IccwUe/FcHlbOkjA==
X-Received: by 2002:a17:902:e952:b0:189:dc3:ee9c with SMTP id b18-20020a170902e95200b001890dc3ee9cmr18076957pll.65.1670848463236;
        Mon, 12 Dec 2022 04:34:23 -0800 (PST)
Received: from localhost.localdomain ([220.158.159.33])
        by smtp.gmail.com with ESMTPSA id j14-20020a170902da8e00b00189c93ce5easm6252557plx.166.2022.12.12.04.34.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 04:34:22 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     andersson@kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, bp@alien8.de,
        tony.luck@intel.com
Cc:     quic_saipraka@quicinc.com, konrad.dybcio@linaro.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        james.morse@arm.com, mchehab@kernel.org, rric@kernel.org,
        linux-edac@vger.kernel.org, quic_ppareek@quicinc.com,
        luca.weiss@fairphone.com,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH v2 10/13] arm64: dts: qcom: sm8450: Fix the base addresses of LLCC banks
Date:   Mon, 12 Dec 2022 18:03:08 +0530
Message-Id: <20221212123311.146261-11-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221212123311.146261-1-manivannan.sadhasivam@linaro.org>
References: <20221212123311.146261-1-manivannan.sadhasivam@linaro.org>
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

Also, let's get rid of reg-names property as it is not needed anymore.
The driver is expected to parse the reg field based on index to get the
addresses of each LLCC banks.

Cc: <stable@vger.kernel.org> # 5.18
Fixes: 1dc3e50eb680 ("arm64: dts: qcom: sm8450: Add LLCC/system-cache-controller node")
Reported-by: Parikshit Pareek <quic_ppareek@quicinc.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 arch/arm64/boot/dts/qcom/sm8450.dtsi | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
index 570475040d95..30685857021a 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -3640,8 +3640,9 @@ gem_noc: interconnect@19100000 {
 
 		system-cache-controller@19200000 {
 			compatible = "qcom,sm8450-llcc";
-			reg = <0 0x19200000 0 0x580000>, <0 0x19a00000 0 0x80000>;
-			reg-names = "llcc_base", "llcc_broadcast_base";
+			reg = <0 0x19200000 0 0x80000>, <0 0x19600000 0 0x80000>,
+			      <0 0x19300000 0 0x80000>, <0 0x19700000 0 0x80000>,
+			      <0 0x19a00000 0 0x80000>;
 			interrupts = <GIC_SPI 266 IRQ_TYPE_LEVEL_HIGH>;
 		};
 
-- 
2.25.1

