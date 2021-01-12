Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79F792F40BD
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 01:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393644AbhAMAnF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 19:43:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:46328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391989AbhALXua (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 18:50:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61F5723131;
        Tue, 12 Jan 2021 23:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610495375;
        bh=IQLpdJSqJTkSxzfWi+dXB1+DERUDSuH3taG7+PK6n3E=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=eWuiIHli0EO70cgQHU1ERd+t/UkAS++HuBaJm1rtrnypQivTdE9I0J5a1+MbcesRz
         9oNblxlMmP5caGO7wl0DNYG9A7m/h/ENbo0L1v9XNww/9/FNb3JPrdjq7XOHMbtHsK
         c5ivg+SrbGPeT5LD+7bRIRMMqv8XRW1r/vr1Xuok=
Date:   Tue, 12 Jan 2021 15:49:33 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, axboe@kernel.dk, hch@lst.de,
        linux-mm@kvack.org, me@kylehuey.com, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk
Subject:  [patch 10/10] mm/process_vm_access.c: include compat.h
Message-ID: <20210112234933.KYQegrK93%akpm@linux-foundation.org>
In-Reply-To: <20210112154839.abeb6e57de79480059fd9b0e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/process_vm_access.c: include compat.h

mm/process_vm_access.c:277:5: error: implicit declaration of function 'in_compat_syscall'; did you mean 'in_ia32_syscall'? [-Werror=implicit-function-declaration]

Fixes: 38dc5079da7081e "Fix compat regression in process_vm_rw()"
Reported-by: syzbot+5b0d0de84d6c65b8dd2b@syzkaller.appspotmail.com
Cc: Kyle Huey <me@kylehuey.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/process_vm_access.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/process_vm_access.c~mm-process_vm_accessc-include-compath
+++ a/mm/process_vm_access.c
@@ -9,6 +9,7 @@
 #include <linux/mm.h>
 #include <linux/uio.h>
 #include <linux/sched.h>
+#include <linux/compat.h>
 #include <linux/sched/mm.h>
 #include <linux/highmem.h>
 #include <linux/ptrace.h>
_
