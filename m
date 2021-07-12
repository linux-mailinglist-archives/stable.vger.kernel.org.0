Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA77D3C44CE
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234264AbhGLGVe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:21:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:37428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233947AbhGLGUq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:20:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6738610A7;
        Mon, 12 Jul 2021 06:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070678;
        bh=2WtajsOj7fe07Yx5SkDoLC1ViN8fbEvcUM2RY0WTpk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qX/sJKS8m2hvWcDGB0yznGy++LZJyNQVaJw0sIu164UByLB8R/xvchgnnAkMvU1no
         fz/akWBBMdObYd0GoMgavc+DAS/ZwXVy013Kz0joZz41mNImdLsO5R5o7WW5U/XOU3
         uXQz8TxvqcnUK3hmlvs1prOCrDPLwB4pndR3Wjgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 093/348] mmc: sdhci-sprd: use sdhci_sprd_writew
Date:   Mon, 12 Jul 2021 08:07:57 +0200
Message-Id: <20210712060714.090081566@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
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
index 10705e5fa90e..a999d2089d3d 100644
--- a/drivers/mmc/host/sdhci-sprd.c
+++ b/drivers/mmc/host/sdhci-sprd.c
@@ -382,6 +382,7 @@ static unsigned int sdhci_sprd_get_ro(struct sdhci_host *host)
 static struct sdhci_ops sdhci_sprd_ops = {
 	.read_l = sdhci_sprd_readl,
 	.write_l = sdhci_sprd_writel,
+	.write_w = sdhci_sprd_writew,
 	.write_b = sdhci_sprd_writeb,
 	.set_clock = sdhci_sprd_set_clock,
 	.get_max_clock = sdhci_sprd_get_max_clock,
-- 
2.30.2



