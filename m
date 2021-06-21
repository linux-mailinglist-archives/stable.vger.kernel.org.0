Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A25C43AF0D9
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232757AbhFUQxb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:53:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:42846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231833AbhFUQv2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:51:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7195761474;
        Mon, 21 Jun 2021 16:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293326;
        bh=zbAT/kX5Ee7YMu5zr+rIkouwoULEylJPP58Uk+Fz4Zk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lVkJfVxmETWgh46PmJXV0M7hN0zJgA2M0PpSeBdXoOrkcDIQolBZ0sshEyVu88PuU
         H03jrPR70ZFczCJFWTExUnLtIyNfLMFMT6Fxu56mgE9NehZ+PC/hc6Pgh/A0AY5BJV
         KVOuu510cIXoanKcfc0HN77EwJyv670sA8Jvh8Ho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, vannguye@cisco.com,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.12 172/178] mm/slub.c: include swab.h
Date:   Mon, 21 Jun 2021 18:16:26 +0200
Message-Id: <20210621154928.601074735@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 mm/slub.c |    1 +
 1 file changed, 1 insertion(+)

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


