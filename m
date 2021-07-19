Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B01E43CE347
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236102AbhGSPhD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:37:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:57408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235781AbhGSPcl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:32:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CC5B6142B;
        Mon, 19 Jul 2021 16:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711043;
        bh=xrdCy1QqxZg1UrPMNmOK+vwd06oX25X0tMQaTm+IQzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kSkpH3C/SfZif3KkQvUCt/h96P4ZmECYVNSuJ6C3qp5SakwdgjdlSgRiQMznOiVGH
         AnrK7mlUtiC2Srlh0s96XbwhqZEjp9kO8OCIpQw+3aPg8QHRCBHQjwRBKbD0qX4yrJ
         scIQgHbOPfjPgWI8y48BL0cAhWiiP2Y5kX1m3CMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zou Wei <zou_wei@huawei.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 172/351] PCI: mediatek-gen3: Add missing MODULE_DEVICE_TABLE
Date:   Mon, 19 Jul 2021 16:51:58 +0200
Message-Id: <20210719144950.661970418@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit 3a2e476dc5d02af3422143b07d8db1eced475314 ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this driver when it is built
as an external module.

Link: https://lore.kernel.org/r/1620717091-108691-1-git-send-email-zou_wei@huawei.com
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Krzysztof Wilczyński <kw@linux.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-mediatek-gen3.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/controller/pcie-mediatek-gen3.c b/drivers/pci/controller/pcie-mediatek-gen3.c
index 3c5b97716d40..f3aeb8d4eaca 100644
--- a/drivers/pci/controller/pcie-mediatek-gen3.c
+++ b/drivers/pci/controller/pcie-mediatek-gen3.c
@@ -1012,6 +1012,7 @@ static const struct of_device_id mtk_pcie_of_match[] = {
 	{ .compatible = "mediatek,mt8192-pcie" },
 	{},
 };
+MODULE_DEVICE_TABLE(of, mtk_pcie_of_match);
 
 static struct platform_driver mtk_pcie_driver = {
 	.probe = mtk_pcie_probe,
-- 
2.30.2



