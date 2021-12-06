Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AEBF46A97C
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 22:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350641AbhLFVRw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 16:17:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350566AbhLFVRl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 16:17:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C34ECC061D7E;
        Mon,  6 Dec 2021 13:14:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8ED91B810D5;
        Mon,  6 Dec 2021 21:14:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56473C341C1;
        Mon,  6 Dec 2021 21:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638825249;
        bh=eDprUhMM8vftWzn2Cl89AMWfd58wb49TmTCNevGQdHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ppkAJr/ztAC5mto+EnWUlT+g+t8WWaheXGTem0GF7f6KyRbjsprj5IQ9chUFGcYxf
         e62GekpyPoQ+AB4ihtH3qQTx9knntaXkmHCEmSndXAgkeFpUNNQeH7b2FW481eoCHr
         iqdjVnkGIszsmiYSrI4AIg13J7/kDf96q1AlNvBnHeJUgrAtTfrmtiQVJtaqg5jtez
         JTZo9EZGUrLkL0Y/+9FI4erAun5asGVxcgu4zwAWTjo8DzOY2AKCzQ+afhJhzv8gut
         QjQ9GIz4UPkSfo7njE5FV4hMM/EygOV5NvSVUst1Do8+WKyL08M0ALukiMyZF+XshU
         pfi1Vz4/Ugavw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Helge Deller <deller@gmx.de>, kernel test robot <lkp@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        James.Bottomley@HansenPartnership.com, airlied@linux.ie,
        linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 14/24] parisc/agp: Annotate parisc agp init functions with __init
Date:   Mon,  6 Dec 2021 16:12:19 -0500
Message-Id: <20211206211230.1660072-14-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211206211230.1660072-1-sashal@kernel.org>
References: <20211206211230.1660072-1-sashal@kernel.org>
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

