Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1C7278E1F
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 18:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729517AbgIYQTz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 12:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729546AbgIYQTy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 12:19:54 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19DEAC0613CE
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:19:54 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id c197so2693998pfb.23
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=jWMAFF+ZM67Ep7R4sbI6j2v0w5CXnZCbG0uQwudXMmg=;
        b=JlIQ4lL/7JkY7/7rFI2VeDAHbLc2Xg35CZzcDG5tU+iFBr3r9bWTjs+VTx2UNB+tkx
         WMgmpF3l9E6ViRLEkHe6A5/o3FUDNxWEGe1+mfWTjbpOx8KUApc39ElsJ4NdC5nIvfh2
         99vFCEvukGHqqDyfU0kblpKxuIZtFgVP7TvgOCg7xgo2i/Mt4e5dOSxTOfntXLnTCTIu
         mxmJv9JBsnvl2unmZLDUvMdL38GhBzKgKh0wAUTHzdkCXnxyMq8Neihwf9BD0/9QTvl6
         uf1lLTE1ezNR5QGcMrMLsjiepOrLz9Huv4ARp9rhIozCelrv4N7T4Z4pTJAIXm4KIvwP
         2oIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jWMAFF+ZM67Ep7R4sbI6j2v0w5CXnZCbG0uQwudXMmg=;
        b=EKcRcnTq73twi+jtQ7FjhhmOY8ZBE5n0MVYFMdiVxKCe5fKY/YMzC1CYGnFdLyN7Vv
         WpHt4EaoARWbBDriyRjQAPjD81/mPC13UCqhiTn+N+H9+0ttDtWwTnL8HsnHNrS0/+Rf
         Iw7vFQ7OiDr9pD9XApOQ25gJFn+pkxtcXS3CTkP3mekAPMBTzsvrtDCFd0UjAQLnpQuy
         7P242dZGP4ov0CT55bBLx3hEmWPqdIO7Kh5AkD33YeqF1ssv+xfHC2M/SidDl8Az/KRk
         nO5J4AXnXn0Mttyh+JYXRgeUOWT6zS80/QdKNPi0+EJ5YmFqHeXM3wGN39CVQkOkVB00
         KFUg==
X-Gm-Message-State: AOAM532CPokkuXQdnoWlWAj29wZRq8/+g/pErptrejKsrvOheWlBkAu4
        Yjk2OwBddMbmRLyMmT5KTwrSOh5gFLVbzGEq/Rg+cStZwJiKECX1vfRFozoysw6ZlZxiSXOmJmq
        f931oYjepDmGWZt0ZDBDrpo93GOzLKUSgffSgpNUwOizLG34bgRobujLCCGJAEQ==
X-Google-Smtp-Source: ABdhPJx9qPY7+VA2o+wh8ZoQ7XalRcTieHZSg88Gm7IjLCOcrIc3i/x4CW3dHNKu8LyHb94FJa+ELrTQZWE=
Sender: "pgonda via sendgmr" <pgonda@pgonda1.kir.corp.google.com>
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:1101:f693:9fff:fef4:e3a2])
 (user=pgonda job=sendgmr) by 2002:a05:6a00:2387:b029:142:2501:3970 with SMTP
 id f7-20020a056a002387b029014225013970mr20069pfc.53.1601050793311; Fri, 25
 Sep 2020 09:19:53 -0700 (PDT)
Date:   Fri, 25 Sep 2020 09:18:48 -0700
In-Reply-To: <20200925161916.204667-1-pgonda@google.com>
Message-Id: <20200925161916.204667-3-pgonda@google.com>
Mime-Version: 1.0
References: <20200925161916.204667-1-pgonda@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH 02/30 for 5.4] dma-direct: remove the dma_handle argument to __dma_direct_alloc_pages
From:   Peter Gonda <pgonda@google.com>
To:     stable@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>, Christoph Hellwig <hch@lst.de>,
        Max Filippov <jcmvbkbc@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

upstream 4e1003aa56a7d60ddb048e43a7a51368fcfe36af commit.

The argument isn't used anywhere, so stop passing it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 include/linux/dma-direct.h | 2 +-
 kernel/dma/direct.c        | 4 ++--
 kernel/dma/remap.c         | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/dma-direct.h b/include/linux/dma-direct.h
index 02a418520062..3238177e65ad 100644
--- a/include/linux/dma-direct.h
+++ b/include/linux/dma-direct.h
@@ -75,6 +75,6 @@ void *dma_direct_alloc_pages(struct device *dev, size_t size,
 void dma_direct_free_pages(struct device *dev, size_t size, void *cpu_addr,
 		dma_addr_t dma_addr, unsigned long attrs);
 struct page *__dma_direct_alloc_pages(struct device *dev, size_t size,
-		dma_addr_t *dma_handle, gfp_t gfp, unsigned long attrs);
+		gfp_t gfp, unsigned long attrs);
 int dma_direct_supported(struct device *dev, u64 mask);
 #endif /* _LINUX_DMA_DIRECT_H */
diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 86f580439c9c..9621993bf2bb 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -84,7 +84,7 @@ static bool dma_coherent_ok(struct device *dev, phys_addr_t phys, size_t size)
 }
 
 struct page *__dma_direct_alloc_pages(struct device *dev, size_t size,
-		dma_addr_t *dma_handle, gfp_t gfp, unsigned long attrs)
+		gfp_t gfp, unsigned long attrs)
 {
 	size_t alloc_size = PAGE_ALIGN(size);
 	int node = dev_to_node(dev);
@@ -132,7 +132,7 @@ void *dma_direct_alloc_pages(struct device *dev, size_t size,
 	struct page *page;
 	void *ret;
 
-	page = __dma_direct_alloc_pages(dev, size, dma_handle, gfp, attrs);
+	page = __dma_direct_alloc_pages(dev, size, gfp, attrs);
 	if (!page)
 		return NULL;
 
diff --git a/kernel/dma/remap.c b/kernel/dma/remap.c
index fb1e50c2d48a..90d5ce77c189 100644
--- a/kernel/dma/remap.c
+++ b/kernel/dma/remap.c
@@ -226,7 +226,7 @@ void *arch_dma_alloc(struct device *dev, size_t size, dma_addr_t *dma_handle,
 		goto done;
 	}
 
-	page = __dma_direct_alloc_pages(dev, size, dma_handle, flags, attrs);
+	page = __dma_direct_alloc_pages(dev, size, flags, attrs);
 	if (!page)
 		return NULL;
 
-- 
2.28.0.618.gf4bc123cb7-goog

