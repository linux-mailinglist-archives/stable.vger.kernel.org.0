Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9A7B1801EB
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 16:33:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgCJPdy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 11:33:54 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:38249 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbgCJPdy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 11:33:54 -0400
Received: by mail-lj1-f196.google.com with SMTP id w1so14648435ljh.5
        for <stable@vger.kernel.org>; Tue, 10 Mar 2020 08:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tQ91NJmSAV4APRs3KHb2zhKlTLEt52ygW4o1xrxv0Yc=;
        b=cGdazkWPAfKhtnRnEI2GJzFwuVajaBOS4BQ8hqRTuAgc81uzqNxFrUtq6heoNaKsSU
         OZWF59ABGCQQRm43Ezooj5qClm98b4lC2ETvbslgeg1zcRIOc1kNWoBa9yfyTCd2hDTH
         g7XZ7EGusHb2yPm3G2Etafv9bDdPlhF9oBgHUNy3s4ZUJINM88zPILHB7p8b/0UVKxmc
         IFspfNsRKQ8Agq6u/MYR+v+NA5Mak11gbH6sJsz2yh6pgaq8E7bcQ3eCzFnIaBXBvZjy
         hlzn9nd296Q6BaA2E20i1LCYf4xImX9mORB10ES0NGu3Fa5+zE4k/uCtDB7PsEWR4gPc
         SdIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tQ91NJmSAV4APRs3KHb2zhKlTLEt52ygW4o1xrxv0Yc=;
        b=jf0hG3+iZaqaOGoOHGC/T0KqcJ7YrKtJ2kFB4IJ+LNmNuwKu9kRpiIVUPHMDYU3CJg
         4y7NmIvEQibNaN5Lv3BAlFeV8zk0uiWDXfGKLRUm9g8reZHzCMoMKKx4ul8WV5PdLijf
         S2NaIB5OZROkJtIInJiNUngRiur6Myuy1cZpqxX86extXerrorGjGHuqxy8lgpByRVMN
         LCKlrIEQYE4Zbb5JCL9nqbctsl4zCYHIhqKPS0SZ+3i2m7hJOYLWERLB7axQgKmS683l
         o+WFxeAkA4pDU2fRSfrIdaK/afnvJjqnt2VxKX3dEtOa3JGQp9sc6BvKGavt7ytXdWOe
         kb0Q==
X-Gm-Message-State: ANhLgQ3Lxgsj9COUrK8ek6fH9R8bRNhRmN1NeOhU0T4RJDe/HsGsFPoZ
        Gw2tzBNmwhxR4V6669ajqHOe4A==
X-Google-Smtp-Source: ADFU+vsIvho5Opw/cggl/Q7zZCuGRhCYRY6r8tou4/ZEGVeYx3TZIfDapQeyl9aT5hVka/YBRvw9Jw==
X-Received: by 2002:a2e:a419:: with SMTP id p25mr3027492ljn.206.1583854432037;
        Tue, 10 Mar 2020 08:33:52 -0700 (PDT)
Received: from localhost.localdomain (h-158-174-22-210.NA.cust.bahnhof.se. [158.174.22.210])
        by smtp.gmail.com with ESMTPSA id c22sm17283776lfi.41.2020.03.10.08.33.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 08:33:51 -0700 (PDT)
From:   Ulf Hansson <ulf.hansson@linaro.org>
To:     linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ludovic Barre <ludovic.barre@st.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Chaotian Jing <chaotian.jing@mediatek.com>,
        Shawn Lin <shawn.lin@rock-chips.com>, mirq-linux@rere.qmqm.pl,
        Bitan Biswas <bbiswas@nvidia.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Faiz Abbas <faiz_abbas@ti.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Jon Hunter <jonathanh@nvidia.com>, stable@vger.kernel.org
Subject: [PATCH 3/4] mmc: sdhci-omap: Fix busy detection by enabling MMC_CAP_NEED_RSP_BUSY
Date:   Tue, 10 Mar 2020 16:33:39 +0100
Message-Id: <20200310153340.5593-4-ulf.hansson@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200310153340.5593-1-ulf.hansson@linaro.org>
References: <20200310153340.5593-1-ulf.hansson@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It has turned out that the sdhci-omap controller requires the R1B response,
for commands that has this response associated with them. So, converting
from an R1B to an R1 response for a CMD6 for example, leads to problems
with the HW busy detection support.

Fix this by informing the mmc core about the requirement, via setting the
host cap, MMC_CAP_NEED_RSP_BUSY.

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Reported-by: Anders Roxell <anders.roxell@linaro.org>
Reported-by: Faiz Abbas <faiz_abbas@ti.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/host/sdhci-omap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mmc/host/sdhci-omap.c b/drivers/mmc/host/sdhci-omap.c
index 882053151a47..c4978177ef88 100644
--- a/drivers/mmc/host/sdhci-omap.c
+++ b/drivers/mmc/host/sdhci-omap.c
@@ -1192,6 +1192,9 @@ static int sdhci_omap_probe(struct platform_device *pdev)
 	if (of_find_property(dev->of_node, "dmas", NULL))
 		sdhci_switch_external_dma(host, true);
 
+	/* R1B responses is required to properly manage HW busy detection. */
+	mmc->caps |= MMC_CAP_NEED_RSP_BUSY;
+
 	ret = sdhci_setup_host(host);
 	if (ret)
 		goto err_put_sync;
-- 
2.20.1

