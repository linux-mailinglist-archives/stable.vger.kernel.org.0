Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 130F153E8A8
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241623AbiFFQK7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 12:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241624AbiFFQKx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 12:10:53 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 278F71A8834;
        Mon,  6 Jun 2022 09:10:41 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id n10so29915761ejk.5;
        Mon, 06 Jun 2022 09:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tSDJ73uf033Lt8Qb9E4/AaLuGXv/Rn17XR3DIaxY8rs=;
        b=mMc/wzdZUU4j81nV07i0onYl+1y4eXfdo6T2Ia2ulYbdq3rc0TaK5qTPFKoHm6eb1I
         YfKjpnOAZ/RYYKvhSBq207eWn5CJbbRpPKMu3zzjt0sassLcTxTl43c3ZDGhskjkfvql
         g1nPqRSPj9/gaPsanXlwuOkKg8+7+BGRXj9a3HbSRKAtuLz5N5IcXrujbW2BFXfxWaqC
         /uo39wXFkE1MrtBWmtjkiwAg9ITRDyTf215wB6//akZrHlicGbuzSfw8iVPVTPQdCQPB
         /M5Kz70GFA3kGdCxfo8k+pfxOxa2+/HCqlmz9Huj1mzn8TqM3qlSdtfQEZw0Lukf+OV5
         x89g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tSDJ73uf033Lt8Qb9E4/AaLuGXv/Rn17XR3DIaxY8rs=;
        b=Vyl0/63wiyH/7zo4x0jKoZ4o3tptGRjiZU/gWx8JY59QPBxv7Pj3Ntm0fyl7b7eFuD
         bXNfzrOhuDHCueB0U5ilWDLqQ8AYEmSBMkt1Hb43upWnLoQ2sHcPVu0g35FY+TZWenD2
         30OqtlXWV6x4k5oP7T39qSm/zCTCfz9r1ammwewWNHto0s4vjA+IdQOUTQ4+g9VKAFvh
         +2VYRHMu+O++8g6aC26dw+y4F7RbhSZtr23nIxJM/zNYhrs4LI/+lcDCHC7uM7APniyS
         URFzA8dBPd+ejg+6+KhBUfvQzSGvglSCyqGmY3uhPR2yR4lRr/ccARJVKfRo4PJRYO+H
         Jk9A==
X-Gm-Message-State: AOAM530fM3qMo6cLI+hJ/mZyKcv22uZrImGNbouQ+h9vUB2XwskNMIEK
        QDUwZuzBveE0UljPdJ2/y+k=
X-Google-Smtp-Source: ABdhPJx/yM5uc/IPOixT8zGExudH74lnyMZRR5UZYe4JrnLTsE8gTu44WVnkKvIFXchylVqtUEq+UA==
X-Received: by 2002:a17:907:7811:b0:6ef:a896:b407 with SMTP id la17-20020a170907781100b006efa896b407mr21506298ejc.645.1654531839448;
        Mon, 06 Jun 2022 09:10:39 -0700 (PDT)
Received: from morpheus.home.roving-it.com (3.e.2.0.0.0.0.0.0.0.0.0.0.0.0.0.1.8.6.2.1.1.b.f.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:fb11:2681::2e3])
        by smtp.googlemail.com with ESMTPSA id g22-20020aa7c596000000b0042deea0e961sm8698640edq.67.2022.06.06.09.10.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 09:10:38 -0700 (PDT)
From:   Peter Robinson <pbrobinson@gmail.com>
To:     Vinod Koul <vkoul@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Anson Huang <Anson.Huang@nxp.com>,
        Daniel Baluta <daniel.baluta@nxp.com>,
        Robin Gong <yibin.gong@nxp.com>,
        "Angus Ainslie (Purism)" <angus@akkea.ca>,
        dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Peter Robinson <pbrobinson@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] dmaengine: imx-sdma: Allow imx8m for imx7 FW revs
Date:   Mon,  6 Jun 2022 17:10:34 +0100
Message-Id: <20220606161034.3544803-1-pbrobinson@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The revision of the imx-sdma IP that is in the i.MX8M series is the
same is that as that in the i.MX7 series but the imx7d MODULE_FIRMWARE
directive is wrapped in a condiditional which means it's not defined
when built for aarch64 SOC_IMX8M platforms and hence you get the
following errors when the driver loads on imx8m devices:

imx-sdma 302c0000.dma-controller: Direct firmware load for imx/sdma/sdma-imx7d.bin failed with error -2
imx-sdma 302c0000.dma-controller: external firmware not found, using ROM firmware

Add the SOC_IMX8M into the check so the firmware can load on i.MX8.

Fixes: 1474d48bd639 ("arm64: dts: imx8mq: Add SDMA nodes")
Fixes: 941acd566b18 ("dmaengine: imx-sdma: Only check ratio on parts that support 1:1")
Signed-off-by: Peter Robinson <pbrobinson@gmail.com>
Cc: stable@vger.kernel.org   # v5.2+
---
 drivers/dma/imx-sdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index 8535018ee7a2..900cafdaf359 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -2346,7 +2346,7 @@ MODULE_DESCRIPTION("i.MX SDMA driver");
 #if IS_ENABLED(CONFIG_SOC_IMX6Q)
 MODULE_FIRMWARE("imx/sdma/sdma-imx6q.bin");
 #endif
-#if IS_ENABLED(CONFIG_SOC_IMX7D)
+#if IS_ENABLED(CONFIG_SOC_IMX7D) || IS_ENABLED(CONFIG_SOC_IMX8M)
 MODULE_FIRMWARE("imx/sdma/sdma-imx7d.bin");
 #endif
 MODULE_LICENSE("GPL");
-- 
2.36.1

