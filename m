Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B99295BAD76
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 14:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbiIPM3r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 08:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231493AbiIPM3m (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 08:29:42 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B3C4F4A
        for <stable@vger.kernel.org>; Fri, 16 Sep 2022 05:29:29 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id n40-20020a05600c3ba800b003b49aefc35fso6501379wms.5
        for <stable@vger.kernel.org>; Fri, 16 Sep 2022 05:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=f8P6NdaxW6n0MxKc6m48JQ99Q9yCqPt9CXBbjR8xRMU=;
        b=tX3mOonKXJPL1OZFdAVC68GaOsmTp9e/LPG3v7bWq8bnkc4cpgBSt5Zx3ixiaofOCO
         pkTfI7Tjrj1iiX311Yatu82wewCJaj6s1Li8LN8gH4iO1KSpXFUMj7K7n05rPOlObRl+
         lIsiw8DsjibgmO8KSS15CnoN/OA/SXlDfoW6PVJQqat95zUdR53tAHPZrVTRfoSLtub0
         cIHG8IGR65Lwyq0hVj4rIaxKwkB2fypk2HLxc6J3uBGqxwhERlG1iVUNtjmZ+g6/QPlO
         Z8KDdWzFeFI0534Hp6+vI5D48DH0oRbdkVYeIQ2i/XjuKOEvhlZKtPdpWkCiA4HBqkn7
         W/zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=f8P6NdaxW6n0MxKc6m48JQ99Q9yCqPt9CXBbjR8xRMU=;
        b=RlvyxzdWMBzZYH6Eu9TjBCZz5WizwBSN1hNQnKgMrR2ZYPojtzlJzXOGvyfWst7UbE
         mErl2KtHxPfa1afK8He1OMTemaAz+9eM9KpMW7FSb5M4vNyzGg6NKo0vgubxqp+E2oXJ
         qcmak3yu9Ct7OPpbslXhJ8n89Tm1xv1r3KycQ2q+g52vFUa8cey1PgRtQbuokVEBe6Ll
         vAo295NeaoRrwJQd46qcqhiPOM+fX1q4QWGFq3ApGByl1gBXvrhdm9LaGotgQ1WOe+6H
         7sqKzweUGbJ7qkXZ4ngCxZBVTKdMS+NsC7w5N2stHzGLylrv0lp/nHRtGY0dozoFOnGK
         uz6Q==
X-Gm-Message-State: ACrzQf0NFNYt7mz6R7PIs/CoobNcqRnE5N4EXAMYtOjTxByvyiQnAPGv
        jzVX8ppaZhSdMhkPLGhtvPMLyQ==
X-Google-Smtp-Source: AMsMyM5BXScGtyIuzMOl/K3AX8gg9CaoIh8aIhAZyU4j72K9ld7E6e3s4wK/ApZOPQJkoJf8azFQUA==
X-Received: by 2002:a05:600c:34c2:b0:3b4:7a98:5f5a with SMTP id d2-20020a05600c34c200b003b47a985f5amr3162839wmq.156.1663331368019;
        Fri, 16 Sep 2022 05:29:28 -0700 (PDT)
Received: from srini-hackbase.lan (cpc90716-aztw32-2-0-cust825.18-1.cable.virginm.net. [86.26.103.58])
        by smtp.gmail.com with ESMTPSA id m188-20020a1c26c5000000b003b4a68645e9sm1990825wmm.34.2022.09.16.05.29.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 05:29:27 -0700 (PDT)
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 1/4] slimbus: qcom-ngd: use correct error in message of pdr_add_lookup() failure
Date:   Fri, 16 Sep 2022 13:29:07 +0100
Message-Id: <20220916122910.170730-2-srinivas.kandagatla@linaro.org>
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

Use correct error code, instead of previous 'ret' value, when printing
error from pdr_add_lookup() failure.

Cc: <stable@vger.kernel.org>
Fixes: e1ae85e1830e ("slimbus: qcom-ngd-ctrl: add Protection Domain Restart Support")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/slimbus/qcom-ngd-ctrl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/slimbus/qcom-ngd-ctrl.c b/drivers/slimbus/qcom-ngd-ctrl.c
index 0aa8408464ad..f4f330b9fa72 100644
--- a/drivers/slimbus/qcom-ngd-ctrl.c
+++ b/drivers/slimbus/qcom-ngd-ctrl.c
@@ -1581,8 +1581,9 @@ static int qcom_slim_ngd_ctrl_probe(struct platform_device *pdev)
 
 	pds = pdr_add_lookup(ctrl->pdr, "avs/audio", "msm/adsp/audio_pd");
 	if (IS_ERR(pds) && PTR_ERR(pds) != -EALREADY) {
+		ret = PTR_ERR(pds);
 		dev_err(dev, "pdr add lookup failed: %d\n", ret);
-		return PTR_ERR(pds);
+		return ret;
 	}
 
 	platform_driver_register(&qcom_slim_ngd_driver);
-- 
2.25.1

