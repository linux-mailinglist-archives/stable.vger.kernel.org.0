Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCEE278E2F
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 18:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729574AbgIYQUJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 12:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729383AbgIYQUH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 12:20:07 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A8DEC0613CE
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:07 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id e13so2680561pgk.6
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=HNZdcr/0v7L1U5VM5INM0PY4OF1ckS3zSaQjXDPbL+w=;
        b=FezkcosDc50r26emWpUhtfPd1l+oYxqoR5iUMk/Mk6yHWAHLKA4ioIwAM/Pe0V4Zex
         ZvzQrgRWkdJmo+KbTvQNRpJzTmCnl7u6A/VTOG0pHcplzm+4PuTJgJ7nZheYHvxQ67rP
         FrJwY46wjl3Tfu2qIhR1oYDDrcfYlMaIaPcjur0N6mEE/lojhXiMo+dsYtFYyeOd+/m9
         4A5HQ0DUNXIxxPRPeGZWTodVZ1zZGjoBS9JIbQgqx6XbwEUZCXiOMB5NdDngE3C7DiMp
         xK6aNg40E7EWEReFvUaiyrafuBj7EpluBNU7thqL2YoXT7rSVw2WZRTWo2eWGXQd47Sw
         Uirg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=HNZdcr/0v7L1U5VM5INM0PY4OF1ckS3zSaQjXDPbL+w=;
        b=K9CHK4d/ejRXs4FKU+JovY0eYY7IcTvbpxPvluC63wFxBb/6blXhTZrjFvHvVWynzn
         MVx3XX+hOSfytgEJbj0p2fBxnFBreNs7HPHJ8ogwnO+00IObYA0w7zg5DGFtCvt/IraO
         S6O0QFgNTcHNuJtDofOjCIvl4G6CqYBetItIoJC7FAwwq3yPhByLGgSZ6lCAFpWXrbE9
         tAPGQlnfzGUPH6VaDsJuShtMy2Yg0IOcWFYh2iPTDungI6J36PViLDYQclYs3Q5L+bNP
         CIjHJePiUMv05yHU2O0E+775iq2Z0U7h85feF3WCznYJmfpE1fzwFjq9/7eU+QFwSW8u
         T2xQ==
X-Gm-Message-State: AOAM533V/jL1OpCdWLu6mJEyRjS60ArjrYnBJeuy7EMHCi+MKS9MAuml
        S/lIVrOp8rVvsD8y22tPXEHdeW/HPxPBjU/AMpjjiKDhYKdJ2kjz8YXzni36/HGvniSPqCuQD3m
        jvDn04HGM2dX6xw02ekW5VAWUbPgkmfn6NUBs8HJIIkGYs6VKUfU1Z1R2770Hrw==
X-Google-Smtp-Source: ABdhPJxtr8iJry8Mf8unsAYGACC+4j9H0Ej41oelXy5ObZu7Oa1swNq2IFWodY7PRJ34ZSzK6x6IcclKabI=
Sender: "pgonda via sendgmr" <pgonda@pgonda1.kir.corp.google.com>
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:1101:f693:9fff:fef4:e3a2])
 (user=pgonda job=sendgmr) by 2002:aa7:8dc9:0:b029:150:e9ad:952 with SMTP id
 j9-20020aa78dc90000b0290150e9ad0952mr106411pfr.61.1601050806498; Fri, 25 Sep
 2020 09:20:06 -0700 (PDT)
Date:   Fri, 25 Sep 2020 09:18:55 -0700
In-Reply-To: <20200925161916.204667-1-pgonda@google.com>
Message-Id: <20200925161916.204667-10-pgonda@google.com>
Mime-Version: 1.0
References: <20200925161916.204667-1-pgonda@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH 09/30 for 5.4] dma-direct: atomic allocations must come from
 atomic coherent pools
From:   Peter Gonda <pgonda@google.com>
To:     stable@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        David Rientjes <rientjes@google.com>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Rientjes <rientjes@google.com>

upstream 76a19940bd62a81148c303f3df6d0cee9ae4b509 commit.

When a device requires unencrypted memory and the context does not allow
blocking, memory must be returned from the atomic coherent pools.

This avoids the remap when CONFIG_DMA_DIRECT_REMAP is not enabled and the
config only requires CONFIG_DMA_COHERENT_POOL.  This will be used for
CONFIG_AMD_MEM_ENCRYPT in a subsequent patch.

Keep all memory in these pools unencrypted.  When set_memory_decrypted()
fails, this prohibits the memory from being added.  If adding memory to
the genpool fails, and set_memory_encrypted() subsequently fails, there
is no alternative other than leaking the memory.

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 kernel/dma/direct.c | 46 ++++++++++++++++++++++++++++++++++++++-------
 kernel/dma/pool.c   | 27 +++++++++++++++++++++++---
 2 files changed, 63 insertions(+), 10 deletions(-)

diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 38266fb2797d..210ea469028c 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -90,6 +90,39 @@ static bool dma_coherent_ok(struct device *dev, phys_addr_t phys, size_t size)
 			min_not_zero(dev->coherent_dma_mask, dev->bus_dma_mask);
 }
 
