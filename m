Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5205D278E27
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 18:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729550AbgIYQUC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 12:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729383AbgIYQUC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 12:20:02 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00530C0613CE
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:01 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id k17so2660468pgb.7
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=TkqoSSzKMF5MExKtvfD1k7y0mbj5PDKEIWdm95DWQTw=;
        b=R0pyNQRI5xiGpyHEWBPjy7RdOFWHcKlBV6P4baa2hO04LTGg+/rWGh27YLDWng4qyc
         94Fn7ZbO2o3HkjrLcA9TgxPUIx+PWYcJT2vCjti4+q7HId7ZYRKWBgZwjNwhpTRpIciP
         jpKrig3dp3obgaXCdXuZUQvEmFts7QP+ZUwc8Zw1Z3YWpAwjLcMt7nYAeICq/kz9dQ3h
         RkW8B+d3Hj0xb53CvKA0/Se4Nevcc5DkX+xJtCl1O9KzJWo8ipFGFGf+ovqVfz68byrz
         Nr9Z8psGPzrYVY1aOcAr0LMLg9RvgdAa4os/+0CZyt0mjS8HYFgYgD/I8lVVDWAxQ8iU
         1vTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=TkqoSSzKMF5MExKtvfD1k7y0mbj5PDKEIWdm95DWQTw=;
        b=tMQoz88h2bkjL+vlSXaOWb1rr8zYqbtj6koEJn54Y8xdsg8mpcTCcqIQ/nzNO0Id+e
         rQMjsuHnQK3fwBb2AnMGAJKAkToLpFRw+Qcjoz55uTXcF+3bq78tRyDbU9aTNQG7m7qK
         VjWJ869uKCZFdX7fG6vFo3Fhcd+0cuqDez46Fbwsge9N9BQ5ZrN8mjSSkRvA7rsDxBnN
         6fafXmL7OOssNLgmHvIR3w5E6CCQ9stnpqGowBZbqVFwID4iFPTS5aLnpifDt1eP7DWb
         p6ZDTIMT4KTrPtd7ctyJ5pycnkF3a1cQq+wm1Y5uay619FaQVZfU7p/ACdQYQ9z6QHDF
         KirA==
X-Gm-Message-State: AOAM533ujYh/IxoG1bCLspWmm0GusGeY1aBetjUdHT5CJbG3lNZnBBBf
        fa3+tuaNPNi+xsEgPJPr/ZbPvNo39KAC06/kh4jRLmBN8FW/Uk5nCpjmNH83c6ceWWxXr3YBRDC
        VuwwrBMqzTPFBJQsaD2b5r2vJK8hFLu9THcT60RLVpy7Ng1kvGjQFov/nrPazOw==
X-Google-Smtp-Source: ABdhPJxn5VlzlvhbMF+jl4jGlB+BF2wfTyb2xaig4cb7yDNmNpZPLFOgehQBmv1ALbwF0WL2m9DGAmTn5LQ=
Sender: "pgonda via sendgmr" <pgonda@pgonda1.kir.corp.google.com>
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:1101:f693:9fff:fef4:e3a2])
 (user=pgonda job=sendgmr) by 2002:a05:6a00:15c1:b029:13e:d13d:a07a with SMTP
 id o1-20020a056a0015c1b029013ed13da07amr37039pfu.17.1601050801182; Fri, 25
 Sep 2020 09:20:01 -0700 (PDT)
Date:   Fri, 25 Sep 2020 09:18:52 -0700
In-Reply-To: <20200925161916.204667-1-pgonda@google.com>
Message-Id: <20200925161916.204667-7-pgonda@google.com>
Mime-Version: 1.0
References: <20200925161916.204667-1-pgonda@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH 06/30 for 5.4] dma-remap: separate DMA atomic pools from
 direct remap code
From:   Peter Gonda <pgonda@google.com>
To:     stable@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>, Christoph Hellwig <hch@lst.de>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Rientjes <rientjes@google.com>

