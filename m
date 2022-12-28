Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2191D65743E
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 09:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232868AbiL1Iov (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 03:44:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232909AbiL1IoJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 03:44:09 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B65910563
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 00:42:51 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id q68so2693908pgq.9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 00:42:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t4t3wjs91jqYDdhcaBgIoHHF665G49/NIuIJvlGrcfA=;
        b=imJgc7Ixk5aekscKAi7ezzMRHSzFJJTv+Rq9u2se4QLC3CgFHjcLdLAqnY2rzzFixf
         FB/pf4o10XfdXgwrgeJuwnCZYYnEreMSGeaAybI3Jzs4/o52VhkkDlL6PJnDfWn9ShtF
         mqaC6Bf6E2WPM+/9orsIi8nkgVl4TyzU8rHRPvO4INIZML0JinHhsY7rM4Y0xeqCg9z9
         l/2zHbqrpeISzR07n/1geMozRMXA5pbcrDiMRfIfZA5Ixv0GK4bdYcQfyyAQdnt8fIm5
         8awUhpTgxQrL7XVdYHyYQoNIay9wGN9reUFCp1rLQH7N+o2jcbG5TXcArgmP8SXEtqCc
         FMvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t4t3wjs91jqYDdhcaBgIoHHF665G49/NIuIJvlGrcfA=;
        b=uAan0Tizsq6WRBnY/lT83kRK+W79Ozoffuz+vQbKuXqXcvOpVyNUESy9DOFTriCd9h
         Ype7G88+IT0OUbIHi3Cr5AptZuuSXjv8zuhxxvEAOUs26Ye7zGWan43OwcdURizd5P3V
         CpKcJZ/u7+pLaZxag4xPQ2gBCsTpatVaU1E2yfgWf4IhN14x6yqviv4//rJJnFmimg1I
         ZoMoIM641cILGBsMdXoVOJGXgmPQRQdrcfio71BjhGmuDw/mdBqaQsJTolLSkwKsxN2Y
         fts/aDECbpM1Vi+s5xJwInjWIlLg/uSq8tY9u0zaN9Ez5sZJdeUL42f6kF1Kw2t9zvBc
         4Smw==
X-Gm-Message-State: AFqh2kpl/4pDBQdvSN6OOpdxvovv7kz/ubcIOiqhndnxPN16aa5v1DGc
        4IyD3uHgtxyMSNJzj1MIIPMC
X-Google-Smtp-Source: AMrXdXvSYBjnlw6dNXNKrCldqAfDaRwwTmdPy20rhmuxhW42MAtunz6GotQ6FvGBfFh2eY2A3ffN9g==
X-Received: by 2002:a05:6a00:1485:b0:575:b783:b6b3 with SMTP id v5-20020a056a00148500b00575b783b6b3mr34741803pfu.28.1672216971036;
        Wed, 28 Dec 2022 00:42:51 -0800 (PST)
Received: from localhost.localdomain ([117.217.178.73])
        by smtp.gmail.com with ESMTPSA id d188-20020a6236c5000000b0057a9b146592sm9786286pfa.186.2022.12.28.00.42.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Dec 2022 00:42:50 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     andersson@kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, bp@alien8.de,
        tony.luck@intel.com
Cc:     quic_saipraka@quicinc.com, konrad.dybcio@linaro.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        james.morse@arm.com, mchehab@kernel.org, rric@kernel.org,
        linux-edac@vger.kernel.org, quic_ppareek@quicinc.com,
        luca.weiss@fairphone.com, ahalaney@redhat.com, steev@kali.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH v5 17/17] soc: qcom: llcc: Do not create EDAC platform device on SDM845
Date:   Wed, 28 Dec 2022 14:10:28 +0530
Message-Id: <20221228084028.46528-18-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221228084028.46528-1-manivannan.sadhasivam@linaro.org>
References: <20221228084028.46528-1-manivannan.sadhasivam@linaro.org>
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

The platforms based on SDM845 SoC locks the access to EDAC registers in the
bootloader. So probing the EDAC driver will result in a crash. Hence,
disable the creation of EDAC platform device on all SDM845 devices.

The issue has been observed on Lenovo Yoga C630 and DB845c.

Cc: <stable@vger.kernel.org> # 5.10
Reported-by: Steev Klimaszewski <steev@kali.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/soc/qcom/llcc-qcom.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/soc/qcom/llcc-qcom.c b/drivers/soc/qcom/llcc-qcom.c
index 7b7c5a38bac6..8d840702df50 100644
--- a/drivers/soc/qcom/llcc-qcom.c
+++ b/drivers/soc/qcom/llcc-qcom.c
@@ -1012,11 +1012,18 @@ static int qcom_llcc_probe(struct platform_device *pdev)
 
 	drv_data->ecc_irq = platform_get_irq_optional(pdev, 0);
 
-	llcc_edac = platform_device_register_data(&pdev->dev,
-					"qcom_llcc_edac", -1, drv_data,
-					sizeof(*drv_data));
-	if (IS_ERR(llcc_edac))
-		dev_err(dev, "Failed to register llcc edac driver\n");
+	/*
+	 * The platforms based on SDM845 SoC locks the access to EDAC registers
+	 * in bootloader. So probing the EDAC driver will result in a crash.
+	 * Hence, disable the creation of EDAC platform device on SDM845.
+	 */
+	if (!of_device_is_compatible(dev->of_node, "qcom,sdm845-llcc")) {
+		llcc_edac = platform_device_register_data(&pdev->dev,
+						"qcom_llcc_edac", -1, drv_data,
+						sizeof(*drv_data));
+		if (IS_ERR(llcc_edac))
+			dev_err(dev, "Failed to register llcc edac driver\n");
+	}
 
 	return 0;
 err:
-- 
2.25.1

