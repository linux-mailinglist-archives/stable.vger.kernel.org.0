Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77D2C657B99
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233674AbiL1PX2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:23:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233619AbiL1PX1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:23:27 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786B91400A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:23:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C41D4CE1369
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:23:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB5FBC433EF;
        Wed, 28 Dec 2022 15:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241002;
        bh=H0vaa3FeoIgozeIa0nSo6BGTP4KJIvVwr5Garer8nj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K58CSHUH7cLDEi27QSPW3E0M1apE90YsYTRi70Zvm+QU4n0VwD58IXJUY/rfRIH7B
         YQjfYMoqI3nC9f7Kpu9hY5QOU+kh38btKE8nsDzWTkVIQQEuTrZ8oun0P9dSod0nQF
         G8bFBaYsFcWJT30eMrCRKWsNnzf6oWFWSIaq/eOs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Bjorn Helgaas <bhelgaas@google.com>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 426/731] PCI: mt7621: Rename mt7621_pci_ to mt7621_pcie_
Date:   Wed, 28 Dec 2022 15:38:53 +0100
Message-Id: <20221228144308.915972067@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit 4793895f597d42eb54a0f54711b61263b6a8dd03 ]

Rename mt7621_pci_* structs and functions to mt7621_pcie_* for consistency
with the rest of the file.

Link: https://lore.kernel.org/r/20211223011054.1227810-18-helgaas@kernel.org
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Stable-dep-of: 19098934f910 ("PCI: mt7621: Add sentinel to quirks table")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/mt7621-pci/pci-mt7621.c | 36 ++++++++++++-------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/mt7621-pci/pci-mt7621.c b/drivers/staging/mt7621-pci/pci-mt7621.c
index 6acfc94a16e7..c4f57bb63482 100644
--- a/drivers/staging/mt7621-pci/pci-mt7621.c
+++ b/drivers/staging/mt7621-pci/pci-mt7621.c
@@ -93,8 +93,8 @@ struct mt7621_pcie_port {
  * reset lines are inverted.
  */
 struct mt7621_pcie {
-	void __iomem *base;
 	struct device *dev;
+	void __iomem *base;
 	struct list_head ports;
 	bool resets_inverted;
 };
@@ -129,7 +129,7 @@ static inline void pcie_port_write(struct mt7621_pcie_port *port,
 	writel_relaxed(val, port->base + reg);
 }
 
-static inline u32 mt7621_pci_get_cfgaddr(unsigned int bus, unsigned int slot,
+static inline u32 mt7621_pcie_get_cfgaddr(unsigned int bus, unsigned int slot,
 					 unsigned int func, unsigned int where)
 {
 	return (((where & 0xF00) >> 8) << 24) | (bus << 16) | (slot << 11) |
@@ -140,7 +140,7 @@ static void __iomem *mt7621_pcie_map_bus(struct pci_bus *bus,
 					 unsigned int devfn, int where)
 {
 	struct mt7621_pcie *pcie = bus->sysdata;
-	u32 address = mt7621_pci_get_cfgaddr(bus->number, PCI_SLOT(devfn),
+	u32 address = mt7621_pcie_get_cfgaddr(bus->number, PCI_SLOT(devfn),
 					     PCI_FUNC(devfn), where);
 
 	writel_relaxed(address, pcie->base + RALINK_PCI_CONFIG_ADDR);
@@ -148,7 +148,7 @@ static void __iomem *mt7621_pcie_map_bus(struct pci_bus *bus,
 	return pcie->base + RALINK_PCI_CONFIG_DATA + (where & 3);
 }
 
-struct pci_ops mt7621_pci_ops = {
+struct pci_ops mt7621_pcie_ops = {
 	.map_bus	= mt7621_pcie_map_bus,
 	.read		= pci_generic_config_read,
 	.write		= pci_generic_config_write,
@@ -156,7 +156,7 @@ struct pci_ops mt7621_pci_ops = {
 
 static u32 read_config(struct mt7621_pcie *pcie, unsigned int dev, u32 reg)
 {
-	u32 address = mt7621_pci_get_cfgaddr(0, dev, 0, reg);
+	u32 address = mt7621_pcie_get_cfgaddr(0, dev, 0, reg);
 
 	pcie_write(pcie, address, RALINK_PCI_CONFIG_ADDR);
 	return pcie_read(pcie, RALINK_PCI_CONFIG_DATA);
@@ -165,7 +165,7 @@ static u32 read_config(struct mt7621_pcie *pcie, unsigned int dev, u32 reg)
 static void write_config(struct mt7621_pcie *pcie, unsigned int dev,
 			 u32 reg, u32 val)
 {
-	u32 address = mt7621_pci_get_cfgaddr(0, dev, 0, reg);
+	u32 address = mt7621_pcie_get_cfgaddr(0, dev, 0, reg);
 
 	pcie_write(pcie, address, RALINK_PCI_CONFIG_ADDR);
 	pcie_write(pcie, val, RALINK_PCI_CONFIG_DATA);
@@ -505,16 +505,16 @@ static int mt7621_pcie_register_host(struct pci_host_bridge *host)
 {
 	struct mt7621_pcie *pcie = pci_host_bridge_priv(host);
 
-	host->ops = &mt7621_pci_ops;
+	host->ops = &mt7621_pcie_ops;
 	host->sysdata = pcie;
 	return pci_host_probe(host);
 }
 
-static const struct soc_device_attribute mt7621_pci_quirks_match[] = {
+static const struct soc_device_attribute mt7621_pcie_quirks_match[] = {
 	{ .soc_id = "mt7621", .revision = "E2" }
 };
 
-static int mt7621_pci_probe(struct platform_device *pdev)
+static int mt7621_pcie_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	const struct soc_device_attribute *attr;
@@ -535,7 +535,7 @@ static int mt7621_pci_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, pcie);
 	INIT_LIST_HEAD(&pcie->ports);
 
-	attr = soc_device_match(mt7621_pci_quirks_match);
+	attr = soc_device_match(mt7621_pcie_quirks_match);
 	if (attr)
 		pcie->resets_inverted = true;
 
@@ -572,7 +572,7 @@ static int mt7621_pci_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int mt7621_pci_remove(struct platform_device *pdev)
+static int mt7621_pcie_remove(struct platform_device *pdev)
 {
 	struct mt7621_pcie *pcie = platform_get_drvdata(pdev);
 	struct mt7621_pcie_port *port;
@@ -583,18 +583,18 @@ static int mt7621_pci_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static const struct of_device_id mt7621_pci_ids[] = {
+static const struct of_device_id mt7621_pcie_ids[] = {
 	{ .compatible = "mediatek,mt7621-pci" },
 	{},
 };
-MODULE_DEVICE_TABLE(of, mt7621_pci_ids);
+MODULE_DEVICE_TABLE(of, mt7621_pcie_ids);
 
-static struct platform_driver mt7621_pci_driver = {
-	.probe = mt7621_pci_probe,
-	.remove = mt7621_pci_remove,
+static struct platform_driver mt7621_pcie_driver = {
+	.probe = mt7621_pcie_probe,
+	.remove = mt7621_pcie_remove,
 	.driver = {
 		.name = "mt7621-pci",
-		.of_match_table = of_match_ptr(mt7621_pci_ids),
+		.of_match_table = of_match_ptr(mt7621_pcie_ids),
 	},
 };
-builtin_platform_driver(mt7621_pci_driver);
+builtin_platform_driver(mt7621_pcie_driver);
-- 
2.35.1



