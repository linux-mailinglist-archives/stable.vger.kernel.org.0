Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8282B4F47C1
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 01:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233679AbiDEVUe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 17:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457237AbiDEQC6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 12:02:58 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3248F46
        for <stable@vger.kernel.org>; Tue,  5 Apr 2022 08:34:34 -0700 (PDT)
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 99A973F7FB
        for <stable@vger.kernel.org>; Tue,  5 Apr 2022 15:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1649172872;
        bh=N6jeGkQQKqHqg0+BgpyVPNX0anF5f6qlPZdRA4t1sTk=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=hg62Y6nL46Gc7EE7Sj8GdSirsKACLmtgIyV32FZJrCXjce0fX/WFRmxycqIzHGrGT
         LD0HMXIAE92bbVhXAVwIZuJwjKtZMzhYKqG6OnuoCbRKlElD4b29J0LeWTRA/Mog3T
         RMYE3xj/aP0j6oAuROcSq0dk8Ui1Q6CgRkkV2q+xISG5r6o5/ZBLm9jfAn8emeShWs
         6uA6MNy1blOoG5iyS4dGhnLPgkhEqnJUmD5PjZPhmlskrEGD2vacFyFdnVB2eds0Hf
         TLI3FX5aan9sAcB+StizEU57U0TBB111wUYkQEIWld6O+WPOZf0VhlU4nbD1uyn0aa
         DgXfWzmZCebNw==
Received: by mail-il1-f200.google.com with SMTP id a6-20020a056e02120600b002ca412e65a7so3848949ilq.0
        for <stable@vger.kernel.org>; Tue, 05 Apr 2022 08:34:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N6jeGkQQKqHqg0+BgpyVPNX0anF5f6qlPZdRA4t1sTk=;
        b=trNcEOIzkeAM+Nkx+n+ep5GQBN3WgHja9B+0BuT8cujqauaIWUXvCEZSj+i0r2ei5p
         MRSWjVMN/MYscSUxXJswQ6kPt7f6TD96nTr1V09SEdk+RHOl3n1CPeIvyjbUQWsjh4tW
         LzyKYMZCTHE38k1h+ZRo4ufsvX1lRrEUfAH5LD3wXk4sEsWbnNEQuq3X2P3SeNvMMA42
         iVdmpj/w9y+pN/AgNZlkb95JR9gmjZIWVjKbpuMW3RF6wCH4nvVgD/j7GCGdg1Dv+Bsr
         70jneXOXA8JEPBpsOTryLhogWIA5YaO3L3WgYaknqF1b/HkAzwsevIdFORHeyvOnxnH3
         toTg==
X-Gm-Message-State: AOAM530vYTkeIXk7xV99SwElrMS9GFbqgWfXYFlP1cbzy/LXTLmryvh6
        nXgW2xqwqfc3EyBAXaW4n7vq62kgr8EWN1GbXwoZ+LXAXWv286lQ1Q7Yy/LR5vXZcjGbV1Af+iC
        eqNA6yDo9Jq2qdlefcT22/9B8voiCyHLBbw==
X-Received: by 2002:a05:6638:388e:b0:321:57c3:f86 with SMTP id b14-20020a056638388e00b0032157c30f86mr2285635jav.255.1649172871148;
        Tue, 05 Apr 2022 08:34:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz64Tt7gTVGd157TuQ0Dp/PRTIis1PsUJDadh8JfXOs7ZJKoof01ngI6XflNQJAttcj0KPCBw==
X-Received: by 2002:a05:6638:388e:b0:321:57c3:f86 with SMTP id b14-20020a056638388e00b0032157c30f86mr2285612jav.255.1649172870886;
        Tue, 05 Apr 2022 08:34:30 -0700 (PDT)
Received: from localhost (c-73-14-97-161.hsd1.co.comcast.net. [73.14.97.161])
        by smtp.gmail.com with ESMTPSA id v18-20020a6b5b12000000b00645bd8bd288sm8742277ioh.47.2022.04.05.08.34.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 08:34:29 -0700 (PDT)
From:   dann frazier <dann.frazier@canonical.com>
To:     Marc Zyngier <maz@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        stable@vger.kernel.org
Cc:     Rob Herring <robh@kernel.org>,
        Toan Le <toan@os.amperecomputing.com>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>
Subject: [PATCH v5.10] PCI: xgene: Revert "PCI: xgene: Use inbound resources for setup"
Date:   Tue,  5 Apr 2022 09:34:19 -0600
Message-Id: <20220405153419.1330755-1-dann.frazier@canonical.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit 1874b6d7ab1bdc900e8398026350313ac29caddb upstream.

