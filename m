Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2124C5BBF
	for <lists+stable@lfdr.de>; Sun, 27 Feb 2022 14:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbiB0Nyj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Feb 2022 08:54:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbiB0Nyb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Feb 2022 08:54:31 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409781BE8B
        for <stable@vger.kernel.org>; Sun, 27 Feb 2022 05:53:53 -0800 (PST)
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 1C38D40809
        for <stable@vger.kernel.org>; Sun, 27 Feb 2022 13:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1645970032;
        bh=Ittcal6Pd+WYY4FgdYnMj0oR0y7noG6anoPNpq8mwII=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=GE7ENpidT+a7WcTaerqO6+NejAupKyRUD6NJVuBPUKmwvhH+qT+x0aBL7kwJwpu85
         LHikue2wWI0pNLxJ7xSlsREm4hCq07EBflHXpUbR58+LnJuy8jTjr7lxlSXJ4tnfUS
         454tIgAEOAkmTQuU/SSl0HSULH2BflpTWbpj/n88wx6N7x1BGNKskf82+75FvD4X30
         +/oMPO4PCKaZrhmtpVPLYcB1QpbefL4sHJ9SdLgYmJz/02HQSoNYgo/nmrR29O+h4C
         Xj5vhV7m3SfcUggW9J8QAZB5pwXhv+Q53AduN7OPHx/nDWBLHw2BY1S5izELeITLyv
         Tu65i4wga6jag==
Received: by mail-wm1-f72.google.com with SMTP id q17-20020a1ca711000000b0037be98d03a1so4940466wme.0
        for <stable@vger.kernel.org>; Sun, 27 Feb 2022 05:53:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ittcal6Pd+WYY4FgdYnMj0oR0y7noG6anoPNpq8mwII=;
        b=HKoa6FgCoLGa7+q+lmcC1G8t4DMHqQ3XO+mPFPuabvcRZ5nSk+Xy7tfiP/yyOSp/wX
         LVpBJDUEYHkfXsRPr4oNJhvagibu2q2x2VAilnp15GK8yv1CoS1a7UJkeaEhfIAQxCLO
         tPBqVXLADlDK27YzdXXj9v8slKMwFaISGI9Xd0UwTJmyesgyT906chwYXSBcgOoS2HHO
         wwBiKlvRBGEZXVpmlv7PzXHJsIymPjVkDlUoJFGDKyxGsBS/2il4jtCMVS19l6/sQSt0
         J4jgeqceV4eQpJWhRcWXI1zs9MiXOu7t1rA6swlCB+49g6dDhLuL2+GAkY0y9PRzfxVV
         cLJA==
X-Gm-Message-State: AOAM5331UD1RDnOlMR0hd/QbJEb37XgdR/CjTJtWgLcW74C68ADIa1Rq
        O8tbEJQuZylFdeVsRYeNLp5cYlQX6ZtvmYca4VSuFlbVWaTif7XvjDxwTAHiDxGdpzIvLYXnnS3
        bll2Uwe9FA8R1H1Mm0b8okD6vNsg22DlsKw==
X-Received: by 2002:a05:6402:42c6:b0:412:8cbc:8f3d with SMTP id i6-20020a05640242c600b004128cbc8f3dmr15364976edc.310.1645970020960;
        Sun, 27 Feb 2022 05:53:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxGCAqzYcYv+6/2reZV+SOww6e12ONBNi9SinPyNgz1D+wg9pi5uHfXVkGat4zViryxXKoTAQ==
X-Received: by 2002:a05:6402:42c6:b0:412:8cbc:8f3d with SMTP id i6-20020a05640242c600b004128cbc8f3dmr15364941edc.310.1645970020805;
        Sun, 27 Feb 2022 05:53:40 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-181-108.adslplus.ch. [188.155.181.108])
        by smtp.gmail.com with ESMTPSA id w11-20020a056402128b00b00412ec3f5f74sm4600760edv.62.2022.02.27.05.53.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Feb 2022 05:53:40 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Abel Vesa <abel.vesa@nxp.com>, Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Andy Gross <agross@kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org, NXP Linux Team <linux-imx@nxp.com>,
        linux-arm-kernel@lists.infradead.org, linux-hyperv@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-spi@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        stable@vger.kernel.org
Subject: [PATCH v3 10/11] slimbus: qcom-ngd: Fix kfree() of static memory on setting driver_override
Date:   Sun, 27 Feb 2022 14:53:28 +0100
Message-Id: <20220227135329.145862-4-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220227135214.145599-1-krzysztof.kozlowski@canonical.com>
References: <20220227135214.145599-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The driver_override field from platform driver should not be initialized
from static memory (string literal) because the core later kfree() it,
for example when driver_override is set via sysfs.

Use dedicated helper to set driver_override properly.

Fixes: 917809e2280b ("slimbus: ngd: Add qcom SLIMBus NGD driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/slimbus/qcom-ngd-ctrl.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/slimbus/qcom-ngd-ctrl.c b/drivers/slimbus/qcom-ngd-ctrl.c
index 7040293c2ee8..e5d9fdb81eb0 100644
--- a/drivers/slimbus/qcom-ngd-ctrl.c
+++ b/drivers/slimbus/qcom-ngd-ctrl.c
@@ -1434,6 +1434,7 @@ static int of_qcom_slim_ngd_register(struct device *parent,
 	const struct of_device_id *match;
 	struct device_node *node;
 	u32 id;
+	int ret;
 
 	match = of_match_node(qcom_slim_ngd_dt_match, parent->of_node);
 	data = match->data;
@@ -1455,7 +1456,17 @@ static int of_qcom_slim_ngd_register(struct device *parent,
 		}
 		ngd->id = id;
 		ngd->pdev->dev.parent = parent;
-		ngd->pdev->driver_override = QCOM_SLIM_NGD_DRV_NAME;
+
+		ret = driver_set_override(&ngd->pdev->dev,
+					  &ngd->pdev->driver_override,
+					  QCOM_SLIM_NGD_DRV_NAME,
+					  strlen(QCOM_SLIM_NGD_DRV_NAME));
+		if (ret) {
+			platform_device_put(ngd->pdev);
+			kfree(ngd);
+			of_node_put(node);
+			return ret;
+		}
 		ngd->pdev->dev.of_node = node;
 		ctrl->ngd = ngd;
 
-- 
2.32.0

