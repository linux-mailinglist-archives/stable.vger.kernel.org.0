Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11E6F157ABE
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728585AbgBJMg7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:36:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:57580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728581AbgBJMg6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:36:58 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E46B720661;
        Mon, 10 Feb 2020 12:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338218;
        bh=H2c6hpcHaXEX8RbjLCaE5ksJqfVjCa4i3BpC92XnC5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TwmwGicDdveqTwCfH2g7eiFoS+1QlDDbQPsiUkAwfhn4L27CvE7Xf38ndPEOTYkWA
         nk2xzHkSTF17+YZ4IFx90ZhZJbSCCUkRWZWmWIEEaqXbjz8t+8V3kGa7n1mg7fc1Dg
         edQ6rNA2Em/JAxcQlUtA6PGluMZ8xBnNyiYMJVt4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        zhengbin <zhengbin13@huawei.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 050/309] mmc: sdhci-pci: Make function amd_sdhci_reset static
Date:   Mon, 10 Feb 2020 04:30:06 -0800
Message-Id: <20200210122410.803394396@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhengbin <zhengbin13@huawei.com>

commit 38413ce39a4bd908c02257cd2f9e0c92b27886f4 upstream.

Fix sparse warnings:

drivers/mmc/host/sdhci-pci-core.c:1599:6: warning: symbol 'amd_sdhci_reset' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-pci-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci-pci-core.c
+++ b/drivers/mmc/host/sdhci-pci-core.c
@@ -1604,7 +1604,7 @@ static u32 sdhci_read_present_state(stru
 	return sdhci_readl(host, SDHCI_PRESENT_STATE);
 }
 
-void amd_sdhci_reset(struct sdhci_host *host, u8 mask)
+static void amd_sdhci_reset(struct sdhci_host *host, u8 mask)
 {
 	struct sdhci_pci_slot *slot = sdhci_priv(host);
 	struct pci_dev *pdev = slot->chip->pdev;


