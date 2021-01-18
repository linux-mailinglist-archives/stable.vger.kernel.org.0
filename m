Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF502F9E90
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 12:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390824AbhARLn3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 06:43:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:38328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390817AbhARLnP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:43:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 950CC22CA2;
        Mon, 18 Jan 2021 11:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970180;
        bh=UGPotwOSlOAFBfdp+QF5pYzteNoSZIVrouejYfN2oA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AQ4xrvnDOg/cI083X+6buqcGtQmCE7ZPOoOrGJbT3QSKiWWxgF8+5XeT9ZduxdzNg
         UybgaxAWiiGIpBTpI1K9AqByMDD+kStTDrCb/FAa8h5cXQKz8LNU3PNMcrYQEtdnvR
         10x7gf8UEJBj176jxkBbR6rXvn7+Qn+iNkTFkM9s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+5b0d0de84d6c65b8dd2b@syzkaller.appspotmail.com,
        Kyle Huey <me@kylehuey.com>, Jens Axboe <axboe@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 040/152] mm/process_vm_access.c: include compat.h
Date:   Mon, 18 Jan 2021 12:33:35 +0100
Message-Id: <20210118113354.705127325@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>

commit eb351d75ce1e75b4f793d609efac08426ca50acd upstream.

Fix the build error:

  mm/process_vm_access.c:277:5: error: implicit declaration of function 'in_compat_syscall'; did you mean 'in_ia32_syscall'? [-Werror=implicit-function-declaration]

Fixes: 38dc5079da7081e "Fix compat regression in process_vm_rw()"
Reported-by: syzbot+5b0d0de84d6c65b8dd2b@syzkaller.appspotmail.com
Cc: Kyle Huey <me@kylehuey.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/process_vm_access.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/process_vm_access.c
+++ b/mm/process_vm_access.c
@@ -9,6 +9,7 @@
 #include <linux/mm.h>
 #include <linux/uio.h>
 #include <linux/sched.h>
+#include <linux/compat.h>
 #include <linux/sched/mm.h>
 #include <linux/highmem.h>
 #include <linux/ptrace.h>


