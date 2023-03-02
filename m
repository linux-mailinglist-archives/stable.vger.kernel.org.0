Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72B776A8229
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 13:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbjCBM3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 07:29:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjCBM3O (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 07:29:14 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E86BBA9
        for <stable@vger.kernel.org>; Thu,  2 Mar 2023 04:29:13 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id f13so66898560edz.6
        for <stable@vger.kernel.org>; Thu, 02 Mar 2023 04:29:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1677760152;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MkMpyzZmxlO9b2AsSdB9NaVD+MPuHTACY2Gn31+0dVU=;
        b=UaZu2BYWB0K2sii6++RoHtMF5I+lioLvgxeEoscuP9Va3mg+vWk6yAcjGTSJGqaa3k
         RGZ/LPMXH+9wXWkzahKFbc30DkZdm9Pbgyi+y7bHuu8bDoGPUeFAz54DCb3SOBMOZKNc
         dGSDKozlupvguO0NRPCDD5XF5gPF+vbAn1YD8IGp+pCblCZjAkjPNmectE11GvBenTwD
         THK74CQdYlgv+dhoxYvOkXw4X4foBcg4s9Px0u3M3UYD2eUM0rszKk41E7pnnv7acm3t
         NOBOlZ8oDh63mQPWSNFPl53EIfzWEosnIU7qzq3Gag1PvGR7BGsVCt6OBNNQqXin3+JC
         6UVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677760152;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MkMpyzZmxlO9b2AsSdB9NaVD+MPuHTACY2Gn31+0dVU=;
        b=3WCm9Zhi9Xi+nSWLyTKrc9joz50k/gONlus8IlnKng2/fx8E2LbaSlOU6MO0+waWvC
         ezNP+xxZFnez67CAlm26K7p1n0E3BV8VNzkWbhbVMfDU4DWcf4x6F45TAsBlSOtnP0FU
         PyLRPy/W4wemQbl5KrDzRnxp6oAg5Z4p3axj6IUfvzjAiXkBR+FLdnU5yOX18BK4UE/P
         ETGXsIG3AKZyWAIOsLQivCKdjb+98QlliKPG21Z1+n9UmMAtbFFFs0CwbfWQjNvLQnY0
         DFqpisVLf2kQl8KhfbaFPu33Pgqsp8Bes1OQKwKYR5NrUOXegNiyMvjncVF5XyKgTY8b
         ciaw==
X-Gm-Message-State: AO0yUKV8sLBWh2nnyhAFCR4uT1qN7mt/+bOhwP26FVzTvKSffrwAP2t0
        ZWx2VAjFPrurOzp8u5krA6mIKA==
X-Google-Smtp-Source: AK7set+vwQ+sJWL6Mw1/s1vP3DaSNtdfPbkp5RSPjIdryaxpJ01PRGBmL0J6RgaXTsCL7uxbGpM1qw==
X-Received: by 2002:a17:906:4887:b0:8af:54d2:36af with SMTP id v7-20020a170906488700b008af54d236afmr9381027ejq.76.1677760152468;
        Thu, 02 Mar 2023 04:29:12 -0800 (PST)
Received: from krzk-bin.. ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id v13-20020a1709064e8d00b008e3bf17fb2asm7162155eju.19.2023.03.02.04.29.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 04:29:12 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Banajit Goswami <bgoswami@quicinc.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH] ASoC: qcom: q6prm: fix incorrect clk_root passed to ADSP
Date:   Thu,  2 Mar 2023 13:29:08 +0100
Message-Id: <20230302122908.221398-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
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

The second to last argument is clk_root (root of the clock), however the
code called q6prm_request_lpass_clock() with clk_attr instead
(copy-paste error).  This effectively was passing value of 1 as root
clock which worked on some of the SoCs (e.g. SM8450) but fails on
others, depending on the ADSP.  For example on SM8550 this "1" as root
clock is not accepted and results in errors coming from ADSP.

Fixes: 2f20640491ed ("ASoC: qdsp6: qdsp6: q6prm: handle clk disable correctly")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 sound/soc/qcom/qdsp6/q6prm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/qcom/qdsp6/q6prm.c b/sound/soc/qcom/qdsp6/q6prm.c
index 8aa1a213bfb7..c1dc5bae715a 100644
--- a/sound/soc/qcom/qdsp6/q6prm.c
+++ b/sound/soc/qcom/qdsp6/q6prm.c
@@ -183,9 +183,9 @@ int q6prm_set_lpass_clock(struct device *dev, int clk_id, int clk_attr, int clk_
 			  unsigned int freq)
 {
 	if (freq)
-		return q6prm_request_lpass_clock(dev, clk_id, clk_attr, clk_attr, freq);
+		return q6prm_request_lpass_clock(dev, clk_id, clk_attr, clk_root, freq);
 
-	return q6prm_release_lpass_clock(dev, clk_id, clk_attr, clk_attr, freq);
+	return q6prm_release_lpass_clock(dev, clk_id, clk_attr, clk_root, freq);
 }
 EXPORT_SYMBOL_GPL(q6prm_set_lpass_clock);
 
-- 
2.34.1