Commit 6dce5aa59e0b ("PCI: xgene: Use inbound resources for setup")
killed PCIe on my XGene-1 box (a Mustang board). The machine itself
is still alive, but half of its storage (over NVMe) is gone, and the
NVMe driver just times out.

Note that this machine boots with a device tree provided by the
UEFI firmware (2016 vintage), which could well be non conformant
with the spec, hence the breakage.

With the patch reverted, the box boots 5.17-rc8 with flying colors.

Link: https://lore.kernel.org/all/Yf2wTLjmcRj+AbDv@xps13.dannf
Link: https://lore.kernel.org/r/20220321104843.949645-2-maz@kernel.org
Fixes: 6dce5aa59e0b ("PCI: xgene: Use inbound resources for setup")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: stable@vger.kernel.org
Cc: Rob Herring <robh@kernel.org>
Cc: Toan Le <toan@os.amperecomputing.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Krzysztof Wilczyński <kw@linux.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Stéphane Graber <stgraber@ubuntu.com>
Cc: dann frazier <dann.frazier@canonical.com>
[dannf: minor context adjustment]
Signed-off-by: dann frazier <dann.frazier@canonical.com>
---
 drivers/pci/controller/pci-xgene.c | 33 ++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/pci/controller/pci-xgene.c b/drivers/pci/controller/pci-xgene.c
index c33b385ac918e..e1c2daa50b498 100644
--- a/drivers/pci/controller/pci-xgene.c
+++ b/drivers/pci/controller/pci-xgene.c
@@ -481,28 +481,27 @@ static int xgene_pcie_select_ib_reg(u8 *ib_reg_mask, u64 size)
 }
 
 static void xgene_pcie_setup_ib_reg(struct xgene_pcie_port *port,
-				    struct resource_entry *entry,
-				    u8 *ib_reg_mask)
+				    struct of_pci_range *range, u8 *ib_reg_mask)
 {
 	void __iomem *cfg_base = port->cfg_base;
 	struct device *dev = port->dev;
 	void *bar_addr;
 	u32 pim_reg;
-	u64 cpu_addr = entry->res->start;
-	u64 pci_addr = cpu_addr - entry->offset;
-	u64 size = resource_size(entry->res);
+	u64 cpu_addr = range->cpu_addr;
+	u64 pci_addr = range->pci_addr;
+	u64 size = range->size;
 	u64 mask = ~(size - 1) | EN_REG;
 	u32 flags = PCI_BASE_ADDRESS_MEM_TYPE_64;
 	u32 bar_low;
 	int region;
 
-	region = xgene_pcie_select_ib_reg(ib_reg_mask, size);
+	region = xgene_pcie_select_ib_reg(ib_reg_mask, range->size);
 	if (region < 0) {
 		dev_warn(dev, "invalid pcie dma-range config\n");
 		return;
 	}
 
-	if (entry->res->flags & IORESOURCE_PREFETCH)
+	if (range->flags & IORESOURCE_PREFETCH)
 		flags |= PCI_BASE_ADDRESS_MEM_PREFETCH;
 
 	bar_low = pcie_bar_low_val((u32)cpu_addr, flags);
@@ -533,13 +532,25 @@ static void xgene_pcie_setup_ib_reg(struct xgene_pcie_port *port,
 
 static int xgene_pcie_parse_map_dma_ranges(struct xgene_pcie_port *port)
 {
-	struct pci_host_bridge *bridge = pci_host_bridge_from_priv(port);
-	struct resource_entry *entry;
+	struct device_node *np = port->node;
+	struct of_pci_range range;
+	struct of_pci_range_parser parser;
+	struct device *dev = port->dev;
 	u8 ib_reg_mask = 0;
 
-	resource_list_for_each_entry(entry, &bridge->dma_ranges)
-		xgene_pcie_setup_ib_reg(port, entry, &ib_reg_mask);
+	if (of_pci_dma_range_parser_init(&parser, np)) {
+		dev_err(dev, "missing dma-ranges property\n");
+		return -EINVAL;
+	}
+
+	/* Get the dma-ranges from DT */
+	for_each_of_pci_range(&parser, &range) {
+		u64 end = range.cpu_addr + range.size - 1;
 
+		dev_dbg(dev, "0x%08x 0x%016llx..0x%016llx -> 0x%016llx\n",
+			range.flags, range.cpu_addr, end, range.pci_addr);
+		xgene_pcie_setup_ib_reg(port, &range, &ib_reg_mask);
+	}
 	return 0;
 }
 
-- 
2.35.1

