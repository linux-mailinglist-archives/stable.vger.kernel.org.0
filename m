Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70BAF5A62FA
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 14:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbiH3MOI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 08:14:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbiH3MOH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 08:14:07 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65BB8FE356
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 05:14:05 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id b26so4230317ljk.12
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 05:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=733lkI4nV8tAJya1OCGSDu4na04yzaOxs1WGC8a5e54=;
        b=lDRTcSWk7n5WQYwupr0VW1gI/QLldoWoLCFM2J685qNCJnlhBYp84BlmdPypYDBNo3
         ouJRHsTrlaKAimiUYCJd+qaQ/TwoZ+f5yu50PoNDQJdBhrtNM6mXgmYnUXS7nLhbj44T
         MpvWAod1I18ESN43WrM1B/te/wjdPUxWXEFyxdUcMFaIXtH132GxxAago7aHQvXJe8gh
         JhfxoYsRPaG4ZZW1fJ6R9D8uCCs3sEkRncEFPzwv+K6fIpijn552jnYeSw8LnldYcbhF
         AK6IglZnjBtsb7493A9ttt2jRV3uqL81yUj/p+xTPFucIcU8c2MzP3O0FLZq1JaZtqd4
         xImw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=733lkI4nV8tAJya1OCGSDu4na04yzaOxs1WGC8a5e54=;
        b=NaDvX85XOcNE4ASk+K+ZEPiFsB/BKli8sZfruC10YvBeugpXI7qXGEjvu9KcmO9O2k
         RxpLt5gfIDMt4e38klCTT5TvDTxQcqx5qIegcJjQWc67YzAFfPh57RVQRIxd5pWC9MJ9
         RKRSsud8L5zg584F7rIsbcIDvu8GfeZde+QLb7TD8QM79Ncqz605vJ6iCar8EoLRE0m1
         9b0terVGORm4xP6mMC1RrdXEDKJDEX73AnN0x9sbXLBZx3JrNcIyQP/v3urXtTMwGWGj
         9cnEHtzQnZDw8MVJihCRIq0bH+6FIXdSzUSAfBzbrRkKgenzB0vKjhcKJMudoivOYO4f
         VVsg==
X-Gm-Message-State: ACgBeo2M3SHn8HcQp9LJ/Dxq3Woh4/rI/MAa2DueD15OustdWgOqD2A+
        Ld+/zu8DmEbXQ0EZMaMu/Adl+w==
X-Google-Smtp-Source: AA6agR6g5o6RyV4a/0s0Sj9o147r3+2K3usBGme+KNe+ujHurRQoMOnSOwQSwykKycjIsPgtrmQ2eQ==
X-Received: by 2002:a2e:5005:0:b0:265:54e9:2b81 with SMTP id e5-20020a2e5005000000b0026554e92b81mr2514328ljb.309.1661861643670;
        Tue, 30 Aug 2022 05:14:03 -0700 (PDT)
Received: from krzk-bin.. (balticom-73-99-134.balticom.lv. [109.73.99.134])
        by smtp.gmail.com with ESMTPSA id e14-20020a2e984e000000b0025e57b40009sm1742436ljj.89.2022.08.30.05.14.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 05:14:03 -0700 (PDT)
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
Subject: [PATCH 1/3] slimbus: qcom-ngd: use correct error in message of pdr_add_lookup() failure
Date:   Tue, 30 Aug 2022 15:13:57 +0300
Message-Id: <20220830121359.634344-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
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

Use cprrect error code, instead of previous 'ret' value, when printing
error from pdr_add_lookup() failure.

Cc: <stable@vger.kernel.org>
Fixes: e1ae85e1830e ("slimbus: qcom-ngd-ctrl: add Protection Domain Restart Support")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/slimbus/qcom-ngd-ctrl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/slimbus/qcom-ngd-ctrl.c b/drivers/slimbus/qcom-ngd-ctrl.c
index 0aa8408464ad..6fe6abb86061 100644
--- a/drivers/slimbus/qcom-ngd-ctrl.c
+++ b/drivers/slimbus/qcom-ngd-ctrl.c
@@ -1581,6 +1581,7 @@ static int qcom_slim_ngd_ctrl_probe(struct platform_device *pdev)
 
 	pds = pdr_add_lookup(ctrl->pdr, "avs/audio", "msm/adsp/audio_pd");
 	if (IS_ERR(pds) && PTR_ERR(pds) != -EALREADY) {
+		ret = PTR_ERR(pds);
 		dev_err(dev, "pdr add lookup failed: %d\n", ret);
 		return PTR_ERR(pds);
 	}
-- 
2.34.1