upstream e860c299ac0d738b44ff91693f11e63080a29698 commit.

DMA atomic pools will be needed beyond only CONFIG_DMA_DIRECT_REMAP so
separate them out into their own file.

This also adds a new Kconfig option that can be subsequently used for
options, such as CONFIG_AMD_MEM_ENCRYPT, that will utilize the coherent
pools but do not have a dependency on direct remapping.

For this patch alone, there is no functional change introduced.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: David Rientjes <rientjes@google.com>
[hch: fixup copyrights and remove unused includes]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 kernel/dma/Kconfig  |   6 ++-
 kernel/dma/Makefile |   1 +
 kernel/dma/pool.c   | 123 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/dma/remap.c  | 121 +------------------------------------------
 4 files changed, 130 insertions(+), 121 deletions(-)
 create mode 100644 kernel/dma/pool.c

diff --git a/kernel/dma/Kconfig b/kernel/dma/Kconfig
index 4c103a24e380..d006668c0027 100644
--- a/kernel/dma/Kconfig
+++ b/kernel/dma/Kconfig
@@ -79,10 +79,14 @@ config DMA_REMAP
 	select DMA_NONCOHERENT_MMAP
 	bool
 
-config DMA_DIRECT_REMAP
+config DMA_COHERENT_POOL
 	bool
 	select DMA_REMAP
 
+config DMA_DIRECT_REMAP
+	bool
+	select DMA_COHERENT_POOL
+
 config DMA_CMA
 	bool "DMA Contiguous Memory Allocator"
 	depends on HAVE_DMA_CONTIGUOUS && CMA
diff --git a/kernel/dma/Makefile b/kernel/dma/Makefile
index d237cf3dc181..370f63344e9c 100644
--- a/kernel/dma/Makefile
+++ b/kernel/dma/Makefile
@@ -6,4 +6,5 @@ obj-$(CONFIG_DMA_DECLARE_COHERENT)	+= coherent.o
 obj-$(CONFIG_DMA_VIRT_OPS)		+= virt.o
 obj-$(CONFIG_DMA_API_DEBUG)		+= debug.o
 obj-$(CONFIG_SWIOTLB)			+= swiotlb.o
+obj-$(CONFIG_DMA_COHERENT_POOL)		+= pool.o
 obj-$(CONFIG_DMA_REMAP)			+= remap.o
diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
new file mode 100644
index 000000000000..3df5d9d39922
--- /dev/null
+++ b/kernel/dma/pool.c
@@ -0,0 +1,123 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ * Copyright (C) 2020 Google LLC
+ */
+#include <linux/dma-direct.h>
+#include <linux/dma-noncoherent.h>
+#include <linux/dma-contiguous.h>
+#include <linux/init.h>
+#include <linux/genalloc.h>
+#include <linux/slab.h>
+
+static struct gen_pool *atomic_pool __ro_after_init;
+
+#define DEFAULT_DMA_COHERENT_POOL_SIZE  SZ_256K
+static size_t atomic_pool_size __initdata = DEFAULT_DMA_COHERENT_POOL_SIZE;
+
+static int __init early_coherent_pool(char *p)
+{
+	atomic_pool_size = memparse(p, &p);
+	return 0;
+}
+early_param("coherent_pool", early_coherent_pool);
+
+static gfp_t dma_atomic_pool_gfp(void)
+{
+	if (IS_ENABLED(CONFIG_ZONE_DMA))
+		return GFP_DMA;
+	if (IS_ENABLED(CONFIG_ZONE_DMA32))
+		return GFP_DMA32;
+	return GFP_KERNEL;
+}
+
+static int __init dma_atomic_pool_init(void)
+{
+	unsigned int pool_size_order = get_order(atomic_pool_size);
+	unsigned long nr_pages = atomic_pool_size >> PAGE_SHIFT;
+	struct page *page;
+	void *addr;
+	int ret;
+
+	if (dev_get_cma_area(NULL))
+		page = dma_alloc_from_contiguous(NULL, nr_pages,
+						 pool_size_order, false);
+	else
+		page = alloc_pages(dma_atomic_pool_gfp(), pool_size_order);
+	if (!page)
+		goto out;
+
+	arch_dma_prep_coherent(page, atomic_pool_size);
+
+	atomic_pool = gen_pool_create(PAGE_SHIFT, -1);
+	if (!atomic_pool)
+		goto free_page;
+
+	addr = dma_common_contiguous_remap(page, atomic_pool_size,
+					   pgprot_dmacoherent(PAGE_KERNEL),
+					   __builtin_return_address(0));
+	if (!addr)
+		goto destroy_genpool;
+
+	ret = gen_pool_add_virt(atomic_pool, (unsigned long)addr,
+				page_to_phys(page), atomic_pool_size, -1);
+	if (ret)
+		goto remove_mapping;
+	gen_pool_set_algo(atomic_pool, gen_pool_first_fit_order_align, NULL);
+
+	pr_info("DMA: preallocated %zu KiB pool for atomic allocations\n",
+		atomic_pool_size / 1024);
+	return 0;
+
+remove_mapping:
+	dma_common_free_remap(addr, atomic_pool_size);
+destroy_genpool:
+	gen_pool_destroy(atomic_pool);
+	atomic_pool = NULL;
+free_page:
+	if (!dma_release_from_contiguous(NULL, page, nr_pages))
+		__free_pages(page, pool_size_order);
+out:
+	pr_err("DMA: failed to allocate %zu KiB pool for atomic coherent allocation\n",
+		atomic_pool_size / 1024);
+	return -ENOMEM;
+}
+postcore_initcall(dma_atomic_pool_init);
+
+bool dma_in_atomic_pool(void *start, size_t size)
+{
+	if (unlikely(!atomic_pool))
+		return false;
+
+	return gen_pool_has_addr(atomic_pool, (unsigned long)start, size);
+}
+
+void *dma_alloc_from_pool(size_t size, struct page **ret_page, gfp_t flags)
+{
+	unsigned long val;
+	void *ptr = NULL;
+
+	if (!atomic_pool) {
+		WARN(1, "coherent pool not initialised!\n");
+		return NULL;
+	}
+
+	val = gen_pool_alloc(atomic_pool, size);
+	if (val) {
+		phys_addr_t phys = gen_pool_virt_to_phys(atomic_pool, val);
+
+		*ret_page = pfn_to_page(__phys_to_pfn(phys));
+		ptr = (void *)val;
+		memset(ptr, 0, size);
+	}
+
+	return ptr;
+}
+
+bool dma_free_from_pool(void *start, size_t size)
+{
+	if (!dma_in_atomic_pool(start, size))
+		return false;
+	gen_pool_free(atomic_pool, (unsigned long)start, size);
+	return true;
+}
diff --git a/kernel/dma/remap.c b/kernel/dma/remap.c
index d14cbc83986a..f7b402849891 100644
--- a/kernel/dma/remap.c
+++ b/kernel/dma/remap.c
@@ -1,13 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * Copyright (C) 2012 ARM Ltd.
  * Copyright (c) 2014 The Linux Foundation
  */
-#include <linux/dma-direct.h>
-#include <linux/dma-noncoherent.h>
-#include <linux/dma-contiguous.h>
-#include <linux/init.h>
-#include <linux/genalloc.h>
+#include <linux/dma-mapping.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 
@@ -97,117 +92,3 @@ void dma_common_free_remap(void *cpu_addr, size_t size)
 	unmap_kernel_range((unsigned long)cpu_addr, PAGE_ALIGN(size));
 	vunmap(cpu_addr);
 }
