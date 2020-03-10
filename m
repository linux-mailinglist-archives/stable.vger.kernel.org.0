Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E69F01801ED
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 16:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgCJPd4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 11:33:56 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:38256 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbgCJPd4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 11:33:56 -0400
Received: by mail-lj1-f193.google.com with SMTP id w1so14648606ljh.5
        for <stable@vger.kernel.org>; Tue, 10 Mar 2020 08:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zXfY+hm6nAyuD/AmdMy4F6zgsNBRxXYSqgTSrNob95Q=;
        b=evewDF+wTbM0lLqZStPAgQrySHKOjDHSrTd0D3LYXi3Hs1GFNSR2WKOt5NSBLo8RIp
         LxOIXvlUl3s7CuyOoTRhBAfyHxGwEtKkv0VIU1R7vqrvkTlLg9qrbqES+G6AwX0c89Gz
         A0dmrhmJ/vNNCaOjDh2a1J++41kzdyq0wzhbk/qe+/NGoCdog6ZJ9BhLi5F2vygH/2r8
         muK7CKqK/LHc8xNMcwbBlDDoC69aDJYHbJ9JJ0e5MO/szgUP5RsFkn/IrdTv2ZueelUS
         9vukUF7mTkIb2upmvxx/cqXFl6PlKA5UnMs25tKaAvlBRbydEx3XD0EfYAayl45jYRkO
         Qx5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zXfY+hm6nAyuD/AmdMy4F6zgsNBRxXYSqgTSrNob95Q=;
        b=EhxfcppQd8iKjVMkLghueEuE/1iglK5I4R6+fbW+OykT4GaSEGJbgaD+VBypFVMXdV
         DaTzufdwUUH7TdtJR1jSyrwuogawBJD/eqCinZAytvP8BBPSgJ6CI0icEKZBDoNg6dNL
         nt42U2ER55PF+Dzy7tDilHG/uisAnBwFizKP0uZyGycB0a5n+FeuDYkjVa+R4ljHAXPN
         ZDtYVO/c3a4VDlnjMbKYGCraJveqesH8ORnE6WOKTv2HQfdOtuuPntnCH3NYFPTBzgml
         t5Cbnv0KAEWuURGcXtDK/uod5kNpyUrk5d2e6O/N85SNPigjzdEkn3eqR4qg7JM9iKHS
         OhdA==
X-Gm-Message-State: ANhLgQ0ocb1ss1rfiONxafXHAZexG8LhXEKTO8Q6XuME12b7ibNmBxuX
        mb2+7aEbQAwhG1QxXLp0ia1nqw==
X-Google-Smtp-Source: ADFU+vu0tIjfpP50RQbzS8Z+nzh45tErRu3mPFdaEIEBUL9uWfO0Z5/yv52Cb1ks+dOCE2AuCLaiKA==
X-Received: by 2002:a2e:3608:: with SMTP id d8mr12867272lja.52.1583854434100;
        Tue, 10 Mar 2020 08:33:54 -0700 (PDT)
Received: from localhost.localdomain (h-158-174-22-210.NA.cust.bahnhof.se. [158.174.22.210])
        by smtp.gmail.com with ESMTPSA id c22sm17283776lfi.41.2020.03.10.08.33.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 08:33:53 -0700 (PDT)
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
Subject: [PATCH 4/4] mmc: sdhci-tegra: Fix busy detection by enabling MMC_CAP_NEED_RSP_BUSY
Date:   Tue, 10 Mar 2020 16:33:40 +0100
Message-Id: <20200310153340.5593-5-ulf.hansson@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200310153340.5593-1-ulf.hansson@linaro.org>
References: <20200310153340.5593-1-ulf.hansson@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It has turned out that the sdhci-tegra controller requires the R1B response,
for commands that has this response associated with them. So, converting
from an R1B to an R1 response for a CMD6 for example, leads to problems
with the HW busy detection support.

Fix this by informing the mmc core about the requirement, via setting the
host cap, MMC_CAP_NEED_RSP_BUSY.

Reported-by: Bitan Biswas <bbiswas@nvidia.com>
Reported-by: Peter Geis <pgwipeout@gmail.com>
Suggested-by: Sowjanya Komatineni <skomatineni@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/host/sdhci-tegra.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
index 403ac44a7378..a25c3a4d3f6c 100644
--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -1552,6 +1552,9 @@ static int sdhci_tegra_probe(struct platform_device *pdev)
 	if (tegra_host->soc_data->nvquirks & NVQUIRK_ENABLE_DDR50)
 		host->mmc->caps |= MMC_CAP_1_8V_DDR;
 
+	/* R1B responses is required to properly manage HW busy detection. */
+	host->mmc->caps |= MMC_CAP_NEED_RSP_BUSY;
+
 	tegra_sdhci_parse_dt(host);
 
 	tegra_host->power_gpio = devm_gpiod_get_optional(&pdev->dev, "power",
-- 
2.20.1

