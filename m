Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 960E94C1BEE
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 20:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244257AbiBWTQC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 14:16:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244227AbiBWTQB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 14:16:01 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A7D403F1
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 11:15:33 -0800 (PST)
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 2233D40A7F
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 19:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1645643730;
        bh=oRXS+YkCrSg6HXmKQBekF6bqmCpfytEa7gv0higjFpc=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=cJ2q0MKFJYtHPpFU5Job3H8lXZ6YISX7IgujwZJcGHQlqTMcAJekvpyV4ImFhLQPc
         1CTC+hpkZyc9qMDd772GexvnStBDEIlJN8zN7qc9StZS/BLIKNWHXKML+Z5zrrjUy2
         Ieob8AgPMi64bf78H8uiSFy9iC6ltyqq65p6RtakHvm4Xrs8UE5NP6NWIm2EfyLvI+
         SzFBrPzJf+/+pjvQf/bUDzGBq38wjAhfxvT4ORZp9ykJpBNNdHmOdO7y4XfpZ8/TRE
         vh8rn3TU/+9iREHdLBdWtmMbkcrBo7FSgriRL+s1C9Cnm23M6dD4PwPBOWaki/8rml
         KlsgSUcEdtNeQ==
Received: by mail-ej1-f72.google.com with SMTP id d7-20020a1709061f4700b006bbf73a7becso7481022ejk.17
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 11:15:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oRXS+YkCrSg6HXmKQBekF6bqmCpfytEa7gv0higjFpc=;
        b=M8SHXeYjfYZL0gGKxy7Ioq4SUONz2sRFJ4E1wTh4r7fxu9KPfMn9Jhka6/oUh98Fbm
         rRH7uvYSxFJ9hjKBzegJVo7Qxtj+LxPEiuj8AQpng68hSsVFTx2Be4eKtrpnCitM6dzj
         FXY82YuiUqeoUi/idRnLEv/Kc5LLj11SVIGVfrCuKzulKT1x3JJF9xvC8/kwIbjHQK+d
         dk4V82HfMjPdGuoUw/J7x2lfTKDCK5FLbi+5NrawGwKJ0XefBr7OaZce5gx/hDjO8zGN
         BZ9nLxRkWXjGSJhwfbiWVMN9fubzM4uotKvLPJUjowTlAGNbY8XQyp8dxgEwOSYM8vSs
         OkhA==
X-Gm-Message-State: AOAM533GcVJr2QiJosH3zvwvKBvQKAFQZeFRd1QA/PyA1gC7SBc4zzkv
        BXjbtEe5TKMBBrZ9AD2zQyKwqAjMBhUk1yMW0ceNY/VJ+jJWYY1PXPITX2MTildNay3LJjOkZdd
        0FHpCxjQx+7shUyhPPkDpvKFqQ9Y2dee1dQ==
X-Received: by 2002:a05:6402:3487:b0:40f:fa53:956c with SMTP id v7-20020a056402348700b0040ffa53956cmr894417edc.22.1645643729009;
        Wed, 23 Feb 2022 11:15:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx5CjazTLBKPiBmuMFKmO+Lmp6CQ3NgkMty7AAh8YmijE7P+oo2dQqmhFhNHN6v7AVbA25vYw==
X-Received: by 2002:a05:6402:3487:b0:40f:fa53:956c with SMTP id v7-20020a056402348700b0040ffa53956cmr894395edc.22.1645643728802;
        Wed, 23 Feb 2022 11:15:28 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-181-108.adslplus.ch. [188.155.181.108])
        by smtp.gmail.com with ESMTPSA id b3sm208368ejl.67.2022.02.23.11.15.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 11:15:28 -0800 (PST)
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
Subject: [PATCH v2 10/11] slimbus: qcom-ngd: fix kfree() of static memory on setting driver_override
Date:   Wed, 23 Feb 2022 20:14:40 +0100
Message-Id: <20220223191441.348109-4-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220223191310.347669-1-krzysztof.kozlowski@canonical.com>
References: <20220223191310.347669-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 drivers/slimbus/qcom-ngd-ctrl.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/slimbus/qcom-ngd-ctrl.c b/drivers/slimbus/qcom-ngd-ctrl.c
index 7040293c2ee8..e1a8de4d41fb 100644
--- a/drivers/slimbus/qcom-ngd-ctrl.c
+++ b/drivers/slimbus/qcom-ngd-ctrl.c
@@ -1434,6 +1434,7 @@ static int of_qcom_slim_ngd_register(struct device *parent,
 	const struct of_device_id *match;
 	struct device_node *node;
 	u32 id;
+	int ret;
 
 	match = of_match_node(qcom_slim_ngd_dt_match, parent->of_node);
 	data = match->data;
@@ -1455,7 +1456,16 @@ static int of_qcom_slim_ngd_register(struct device *parent,
 		}
 		ngd->id = id;
 		ngd->pdev->dev.parent = parent;
-		ngd->pdev->driver_override = QCOM_SLIM_NGD_DRV_NAME;
+
+		ret = driver_set_override(&ngd->pdev->dev,
+					  &ngd->pdev->driver_override,
+					  QCOM_SLIM_NGD_DRV_NAME);
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

