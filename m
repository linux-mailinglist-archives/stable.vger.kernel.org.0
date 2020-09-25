Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D34A6278E26
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 18:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729546AbgIYQUA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 12:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729556AbgIYQT7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 12:19:59 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55A18C0613CE
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:19:59 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id r4so2661533pgl.20
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=pkrLIyZkkfAlj0b7XRwANO1F7a741pqc7PrjWyrMojY=;
        b=irF5PimiZVHOeT2ACNrEl666hNjfNJFQSVQiBZFsLI0wT30i66MmSi7WaGjSBZh5+U
         RHQy709yO3uJk3vOHf8qhsOweSJihiILg0DVXnutWZfxVfEdwyVKm/nrmpHn2kix4x66
         iZA090E+pUhXFP10J5rXeDLGB2PVyn9dkWp1r5XCY4EVmPKYIff5ENfTsXkOsM5nb3VF
         MVS5+w7N27DFSc33Gzi3eOJ9GiLmsDsvxqLGh+6AYyrvzRfqQre90VbKCAq0HLqtGu58
         YsHNO5XtNJgOWEGcu5Bgp/qzTArd/Vn2j0qVQUEHUa2NjpQwW1mt+juwkHTc7ffzo/ET
         conQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=pkrLIyZkkfAlj0b7XRwANO1F7a741pqc7PrjWyrMojY=;
        b=Db0e8LI+MFHA4WmOqCp9i2z23KNu1j5Ioce2bw/PsQOeeqKt3ouY4cqyjGA8EFHsRL
         Zz3HKPP8iKofCoTo8USbswUhJieuiV00GygIhCVKUql2kXpwnYn+qWCDPd0jTnfW9ZwK
         35Z1IHs8Sa0Za5/KxhH81HpfSkhOiQsRK+8zHPyFo8TpNSztfSr8/42B3JAUELvM/Ias
         tgclPAnja2n+qDM47wuwENCrxb0tDCPsveKQrEF5hAOFlQUtKIMtgerTP76enHevgEvr
         2fVFMHFiyaGp5ErZRsJNUFXWPUEZfIIPtY4pQwt1G4qWva0CMj4/MgJhxzsdFzDjDo3r
         0V/A==
X-Gm-Message-State: AOAM532FUq3cRna6tH9wk9iRzsO4hmAmGKlrqyYR+cf+Mlir2RePly4S
        Kaw5elnJ5/N23KQZAK0oLAtGxMebiDzzNsxUcKb02i4/YGQIRqIu19SVXm5SRTfyV2iRq7kTq1x
        JX/8J+rSZtXP8n/UeWG3q+10M7gHLE3HZ77vGrDv/0iM/qBj15MWe5ac8CsT9pA==
X-Google-Smtp-Source: ABdhPJzCDZthIQPMkTNog9PVNt3HCrmPImSVaHcbjLUws2d8S3UsCr32Xg7e6gvB4C6dz943UvEnM9aQt4I=
Sender: "pgonda via sendgmr" <pgonda@pgonda1.kir.corp.google.com>
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:1101:f693:9fff:fef4:e3a2])
 (user=pgonda job=sendgmr) by 2002:a17:902:8b81:b029:d2:42a6:ba2 with SMTP id
 ay1-20020a1709028b81b02900d242a60ba2mr183915plb.24.1601050798703; Fri, 25 Sep
 2020 09:19:58 -0700 (PDT)
Date:   Fri, 25 Sep 2020 09:18:51 -0700
In-Reply-To: <20200925161916.204667-1-pgonda@google.com>
Message-Id: <20200925161916.204667-6-pgonda@google.com>
Mime-Version: 1.0
References: <20200925161916.204667-1-pgonda@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH 05/30 for 5.4] lib/genalloc.c: rename addr_in_gen_pool to gen_pool_has_addr
From:   Peter Gonda <pgonda@google.com>
To:     stable@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        Huang Shijie <sjhuang@iluvatar.ai>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@armlinux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huang Shijie <sjhuang@iluvatar.ai>

upstream 964975ac6677c97ae61ec9d6969dd5d03f18d1c3 commit.

Follow the kernel conventions, rename addr_in_gen_pool to
gen_pool_has_addr.

[sjhuang@iluvatar.ai: fix Documentation/ too]
 Link: http://lkml.kernel.org/r/20181229015914.5573-1-sjhuang@iluvatar.ai
Link: http://lkml.kernel.org/r/20181228083950.20398-1-sjhuang@iluvatar.ai
Signed-off-by: Huang Shijie <sjhuang@iluvatar.ai>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 Documentation/core-api/genalloc.rst | 2 +-
 arch/arm/mm/dma-mapping.c           | 2 +-
 drivers/misc/sram-exec.c            | 2 +-
 include/linux/genalloc.h            | 2 +-
 kernel/dma/remap.c                  | 2 +-
 lib/genalloc.c                      | 5 +++--
 6 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/Documentation/core-api/genalloc.rst b/Documentation/core-api/genalloc.rst
