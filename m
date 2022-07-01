Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97EB256330B
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 13:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234022AbiGAL7U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 07:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232975AbiGAL7T (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 07:59:19 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A3E083F08;
        Fri,  1 Jul 2022 04:59:18 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id lw20so3655992ejb.4;
        Fri, 01 Jul 2022 04:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F5g5aJ1I7RiOqycWmd4P9Obv7hflqFvZpC+BWDAaPtE=;
        b=kVEM5mh0cMC2nmfuzjTaUHvlVWUbc0AqTVvzxGhlwMU0cGRT6oRWEhjNPmmW5t58ZG
         aNF7Bk0GcsU+Dt8Wxrtu25XB1FY6DXuk+MJFOsI/7htBhgME5yIQOVRiH971JgpPWBT6
         CrGt/PiEV9QvPsYUgbl4pksh5rhxUMkRJrqKRepHSxzMoo61DA6VPRIg+rMpfRL/ikGT
         IfARS6FwIXj3nfhVyLtH1YTv6xX8kNzDpqJbDhBudc2qO0ad502rccs5T3kXNnHAn7Py
         UzqeFxq7/w7POTsTgT6z7muHPaIbcrDhg2d0Bqsl/e9cONr56f+kzlTEcdA2P3jFjhWb
         qsXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F5g5aJ1I7RiOqycWmd4P9Obv7hflqFvZpC+BWDAaPtE=;
        b=7aX0XN1aUfNAFLKS2Hcxf/t8uZKgqybvgxzO4QRpAk279FqdztmB93y1h+lu8kwwzO
         5jkCtiacjhjOO+u32e92Hm54DNA7YPJDFh0mK3Vm44XvXsth9uAjLrMwovk1nnnQHB/x
         Je+NPGVa6MAjm5b402et7hbKsxqbjLx1GjH31ZgxNwXqR5OHbaw0Uj9WtHs6KPgy+1U/
         xJx9nl1MhJ5uzvIvwQ+KWyXRMV5XNMwF+vrUvlsZFzb3NTdFfvrjUUPLVBGZxqdrlDcA
         u12kbn7Z4WcAvsYIBxXP+0njdmbDJtfEGYRO39gvH1u7E41BF0c4sNkvi/XbgH7hu/hh
         G9fQ==
X-Gm-Message-State: AJIora+dy9mtfG2DfgPKA+3PSFZm+0Uijuw2MyJ177/NlERXWJ3/+UEp
        py0SB4zNvha8BaYwZF5xqCeZosLMWjQ=
X-Google-Smtp-Source: AGRyM1suMQSz+NHorY0Bn17cejl3dsl3SCBn+yByvEs1PkAwlbElJJlm/Jzge3hI5DlBYFHWHaXY0w==
X-Received: by 2002:a17:906:2654:b0:722:fd1b:d5fb with SMTP id i20-20020a170906265400b00722fd1bd5fbmr14180997ejc.59.1656676756501;
        Fri, 01 Jul 2022 04:59:16 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id d18-20020a05640208d200b00435bfcad6d1sm14976922edz.74.2022.07.01.04.59.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 04:59:15 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Chanwoo Choi <cw00.choi@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        linux-pm@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>, stable@vger.kernel.org
Subject: [PATCH] PM / devfreq: fix exynos-bus NULL pointer dereference
Date:   Fri,  1 Jul 2022 13:58:59 +0200
Message-Id: <20220701115859.23975-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix exynos-bus NULL pointer dereference by correctly using the local
generated freq_table to output the debug values instead of using the
profile freq_table that is not used in the driver.

Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Fixes: b5d281f6c16d ("PM / devfreq: Rework freq_table to be local to devfreq struct")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/devfreq/exynos-bus.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/devfreq/exynos-bus.c b/drivers/devfreq/exynos-bus.c
index b5615e667e31..79725bbb4bb0 100644
--- a/drivers/devfreq/exynos-bus.c
+++ b/drivers/devfreq/exynos-bus.c
@@ -447,9 +447,9 @@ static int exynos_bus_probe(struct platform_device *pdev)
 		}
 	}
 
-	max_state = bus->devfreq->profile->max_state;
-	min_freq = (bus->devfreq->profile->freq_table[0] / 1000);
-	max_freq = (bus->devfreq->profile->freq_table[max_state - 1] / 1000);
+	max_state = bus->devfreq->max_state;
+	min_freq = (bus->devfreq->freq_table[0] / 1000);
+	max_freq = (bus->devfreq->freq_table[max_state - 1] / 1000);
 	pr_info("exynos-bus: new bus device registered: %s (%6ld KHz ~ %6ld KHz)\n",
 			dev_name(dev), min_freq, max_freq);
 
-- 
2.36.1

