Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F40415BCBAD
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 14:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbiISMVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Sep 2022 08:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiISMVB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Sep 2022 08:21:01 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07A615A18
        for <stable@vger.kernel.org>; Mon, 19 Sep 2022 05:20:59 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id x29so1385770ljq.2
        for <stable@vger.kernel.org>; Mon, 19 Sep 2022 05:20:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=akAS+M555MDELlIlmpkVGxe1Ko+lvv67Qe46MFIs5R8=;
        b=rFI2tguDUwytQi2FpeVgljcxNVQj0L+/eVs8qHfX1/a02A5BbT1uiV2P0lUJL9ki2d
         rLFoZIhTOwQVtPB471K2MSYXWZ80g30wiw/9UimCZ4pVmsjdvqYB+3YcxVHhg+ULhLQ/
         VBKkzbvBn0Kl2MDsZuwEGg2mSxjGJ5JW8E7rg6O3YSQnOsbr51uoAkGO6OOp/dfZdfem
         iA0wvP0TPTAyq8acqHbygY/mJCxINniEc3EmT8c+NAD8K7hNRvSlxkfQGaomV2ox0g6l
         7VUFHet78Y7InqoGHEu+eDfkvh2MHWjEsQWXF+NCxrEo4u0tRNAkDAjMaZctdiGh8qh4
         67qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=akAS+M555MDELlIlmpkVGxe1Ko+lvv67Qe46MFIs5R8=;
        b=UgMZZckrX5nYr9JZRQTDG37HAem7inGFFsrOJJGzIVaml4O3AZ/741iyHj04/GTZI9
         /lFChsFxnJ7rz5/iIkiQZIoBl4+H/cXjPwxjMqtU/5f9sGvH/jzP3Y9h9XzvTZ++//bp
         ISx0L8CbqH69ZxdkQeHtTcvGrVPq/w84QClzzyPJmsTZuGITo6s77kPOncpeFieZpG/i
         QFcBEDLqparZF06Gp0aqovqg4WALxZzMq1sgEqqOYlRD3NjcuecqMJdgnKF8IlwRhGVs
         5AfB3sjt0O3cK4/8h5Elhn5sx/2VzVKmo6QPJXryUA1cjrWxptW5Kirb5gmI6GcvUh0C
         YLuA==
X-Gm-Message-State: ACrzQf0gBeBoqdpha5XXTJ8UMIrw/Gk+RHOD+5ALIU6zfFF7WjoxJy8Y
        +XFHMOdVD6KV+zOgUNWhfOud5A==
X-Google-Smtp-Source: AMsMyM635APqKv4krXUDzNMM2OajbAu7k05Oe88YZ2uTnaBwKN/OwdWZd0s90Iw76X5zESIsVU/k7g==
X-Received: by 2002:a05:651c:1503:b0:24c:81df:e1f2 with SMTP id e3-20020a05651c150300b0024c81dfe1f2mr4761445ljf.182.1663590058203;
        Mon, 19 Sep 2022 05:20:58 -0700 (PDT)
Received: from uffe-XPS13.. (h-94-254-63-18.NA.cust.bahnhof.se. [94.254.63.18])
        by smtp.gmail.com with ESMTPSA id be19-20020a056512251300b0049f53d53235sm2003950lfb.50.2022.09.19.05.20.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 05:20:57 -0700 (PDT)
From:   Ulf Hansson <ulf.hansson@linaro.org>
To:     Sudeep Holla <sudeep.holla@arm.com>,
        Cristian Marussi <cristian.marussi@arm.com>,
        linux-arm-kernel@lists.infradead.org
Cc:     Peng Fan <peng.fan@nxp.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Dien Pham <dien.pham.ry@renesas.com>,
        Gaku Inami <gaku.inami.xh@renesas.com>,
        Nicolas Pitre <npitre@baylibre.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] Revert "firmware: arm_scmi: Add clock management to the SCMI power domain"
