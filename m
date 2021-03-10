Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C25E1333DF3
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233249AbhCJNZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:25:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:46068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232913AbhCJNYl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:24:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B7DE64FFB;
        Wed, 10 Mar 2021 13:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382679;
        bh=03VvVo2hJ9Th1W4Ti2EDtJL0wv4GRIGT7NvTsAFW3W0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EmUDQnG1st0kQL9rXI3QxDQOMqxoCdx+Pws83bzLop9YPKK0/zY82f4xc3XuHfaCk
         xtOh6ngsoeHbgwuH2sGBgtpH6DDSlCcnMF40ZD/pl4fzOBFEOwXqUHWVEBEBtjQ9xR
         Wk44Sk1VpsstqxhKxUuDLq6gHoPHNdO6fiX6oyN8=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 25/36] mmc: sdhci-of-dwcmshc: set SDHCI_QUIRK2_PRESET_VALUE_BROKEN
Date:   Wed, 10 Mar 2021 14:23:38 +0100
Message-Id: <20210310132321.291582621@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132320.510840709@linuxfoundation.org>
References: <20210310132320.510840709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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



