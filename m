Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6ECE5A62FD
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 14:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbiH3MOK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 08:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbiH3MOH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 08:14:07 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF76155A5D
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 05:14:06 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id z29so6679283lfb.13
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 05:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=oACP5OJ8E262bJyD/huCTI3+4w0pfeaLTzinloHqVMQ=;
        b=DmtvEIodMZpn1KTPg/BtyUYkVLXGbMytdn6Cys0esmT+9iQN0XAvFe42woLBW/vtBp
         ZS1w+ZFLCTH5EuI1uyUgA0d49DABrExr4Q2Q0klOa2D7g8C/pHUiq/OKTgRbbqguDN1D
         NCngdCsdD0KZCSIWIrET1AM4LV8HLExbZoxXgxG1+6NOaCFHmTnom4uVmGQJpskH5fJv
         nsvkMj/ScQUK6BKiye/dXX20Zu0TFdbUNO1AHhjektm683zwSI5abtOqnt7BC1Wq6VL0
         qjmNzei4jAEl3Y8QMWf15lp97r3x9KkpHlCZYoMaaxz3tKJVq0WJbnukJYwOCFZxfAfr
         F1Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=oACP5OJ8E262bJyD/huCTI3+4w0pfeaLTzinloHqVMQ=;
        b=ottHTs/a23E4LiD8qopCelRB71tN9mifXpz2grImrBtOVgj4sx6OKqI4B0XBKo0lpC
         tlthepQ0xiYcgxgEaBUKiVBk5RFno9C9BuK1chBmsjIM2NliNjEbIBpgvvD8ZuKuGMqq
         QJg8lT+C9q66VJcVIf3mKFzK4B/RdaRaXszqq9Xr3Xnq6okbX0d5B8lo8pqE4au9LIe/
         m3Uk8jOz9pCV3gqRW74yDy+uUbBlhYWZP4W5C70uJGtztO8TjggQBzcwfMfDTc0ObTAQ
         N1AGShetVS/NZg9kJON7AiwpG92FsYJRGy/kDTJyQ6uwGbktrejM4Xj/buF7jmLYrPVW
         D/1w==
X-Gm-Message-State: ACgBeo0YHBX+NNCjiOVAMimjHERFezfZjba1VfLg2vcIQVmpYMm7WzDC
        cUOii2E4f8+QUxF1k5PkgcF9cg==
X-Google-Smtp-Source: AA6agR5rB94QRjCCM1vUWb04bJnxTamAaZW4THRNYgKtwQvwdbklXgkZdG0aKFaLfkcqxqu5JMSPqg==
X-Received: by 2002:a05:6512:38b2:b0:493:9a:ac2e with SMTP id o18-20020a05651238b200b00493009aac2emr7333228lft.126.1661861644793;
        Tue, 30 Aug 2022 05:14:04 -0700 (PDT)
Received: from krzk-bin.. (balticom-73-99-134.balticom.lv. [109.73.99.134])
        by smtp.gmail.com with ESMTPSA id e14-20020a2e984e000000b0025e57b40009sm1742436ljj.89.2022.08.30.05.14.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 05:14:04 -0700 (PDT)
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
Subject: [PATCH 2/3] slimbus: qcom-ngd: cleanup in probe error path
Date:   Tue, 30 Aug 2022 15:13:58 +0300
Message-Id: <20220830121359.634344-2-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220830121359.634344-1-krzysztof.kozlowski@linaro.org>
References: <20220830121359.634344-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add proper error path in probe() to cleanup resources previously
acquired/allocated:

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
 drivers/slimbus/qcom-ngd-ctrl.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/slimbus/qcom-ngd-ctrl.c b/drivers/slimbus/qcom-ngd-ctrl.c
index 6fe6abb86061..bacc6af1d51e 100644
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
-		return PTR_ERR(pds);
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

