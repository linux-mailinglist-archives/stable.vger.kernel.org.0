Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C110D62502E
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 03:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbiKKCdr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 21:33:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231559AbiKKCdq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 21:33:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BAD96446;
        Thu, 10 Nov 2022 18:33:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB58A61E87;
        Fri, 11 Nov 2022 02:33:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B00C43470;
        Fri, 11 Nov 2022 02:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668134025;
        bh=VNiKRABtIMeIUh7oCOs21KW8F8F7jkA01llco3JUimo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ourdeIO32FYE6REoiJNAP6nNPSgLTsppbZ9BZYzjsiu/PfbC5GMYSKkgmnBT5bTYT
         HG5aMdCKzr/SMTnhtjB2KueYiI71de/SR6uyE36Ud2Ys2PgE/nXd22+8+0lwKFSd1O
         wbxp7Gngae0SPsMoExXgCkwAIDHWRh7BkhUL8PnZw0JsQhhJlvm7CWl98PSxdhuxJd
         Cjpugkw6qlNW8zCbN/ZG72sh236xq7vJ4VWPsf2b99QRBRbxpvU/ncl7chUbe3qENG
         VWtozXPSqlrCYG14aEMCWhUKnjI/B9lyO5rLBSrml6fSi5mWAfa+CJnLdH6iLu1ysY
         GMQJCOKWyVfzg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Margolin <mrgolin@amazon.com>,
        Firas Jahjah <firasj@amazon.com>,
        Yossi Leybovich <sleybo@amazon.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>, galpress@amazon.com,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 02/30] RDMA/efa: Add EFA 0xefa2 PCI ID
Date:   Thu, 10 Nov 2022 21:33:10 -0500
Message-Id: <20221111023340.227279-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221111023340.227279-1-sashal@kernel.org>
References: <20221111023340.227279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Margolin <mrgolin@amazon.com>

[ Upstream commit b75927cff13e0b3b652a12da7eb9a012911799e8 ]

Add support for 0xefa2 devices.

Reviewed-by: Firas Jahjah <firasj@amazon.com>
Reviewed-by: Yossi Leybovich <sleybo@amazon.com>
Signed-off-by: Michael Margolin <mrgolin@amazon.com>
Link: https://lore.kernel.org/r/20221020151949.1768-1-mrgolin@amazon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/efa/efa_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/efa/efa_main.c b/drivers/infiniband/hw/efa/efa_main.c
index 94b94cca4870..15ee92081118 100644
--- a/drivers/infiniband/hw/efa/efa_main.c
+++ b/drivers/infiniband/hw/efa/efa_main.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
 /*
- * Copyright 2018-2021 Amazon.com, Inc. or its affiliates. All rights reserved.
+ * Copyright 2018-2022 Amazon.com, Inc. or its affiliates. All rights reserved.
  */
 
 #include <linux/module.h>
@@ -14,10 +14,12 @@
 
 #define PCI_DEV_ID_EFA0_VF 0xefa0
 #define PCI_DEV_ID_EFA1_VF 0xefa1
+#define PCI_DEV_ID_EFA2_VF 0xefa2
 
 static const struct pci_device_id efa_pci_tbl[] = {
 	{ PCI_VDEVICE(AMAZON, PCI_DEV_ID_EFA0_VF) },
 	{ PCI_VDEVICE(AMAZON, PCI_DEV_ID_EFA1_VF) },
+	{ PCI_VDEVICE(AMAZON, PCI_DEV_ID_EFA2_VF) },
 	{ }
 };
 
-- 
2.35.1

