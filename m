Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D86E03C389A
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233544AbhGJXza (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:55:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:41100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233720AbhGJXyd (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:54:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 324F361057;
        Sat, 10 Jul 2021 23:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961087;
        bh=ltZ7vO6TGRJU0yf0niTNoGRE3EuoqsctVzx+HefZ7Do=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AQXbkkE3X0p3Vc49jaAIJo2IigfPV483QqSDj9aRBPJtIn6PU2RIAaUOyxwdKwFjt
         kI0t+3P+bovud/O97XkcqXXA3uTEiNcTVL0/eO7Zy5GaKVM7NOLhPz8TTmXCaTGj+M
         RV+1R1lKv5Zo5lG1drSqCliVuqOSu9BK0nieFETvvosB5aSsj52EjNhs1W+MVPY13b
         xUH+4TL43Z2BvNfllWM3cC0iWOOarSJmKn2QE2AHxrfujvVokTHQgN8ay5K8vxAbgN
         Ew37x3Vaj/n1BRPriz86vg8qsp7cm+H7yKN37lvWqKa81L/gF+610T7o93YERF2pxJ
         pqrX8XQcxWYvQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Vidya Sagar <vidyas@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-tegra@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 15/28] PCI: tegra: Add missing MODULE_DEVICE_TABLE
Date:   Sat, 10 Jul 2021 19:50:54 -0400
Message-Id: <20210710235107.3221840-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235107.3221840-1-sashal@kernel.org>
References: <20210710235107.3221840-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