Date:   Mon, 19 Sep 2022 14:20:33 +0200
Message-Id: <20220919122033.86126-1-ulf.hansson@linaro.org>
X-Mailer: git-send-email 2.34.1
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

This reverts commit a3b884cef873 ("firmware: arm_scmi: Add clock management
to the SCMI power domain").

Using the GENPD_FLAG_PM_CLK tells genpd to gate/ungate the consumer
device's clock(s) during runtime suspend/resume through the PM clock API.
More precisely, in genpd_runtime_resume() the clock(s) for the consumer
device would become ungated prior to the driver-level ->runtime_resume()
callbacks gets invoked.

This behaviour isn't a good fit for all platforms/drivers. For example, a
driver may need to make some preparations of its device in its
->runtime_resume() callback, like calling clk_set_rate() before the
clock(s) should be ungated. In these cases, it's easier to let the clock(s)
to be managed solely by the driver, rather than at the PM domain level.

For these reasons, let's drop the use GENPD_FLAG_PM_CLK for the SCMI PM
domain, as to enable it to be more easily adopted across ARM platforms.

Fixes: a3b884cef873 ("firmware: arm_scmi: Add clock management to the SCMI power domain")
Cc: Nicolas Pitre <npitre@baylibre.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---

To get some more background to $subject patch, please have a look at the
lore-link below.

https://lore.kernel.org/all/DU0PR04MB94173B45A2CFEE3BF1BD313A88409@DU0PR04MB9417.eurprd04.prod.outlook.com/

Kind regards
Ulf Hansson

---
 drivers/firmware/arm_scmi/scmi_pm_domain.c | 26 ----------------------
 1 file changed, 26 deletions(-)

diff --git a/drivers/firmware/arm_scmi/scmi_pm_domain.c b/drivers/firmware/arm_scmi/scmi_pm_domain.c
index 581d34c95769..d5dee625de78 100644
--- a/drivers/firmware/arm_scmi/scmi_pm_domain.c
+++ b/drivers/firmware/arm_scmi/scmi_pm_domain.c
@@ -8,7 +8,6 @@
 #include <linux/err.h>
 #include <linux/io.h>
 #include <linux/module.h>
-#include <linux/pm_clock.h>
 #include <linux/pm_domain.h>
 #include <linux/scmi_protocol.h>
 
@@ -53,27 +52,6 @@ static int scmi_pd_power_off(struct generic_pm_domain *domain)
 	return scmi_pd_power(domain, false);
 }
 
-static int scmi_pd_attach_dev(struct generic_pm_domain *pd, struct device *dev)
-{
-	int ret;
-
-	ret = pm_clk_create(dev);
-	if (ret)
-		return ret;
-
-	ret = of_pm_clk_add_clks(dev);
-	if (ret >= 0)
-		return 0;
-
-	pm_clk_destroy(dev);
-	return ret;
-}
-
-static void scmi_pd_detach_dev(struct generic_pm_domain *pd, struct device *dev)
-{
-	pm_clk_destroy(dev);
-}
-
 static int scmi_pm_domain_probe(struct scmi_device *sdev)
 {
 	int num_domains, i;
@@ -124,10 +102,6 @@ static int scmi_pm_domain_probe(struct scmi_device *sdev)
 		scmi_pd->genpd.name = scmi_pd->name;
 		scmi_pd->genpd.power_off = scmi_pd_power_off;
 		scmi_pd->genpd.power_on = scmi_pd_power_on;
-		scmi_pd->genpd.attach_dev = scmi_pd_attach_dev;
-		scmi_pd->genpd.detach_dev = scmi_pd_detach_dev;
-		scmi_pd->genpd.flags = GENPD_FLAG_PM_CLK |
-				       GENPD_FLAG_ACTIVE_WAKEUP;
 
 		pm_genpd_init(&scmi_pd->genpd, NULL,
 			      state == SCMI_POWER_STATE_GENERIC_OFF);
-- 
2.34.1

