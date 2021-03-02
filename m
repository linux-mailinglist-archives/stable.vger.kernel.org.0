Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B314D32AF08
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbhCCAOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:14:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:40276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240378AbhCBL70 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 06:59:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B08EC64F1C;
        Tue,  2 Mar 2021 11:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686149;
        bh=7zx+vzbfje1Qh+19C+tUQH2oflZyQWKdmL2xzZgLihU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HWojzqWjr3jW5rQnP7hcu86bm0Oc7mj3xUWkaYC9pAKbH4tJK5wDYUd8CPBCPegNQ
         MWR+jwejHXTF0r1bm+GKC1PaLwQZosyld4iJ+58RWe1cNVTGuVibCnEQwURCbHbIxV
         kZd8aHZ1Zl3wC17+MgvCArZfDCyyXcECTHIgmQeyAFVAwllIPaYt8hYsEKgF1HmlD3
         8r/3ctPadiCwFpUESqZU7keDuwFSIXZ4PXFP/NKvJyvupADCMaxIwqbTyM+CtHR7qR
         3rmLK87f/wBab/n8nxJ9R/ERfUqY0nKlPQcS7GVW449gHUgfEpGu+L7PRJBExJcOcs
         PVty+GH/XUipQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 11/52] mmc: sdhci-of-dwcmshc: set SDHCI_QUIRK2_PRESET_VALUE_BROKEN
Date:   Tue,  2 Mar 2021 06:54:52 -0500
Message-Id: <20210302115534.61800-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115534.61800-1-sashal@kernel.org>
References: <20210302115534.61800-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jisheng Zhang <Jisheng.Zhang@synaptics.com>

[ Upstream commit 5f7dfda4f2cec580c135fd81d96a05006651c128 ]

The SDHCI_PRESET_FOR_* registers are not set(all read as zeros), so
set the quirk.

Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Link: https://lore.kernel.org/r/20201210165510.76b917e5@xhacker.debian
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-of-dwcmshc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/sdhci-of-dwcmshc.c b/drivers/mmc/host/sdhci-of-dwcmshc.c
index d90020ed3622..59d8d96ce206 100644
--- a/drivers/mmc/host/sdhci-of-dwcmshc.c
+++ b/drivers/mmc/host/sdhci-of-dwcmshc.c
@@ -112,6 +112,7 @@ static const struct sdhci_ops sdhci_dwcmshc_ops = {
 static const struct sdhci_pltfm_data sdhci_dwcmshc_pdata = {
 	.ops = &sdhci_dwcmshc_ops,
 	.quirks = SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN,
+	.quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN,
 };
 
 static int dwcmshc_probe(struct platform_device *pdev)
-- 
2.30.1

