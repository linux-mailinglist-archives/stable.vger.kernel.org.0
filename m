Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6613C4CB3
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242704AbhGLHGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:06:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:40652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243903AbhGLHF6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:05:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4329B6120F;
        Mon, 12 Jul 2021 07:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073368;
        bh=nYZjtovbTvEXUjXwCxT6in8QL3EZuWYSvKmgcDiqPfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v+lfl8ORydP/s+IeHFmm/zqic5A6XSNxcftRdBUi53XnRjdxxMTMu7uLTNafphYPz
         WCyWvYkL1NACps1G39vbLwdg1l58g0R9OYrIAV9MShjllhjaAvuznhzaun8uLfh6/5
         WZvCkZejUX/FZIqTPLDd4ksMx94JComuIxTCEMTw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 166/700] mmc: sdhci-sprd: use sdhci_sprd_writew
Date:   Mon, 12 Jul 2021 08:04:09 +0200
Message-Id: <20210712060949.236146413@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

[ Upstream commit 961470820021e6f9d74db4837bd6831a1a30341b ]

The sdhci_sprd_writew() was defined by never used in sdhci_ops:

    drivers/mmc/host/sdhci-sprd.c:134:20: warning: unused function 'sdhci_sprd_writew'

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Link: https://lore.kernel.org/r/20210601095403.236007-2-krzysztof.kozlowski@canonical.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-sprd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/sdhci-sprd.c b/drivers/mmc/host/sdhci-sprd.c
index 5dc36efff47f..11e375579cfb 100644
--- a/drivers/mmc/host/sdhci-sprd.c
+++ b/drivers/mmc/host/sdhci-sprd.c
@@ -393,6 +393,7 @@ static void sdhci_sprd_request_done(struct sdhci_host *host,
 static struct sdhci_ops sdhci_sprd_ops = {
 	.read_l = sdhci_sprd_readl,
 	.write_l = sdhci_sprd_writel,
+	.write_w = sdhci_sprd_writew,
 	.write_b = sdhci_sprd_writeb,
 	.set_clock = sdhci_sprd_set_clock,
 	.get_max_clock = sdhci_sprd_get_max_clock,
-- 
2.30.2



