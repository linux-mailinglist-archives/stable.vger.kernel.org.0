Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9361847ABA9
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:39:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234133AbhLTOiF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:38:05 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46822 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234141AbhLTOhn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:37:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3C2CB80EE1;
        Mon, 20 Dec 2021 14:37:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1728CC36AF8;
        Mon, 20 Dec 2021 14:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011061;
        bh=6QpwS/9Vb12Zo4I5wEAM8ZPeJpvINJqCzEKoMF6wWOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QebOVPCOR6G+7hJvAdsLBXL7iVG8/RFLClFwu/fP5BsBqTGatf5jClgZ/2dIwBxOA
         ROlFRLuSB7Vj2GGDA/AL9MWgqTbARugsllNkAmu3WWtGNKu6mHos5WPVxCj4oI3TcQ
         hjlDKjqP/jXfA0aqBzFkPNsLgzMdObD1887nFWlk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>,
        kernel test robot <lkp@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 03/31] parisc/agp: Annotate parisc agp init functions with __init
Date:   Mon, 20 Dec 2021 15:34:03 +0100
Message-Id: <20211220143020.095365778@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143019.974513085@linuxfoundation.org>
References: <20211220143019.974513085@linuxfoundation.org>
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



