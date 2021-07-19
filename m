Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0AD33CE53C
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346938AbhGSPsT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:48:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349286AbhGSPo5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:44:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B18261364;
        Mon, 19 Jul 2021 16:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711860;
        bh=7zuqEJtcX/xnHOsRzILBcADqTxEWzA2lE8i1F+mGGWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qTpXxcYVSWPqzA57SfXKZy8xFr/H/6O/3TqUFfdIIR7frJvf5XLjCQ4p3jjvhvs9G
         Mal6EZBglFCIc3Qmk8edgnW+jqlrpZVfzyLzytE8xwpChkjRvE+VcjfW0M+6sRsgvE
         7k/gbjRlvH21DDg2q7B6MkoXJTQuHVv0TCfXNtZo=
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
Subject: [PATCH 5.12 152/292] PCI: tegra: Add missing MODULE_DEVICE_TABLE
Date:   Mon, 19 Jul 2021 16:53:34 +0200
Message-Id: <20210719144947.487388664@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
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
index 8fcabed7c6a6..1a2af963599c 100644
--- a/drivers/pci/controller/pci-tegra.c
+++ b/drivers/pci/controller/pci-tegra.c
@@ -2506,6 +2506,7 @@ static const struct of_device_id tegra_pcie_of_match[] = {
 	{ .compatible = "nvidia,tegra20-pcie", .data = &tegra20_pcie },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, tegra_pcie_of_match);
 
 static void *tegra_pcie_ports_seq_start(struct seq_file *s, loff_t *pos)
 {
-- 
2.30.2