+/*
+ * Decrypting memory is allowed to block, so if this device requires
+ * unencrypted memory it must come from atomic pools.
+ */
+static inline bool dma_should_alloc_from_pool(struct device *dev, gfp_t gfp,
+					      unsigned long attrs)
+{
+	if (!IS_ENABLED(CONFIG_DMA_COHERENT_POOL))
+		return false;
+	if (gfpflags_allow_blocking(gfp))
+		return false;
+	if (force_dma_unencrypted(dev))
+		return true;
+	if (!IS_ENABLED(CONFIG_DMA_DIRECT_REMAP))
+		return false;
+	if (dma_alloc_need_uncached(dev, attrs))
+		return true;
+	return false;
+}
+
+static inline bool dma_should_free_from_pool(struct device *dev,
+					     unsigned long attrs)
+{
+	if (IS_ENABLED(CONFIG_DMA_COHERENT_POOL))
+		return true;
+	if ((attrs & DMA_ATTR_NO_KERNEL_MAPPING) &&
+	    !force_dma_unencrypted(dev))
+		return false;
+	if (IS_ENABLED(CONFIG_DMA_DIRECT_REMAP))
+		return true;
+	return false;
+}
+
 struct page *__dma_direct_alloc_pages(struct device *dev, size_t size,
 		gfp_t gfp, unsigned long attrs)
 {
@@ -139,9 +172,7 @@ void *dma_direct_alloc_pages(struct device *dev, size_t size,
 	struct page *page;
 	void *ret;
 
-	if (IS_ENABLED(CONFIG_DMA_DIRECT_REMAP) &&
-	    dma_alloc_need_uncached(dev, attrs) &&
-	    !gfpflags_allow_blocking(gfp)) {
+	if (dma_should_alloc_from_pool(dev, gfp, attrs)) {
 		ret = dma_alloc_from_pool(dev, PAGE_ALIGN(size), &page, gfp);
 		if (!ret)
 			return NULL;
@@ -217,6 +248,11 @@ void dma_direct_free_pages(struct device *dev, size_t size, void *cpu_addr,
 {
 	unsigned int page_order = get_order(size);
 
+	/* If cpu_addr is not from an atomic pool, dma_free_from_pool() fails */
+	if (dma_should_free_from_pool(dev, attrs) &&
+	    dma_free_from_pool(dev, cpu_addr, PAGE_ALIGN(size)))
+		return;
+
 	if ((attrs & DMA_ATTR_NO_KERNEL_MAPPING) &&
 	    !force_dma_unencrypted(dev)) {
 		/* cpu_addr is a struct page cookie, not a kernel address */
@@ -224,10 +260,6 @@ void dma_direct_free_pages(struct device *dev, size_t size, void *cpu_addr,
 		return;
 	}
 
-	if (IS_ENABLED(CONFIG_DMA_DIRECT_REMAP) &&
-	    dma_free_from_pool(dev, cpu_addr, PAGE_ALIGN(size)))
-		return;
-
 	if (force_dma_unencrypted(dev))
 		set_memory_encrypted((unsigned long)cpu_addr, 1 << page_order);
 
diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
index ffe866c2c034..c8d61b3a7bd6 100644
--- a/kernel/dma/pool.c
+++ b/kernel/dma/pool.c
@@ -8,6 +8,7 @@
 #include <linux/dma-contiguous.h>
 #include <linux/init.h>
 #include <linux/genalloc.h>
+#include <linux/set_memory.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
 
@@ -53,22 +54,42 @@ static int atomic_pool_expand(struct gen_pool *pool, size_t pool_size,
 
 	arch_dma_prep_coherent(page, pool_size);
 
+#ifdef CONFIG_DMA_DIRECT_REMAP
 	addr = dma_common_contiguous_remap(page, pool_size,
 					   pgprot_dmacoherent(PAGE_KERNEL),
 					   __builtin_return_address(0));
 	if (!addr)
 		goto free_page;
-
+#else
+	addr = page_to_virt(page);
+#endif
+	/*
+	 * Memory in the atomic DMA pools must be unencrypted, the pools do not
+	 * shrink so no re-encryption occurs in dma_direct_free_pages().
+	 */
+	ret = set_memory_decrypted((unsigned long)page_to_virt(page),
+				   1 << order);
+	if (ret)
+		goto remove_mapping;
 	ret = gen_pool_add_virt(pool, (unsigned long)addr, page_to_phys(page),
 				pool_size, NUMA_NO_NODE);
 	if (ret)
-		goto remove_mapping;
+		goto encrypt_mapping;
 
 	return 0;
 
+encrypt_mapping:
+	ret = set_memory_encrypted((unsigned long)page_to_virt(page),
+				   1 << order);
+	if (WARN_ON_ONCE(ret)) {
+		/* Decrypt succeeded but encrypt failed, purposely leak */
+		goto out;
+	}
 remove_mapping:
+#ifdef CONFIG_DMA_DIRECT_REMAP
 	dma_common_free_remap(addr, pool_size);
-free_page:
+#endif
+free_page: __maybe_unused
 	if (!dma_release_from_contiguous(NULL, page, 1 << order))
 		__free_pages(page, order);
 out:
-- 
2.28.0.618.gf4bc123cb7-goog

