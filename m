Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 182A146AA30
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 22:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351307AbhLFVX5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 16:23:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351217AbhLFVXq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 16:23:46 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E2FC0613F8;
        Mon,  6 Dec 2021 13:20:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1F6B4CE17E3;
        Mon,  6 Dec 2021 21:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA64C341CD;
        Mon,  6 Dec 2021 21:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638825613;
        bh=6QpwS/9Vb12Zo4I5wEAM8ZPeJpvINJqCzEKoMF6wWOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jCikGBGngNU/nb/0G2G+wAczfRAGBdySYZ5Q+CABlSVLK2614u8quv3Xv9LcpqppB
         0SCK+UKw0zSx9BQlTHqXSa6JVXjYATLvsZ4PSHvfkQdqP3vz+CIR3Qbj+TKVusbrFW
         UeRDPt/lHHul+X3Oklz0kHI10JjZnRMXiJPMVnn9LGSLil/aeWDWJtm00jbKOUgtJE
         CNHfaEK8B4536XJuqCVmKAoMM/w3aYDGODRUrLyhKe0bAVHebizgxVWnAL/xviVa2m
         ljCEepVRneouwmss4Ev+jBxB9UOGeB3fuj/ZaWm/FaupubBN/bpVzOGaFqs63ZX2cL
         5yWtpzokM7Gqw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Helge Deller <deller@gmx.de>, kernel test robot <lkp@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        James.Bottomley@HansenPartnership.com, airlied@linux.ie,
        linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 3/6] parisc/agp: Annotate parisc agp init functions with __init
Date:   Mon,  6 Dec 2021 16:19:59 -0500
Message-Id: <20211206212004.1661417-3-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211206212004.1661417-1-sashal@kernel.org>
References: <20211206212004.1661417-1-sashal@kernel.org>
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

