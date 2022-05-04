Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 991E951A994
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356611AbiEDRSR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356654AbiEDROC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:14:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD9653A7D
        for <stable@vger.kernel.org>; Wed,  4 May 2022 09:58:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5E3BB82737
        for <stable@vger.kernel.org>; Wed,  4 May 2022 16:58:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C05C385B0;
        Wed,  4 May 2022 16:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651683487;
        bh=oviVimujghxojquOvBrEvHJBUrPLnGcdKwTXQWw6Th8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=amJDGpwj7xj7PvmhZFZxcYumEdUIiuV36AygEixWg9O4/FLoqe5kb9+dsGOrTRicO
         mYabIlmTBgFH+7rHSGVNLU+QaX+m7p8zjvNAgqb/VHOw0Z9c7kZsGuCZIIbULVxgHh
         TeUI4PfIXtJAjA+npv98cbKE9Z2OQuBQXiHIyBd0C7KJh8UlAoLXYjU48Zsdys+2gA
         28o2iGCdPncKsrX0VwE1yqBk7ripllMI4ifXevU0gffZqmZWRbUl+nqJC+nEYI/R94
         1ajexZrBkdZQZD4VegzonPrj79eYdiLNRuhJZoDdKfqfkpTRNYaoeqJnb8xEaelARU
         L+59zi/ewmDkw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.15 05/30] PCI: aardvark: Comment actions in driver remove method
Date:   Wed,  4 May 2022 18:57:30 +0200
Message-Id: <20220504165755.30002-6-kabel@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504165755.30002-1-kabel@kernel.org>
References: <20220504165755.30002-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit a4ca7948e1d47275f8f3e5023243440c40561916 upstream.

Add two more comments into the advk_pcie_remove() method.

Link: https://lore.kernel.org/r/20211130172913.9727-6-kabel@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index 0d02ae8bb4a6..7432eeafc8fe 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -1681,11 +1681,13 @@ static int advk_pcie_remove(struct platform_device *pdev)
 	struct pci_host_bridge *bridge = pci_host_bridge_from_priv(pcie);
 	int i;
 
+	/* Remove PCI bus with all devices */
 	pci_lock_rescan_remove();
 	pci_stop_root_bus(bridge->bus);
 	pci_remove_root_bus(bridge->bus);
 	pci_unlock_rescan_remove();
 
+	/* Remove IRQ domains */
 	advk_pcie_remove_msi_irq_domain(pcie);
 	advk_pcie_remove_irq_domain(pcie);
 
-- 
2.35.1