index 6b38a39fab24..a534cc7ebd05 100644
--- a/Documentation/core-api/genalloc.rst
+++ b/Documentation/core-api/genalloc.rst
@@ -129,7 +129,7 @@ writing of special-purpose memory allocators in the future.
    :functions: gen_pool_for_each_chunk
 
 .. kernel-doc:: lib/genalloc.c
-   :functions: addr_in_gen_pool
+   :functions: gen_pool_has_addr
 
 .. kernel-doc:: lib/genalloc.c
    :functions: gen_pool_avail
diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 58d5765fb129..84ecbaefb9cf 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -529,7 +529,7 @@ static void *__alloc_from_pool(size_t size, struct page **ret_page)
 
 static bool __in_atomic_pool(void *start, size_t size)
 {
-	return addr_in_gen_pool(atomic_pool, (unsigned long)start, size);
+	return gen_pool_has_addr(atomic_pool, (unsigned long)start, size);
 }
 
 static int __free_from_pool(void *start, size_t size)
diff --git a/drivers/misc/sram-exec.c b/drivers/misc/sram-exec.c
index 426ad912b441..d054e2842a5f 100644
--- a/drivers/misc/sram-exec.c
+++ b/drivers/misc/sram-exec.c
@@ -96,7 +96,7 @@ void *sram_exec_copy(struct gen_pool *pool, void *dst, void *src,
 	if (!part)
 		return NULL;
 
-	if (!addr_in_gen_pool(pool, (unsigned long)dst, size))
+	if (!gen_pool_has_addr(pool, (unsigned long)dst, size))
 		return NULL;
 
 	base = (unsigned long)part->base;
diff --git a/include/linux/genalloc.h b/include/linux/genalloc.h
index 4bd583bd6934..5b14a0f38124 100644
--- a/include/linux/genalloc.h
+++ b/include/linux/genalloc.h
@@ -206,7 +206,7 @@ extern struct gen_pool *devm_gen_pool_create(struct device *dev,
 		int min_alloc_order, int nid, const char *name);
 extern struct gen_pool *gen_pool_get(struct device *dev, const char *name);
 
-bool addr_in_gen_pool(struct gen_pool *pool, unsigned long start,
+extern bool gen_pool_has_addr(struct gen_pool *pool, unsigned long start,
 			size_t size);
 
 #ifdef CONFIG_OF
diff --git a/kernel/dma/remap.c b/kernel/dma/remap.c
index d47bd40fc0f5..d14cbc83986a 100644
--- a/kernel/dma/remap.c
+++ b/kernel/dma/remap.c
@@ -178,7 +178,7 @@ bool dma_in_atomic_pool(void *start, size_t size)
 	if (unlikely(!atomic_pool))
 		return false;
 
-	return addr_in_gen_pool(atomic_pool, (unsigned long)start, size);
+	return gen_pool_has_addr(atomic_pool, (unsigned long)start, size);
 }
 
 void *dma_alloc_from_pool(size_t size, struct page **ret_page, gfp_t flags)
diff --git a/lib/genalloc.c b/lib/genalloc.c
index 9fc31292cfa1..e43d6107fd62 100644
--- a/lib/genalloc.c
+++ b/lib/genalloc.c
@@ -540,7 +540,7 @@ void gen_pool_for_each_chunk(struct gen_pool *pool,
 EXPORT_SYMBOL(gen_pool_for_each_chunk);
 
 /**
- * addr_in_gen_pool - checks if an address falls within the range of a pool
+ * gen_pool_has_addr - checks if an address falls within the range of a pool
  * @pool:	the generic memory pool
  * @start:	start address
  * @size:	size of the region
@@ -548,7 +548,7 @@ EXPORT_SYMBOL(gen_pool_for_each_chunk);
  * Check if the range of addresses falls within the specified pool. Returns
  * true if the entire range is contained in the pool and false otherwise.
  */
-bool addr_in_gen_pool(struct gen_pool *pool, unsigned long start,
+bool gen_pool_has_addr(struct gen_pool *pool, unsigned long start,
 			size_t size)
 {
 	bool found = false;
@@ -567,6 +567,7 @@ bool addr_in_gen_pool(struct gen_pool *pool, unsigned long start,
 	rcu_read_unlock();
 	return found;
 }
+EXPORT_SYMBOL(gen_pool_has_addr);
 
 /**
  * gen_pool_avail - get available free space of the pool
-- 
2.28.0.618.gf4bc123cb7-goog

