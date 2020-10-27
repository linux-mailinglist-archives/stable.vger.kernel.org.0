Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74A4729BD55
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368863AbgJ0PmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:42:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:54804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1800523AbgJ0PgH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:36:07 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AD512225E;
        Tue, 27 Oct 2020 15:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812965;
        bh=4m0G9Rxk7uOd0oxncto8sVRYvtKm8kMXhZrGfmFjMqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IDZq7ng6yac8UqHBYHDAyJ9qegL0l5UoqB/m8W3lV3IgcYFgPYJfYTRVMIps0YN2U
         sgJaAd1OF9P7TjRVGAuTfrffw7oHgOvwe9Xr8D+m2gXfy4ggw3XPd5qPEHUFTylfaQ
         FCaUKzeW3jJfJCRMKyTJIzqDDnn8g+Px3fAl7BXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liao Pingfang <liao.pingfang@zte.com.cn>,
        Yi Wang <wang.yi59@zte.com.cn>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 392/757] mm/mmap.c: replace do_brk with do_brk_flags in comment of insert_vm_struct()
Date:   Tue, 27 Oct 2020 14:50:42 +0100
Message-Id: <20201027135508.942656738@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liao Pingfang <liao.pingfang@zte.com.cn>

[ Upstream commit 8332326e8e47fbc35711433419c31f610153dd58 ]

Replace do_brk with do_brk_flags in comment of insert_vm_struct(), since
do_brk was removed in following commit.

Fixes: bb177a732c4369 ("mm: do not bug_on on incorrect length in __mm_populate()")
Signed-off-by: Liao Pingfang <liao.pingfang@zte.com.cn>
Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Link: https://lkml.kernel.org/r/1600650778-43230-1-git-send-email-wang.yi59@zte.com.cn
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index bdd19f5b994e0..7a8987aa69962 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -3227,7 +3227,7 @@ int insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
 	 * By setting it to reflect the virtual start address of the
 	 * vma, merges and splits can happen in a seamless way, just
 	 * using the existing file pgoff checks and manipulations.
-	 * Similarly in do_mmap and in do_brk.
+	 * Similarly in do_mmap and in do_brk_flags.
 	 */
 	if (vma_is_anonymous(vma)) {
 		BUG_ON(vma->anon_vma);
-- 
2.25.1



