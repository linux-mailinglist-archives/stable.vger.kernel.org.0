Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 161983B6364
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbhF1O4s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:56:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:59412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235845AbhF1Owy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:52:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF71061D38;
        Mon, 28 Jun 2021 14:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891039;
        bh=lJ24d/MGhTh9IxIR9GnUmg82JD76yE9nm6V6CuJ950U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h22a7hLN3/q6dGawY0dmg/SOFXJKwzTEoge1Uwt0MwD0q0ebKk1uh/m12fkadNvEA
         7cSFTiXwakR1W6Q0MuP6VKKJGbYtqYV5lZ1ZxjUAxx5PIj40H2K8y98KwZ9HJEn6t8
         q9INLPVc0ltHBVEw1XXU0uhsD1ynB3CQw/lQSH2lDIBCUTB/VD0YzVKzpOcewwR8Zb
         H8woJdmKTXppAz2VmhVspxRHxAsbhI6kNz9z+bqpgO/GRuEELDJ3gNXQkSgnLhixyS
         N7sdQBSHINul9cnLbOAkOnfW7TLHyd80Q8hKm97sBjYDN8L30opCQnlqWcCclMDLqx
         WXsvPrSANHG9A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrew Morton <akpm@linux-foundation.org>, vannguye@cisco.com,
        Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 57/88] mm/slub.c: include swab.h
Date:   Mon, 28 Jun 2021 10:35:57 -0400
Message-Id: <20210628143628.33342-58-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143628.33342-1-sashal@kernel.org>
References: <20210628143628.33342-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.238-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.238-rc1
X-KernelTest-Deadline: 2021-06-30T14:36+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>

commit 1b3865d016815cbd69a1879ca1c8a8901fda1072 upstream.

Fixes build with CONFIG_SLAB_FREELIST_HARDENED=y.

Hopefully.  But it's the right thing to do anwyay.

Fixes: 1ad53d9fa3f61 ("slub: improve bit diffusion for freelist ptr obfuscation")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=213417
Reported-by: <vannguye@cisco.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slub.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/slub.c b/mm/slub.c
index a0cb3568b0b5..484a75296a12 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/bit_spinlock.h>
 #include <linux/interrupt.h>
+#include <linux/swab.h>
 #include <linux/bitops.h>
 #include <linux/slab.h>
 #include "slab.h"
-- 
2.30.2

