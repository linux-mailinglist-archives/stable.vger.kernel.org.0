Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 339E54824C8
	for <lists+stable@lfdr.de>; Fri, 31 Dec 2021 17:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbhLaQUS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Dec 2021 11:20:18 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:54858
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229693AbhLaQUR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Dec 2021 11:20:17 -0500
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com [209.85.167.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id F20F6407B0
        for <stable@vger.kernel.org>; Fri, 31 Dec 2021 16:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1640967615;
        bh=Z5ioY/F3t7PzEeZt89hQh1G0ZQnghAHpzWba5N0rXNM=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=d8877vxYZ2irgGdj3Ay4kG7kTqaXuGZgMIiEnWi7JH+Sjwhb3JG89ZrBFWj2dyWdd
         2SxalkU2biu3E1xOvaaRTAYk+COQDzrsrzxheKWletirNIuAQY19NDmPr/8JWjVn54
         409Gv/bK18FjOZk6vlNd4swKQ8TqBs/s9+0xeXv6EdRqR0YW34HEthgdYgviZkSIcT
         8kjkNcxri+7ltWfleBVzbmUz2vuppfWFvDgCr0L72bMoxlkXtc/3NYnaJ/i26Qxi+v
         FWgMYr2eFolchVUul4yEIfvb4TTUygkDXudlRrA8zZQauox5iidk923BJuVL65zITu
         Ea9jEp+H5UClA==
Received: by mail-lf1-f71.google.com with SMTP id t196-20020a19c3cd000000b0042a2598bebaso967206lff.2
        for <stable@vger.kernel.org>; Fri, 31 Dec 2021 08:20:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z5ioY/F3t7PzEeZt89hQh1G0ZQnghAHpzWba5N0rXNM=;
        b=ZBv7oguX3IlafThnrkTUJMiG/PiF7AiQvlIrA+VX30Hgi5RKHOmZbwF523GF8hmlPj
         tQJodvHV50Ul4yziVNSJe7CVl0DPwpiIK5MmGuDhjKGyIUOaSuIeAAFduC/LRejG0vj2
         vg3dSuTnxpbdLt23p4uKZjwD74TtmOocbREgD/alNGH3R1l4yU7ZuF6W1fAxxfqEPmFV
         1m8Ss9y+Fm/5gyNUOX+87M4y1FrwWwscSJlgfMfbOLhlonXU84DxNmppvAx7h8uuihnl
         7TmoXae4et8hLoDTU78jmNrgqoSAo8yyS7GOD+8f0s+4eBfOzOgV6Go/9n4A/MKysiX9
         CW4A==
X-Gm-Message-State: AOAM533qnhZ++K9AnxuEKOCZhYT95HEDNsmITieQxgnywNFvRMqlscP4
        Z0r23W3KnHZ8FU5ulEi1fJPZ9UGDzsJEpi4IWkR2czdn+04E8kFPqf0aX3KI6wybU06bD4FtUkS
        Zrz6v7LeVHAtMcjLcT+mdBHhhwDqQ9yXnkg==
X-Received: by 2002:a05:651c:a09:: with SMTP id k9mr9172159ljq.180.1640967615252;
        Fri, 31 Dec 2021 08:20:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzc+4kTYgqygG16URIJFVj2z6Z4ttRC0uwPhq5+1fKUZ9If5v0MZQV6COmgWUmppRWM7qDBog==
X-Received: by 2002:a05:651c:a09:: with SMTP id k9mr9172134ljq.180.1640967614996;
        Fri, 31 Dec 2021 08:20:14 -0800 (PST)
Received: from krzk-bin.lan (89-77-68-124.dynamic.chello.pl. [89.77.68.124])
        by smtp.gmail.com with ESMTPSA id bx10sm2817607ljb.3.2021.12.31.08.20.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Dec 2021 08:20:14 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Tomasz Figa <tomasz.figa@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        Chanho Park <chanho61.park@samsung.com>, stable@vger.kernel.org
Subject: [PATCH 01/24] pinctrl: samsung: drop pin banks references on error paths
Date:   Fri, 31 Dec 2021 17:19:07 +0100
Message-Id: <20211231161930.256733-2-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211231161930.256733-1-krzysztof.kozlowski@canonical.com>
References: <20211231161930.256733-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The driver iterates over its devicetree children with
for_each_child_of_node() and stores for later found node pointer.  This
has to be put in error paths to avoid leak during re-probing.

Fixes: ab663789d697 ("pinctrl: samsung: Match pin banks with their device nodes")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/pinctrl/samsung/pinctrl-samsung.c | 29 +++++++++++++++++------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/pinctrl/samsung/pinctrl-samsung.c b/drivers/pinctrl/samsung/pinctrl-samsung.c
index 8941f658e7f1..f2864a7869b3 100644
--- a/drivers/pinctrl/samsung/pinctrl-samsung.c
+++ b/drivers/pinctrl/samsung/pinctrl-samsung.c
@@ -1002,6 +1002,15 @@ samsung_pinctrl_get_soc_data_for_of_alias(struct platform_device *pdev)
 	return &(of_data->ctrl[id]);
 }
 
+static void samsung_banks_of_node_put(struct samsung_pinctrl_drv_data *d)
+{
+	struct samsung_pin_bank *bank;
+	unsigned int i;
+
+	for (i = 0; i < d->nr_banks; ++i, ++bank)
+		of_node_put(bank->of_node);
+}
+
 /* retrieve the soc specific data */
 static const struct samsung_pin_ctrl *
 samsung_pinctrl_get_soc_data(struct samsung_pinctrl_drv_data *d,
@@ -1116,19 +1125,19 @@ static int samsung_pinctrl_probe(struct platform_device *pdev)
 	if (ctrl->retention_data) {
 		drvdata->retention_ctrl = ctrl->retention_data->init(drvdata,
 							  ctrl->retention_data);
-		if (IS_ERR(drvdata->retention_ctrl))
-			return PTR_ERR(drvdata->retention_ctrl);
+		if (IS_ERR(drvdata->retention_ctrl)) {
+			ret = PTR_ERR(drvdata->retention_ctrl);
+			goto err_put_banks;
+		}
 	}
 
 	ret = samsung_pinctrl_register(pdev, drvdata);
 	if (ret)
-		return ret;
+		goto err_put_banks;
 
 	ret = samsung_gpiolib_register(pdev, drvdata);
-	if (ret) {
-		samsung_pinctrl_unregister(pdev, drvdata);
-		return ret;
-	}
+	if (ret)
+		goto err_unregister;
 
 	if (ctrl->eint_gpio_init)
 		ctrl->eint_gpio_init(drvdata);
@@ -1138,6 +1147,12 @@ static int samsung_pinctrl_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, drvdata);
 
 	return 0;
+
+err_unregister:
+	samsung_pinctrl_unregister(pdev, drvdata);
+err_put_banks:
+	samsung_banks_of_node_put(drvdata);
+	return ret;
 }
 
 /*
-- 
2.32.0

