Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A89CD46AA44
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 22:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351502AbhLFVYQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 16:24:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350903AbhLFVYL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 16:24:11 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D01FC0698C6;
        Mon,  6 Dec 2021 13:20:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B9B4ACE1846;
        Mon,  6 Dec 2021 21:20:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBCB6C341C1;
        Mon,  6 Dec 2021 21:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638825638;
        bh=6QpwS/9Vb12Zo4I5wEAM8ZPeJpvINJqCzEKoMF6wWOM=;
        h=From:To:Cc:Subject:Date:From;
        b=HoXi/NOril+9F7K/md0z09gHkbgDiRDeYXo/Y4YgR5UAnhVPAnzEaoJVQdw9SEx/Y
         TYvWTaisvXQWC//m5iEDfKpR/f+jzEmy547hD9iNVeRXQ1I49Yzb20v7csHW4bWg9o
         2tAnDMkeZufFLe5RUzQDR568iauJlZq6t5YMoZwqErcTmGWjHTWP2E8R/DbWWkwte2
         2yXWPHhDDHUXRJk5bex+OixmaQ/oEDrq+6El5vJFyl8wXyphphR4Zapb0grq2NNyax
         3vfSSJbLEHa7Y7gPLKzQTrcOjVRKXDo4yqadUIzpo6CNazvNo0/l+9KaNHukzT591O
         zhuE1F20ZAGfA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Helge Deller <deller@gmx.de>, kernel test robot <lkp@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        James.Bottomley@HansenPartnership.com, airlied@linux.ie,
        linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 1/3] parisc/agp: Annotate parisc agp init functions with __init
Date:   Mon,  6 Dec 2021 16:20:32 -0500
Message-Id: <20211206212034.1661597-1-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
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

