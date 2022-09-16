Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA03E5BAD75
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 14:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbiIPM3p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 08:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbiIPM3k (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 08:29:40 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC2010F5
        for <stable@vger.kernel.org>; Fri, 16 Sep 2022 05:29:30 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id az24-20020a05600c601800b003a842e4983cso15808974wmb.0
        for <stable@vger.kernel.org>; Fri, 16 Sep 2022 05:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=I5+a1QqwYJyDVCXJAIa2b2pM30dX36e5vx2XWxYNEV0=;
        b=l8U22qeDLoG6bQDYeGUJjpLo/DRhBjday95PJXEIzMSqXXXHiA4xaCoDfTzVfQ/CVq
         qU6Pfy8XwKvcfsHDCSNgrIGDB6AGGPCOlyRF0YLdG7VzRXkNcrn1B19w3xyKbupqRCS9
         FPHhnbZGoW5HJbs0/yrFp670RaB9M1vUXHmabImT3ZeF+8Qkl8//PoktWo0AmIAOL0+0
         VGUYCvJ+Aos7ipIj7453Q3y5srYvlMzTH0T75kw80aoiMuRuDc+SuhmeC+ruXEW8VOFi
         u9jk+gql0l/Dc0VZRkrHxYtIItiPFPUAXCsrJdbeHSwBWnho9W8e6Qy4c5vQOfeaB+V2
         ZJ3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=I5+a1QqwYJyDVCXJAIa2b2pM30dX36e5vx2XWxYNEV0=;
        b=iSU/9YUECUV5uiV8klvi3JVhArZToiUlHnH9kVvQd4LsYLNsvmox07nA99yyv9T5F2
         KAGFhNVs7kjVsFKEQa0kjOXY14/BI+W4sHc2jGGGJ7gCiHiFeteEZBizD5c70dfay+mN
         GHleoa3HC5aNODd8gXRESfjvfl4IU89hnU/5FGvWPpsjG/TVd/UuPsoCuL8GA1jz9reG
         F6AL5X457NvdDm1QqPT5RGz09DBoqrOXz8bwqQ0KVEYTZfinprq6ab7Ejc8q16+XmUTl
         FNvXjQ2mwYWMdvIEkLNm7Y4HtySNp/Rne3rTGSGtQE1oqP7aHzGuQKVt02I/hvmu5oPo
         nSdQ==
X-Gm-Message-State: ACrzQf0i2yuVF2NYHtkYq1/yUv25r7bg51K4a5tOOghIckqUNGUSNR1T
        mXO3i467g3GRlNhkI5zBQbDtdg==
X-Google-Smtp-Source: AMsMyM4hiJXwY5TumSy3scrgqTr6Dy3ZxbhqEUmo1iJI4hfLpyRhZmvrwpb/08j8H+qL8RcHuN2ddg==
X-Received: by 2002:a05:600c:4ec8:b0:3b4:bdc6:9b3d with SMTP id g8-20020a05600c4ec800b003b4bdc69b3dmr1876174wmq.181.1663331368894;
        Fri, 16 Sep 2022 05:29:28 -0700 (PDT)
Received: from srini-hackbase.lan (cpc90716-aztw32-2-0-cust825.18-1.cable.virginm.net. [86.26.103.58])
        by smtp.gmail.com with ESMTPSA id m188-20020a1c26c5000000b003b4a68645e9sm1990825wmm.34.2022.09.16.05.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 05:29:28 -0700 (PDT)
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 2/4] slimbus: qcom-ngd: cleanup in probe error path
Date:   Fri, 16 Sep 2022 13:29:08 +0100
Message-Id: <20220916122910.170730-3-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220916122910.170730-1-srinivas.kandagatla@linaro.org>
References: <20220916122910.170730-1-srinivas.kandagatla@linaro.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Add proper error path in probe() to cleanup resources previously
acquired/allocated to fix warnings visible during probe deferral:

  notifier callback qcom_slim_ngd_ssr_notify already registered
  WARNING: CPU: 6 PID: 70 at kernel/notifier.c:28 notifier_chain_register+0x5c/0x90
  Modules linked in:
  CPU: 6 PID: 70 Comm: kworker/u16:1 Not tainted 6.0.0-rc3-next-20220830 #380
  Call trace:
   notifier_chain_register+0x5c/0x90
   srcu_notifier_chain_register+0x44/0x90
   qcom_register_ssr_notifier+0x38/0x4c
   qcom_slim_ngd_ctrl_probe+0xd8/0x400
   platform_probe+0x6c/0xe0
   really_probe+0xbc/0x2d4
   __driver_probe_device+0x78/0xe0
   driver_probe_device+0x3c/0x12c
   __device_attach_driver+0xb8/0x120
   bus_for_each_drv+0x78/0xd0
   __device_attach+0xa8/0x1c0
   device_initial_probe+0x18/0x24
   bus_probe_device+0xa0/0xac
   deferred_probe_work_func+0x88/0xc0
   process_one_work+0x1d4/0x320
   worker_thread+0x2cc/0x44c
   kthread+0x110/0x114
   ret_from_fork+0x10/0x20

Cc: <stable@vger.kernel.org>
Fixes: e1ae85e1830e ("slimbus: qcom-ngd-ctrl: add Protection Domain Restart Support")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/slimbus/qcom-ngd-ctrl.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/slimbus/qcom-ngd-ctrl.c b/drivers/slimbus/qcom-ngd-ctrl.c
index f4f330b9fa72..bacc6af1d51e 100644
--- a/drivers/slimbus/qcom-ngd-ctrl.c
+++ b/drivers/slimbus/qcom-ngd-ctrl.c
@@ -1576,18 +1576,27 @@ static int qcom_slim_ngd_ctrl_probe(struct platform_device *pdev)
 	ctrl->pdr = pdr_handle_alloc(slim_pd_status, ctrl);
 	if (IS_ERR(ctrl->pdr)) {
 		dev_err(dev, "Failed to init PDR handle\n");
-		return PTR_ERR(ctrl->pdr);
+		ret = PTR_ERR(ctrl->pdr);
+		goto err_pdr_alloc;
 	}
 
 	pds = pdr_add_lookup(ctrl->pdr, "avs/audio", "msm/adsp/audio_pd");
 	if (IS_ERR(pds) && PTR_ERR(pds) != -EALREADY) {
 		ret = PTR_ERR(pds);
 		dev_err(dev, "pdr add lookup failed: %d\n", ret);
-		return ret;
+		goto err_pdr_lookup;
 	}
 
 	platform_driver_register(&qcom_slim_ngd_driver);
 	return of_qcom_slim_ngd_register(dev, ctrl);
+
+err_pdr_alloc:
+	qcom_unregister_ssr_notifier(ctrl->notifier, &ctrl->nb);
+
+err_pdr_lookup:
+	pdr_handle_release(ctrl->pdr);
+
+	return ret;
 }
 
 static int qcom_slim_ngd_ctrl_remove(struct platform_device *pdev)
-- 
2.25.1

