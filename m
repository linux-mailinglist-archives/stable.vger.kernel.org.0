Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AEF2304083
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 15:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391557AbhAZOhO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 09:37:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391535AbhAZJxR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 04:53:17 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE10C061573
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 01:52:36 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id s18so5634243ljg.7
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 01:52:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Xl+szrNKltw4M9EkOt6Ku8phtfpsNC6B9vqlONxx0g4=;
        b=ETXxVM2bLAeaCcj1UVibB+xzYWVDbEQPAGexw9B8RYRZue9PL7GzvgHmtFb1o0R7oT
         mtB24aVlehH1AnDLZ0B/etqmD5yLUoEPaK18N3RlZhzBOOhPcEtq1BNGhUvCiUigkyT0
         AWLbVzTPiW2ztrNE1OBGr3Zne1+sdlNWslLg5Pqxar6+9Cm5i4KqulWIwkRZRbKHHjKs
         0x2GoyFNCwbphjOh0pcyzy1GSqn3Q18kYPBzvvq4RJ/p2qIn/3x8DdbDsRod07Kh5kPQ
         +jHrsl4/rIh483QgCKofWC7ei83w4/JhFrmUbnl5RKwPFXF0oGeQvBdFBHpyLVt/zfe4
         wUBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Xl+szrNKltw4M9EkOt6Ku8phtfpsNC6B9vqlONxx0g4=;
        b=RRshHZI44ugeF2uQcam0TFHhEDnEflT6/OYQNWVt6r2XUT9snIaQ680XYk3S9mWAZh
         6xDSwkcXlGQczIXR8ybfwoQgoqXOsCcWLorSxgBHBYZz4Vs06r0f2e/pSgwhG01omt2S
         KMLYuHQ/7Rgz40JP4W+ini/jCxAcY4zQWPJ5FZXX17tqX3gYQoxVo/o7u+u5zprBCC5W
         z6gVYDJ2XawnbiV/g0qrS5tEtGXtUQIu51Ni2JJoPQ9gglDNjxTyR21AE3EugoT88Xhf
         TbqaeFWrcLjpPoG8yaP3fZwSg/wSnWxRDz0FHYh/l+JU4FbVQ1a1/EBMfJULjrmrem9J
         Zf/A==
X-Gm-Message-State: AOAM533WgptTn8oSG1OdVD73oThdexzdQbtg3WUOcVWapT7DffsW5cZ0
        3jR1c8mFwxOHNP9bu4styCJKZg==
X-Google-Smtp-Source: ABdhPJwe2hBaInwMyQJ6bm/S6REpkGRtWsL6YNFzyylZ3R0mgoyfmjcIrsAuAKVG67ByJ+1FBIUMlw==
X-Received: by 2002:a2e:81d1:: with SMTP id s17mr2447074ljg.49.1611654755466;
        Tue, 26 Jan 2021 01:52:35 -0800 (PST)
Received: from localhost.localdomain (h-98-128-180-179.NA.cust.bahnhof.se. [98.128.180.179])
        by smtp.gmail.com with ESMTPSA id x28sm2031841lfn.98.2021.01.26.01.52.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 01:52:34 -0800 (PST)
From:   Ulf Hansson <ulf.hansson@linaro.org>
To:     linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Nicolas Schichan <nschichan@freebox.fr>, stable@vger.kernel.org
Subject: [PATCH] mmc: sdhci-pltfm: Fix linking err for sdhci-brcmstb
Date:   Tue, 26 Jan 2021 10:52:30 +0100
Message-Id: <20210126095230.26580-1-ulf.hansson@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The implementation of sdhci_pltfm_suspend() is only available when
CONFIG_PM_SLEEP is set, which triggers a linking error:

"undefined symbol: sdhci_pltfm_suspend" when building sdhci-brcmstb.c.

Fix this by implementing the missing stubs when CONFIG_PM_SLEEP is unset.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
Cc: Nicolas Schichan <nschichan@freebox.fr>
Fixes: 5b191dcba719 ("mmc: sdhci-brcmstb: Fix mmc timeout errors on S5 suspend")
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/host/sdhci-pltfm.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-pltfm.h b/drivers/mmc/host/sdhci-pltfm.h
index 6301b81cf573..9bd717ff784b 100644
--- a/drivers/mmc/host/sdhci-pltfm.h
+++ b/drivers/mmc/host/sdhci-pltfm.h
@@ -111,8 +111,13 @@ static inline void *sdhci_pltfm_priv(struct sdhci_pltfm_host *host)
 	return host->private;
 }
 
+extern const struct dev_pm_ops sdhci_pltfm_pmops;
+#ifdef CONFIG_PM_SLEEP
 int sdhci_pltfm_suspend(struct device *dev);
 int sdhci_pltfm_resume(struct device *dev);
-extern const struct dev_pm_ops sdhci_pltfm_pmops;
+#else
+static inline int sdhci_pltfm_suspend(struct device *dev) { return 0; }
+static inline int sdhci_pltfm_resume(struct device *dev) { return 0; }
+#endif
 
 #endif /* _DRIVERS_MMC_SDHCI_PLTFM_H */
-- 
2.25.1

