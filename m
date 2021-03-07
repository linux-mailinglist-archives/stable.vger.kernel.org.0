Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 415F5330178
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 14:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbhCGNyQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 08:54:16 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:48349 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231562AbhCGNx4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 08:53:56 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 7A5951A76;
        Sun,  7 Mar 2021 08:53:55 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 07 Mar 2021 08:53:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=XEbl7T
        sdaIZwTzYIUN9A6sDCp3b+GsdmE0JH5QJRH+Y=; b=gCOHIsPvQAV3SYe3SZSq0r
        Fwlq8IYJong2zFABsgtUpl4jmMwvnRUH8TI+6Ucu/0yGC4G7tORtAG9r9ahvWcrS
        7z7ip20cRMxVea8YE+CGS6ByqTvOB2wPLupoAypcMr41EKzN4PkTRST6oE5pUTAE
        kP1w4jXXKOBMGsx27znL9OlKUfyr6qSRozuLl5HhPewgM9lxH838+ua8h2lliVqQ
        Vn/+HZAVXLAWsQvWyHDvK7BkSgxuUJBLbkXFfIAizjjiW0rUuVTrP5nMQPyKblQw
        HItPC6LZc9o8sAnCXarZ/nHy/sd09aAtmdGG+Y4TA33Joe1TSs0/vCIuJiDcg4Mg
        ==
X-ME-Sender: <xms:89pEYMFa54rYl4LffhOapCbrQ-sLgyuHpA-y5ronYdycN67eNwXlVg>
    <xme:89pEYFUm7U9Iq8fhGv6WtgbyLAAMqPdLlo6qoLglDOdjug27hFb6744eX6_ln05fR
    GHTqQ5E3UNeMg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddutddghedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeehnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:89pEYGIIJhyVDwVKjtO4hsO7vdVcZdcuKtDCrjm9sydqn7vt7D3uPA>
    <xmx:89pEYOEJ9SJ2eDqlYVMnuseAecAuLr8RvnbkSEzenbWm46Zx1NmueQ>
    <xmx:89pEYCUf5X7TJ67QSfC2rXRheiHPoewPH3Nf5T0HDHJFmy5oVtD-Pg>
    <xmx:89pEYFcQlfpAMpPb3ru2W9_OIipz711wQETiAH1baxwAFnGwHhIctIy6kG0>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id B94BA1080054;
        Sun,  7 Mar 2021 08:53:54 -0500 (EST)
Subject: FAILED: patch "[PATCH] iommu/amd: Fix sleeping in atomic in increase_address_space()" failed to apply to 4.9-stable tree
To:     arbn@yandex-team.com, jroedel@suse.de, stable@vger.kernel.org,
        will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 07 Mar 2021 14:53:45 +0100
Message-ID: <161512522533161@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 140456f994195b568ecd7fc2287a34eadffef3ca Mon Sep 17 00:00:00 2001
From: Andrey Ryabinin <arbn@yandex-team.com>
Date: Wed, 17 Feb 2021 17:30:04 +0300
Subject: [PATCH] iommu/amd: Fix sleeping in atomic in increase_address_space()

increase_address_space() calls get_zeroed_page(gfp) under spin_lock with
disabled interrupts. gfp flags passed to increase_address_space() may allow
sleeping, so it comes to this:

 BUG: sleeping function called from invalid context at mm/page_alloc.c:4342
 in_atomic(): 1, irqs_disabled(): 1, pid: 21555, name: epdcbbf1qnhbsd8

 Call Trace:
  dump_stack+0x66/0x8b
  ___might_sleep+0xec/0x110
  __alloc_pages_nodemask+0x104/0x300
  get_zeroed_page+0x15/0x40
  iommu_map_page+0xdd/0x3e0
  amd_iommu_map+0x50/0x70
  iommu_map+0x106/0x220
  vfio_iommu_type1_ioctl+0x76e/0x950 [vfio_iommu_type1]
  do_vfs_ioctl+0xa3/0x6f0
  ksys_ioctl+0x66/0x70
  __x64_sys_ioctl+0x16/0x20
  do_syscall_64+0x4e/0x100
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fix this by moving get_zeroed_page() out of spin_lock/unlock section.

Fixes: 754265bcab ("iommu/amd: Fix race in increase_address_space()")
Signed-off-by: Andrey Ryabinin <arbn@yandex-team.com>
Acked-by: Will Deacon <will@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210217143004.19165-1-arbn@yandex-team.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>

diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index 1c4961e05c12..bb0ee5c9fde7 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -182,6 +182,10 @@ static bool increase_address_space(struct protection_domain *domain,
 	bool ret = true;
 	u64 *pte;
 
+	pte = (void *)get_zeroed_page(gfp);
+	if (!pte)
+		return false;
+
 	spin_lock_irqsave(&domain->lock, flags);
 
 	if (address <= PM_LEVEL_SIZE(domain->iop.mode))
@@ -191,10 +195,6 @@ static bool increase_address_space(struct protection_domain *domain,
 	if (WARN_ON_ONCE(domain->iop.mode == PAGE_MODE_6_LEVEL))
 		goto out;
 
-	pte = (void *)get_zeroed_page(gfp);
-	if (!pte)
-		goto out;
-
 	*pte = PM_LEVEL_PDE(domain->iop.mode, iommu_virt_to_phys(domain->iop.root));
 
 	domain->iop.root  = pte;
@@ -208,10 +208,12 @@ static bool increase_address_space(struct protection_domain *domain,
 	 */
 	amd_iommu_domain_set_pgtable(domain, pte, domain->iop.mode);
 
+	pte = NULL;
 	ret = true;
 
 out:
 	spin_unlock_irqrestore(&domain->lock, flags);
+	free_page((unsigned long)pte);
 
 	return ret;
 }

