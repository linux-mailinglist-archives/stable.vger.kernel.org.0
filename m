Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D345362509F
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 03:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232931AbiKKChM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 21:37:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232904AbiKKCgk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 21:36:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004B317E17;
        Thu, 10 Nov 2022 18:35:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85DEBB822ED;
        Fri, 11 Nov 2022 02:35:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A30C433C1;
        Fri, 11 Nov 2022 02:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668134114;
        bh=N8NVJueAeboGeHke8tO0MN6mtyRozkODvCg+zb2WlE0=;
        h=From:To:Cc:Subject:Date:From;
        b=a/a6d0BrxlNRsdWrZjzX8qp391u3K4zgrZcbgl3WxboJlEL9bIx1EiboCmZXLV3xv
         xmKx9D1qQ4MWm5sxMAfGWxVCuKw/xb8q3fd7AmC/CczSrqdJ8vRtc6tB/Kg1wHPLWD
         Tki/fYGa0/Qlt/V27or056cUxve3+CMZuuZzcQSCxqYWSg1mY6KGyhYNC2x7H1UMYn
         lIYp4rDrfLtUTdQmfdQ3CFVHT2f8ww8QdME6/zePNIkNcpXE5xEQDufCc1OQB/JUqX
         adKBuo9U4WcPiK183bgqDNKJ8ICn/jwiKSMxjZ4Bbs8moBh/AJzD3VpWEOrX72uanN
         lINAQ6LDAFLjQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Margolin <mrgolin@amazon.com>,
        Firas Jahjah <firasj@amazon.com>,
        Yossi Leybovich <sleybo@amazon.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>, galpress@amazon.com,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 01/11] RDMA/efa: Add EFA 0xefa2 PCI ID
Date:   Thu, 10 Nov 2022 21:35:01 -0500
Message-Id: <20221111023511.227800-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
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
index 417dea5f90cf..d6d48db86681 100644
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