-
-#ifdef CONFIG_DMA_DIRECT_REMAP
-static struct gen_pool *atomic_pool __ro_after_init;
-
-#define DEFAULT_DMA_COHERENT_POOL_SIZE  SZ_256K
-static size_t atomic_pool_size __initdata = DEFAULT_DMA_COHERENT_POOL_SIZE;
-
-static int __init early_coherent_pool(char *p)
-{
-	atomic_pool_size = memparse(p, &p);
-	return 0;
-}
-early_param("coherent_pool", early_coherent_pool);
-
-static gfp_t dma_atomic_pool_gfp(void)
-{
-	if (IS_ENABLED(CONFIG_ZONE_DMA))
-		return GFP_DMA;
-	if (IS_ENABLED(CONFIG_ZONE_DMA32))
-		return GFP_DMA32;
-	return GFP_KERNEL;
-}
-
-static int __init dma_atomic_pool_init(void)
-{
-	unsigned int pool_size_order = get_order(atomic_pool_size);
-	unsigned long nr_pages = atomic_pool_size >> PAGE_SHIFT;
-	struct page *page;
-	void *addr;
-	int ret;
-
-	if (dev_get_cma_area(NULL))
-		page = dma_alloc_from_contiguous(NULL, nr_pages,
-						 pool_size_order, false);
-	else
-		page = alloc_pages(dma_atomic_pool_gfp(), pool_size_order);
-	if (!page)
-		goto out;
-
-	arch_dma_prep_coherent(page, atomic_pool_size);
-
-	atomic_pool = gen_pool_create(PAGE_SHIFT, -1);
-	if (!atomic_pool)
-		goto free_page;
-
-	addr = dma_common_contiguous_remap(page, atomic_pool_size,
-					   pgprot_dmacoherent(PAGE_KERNEL),
-					   __builtin_return_address(0));
-	if (!addr)
-		goto destroy_genpool;
-
-	ret = gen_pool_add_virt(atomic_pool, (unsigned long)addr,
-				page_to_phys(page), atomic_pool_size, -1);
-	if (ret)
-		goto remove_mapping;
-	gen_pool_set_algo(atomic_pool, gen_pool_first_fit_order_align, NULL);
-
-	pr_info("DMA: preallocated %zu KiB pool for atomic allocations\n",
-		atomic_pool_size / 1024);
-	return 0;
-
-remove_mapping:
-	dma_common_free_remap(addr, atomic_pool_size);
-destroy_genpool:
-	gen_pool_destroy(atomic_pool);
-	atomic_pool = NULL;
-free_page:
-	if (!dma_release_from_contiguous(NULL, page, nr_pages))
-		__free_pages(page, pool_size_order);
-out:
-	pr_err("DMA: failed to allocate %zu KiB pool for atomic coherent allocation\n",
-		atomic_pool_size / 1024);
-	return -ENOMEM;
-}
-postcore_initcall(dma_atomic_pool_init);
-
-bool dma_in_atomic_pool(void *start, size_t size)
-{
-	if (unlikely(!atomic_pool))
-		return false;
-
-	return gen_pool_has_addr(atomic_pool, (unsigned long)start, size);
-}
-
-void *dma_alloc_from_pool(size_t size, struct page **ret_page, gfp_t flags)
-{
-	unsigned long val;
-	void *ptr = NULL;
-
-	if (!atomic_pool) {
-		WARN(1, "coherent pool not initialised!\n");
-		return NULL;
-	}
-
-	val = gen_pool_alloc(atomic_pool, size);
-	if (val) {
-		phys_addr_t phys = gen_pool_virt_to_phys(atomic_pool, val);
-
-		*ret_page = pfn_to_page(__phys_to_pfn(phys));
-		ptr = (void *)val;
-		memset(ptr, 0, size);
-	}
-
-	return ptr;
-}
-
-bool dma_free_from_pool(void *start, size_t size)
-{
-	if (!dma_in_atomic_pool(start, size))
-		return false;
-	gen_pool_free(atomic_pool, (unsigned long)start, size);
-	return true;
-}
-#endif /* CONFIG_DMA_DIRECT_REMAP */
-- 
2.28.0.618.gf4bc123cb7-goog

