Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4871A32AF84
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237933AbhCCAZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:25:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:46966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244772AbhCBMVD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:21:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 818E364F0D;
        Tue,  2 Mar 2021 11:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686321;
        bh=/8FUt7chgMpPTvXVhX3bHuY0NwLm6+bJfL2Iolt/3k8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JlZY2e3qYrpoS3hZa1hyOHFCNdoY1vw73xHoxdupUpmh7qXxVblKjYfHlCkgMQ8Ew
         Smq8ZzXaCyNzw6AM87EhoZETb4xQRbiwJAJodyV3BCYFLx08Lws42Mvyh0ANCQeazU
         wXlK/SbvtFIAS13V5nl+Xng3Sul1ynH1fqA2xmT2uuWR5UgRGFRdiAMr5wEsjT2Lge
         cjzoc7fx4AdADEChGxvpwg7xyUpQsnY9f/E+6eI0e/FdY6Y/WjS+Xx8w0+X3iix/wE
         /q5VVhR9y4zNKdbIxsXyrbt+cBc26f+eXqV/KrxB5cLr/7rbOT1GKG3iGGsib9yF9f
         c3tsvLaqUM1CQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 04/21] mmc: sdhci-of-dwcmshc: set SDHCI_QUIRK2_PRESET_VALUE_BROKEN
Date:   Tue,  2 Mar 2021 06:58:18 -0500
Message-Id: <20210302115835.63269-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115835.63269-1-sashal@kernel.org>
References: <20210302115835.63269-1-sashal@kernel.org>
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
index 1b7cd144fb01..a34b17b284a5 100644
--- a/drivers/mmc/host/sdhci-of-dwcmshc.c
+++ b/drivers/mmc/host/sdhci-of-dwcmshc.c
@@ -28,6 +28,7 @@ static const struct sdhci_ops sdhci_dwcmshc_ops = {
 static const struct sdhci_pltfm_data sdhci_dwcmshc_pdata = {
 	.ops = &sdhci_dwcmshc_ops,
 	.quirks = SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN,
+	.quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN,
 };
 
 static int dwcmshc_probe(struct platform_device *pdev)
-- 
2.30.1

