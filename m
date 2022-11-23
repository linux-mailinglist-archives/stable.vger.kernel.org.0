Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60EDF63567D
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237766AbiKWJbG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:31:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237767AbiKWJat (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:30:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47FAABF53
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:29:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D915C61B3B
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:29:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15EAC433D6;
        Wed, 23 Nov 2022 09:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195751;
        bh=N8NVJueAeboGeHke8tO0MN6mtyRozkODvCg+zb2WlE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BWbLhj2PQY9uKiJkL05lPN8zGKUpWI6SHk6Fok4HJ1g/lh3/Qt6bCW0NeVpq9eTLo
         vbT8Hvv7u/OUi29qblF8Z1mlRAs1W20FGYCiewVAdqwOPQUNJLmR68V79hXdyhgs7D
         GMgPemc5BMCzI5+azGIbSCp0o+sukryj//JiiMDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Firas Jahjah <firasj@amazon.com>,
        Yossi Leybovich <sleybo@amazon.com>,
        Michael Margolin <mrgolin@amazon.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 022/181] RDMA/efa: Add EFA 0xefa2 PCI ID
Date:   Wed, 23 Nov 2022 09:49:45 +0100
Message-Id: <20221123084603.412010802@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
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



