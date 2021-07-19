Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0667A3CDF90
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345541AbhGSPKq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:10:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:39718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345537AbhGSPJ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:09:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AC8A60FE7;
        Mon, 19 Jul 2021 15:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709751;
        bh=ltZ7vO6TGRJU0yf0niTNoGRE3EuoqsctVzx+HefZ7Do=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1ZVxJgBo2elZ3em8u7Z91IZlU+K3gfmEbhKsclFZKnAYvA+U5PzhIh8urG2RNsIDq
         TxZ8hT47Oq9dK8x5QZ+f8JLqdtqGHBZNZ95pPu1syhZCB7zp74BMn1kEYlrDddzXOH
         p4E1TD4zSkoANSTxmLWAMIuc9Nw5eJ9+nveDMuTE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zou Wei <zou_wei@huawei.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Vidya Sagar <vidyas@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 083/149] PCI: tegra: Add missing MODULE_DEVICE_TABLE
Date:   Mon, 19 Jul 2021 16:53:11 +0200
Message-Id: <20210719144920.998602961@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144901.370365147@linuxfoundation.org>
References: <20210719144901.370365147@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit 7bf475a4614a9722b9b989e53184a02596cf16d1 ]

Add missing MODULE_DEVICE_TABLE definition so we generate correct modalias
for automatic loading of this driver when it is built as a module.

Link: https://lore.kernel.org/r/1620792422-16535-1-git-send-email-zou_wei@huawei.com
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Vidya Sagar <vidyas@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-tegra.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/controller/pci-tegra.c b/drivers/pci/controller/pci-tegra.c
index cfa3c83d6cc7..99d505a85067 100644
--- a/drivers/pci/controller/pci-tegra.c
+++ b/drivers/pci/controller/pci-tegra.c
@@ -2613,6 +2613,7 @@ static const struct of_device_id tegra_pcie_of_match[] = {
 	{ .compatible = "nvidia,tegra20-pcie", .data = &tegra20_pcie },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, tegra_pcie_of_match);
 
 static void *tegra_pcie_ports_seq_start(struct seq_file *s, loff_t *pos)
 {
-- 
2.30.2



