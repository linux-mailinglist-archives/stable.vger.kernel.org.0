Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56D1F579ED4
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243088AbiGSNGq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243109AbiGSNGa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 09:06:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55C07A0259;
        Tue, 19 Jul 2022 05:27:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9904A61978;
        Tue, 19 Jul 2022 12:26:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59C5CC341D0;
        Tue, 19 Jul 2022 12:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233615;
        bh=FFOp3TiFjA6X4kN9wrJUlb/4XNEw+QMu8X8lFkJOVCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D0agrEKQWyai5kIrDILY7URGuGsgkE9ycirfTQPGjD/7WWP8+WELpUfhckwHxjcQS
         FLZ0E0V4R9ssxPJCGiZ1QRcc+ea7fOFFuW3RNKErj5s2jTiNdmDoFYpnKsQoGzNLsz
         y5p8sEyQy+5FCabkuGF2SkOXdAX5QO7m3iv1xUwU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 153/231] ASoC: dt-bindings: Fix description for msm8916
Date:   Tue, 19 Jul 2022 13:53:58 +0200
Message-Id: <20220719114727.178368901@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

[ Upstream commit 94c65dffd4c4af052b3ea8934fbcb2fa8da276a8 ]

For the existing msm8916 bindings the minimum reg/reg-names is 1 not 2.
Similarly the minimum interrupt/interrupt-names is 1 not 2.

Fixes: f3fc4fbfa2d2 ("ASoC: dt-bindings: Add SC7280 lpass cpu bindings")
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20220629114012.3282945-1-bryan.odonoghue@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/sound/qcom,lpass-cpu.yaml         | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/sound/qcom,lpass-cpu.yaml b/Documentation/devicetree/bindings/sound/qcom,lpass-cpu.yaml
index 2c81efb5fa37..47bb67d43ac2 100644
--- a/Documentation/devicetree/bindings/sound/qcom,lpass-cpu.yaml
+++ b/Documentation/devicetree/bindings/sound/qcom,lpass-cpu.yaml
@@ -25,12 +25,12 @@ properties:
       - qcom,sc7280-lpass-cpu
 
   reg:
-    minItems: 2
+    minItems: 1
     maxItems: 6
     description: LPAIF core registers
 
   reg-names:
-    minItems: 2
+    minItems: 1
     maxItems: 6
 
   clocks:
@@ -42,12 +42,12 @@ properties:
     maxItems: 7
 
   interrupts:
-    minItems: 2
+    minItems: 1
     maxItems: 4
     description: LPAIF DMA buffer interrupt
 
   interrupt-names:
-    minItems: 2
+    minItems: 1
     maxItems: 4
 
   qcom,adsp:
-- 
2.35.1



