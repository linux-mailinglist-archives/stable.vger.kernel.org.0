Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0563A216291
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 01:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbgGFXwQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jul 2020 19:52:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726805AbgGFXwP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Jul 2020 19:52:15 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 620E020672;
        Mon,  6 Jul 2020 23:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594079535;
        bh=sIQJYME5s4wegT4BJJOHUuDeQuxxZo/gSIxb55UbcsI=;
        h=Date:From:To:Subject:From;
        b=RPnp6lEGb54snSMxQfIfFVeYd7vPbFIuEqSjMnfWhwXkHSl2jswuOzF455JLUTkOF
         Yf04h/OQEZM03qIZjHD7SAZVv3QycDdY+dtabTis5FULFoYaVlCA5s9IUEy+lyJUAn
         p25TEF3SRD5XAdegkDXxwHN3M3Qkh4pjoJpAY924=
Date:   Mon, 06 Jul 2020 16:52:15 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, cgxu519@mykernel.net,
        mm-commits@vger.kernel.org, stable@vger.kernel.org
Subject:  [alternative-merged]
 mm-shmem-fix-freeing-new_attr-in-shmem_initxattrs.patch removed from -mm
 tree
Message-ID: <20200706235215.m_7BOmk4N%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/shmem: fix freeing new_attr in shmem_initxattrs()
has been removed from the -mm tree.  Its filename was
     mm-shmem-fix-freeing-new_attr-in-shmem_initxattrs.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Chengguang Xu <cgxu519@mykernel.net>
Subject: mm/shmem: fix freeing new_attr in shmem_initxattrs()

new_attr is allocated with kvmalloc() so should be freed
with kvfree().

Link: http://lkml.kernel.org/r/20200703065636.20897-1-cgxu519@mykernel.net
Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmem-fix-freeing-new_attr-in-shmem_initxattrs
+++ a/mm/shmem.c
@@ -3178,7 +3178,7 @@ static int shmem_initxattrs(struct inode
 		new_xattr->name = kmalloc(XATTR_SECURITY_PREFIX_LEN + len,
 					  GFP_KERNEL);
 		if (!new_xattr->name) {
-			kfree(new_xattr);
+			kvfree(new_xattr);
 			return -ENOMEM;
 		}
 
_

Patches currently in -mm which might be from cgxu519@mykernel.net are

vfs-xattr-mm-shmem-kernfs-release-simple-xattr-entry-in-a-right-way.patch

