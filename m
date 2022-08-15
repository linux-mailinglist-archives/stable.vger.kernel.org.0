Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7B41594B4B
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351740AbiHPAOd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:14:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357133AbiHPANF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:13:05 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD16176500;
        Mon, 15 Aug 2022 13:29:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 00D49CE1344;
        Mon, 15 Aug 2022 20:29:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE19DC433D6;
        Mon, 15 Aug 2022 20:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595387;
        bh=wtp6p6RMN1MZpTJuYtBu272z3ieJ8QwXzu/VzXe3Qcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mlOxB2PmDxkoMJlJHyJOD89ZXfBaIMTO1cgTzcwUaPvPda9NxxWjRgTkyfSwRzbhV
         T2gDnN1WAU20FtyJz1G5K9f7WdlClrO+2d/BvLmgaPbzLEtlgXPlYz1iw5OhxJM4Tv
         8v2MeEQMXGgisNXdQ5U0L58MV8KgyfK6waWZDkkY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0748/1157] clk: qcom: gcc-msm8939: Add missing SYSTEM_MM_NOC_BFDCD_CLK_SRC
Date:   Mon, 15 Aug 2022 20:01:44 +0200
Message-Id: <20220815180509.388337055@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

[ Upstream commit 07e7fcf1714c5f9930ad27613fea940aedba68da ]

When adding in the indexes for this clock-controller we missed
SYSTEM_MM_NOC_BFDCD_CLK_SRC.

Add it in now.

Fixes: 4c71d6abc4fc ("clk: qcom: Add DT bindings for MSM8939 GCC")
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: devicetree@vger.kernel.org
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220504163835.40130-2-bryan.odonoghue@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/dt-bindings/clock/qcom,gcc-msm8939.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/dt-bindings/clock/qcom,gcc-msm8939.h b/include/dt-bindings/clock/qcom,gcc-msm8939.h
index 0634467c4ce5..2d545ed0d35a 100644
--- a/include/dt-bindings/clock/qcom,gcc-msm8939.h
+++ b/include/dt-bindings/clock/qcom,gcc-msm8939.h
@@ -192,6 +192,7 @@
 #define GCC_VENUS0_CORE0_VCODEC0_CLK		183
 #define GCC_VENUS0_CORE1_VCODEC0_CLK		184
 #define GCC_OXILI_TIMER_CLK			185
+#define SYSTEM_MM_NOC_BFDCD_CLK_SRC		186
 
 /* Indexes for GDSCs */
 #define BIMC_GDSC				0
-- 
2.35.1



