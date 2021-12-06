Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F11346AA18
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 22:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351222AbhLFVX2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 16:23:28 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59086 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351208AbhLFVXY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 16:23:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0DADB8159B;
        Mon,  6 Dec 2021 21:19:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D9BC341C8;
        Mon,  6 Dec 2021 21:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638825593;
        bh=6QpwS/9Vb12Zo4I5wEAM8ZPeJpvINJqCzEKoMF6wWOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N1FDrM4M8VEGqGTa4b/pfAyfVFZA2VxE4ZsjsyJ9LbYZL9mpSd4UXqH3x72VKcA17
         pcTfuhiApErQ22AhIZseHvj7KMUESBacmBOF1uLC6kuB2YQ2DZUPCppvdHLKVhZzGL
         8hGC9cAtH/yjKtzyAygFXrpFT7IthX5mm7Gy+FgVnBdyG4HtuCAH99OwzgyRamKa9z
         fQcSFiKCBEX+NLJ20RvOB1yuD5PG2w6b7EjmKVzZ0n8GN8O8EwrbJvpthzK1sz1Plj
         RuJnkH25hNqybzi9oq2sZV9kbzh0Er1rc1ekYy7gqMj3AGIDG2uXbLa6BUTnQef70/
         QDCGcPIUEndoQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Helge Deller <deller@gmx.de>, kernel test robot <lkp@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        James.Bottomley@HansenPartnership.com, airlied@linux.ie,
        linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 4/7] parisc/agp: Annotate parisc agp init functions with __init
Date:   Mon,  6 Dec 2021 16:19:24 -0500
Message-Id: <20211206211934.1661294-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211206211934.1661294-1-sashal@kernel.org>
References: <20211206211934.1661294-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

[ Upstream commit 8d88382b7436551a9ebb78475c546b670790cbf6 ]

Signed-off-by: Helge Deller <deller@gmx.de>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/agp/parisc-agp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/char/agp/parisc-agp.c b/drivers/char/agp/parisc-agp.c
index 15f2e7025b78e..1d5510cb6db4e 100644
--- a/drivers/char/agp/parisc-agp.c
+++ b/drivers/char/agp/parisc-agp.c
@@ -285,7 +285,7 @@ agp_ioc_init(void __iomem *ioc_regs)
         return 0;
 }
 
-static int
+static int __init
 lba_find_capability(int cap)
 {
 	struct _parisc_agp_info *info = &parisc_agp_info;
@@ -370,7 +370,7 @@ parisc_agp_setup(void __iomem *ioc_hpa, void __iomem *lba_hpa)
 	return error;
 }
 
-static int
+static int __init
 find_quicksilver(struct device *dev, void *data)
 {
 	struct parisc_device **lba = data;
@@ -382,7 +382,7 @@ find_quicksilver(struct device *dev, void *data)
 	return 0;
 }
 
-static int
+static int __init
 parisc_agp_init(void)
 {
 	extern struct sba_device *sba_list;
-- 
2.33.0

