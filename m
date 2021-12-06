Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2213146A9C5
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 22:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347430AbhLFVUR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 16:20:17 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:48330 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350842AbhLFVUQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 16:20:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 250E3CE1626;
        Mon,  6 Dec 2021 21:16:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2579BC341C8;
        Mon,  6 Dec 2021 21:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638825404;
        bh=eDprUhMM8vftWzn2Cl89AMWfd58wb49TmTCNevGQdHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vBNoivAURwfvWyRcw6FmQJZWv0cum4yKm+MpwOyZ8bBG2WpyLRtELyM1IRZ4U1HVZ
         /45N75/lNZXaIkMKU6OpcRE8noat0wASHurgtpULg88vC+KMBnHG+fkkDLKhQ44lnM
         bolZZtY7+nbnATps7sPb2rWcLi5EYvj69AxZY1+cnXuBXpmofyiZJnSWa7z1J9DevH
         a2ibSx6/6meMquyjl4iLmnNRUtoaAwqzYiB3G8MVkxfURQ9SWr0Z4Im8WtUCLW9rr5
         sqx+CZINxKrTBBqTF1l4jIu27om4ap/IlBxlXcpK8KXL1kgSDJsxk1FM5Akhm+wEvZ
         W34RHPHeYoNCA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Helge Deller <deller@gmx.de>, kernel test robot <lkp@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        James.Bottomley@HansenPartnership.com, airlied@linux.ie,
        linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 10/15] parisc/agp: Annotate parisc agp init functions with __init
Date:   Mon,  6 Dec 2021 16:15:10 -0500
Message-Id: <20211206211520.1660478-10-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211206211520.1660478-1-sashal@kernel.org>
References: <20211206211520.1660478-1-sashal@kernel.org>
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
index ed3c4c42fc23b..d68d05d5d3838 100644
--- a/drivers/char/agp/parisc-agp.c
+++ b/drivers/char/agp/parisc-agp.c
@@ -281,7 +281,7 @@ agp_ioc_init(void __iomem *ioc_regs)
         return 0;
 }
 
-static int
+static int __init
 lba_find_capability(int cap)
 {
 	struct _parisc_agp_info *info = &parisc_agp_info;
@@ -366,7 +366,7 @@ parisc_agp_setup(void __iomem *ioc_hpa, void __iomem *lba_hpa)
 	return error;
 }
 
-static int
+static int __init
 find_quicksilver(struct device *dev, void *data)
 {
 	struct parisc_device **lba = data;
@@ -378,7 +378,7 @@ find_quicksilver(struct device *dev, void *data)
 	return 0;
 }
 
-static int
+static int __init
 parisc_agp_init(void)
 {
 	extern struct sba_device *sba_list;
-- 
2.33.0

