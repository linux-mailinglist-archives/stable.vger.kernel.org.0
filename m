Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9D5F6AC1F1
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 14:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbjCFNz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 08:55:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbjCFNzx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 08:55:53 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7955303C7
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 05:55:49 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id p16so5678672wmq.5
        for <stable@vger.kernel.org>; Mon, 06 Mar 2023 05:55:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678110948;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6EPk/yxhkspR8/DJQsxy544G2V8zAJbCDLKWqTOj46w=;
        b=kgY1Dp5Ew/FXHTgZM8qaXsLS1dDMQZ2a8xrpy3FJbO1JmjfocvLJTxm0IHxtK+VSQ2
         jQekCGaf0BBw3B6A/LFT2AQ62UaTfrXH40HpB/UT6DNfbc5qpC99RMpIn0TZ2dQCJzFM
         +LERGcIMDN58BAm1SEt35dvTbszgQp/5+TO3vI/AkGX1Jw00iHTve1rJX+jRqAOxZsEa
         958vjqEL9xtXF9kgCZe38xJCjxmG1O3jO60YOSFWyt0QBCYREhikuNtLquZMdHxPDZl5
         p5/yiS/rgCXBt604H+R0CR+IdFj5P8dC9l3VG1RNHK928oBKkgxS4BHyGbHNB+Uk/6TF
         wxiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678110948;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6EPk/yxhkspR8/DJQsxy544G2V8zAJbCDLKWqTOj46w=;
        b=MlpYjOmww1ITeeVZIw1fQNsYiMYYI915pNGfG1MkR92Nr/mvHiUsin8vIfaeGP5cOi
         /ccIcN9iVLOMx282Z7PXq5TsYZ3Gjre/TGiRoIYw4VOJeMTC0NlzjIiElEmQTLwYKHuv
         b9iHQZ7JP2nkySjEwZT+R68Ln/YBxbTjiUbImkW5LrQTfPHZ5cB5wNOqjswIQLo2qW/N
         b98vHXsKMofiU1qgwFwm0ObpDH0NAbdxPbT90XUYuE6+j0NU9+4uA9AnB9m8HuZzJfzn
         wBCOUR9RDAy23lyzbvxXKyZVAQCoTGgy4kVIn99RdzNy2ixNUqtkh7wjBQCdZ1fHv5L6
         GZOQ==
X-Gm-Message-State: AO0yUKU4SO/c8hf6z9V4zSsxPs45uuE293tUpmzW+7/6BTTt446x2Wxw
        f3QDmW5gIb0Q+dkaCfWjdugZhw==
X-Google-Smtp-Source: AK7set8t3Eqavntj8kFwEh8wpn9kndsaf9bmZAUemRYma9rsJHkTtsjmx+z62uLwS/Of71CgxvHgIA==
X-Received: by 2002:a05:600c:4fd6:b0:3df:d8c5:ec18 with SMTP id o22-20020a05600c4fd600b003dfd8c5ec18mr9072578wmq.13.1678110948133;
        Mon, 06 Mar 2023 05:55:48 -0800 (PST)
Received: from hackbox.lan ([94.52.112.99])
        by smtp.gmail.com with ESMTPSA id r1-20020a056000014100b002c5534db60bsm10206752wrx.71.2023.03.06.05.55.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 05:55:47 -0800 (PST)
From:   Abel Vesa <abel.vesa@linaro.org>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Sai Prakash Ranjan <quic_saipraka@quicinc.com>,
        Juerg Haefliger <juerg.haefliger@canonical.com>,
        Johan Hovold <johan@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Johan Hovold <johan+linaro@kernel.org>
Subject: [PATCH v4] soc: qcom: llcc: Fix slice configuration values for SC8280XP
Date:   Mon,  6 Mar 2023 15:55:27 +0200
Message-Id: <20230306135527.509796-1-abel.vesa@linaro.org>
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

The slice IDs for CVPFW, CPUSS1 and CPUWHT currently overflow the 32bit
LLCC config registers, which means it is writing beyond the upper limit
of the ATTR0_CFGn and ATTR1_CFGn range of registers. But the most obvious
impact is the fact that the mentioned slices do not get configured at all,
which will result in reduced performance. Fix that by using the slice ID
values taken from the latest LLCC SC table.

Fixes: ec69dfbdc426 ("soc: qcom: llcc: Add sc8180x and sc8280xp configurations")
Cc: stable@vger.kernel.org	# 5.19+
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Tested-by: Juerg Haefliger <juerg.haefliger@canonical.com>
Reviewed-by: Sai Prakash Ranjan <quic_saipraka@quicinc.com>
Acked-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
---

The v3 is here:
https://lore.kernel.org/all/20230219165701.2557446-1-abel.vesa@linaro.org/

Changes since v3:
 * explicitly mentioned in the commit message the fact that some random
   registers might get written and the fact that there is an impact
   on performance.
 * Added Johan's R-b tag

Changes since v2:
 * specifically mentioned the 3 slice IDs that are being fixed and
   what is happening without this patch
 * added stabke Cc line
 * added Juerg's T-b tag
 * added Sai's R-b tag
 * added Konrad's A-b tag

Changes since v1:
 * dropped the LLCC_GPU and LLCC_WRCACHE max_cap changes
 * took the new values from documentatio this time rather than
   downstream kernel

 drivers/soc/qcom/llcc-qcom.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/soc/qcom/llcc-qcom.c b/drivers/soc/qcom/llcc-qcom.c
index 23ce2f78c4ed..26efe12012a0 100644
--- a/drivers/soc/qcom/llcc-qcom.c
+++ b/drivers/soc/qcom/llcc-qcom.c
@@ -191,9 +191,9 @@ static const struct llcc_slice_config sc8280xp_data[] = {
 	{ LLCC_CVP,      28, 512,  3, 1, 0xfff, 0x0, 0, 0, 0, 1, 0, 0 },
 	{ LLCC_APTCM,    30, 1024, 3, 1, 0x0,   0x1, 1, 0, 0, 1, 0, 0 },
 	{ LLCC_WRCACHE,  31, 1024, 1, 1, 0xfff, 0x0, 0, 0, 0, 0, 1, 0 },
-	{ LLCC_CVPFW,    32, 512,  1, 0, 0xfff, 0x0, 0, 0, 0, 1, 0, 0 },
-	{ LLCC_CPUSS1,   33, 2048, 1, 1, 0xfff, 0x0, 0, 0, 0, 1, 0, 0 },
-	{ LLCC_CPUHWT,   36, 512,  1, 1, 0xfff, 0x0, 0, 0, 0, 0, 1, 0 },
+	{ LLCC_CVPFW,    17, 512,  1, 0, 0xfff, 0x0, 0, 0, 0, 1, 0, 0 },
+	{ LLCC_CPUSS1,   3, 2048, 1, 1, 0xfff, 0x0, 0, 0, 0, 1, 0, 0 },
+	{ LLCC_CPUHWT,   5, 512,  1, 1, 0xfff, 0x0, 0, 0, 0, 0, 1, 0 },
 };
 
 static const struct llcc_slice_config sdm845_data[] =  {
-- 
2.34.1

