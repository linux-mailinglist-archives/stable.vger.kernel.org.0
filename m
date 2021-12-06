Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51B1346A9F8
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 22:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348585AbhLFVWO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 16:22:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236436AbhLFVWO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 16:22:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F3BC061746;
        Mon,  6 Dec 2021 13:18:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95EEEB81110;
        Mon,  6 Dec 2021 21:18:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDBA8C341C1;
        Mon,  6 Dec 2021 21:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638825522;
        bh=eDprUhMM8vftWzn2Cl89AMWfd58wb49TmTCNevGQdHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fnc7XRKxUmI3VHM5KHM588orLxLkHNiqeJU0h5rF42Nhjjxh17gRM/mEnnWnJwq8R
         GgVP0psK6TZnmS338jvCyxx+nuC4+lkSUTWolqWwTdMhGkLE2DRD5Fk6aA57ZM37Ip
         slDEVmFJMiS9V8LgSqfDgkUegAtIr6eaUEkD6LU/nfCCwE4MX1LhpQlq9HOAZQIu/0
         X+G4Fzl9YlE6PFFuYn6ut6PZ0zDYOj72gYRa26MoTJLE5vN90UmA5G1s5F7vJKXSbq
         cxYESOgWJr+eRkgl+ZrHd/KQQlC3qG6m9nH9W7N1EjXU24ixtA6QTa/Udjg3kftW6N
         t9F1KGLAfdp2w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Helge Deller <deller@gmx.de>, kernel test robot <lkp@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        James.Bottomley@HansenPartnership.com, airlied@linux.ie,
        linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 05/10] parisc/agp: Annotate parisc agp init functions with __init
Date:   Mon,  6 Dec 2021 16:17:24 -0500
Message-Id: <20211206211738.1661003-5-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211206211738.1661003-1-sashal@kernel.org>
References: <20211206211738.1661003-1-sashal@kernel.org>
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

