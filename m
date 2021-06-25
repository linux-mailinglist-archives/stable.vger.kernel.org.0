Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09EE83B41E8
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 12:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbhFYKu6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Jun 2021 06:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231512AbhFYKu5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Jun 2021 06:50:57 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C65C061760
        for <stable@vger.kernel.org>; Fri, 25 Jun 2021 03:48:36 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id df12so12815565edb.2
        for <stable@vger.kernel.org>; Fri, 25 Jun 2021 03:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=monstr-eu.20150623.gappssmtp.com; s=20150623;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BzUOqw2gH4V8TdtIGcYxGonGtJVkiti92NxdBxij2EM=;
        b=zFDUHgK0b1U7i7MdkVNsz8yJC4c8ItZe+xAzZSfX/RelVfJLl255VU1V0SnVejrUqj
         mpWdPH+j1CkiIfB1m3QG+T2Z3mtmxpBidW0W0/x70KDdovD9FL7L4iaQHZ8g53do5B9+
         cQNFGy7Od3ug6ZTHnnG7Us+KnkhNoidyvML9ZendFma77hEu2TkuMhuth+0ohz0BpliE
         dspvDwhwIyLfr+Uhr6iVPGzuduC4zK+fH9/AdCHb08I8yD7zaa/1Va1SpwaVIB1cQtEO
         Q++1CojnFwemmcSTrc1WbokaA31ZJFUTKKCxJ5nSfk3TSQ3yexxbxv5kz9UVXij0mOF3
         aJCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=BzUOqw2gH4V8TdtIGcYxGonGtJVkiti92NxdBxij2EM=;
        b=IMtoXBow+5vweWBuLoDB4o4Lq+dklOSrgxUQD2cVfqr0bHc3AIVfGbkRX9Y3/xbj2b
         auxIcoJquS4Cp6n916Qmhi34kuHcRMQgDDMiJcSAxJi+stKSH31QHOpMNVXpFS4rM9wg
         rF+zipxgveo/cbQ4iIbbqoOxXcRGSQXKLJGQ8k20qkHYL6GZe7Etyf7JZEiirYn4kRGo
         ichlEBdmWvIH5Ox97/drZ+4ZjOpsC9gyuoUrz+PcV7c/6nGchIPvjMzJdxJVXhNmmh9j
         u0NWmnqDOuj6c0uK4jHUJf0rA7VD3R3mYvu02mKSkF85BTN4M7inroGzMJO7sAAQDKK+
         1Gjg==
X-Gm-Message-State: AOAM532wxUUCU4KC/DcTY+X0vR97x/KSCeGwF4ieC5JUu8qPe/5kVVFj
        z7cniNfw3QDegiFZVWWiwJR/IQ==
X-Google-Smtp-Source: ABdhPJzH2+0Vo1cyQWNm5G1yUtgYNu+PZorJGXLBHWCC4q79CwJKjfdrF3OJRkr93TOzq2W6B7rwfA==
X-Received: by 2002:aa7:da8a:: with SMTP id q10mr13318907eds.81.1624618114807;
        Fri, 25 Jun 2021 03:48:34 -0700 (PDT)
Received: from localhost ([2a02:768:2307:40d6::f9e])
        by smtp.gmail.com with ESMTPSA id ar14sm2471522ejc.108.2021.06.25.03.48.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 25 Jun 2021 03:48:34 -0700 (PDT)
Sender: Michal Simek <monstr@monstr.eu>
From:   Michal Simek <michal.simek@xilinx.com>
To:     linux-kernel@vger.kernel.org, monstr@monstr.eu,
        michal.simek@xilinx.com, git@xilinx.com,
        bharat.kumar.gogada@xilinx.com, kw@linux.com
Cc:     Hyun Kwon <hyun.kwon@xilinx.com>, stable@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Ravi Kiran Gummaluri <rgummal@xilinx.com>,
        Rob Herring <robh@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: [PATCH v3 2/2] PCI: xilinx-nwl: Enable the clock through CCF
Date:   Fri, 25 Jun 2021 12:48:23 +0200
Message-Id: <ee6997a08fab582b1c6de05f8be184f3fe8d5357.1624618100.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1624618100.git.michal.simek@xilinx.com>
References: <cover.1624618100.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hyun Kwon <hyun.kwon@xilinx.com>

Enable PCIe reference clock. There is no remove function that's why
this should be enough for simple operation.
Normally this clock is enabled by default by firmware but there are
usecases where this clock should be enabled by driver itself.
It is also good that PCIe clock is recorded in a clock framework.

Fixes: ab597d35ef11 ("PCI: xilinx-nwl: Add support for Xilinx NWL PCIe Host Controller")
Cc: stable@vger.kernel.org
Signed-off-by: Hyun Kwon <hyun.kwon@xilinx.com>
Signed-off-by: Bharat Kumar Gogada <bharat.kumar.gogada@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

Changes in v3:
- use PCIe instead of pcie
- add stable cc
- update commit message - reported by Krzysztof

Changes in v2:
- Update commit message - reported by Krzysztof
- Check return value from clk_prepare_enable() - reported by Krzysztof

 drivers/pci/controller/pcie-xilinx-nwl.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/pci/controller/pcie-xilinx-nwl.c b/drivers/pci/controller/pcie-xilinx-nwl.c
index 8689311c5ef6..1c3d5b87ef20 100644
--- a/drivers/pci/controller/pcie-xilinx-nwl.c
+++ b/drivers/pci/controller/pcie-xilinx-nwl.c
@@ -6,6 +6,7 @@
  * (C) Copyright 2014 - 2015, Xilinx, Inc.
  */
 
+#include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
@@ -169,6 +170,7 @@ struct nwl_pcie {
 	u8 last_busno;
 	struct nwl_msi msi;
 	struct irq_domain *legacy_irq_domain;
+	struct clk *clk;
 	raw_spinlock_t leg_mask_lock;
 };
 
@@ -823,6 +825,16 @@ static int nwl_pcie_probe(struct platform_device *pdev)
 		return err;
 	}
 
+	pcie->clk = devm_clk_get(dev, NULL);
+	if (IS_ERR(pcie->clk))
+		return PTR_ERR(pcie->clk);
+
+	err = clk_prepare_enable(pcie->clk);
+	if (err) {
+		dev_err(dev, "can't enable PCIe ref clock\n");
+		return err;
+	}
+
 	err = nwl_pcie_bridge_init(pcie);
 	if (err) {
 		dev_err(dev, "HW Initialization failed\n");
-- 
2.32.0

