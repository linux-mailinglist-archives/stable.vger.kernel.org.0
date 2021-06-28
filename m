Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 280C83B629A
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233883AbhF1Osq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:48:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:51760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235648AbhF1Opf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:45:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DB1A61CCC;
        Mon, 28 Jun 2021 14:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890852;
        bh=HgYfWZ9kJM6XQ8bVvdegZbThS9lSP5yym/eSJcAD/7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sLNOGpf0F3BNW/GJ3C9xcRGfcny8//2UTCtOuWHjKmQJwxyOxFq2axUEqUnqHUurn
         ggJN4hkZWgcdsBKyY3RslslkOEwDZhtOEvEfmaYqN1MJfNuHShBR5eOYekM7heHChb
         PXmZEwhZt2KmGoc4bxUdUkm0862dcsTXhyHAXZz1JQ57NNkNrJUn8noHFDByCriXpt
         btcz6Jd0kN6+RlXh/QiEgLYzKrt44cG/Okd+egthU3PrXDkHYwC2B+EyFLIX5/Wh5M
         +OEsJNSEZSkrOmgnwDqFKLyJyDsypLp0kHzmzkFYR4x0rtZTwdITHL/mXOmg7vQkY3
         eYYE2xgg+njkg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrew Morton <akpm@linux-foundation.org>, vannguye@cisco.com,
        Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 074/109] mm/slub.c: include swab.h
Date:   Mon, 28 Jun 2021 10:32:30 -0400
Message-Id: <20210628143305.32978-75-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
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
index 11a2df00729e..b6c5c8fd265d 100644
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

