Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB905A6B5F
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 19:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbiH3Ryw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 13:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231797AbiH3Ryd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 13:54:33 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D273610400A
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 10:52:16 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id q16so12171653ljp.8
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 10:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=3y3YYNjG4SIll+4KRGX+EDIiHFSP98/0RDSZ0UDqAXc=;
        b=Rrxh/TS3FWVNU8y41gAtxxp1CRU75bRvzDTANnlUteoF/ovurrUMSNm9Yba5XpSq1f
         H9R8AjL9HUgEikw/mKRZmcUZgovaaSLfhvqRWTe6HJlU12QMDCWywCCYHIF9DwB/G6lI
         JTCGDT5LVGV2J9adV3BVXpiwSgyVRgYilju2pZ9hIcA9RMiJjf6PcvcnIXsQhl804zvS
         AuRE5oR9kPjiUW8KXwLyJIpVNt91qCMlblsdbD0/0zjfu52Q+HO1GN2JLriw5Fxy7rLx
         wZ5TG1ag8OOL9Xgu67kbNfFN94Pky8QsLaBUlwnE+f4FX4sZq/5rEf/4zaH7PR15m/Si
         25ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=3y3YYNjG4SIll+4KRGX+EDIiHFSP98/0RDSZ0UDqAXc=;
        b=xSLTZSwKbOTEP4XD+kLhHxkvlRzzpLUgxiYWQIN8+44DyTIwUPP4B3YoV0676jQizs
         SGujzVpuysv9ueT9fClez//0qL3sohEZUptTmkdzulfmtJHStPqADYltI4xZGkn5nBlQ
         nQSrVyrSaEmFUga+LEYwctXF1VhZ7biZ+V0vQVITECBl4a2/Qc4UDtDDexg0eGre2NGx
         0InMccuPf/QpsuY3+NulFO1D0f0rVwhXfnAsFedhfflauhiJ+07ZCCQN5Oh+p3HPXGWL
         GqvZV6hN56OjF8Yd0Eg7M+4vj50wQt5kpuSVcUYpWfGIYnKT9ibwkA/BdFHLRLO/pZ33
         ZjZg==
X-Gm-Message-State: ACgBeo0xN1ifLFnYZUum62XELyqQ1qSGtltWgTWHhWy7OIz52l/WeYPw
        n4wieNjrNHzyNulhkHP5Haacer/NSj7YUSn9
X-Google-Smtp-Source: AA6agR6aBzjax1OJ583UbgWEAsw1wjuLmZGIkw+bcfOnZZOUr6WPMhITL1nEpYPpzybvIaw+MGsTmw==
X-Received: by 2002:a05:651c:105b:b0:265:ca48:d445 with SMTP id x27-20020a05651c105b00b00265ca48d445mr2491150ljm.300.1661881934701;
        Tue, 30 Aug 2022 10:52:14 -0700 (PDT)
Received: from krzk-bin.. (balticom-73-99-134.balticom.lv. [109.73.99.134])
        by smtp.gmail.com with ESMTPSA id z16-20020a05651c11d000b00266461bf934sm653420ljo.107.2022.08.30.10.52.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 10:52:14 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH v2 2/3] slimbus: qcom-ngd: cleanup in probe error path
Date:   Tue, 30 Aug 2022 20:52:06 +0300
Message-Id: <20220830175207.13315-2-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220830175207.13315-1-krzysztof.kozlowski@linaro.org>
References: <20220830175207.13315-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

---

Changes since v1:
1. None
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
2.34.1

