Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2548369C16D
	for <lists+stable@lfdr.de>; Sun, 19 Feb 2023 17:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbjBSQ5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Feb 2023 11:57:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbjBSQ5K (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Feb 2023 11:57:10 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CDB0126E1
        for <stable@vger.kernel.org>; Sun, 19 Feb 2023 08:57:08 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id x22so3472113edd.10
        for <stable@vger.kernel.org>; Sun, 19 Feb 2023 08:57:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kj+lBJ82i0AJk03H8+z+wxkrXrlcvM3V1YG5aWXZ/k0=;
        b=OmLhAumynGYzNay+Qy8rCJvvmIz9OqvoBP/ads/ltAT+OkYAJivj9hpJdSyroAXigx
         kyQsJJjO/XEAnlok2ozZYdXGdh1d1C6R+P+hB7eHxqVB3KGl0iYlNztd3S/Qcnqc9kHl
         PZpxd+Jfej+QETt8q/CfcK6lm/24vjnYnUkVyiVYFExdqOR8VJ2h13D2FsBAlW8K1BSk
         MuTNZCvnZMkAHsQPCGYdDU5dR+DFVeVKIaiJ/FQYFbCZUk10yc+0m8OjKuRfzC0z9Mwt
         p7RQzEXFcdkqCYUzxuoe4Bu4Gg85NmhS1Z4h/mayzG9RiqMCsK82e4rgL5nWKj/7+4ZA
         9YKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kj+lBJ82i0AJk03H8+z+wxkrXrlcvM3V1YG5aWXZ/k0=;
        b=S2rBwmy/Ss+Dc4j1ipifXPhPODZzKu/osBUHGLBZuxLb8dMV1N4WMtlNQ0EDItqBoj
         IGAnIaVj5NDARTSfaLh4KtbyhJFv/LJBsiYVass1sXN5y2bS3ZqofUI5Vyo38P20Hi1B
         E2I8vX/B+EfQpjN3x2ofkfQnKXZt/VfPaGv5XEf5bCSsGR/s7xzV4wcWyNvKgBZQc2iy
         QF3o/EdRjThw6n1LQ90RKkXdRD1Pmd0xsC5+tVac2YOkF/GpL5rWCXz5N7qKsUm9n3So
         D5PUOjDf0agXjz20pcqMF4rYKRLPH5QvikzsANujf7TWyrLsbaXvhLJcjK/uAjdx2GQc
         uo5A==
X-Gm-Message-State: AO0yUKVy3GFL4c9BLfhmOQgKMv6ijed3lVr1p3U5FqYFa//cVGBfzlIV
        Oz79F4GDnt7gn/q7ENnJlc5MTw==
X-Google-Smtp-Source: AK7set/r5JQ1G0B50a/yiJVR3cB11cum4Ecvju9Dv+R+mbRytfdxVSpn9Y4GPPR/2bR/W6Jl9AuoHg==
X-Received: by 2002:a17:906:1014:b0:8b1:756c:1a30 with SMTP id 20-20020a170906101400b008b1756c1a30mr12153399ejm.59.1676825827088;
        Sun, 19 Feb 2023 08:57:07 -0800 (PST)
Received: from hackbox.lan ([94.52.112.99])
        by smtp.gmail.com with ESMTPSA id w5-20020a1709064a0500b008bbc4f3bceesm2213504eju.118.2023.02.19.08.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Feb 2023 08:57:06 -0800 (PST)
From:   Abel Vesa <abel.vesa@linaro.org>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Johan Hovold <johan@kernel.org>,
        Sai Prakash Ranjan <quic_saipraka@quicinc.com>,
        Juerg Haefliger <juerg.haefliger@canonical.com>
Cc:     linux-arm-msm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH v3] soc: qcom: llcc: Fix slice configuration values for SC8280XP
Date:   Sun, 19 Feb 2023 18:57:01 +0200
Message-Id: <20230219165701.2557446-1-abel.vesa@linaro.org>
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
LLCC config registers. Fix that by using the slice ID values taken from
the latest LLCC SC table.

Fixes: ec69dfbdc426 ("soc: qcom: llcc: Add sc8180x and sc8280xp configurations")
Cc: stable@vger.kernel.org	# 5.19+
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Tested-by: Juerg Haefliger <juerg.haefliger@canonical.com>
Reviewed-by: Sai Prakash Ranjan <quic_saipraka@quicinc.com>
Acked-by: Konrad Dybcio <konrad.dybcio@linaro.org>
---

The v2 is here:
https://lore.kernel.org/all/20230127144724.1292580-1-abel.vesa@linaro.org/

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

