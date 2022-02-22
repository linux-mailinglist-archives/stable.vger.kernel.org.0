Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 047974BF949
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 14:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbiBVN3J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 08:29:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232421AbiBVN3I (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 08:29:08 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A13939EF
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 05:28:43 -0800 (PST)
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 5A65740017
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 13:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1645536522;
        bh=bxf6nJLttPRsL7dBKXZgcCS/RsJRiJgMR1Ys1z/0BT0=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=inPGJiFGhpmqpC1lplrkZmDrG4enItXj5xARB4lc5cdaeYCynhjHV2uOwA8PmECTy
         +p18O+fob5cZLtKcwYR5rkT35eF76SFdv5eeC3b+0QpiJFGGJdva3uMcBpI5pzJXut
         XR3oQR1k3OsUZzL10usZUAPNg4IdlM9iVm3K5096lfFrrjknmUjOtHlBfD+61UtmC7
         qR5tY01GVdFkcVaF/GJtQmL3SkJH9gEjIRuyNSbWhdUuk0ZDNnuLfU1+2ni/BpR71i
         f5/y3xmggk2fVxa9ZfH0oDnj0i9qPemKf9NkxtOmUV9HAV4pXPe8k/oIMl6caNXTPO
         Kbn9U5mt2m0xg==
Received: by mail-ed1-f69.google.com with SMTP id b13-20020a056402278d00b0041311e02a9bso2774133ede.13
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 05:28:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bxf6nJLttPRsL7dBKXZgcCS/RsJRiJgMR1Ys1z/0BT0=;
        b=aPxb+lznTv3mbh/oFXVlqxUYWFutwM4OxVtKFCtXDh06s7vLEFaY1gSx3dPLvhYNnB
         u8RtyJdviIeFMDHCpJB82azczqNHgE/P8HUhqR0gS9Y7P4SLV0tjMFdp8dOD7pcMGX5Q
         3V8znYvulESJykdHmCW/WrHdCUxNazmptArok9I6J4jJc77mqs8hitBhgQOETEzNSidU
         0blVsjfFYVJY9D2E9F8HF/E4TltXRaFuFnHaBjAjVMgWWa2HsnUZiXlGQBwlq9uY35lX
         KrAoWBzZZp4rF6J5aZ3ttKaTJ/MrBwbOEokL7aG3DOMXiSwbeI2FW5aP3PJ6bChtHn++
         P5GQ==
X-Gm-Message-State: AOAM532tBxoo1QRvcirogMmclXoeEkjR4KnpSMUbiJZF0bUJeENlRnTw
        m9tYEMHtGKxE8QTzohbMUkn50PHKubk+rF6Hyuf2JkRR+eDjNdajt+8Y8qWRKlsRX22AO07FNwL
        rc5KbtuyHF92gc7WFqqZTurB/MnVebyt1EQ==
X-Received: by 2002:a17:906:a08b:b0:6cf:65bc:e7de with SMTP id q11-20020a170906a08b00b006cf65bce7demr19077975ejy.220.1645536521800;
        Tue, 22 Feb 2022 05:28:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwUTH4XEfwD3KKh1b8myIZr/sth4y54qNnWupnWL+QunNk7jf61nPg0M2zH6cCPLQ41ESwuWQ==
X-Received: by 2002:a17:906:a08b:b0:6cf:65bc:e7de with SMTP id q11-20020a170906a08b00b006cf65bce7demr19077951ejy.220.1645536521622;
        Tue, 22 Feb 2022 05:28:41 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-181-108.adslplus.ch. [188.155.181.108])
        by smtp.gmail.com with ESMTPSA id c5sm10029875edk.43.2022.02.22.05.28.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 05:28:41 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Abel Vesa <abel.vesa@nxp.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-clk@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, alsa-devel@alsa-project.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        stable@vger.kernel.org
Subject: [RFT PATCH 1/3] clk: imx: scu: fix kfree() of const memory on setting driver_override
Date:   Tue, 22 Feb 2022 14:27:05 +0100
Message-Id: <20220222132707.266883-2-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220222132707.266883-1-krzysztof.kozlowski@canonical.com>
References: <20220222132707.266883-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The driver_override field from platform driver should not be initialized
from const memory because the core later kfree() it, for example when
driver_override is set via sysfs.

Fixes: 77d8f3068c63 ("clk: imx: scu: add two cells binding support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/clk/imx/clk-scu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/imx/clk-scu.c b/drivers/clk/imx/clk-scu.c
index 083da31dc3ea..78ed40a0e3e2 100644
--- a/drivers/clk/imx/clk-scu.c
+++ b/drivers/clk/imx/clk-scu.c
@@ -683,7 +683,11 @@ struct clk_hw *imx_clk_scu_alloc_dev(const char *name,
 		return ERR_PTR(ret);
 	}
 
-	pdev->driver_override = "imx-scu-clk";
+	pdev->driver_override = kstrdup("imx-scu-clk", GFP_KERNEL);
+	if (!pdev->driver_override) {
+		platform_device_put(pdev);
+		return ERR_PTR(-ENOMEM);
+	}
 
 	ret = imx_clk_scu_attach_pd(&pdev->dev, rsrc_id);
 	if (ret)
-- 
2.32.0

