Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 466C147AC08
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234197AbhLTOlD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:41:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234640AbhLTOjs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:39:48 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44ABBC0613A1;
        Mon, 20 Dec 2021 06:39:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9705DCE1112;
        Mon, 20 Dec 2021 14:39:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63B14C36AE8;
        Mon, 20 Dec 2021 14:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011184;
        bh=6QpwS/9Vb12Zo4I5wEAM8ZPeJpvINJqCzEKoMF6wWOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cKNK2j/ccu0zmR5Tb2rSLJIvx251x1V7DMgVAXUwm6b+J1sOv+ViBpY7urnIBNV5R
         19gOV0LuowQ1S4pbbclVj+2Pg4QvM6HZgOslEs27cqfno/eVuPQnSG8WQDjdqlaYkj
         G0MpKubvXUkWP1HFvw2XHLXQYrJNEMnO6PTtRQTo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>,
        kernel test robot <lkp@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 04/45] parisc/agp: Annotate parisc agp init functions with __init
Date:   Mon, 20 Dec 2021 15:33:59 +0100
Message-Id: <20211220143022.410463284@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143022.266532675@linuxfoundation.org>
References: <20211220143022.266532675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



