Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40B924D6F2E
	for <lists+stable@lfdr.de>; Sat, 12 Mar 2022 14:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231927AbiCLNbP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Mar 2022 08:31:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231931AbiCLNaq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Mar 2022 08:30:46 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A54512D0A8
        for <stable@vger.kernel.org>; Sat, 12 Mar 2022 05:29:33 -0800 (PST)
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id BDC2640930
        for <stable@vger.kernel.org>; Sat, 12 Mar 2022 13:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1647091771;
        bh=x+DOMuEjhXppqlmSDNC0RKdzUzslcBqDhsGS9OsoQS4=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=IAFJVygo5BVRIeG/gXWeSEJusRAmF9HENlOfdVynkWcWVZXtYKV18AoC+PkS2mj3h
         nO44c4/n67KKQyGKGNSeOZH3oLSHXI7lOzQpUYDTXD0r1r9mXW9X1bI95WAwqLSaB+
         3eMF4wgwaDHwMaQT8Du31JKZt5pTmsP7tQFPROnIJXdbZpq7VwhTxrWAoKkH4xkmQJ
         y2Y8Zj0EBcn7mqjbV8kt4xsFS5Frrihlz+TAR2HxYKpG8tvDq7Uyg7e8OzemC8WKti
         RUpyWUPJHF+FqNPNzlQEGXevsRArYg/Q2ZdfHui6bZodXKlsorW5+N9Bnnqgxczhe3
         sz0Rt5j/ouUrQ==
Received: by mail-wm1-f70.google.com with SMTP id n62-20020a1ca441000000b0038124c99ebcso3516218wme.9
        for <stable@vger.kernel.org>; Sat, 12 Mar 2022 05:29:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x+DOMuEjhXppqlmSDNC0RKdzUzslcBqDhsGS9OsoQS4=;
        b=ALXmmEaIGJF7UUx+sR9RBU+gEJw92RjSBK0OK6arOemLwzrIEcCm0Ek5Hxkce/1kOb
         +E6Es7yTFsRsHH+KRu4jJU/GCCguBugqPXhnnwhh95DyOgf1Sf3NQKNQA7xIkhoKMoLQ
         tpL9KEdhWZ0Xrc0TV0YzDyhZSspEbpDhqpLghlsxyGyKrjPcAltqFHYPpmKuHPrAdijz
         1fSd1R8ulkhMkFhEdG5obhlHYlIowCn3E/y5m67LsYOwheVmjmYOheJssmJt8ukNWCLN
         g1RN+7GdrZ6vojwcuR2E4lAdnaiWjF8rsUs25a2Ku/XX0Rb/xtJi9gKuTp+JIBDRLSiH
         GNIA==
X-Gm-Message-State: AOAM531bQ23pAfFWcasogoez517iLH0jfcPbyhv8+MGcNACAtPNLieU/
        8nxcZKahWVmqMrzIdMOPx/sGSlP+Sdmgjp9RkhrMSiQhJD0K8Vlo4+5GB2pmPMb5Figb641GI1I
        L2oBrHfMefBDtGcN41fj2irWmiRgedfHJxQ==
X-Received: by 2002:adf:f44d:0:b0:1f0:49bb:fead with SMTP id f13-20020adff44d000000b001f049bbfeadmr10583612wrp.586.1647091771130;
        Sat, 12 Mar 2022 05:29:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx5ufiLsjNXlLmSXpd1ewfKV/mq0TKGVtl9zvcWEFJmoAu7ZXtJo6A/7/mnNUpXOXLfNGXp5w==
X-Received: by 2002:adf:f44d:0:b0:1f0:49bb:fead with SMTP id f13-20020adff44d000000b001f049bbfeadmr10583570wrp.586.1647091770954;
        Sat, 12 Mar 2022 05:29:30 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-174-239.adslplus.ch. [188.155.174.239])
        by smtp.gmail.com with ESMTPSA id p22-20020a1c5456000000b00389e7e62800sm5751550wmi.8.2022.03.12.05.29.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Mar 2022 05:29:30 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Stuart Yoder <stuyoder@gmail.com>,
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
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        stable@vger.kernel.org
Subject: [PATCH v4 09/11] clk: imx: scu: Fix kfree() of static memory on setting driver_override
Date:   Sat, 12 Mar 2022 14:28:54 +0100
Message-Id: <20220312132856.65163-10-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220312132856.65163-1-krzysztof.kozlowski@canonical.com>
References: <20220312132856.65163-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Fixes: 77d8f3068c63 ("clk: imx: scu: add two cells binding support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/clk/imx/clk-scu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/imx/clk-scu.c b/drivers/clk/imx/clk-scu.c
index 083da31dc3ea..4b2268b7d0d0 100644
--- a/drivers/clk/imx/clk-scu.c
+++ b/drivers/clk/imx/clk-scu.c
@@ -683,7 +683,12 @@ struct clk_hw *imx_clk_scu_alloc_dev(const char *name,
 		return ERR_PTR(ret);
 	}
 
-	pdev->driver_override = "imx-scu-clk";
+	ret = driver_set_override(&pdev->dev, &pdev->driver_override,
+				  "imx-scu-clk", strlen("imx-scu-clk"));
+	if (ret) {
+		platform_device_put(pdev);
+		return ERR_PTR(ret);
+	}
 
 	ret = imx_clk_scu_attach_pd(&pdev->dev, rsrc_id);
 	if (ret)
-- 
2.32.0

