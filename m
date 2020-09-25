Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21E6C278E37
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 18:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729567AbgIYQUQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 12:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729582AbgIYQUM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 12:20:12 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 364BBC0613D3
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:12 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id t5so2336324pji.6
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=WWigOjuEgeTY5QovcK5jlEzCHIaCCnDSJLo/xPypiZc=;
        b=DIJ/JDgbDHMaVxaOVN+0P1OzGYMDDepm0NR1P5omlp7BNurlBx59G3C4d/K00qZs28
         /fUJiUpUxHSicPizbNETIOjr5LqEat7z0Emb2l5LpsOkK060IKNFl8gUPc1dMOwqU32L
         +NuL1liRyOzqkjWxVRxgLVWd6xNTowYgaVUn4L2UXGnWEINmet/YyYdmGw+56lDcSaAX
         UPHsV9Qwaapy5i5MdNndt1DrBM//9QUNzMwEg2QWcUh/ZtVa/wG4p4/RLPJRcFilPVYQ
         kar+DULVOZcJYVthgJxhUC3YDfSxW+VJdgC4yoiemkQ0L8OqwRk0Fre8OG8m9bpvNj6o
         1nUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=WWigOjuEgeTY5QovcK5jlEzCHIaCCnDSJLo/xPypiZc=;
        b=JU6UVHIV2ZYzc8Ky1pMZLtdLcZuefLj0uwDWh12qpLzzgQfXxo9EHuF0uWex54qQK0
         kG2w5HTtSKTnksImV8k2DbwQZ09rF7Bk9VeW2EM9u+mFTHfvA5a9M0ld/0fV1Ta/8aQd
         4fHzSg0AltpOLSoJMRpCYIlTUkZYFnLlgAP+r9xg6BjKLjL656BC+NrIjxonOtxUUmiM
         ugJAF0uTA3rBCWtyX/qQ4cEhTb3Rncsi+ObGe+WnPQVs5x1wFccK+kkMCzMGjZ3Z+6e7
         dOrxFmM9Dofe0bpGmgtpWLd3VaxTQb8CGs4gIoO4c/Cia3aChZB78wQVrGl/m+oItn1g
         Dbdw==
X-Gm-Message-State: AOAM5335qj9z7Ar4JTAeIwFMxgPYrtcVkgaWNzUWLgvqZPtswLoyD6Kn
        V/DWDvOeJSYk2dHVqDGGiGmW1oLwgjT+vvK8cYko6HQQYu0JNMRUacgYC+g7l1cMWZi0mCciuNu
        E5ere516LsBgEsdFmfWCgxkya3ZGUnK3WZJKE5E46LdE4ScVvA3byF+YJBfJUeg==
X-Google-Smtp-Source: ABdhPJyzfpzQRbWzrMJ4JqKcZ9vjaWrMeDiw8s4fgywWIpgzKi4IiB7QnKU+IlWhcXTLl3sq8k66DzFr90I=
Sender: "pgonda via sendgmr" <pgonda@pgonda1.kir.corp.google.com>
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:1101:f693:9fff:fef4:e3a2])
 (user=pgonda job=sendgmr) by 2002:a17:902:ee06:b029:d1:8c50:b1ba with SMTP id
 z6-20020a170902ee06b02900d18c50b1bamr132209plb.35.1601050811452; Fri, 25 Sep
 2020 09:20:11 -0700 (PDT)
Date:   Fri, 25 Sep 2020 09:18:58 -0700
In-Reply-To: <20200925161916.204667-1-pgonda@google.com>
Message-Id: <20200925161916.204667-13-pgonda@google.com>
Mime-Version: 1.0
References: <20200925161916.204667-1-pgonda@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH 12/30 for 5.4] dma-pool: scale the default DMA coherent pool
 size with memory capacity
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

upstream 1d659236fb43c4d2b37af7a4309681e834e9ec9a commit.

When AMD memory encryption is enabled, some devices may use more than
256KB/sec from the atomic pools.  It would be more appropriate to scale
the default size based on memory capacity unless the coherent_pool
option is used on the kernel command line.

This provides a slight optimization on initial expansion and is deemed
appropriate due to the increased reliance on the atomic pools.  Note that
the default size of 128KB per pool will normally be larger than the
single coherent pool implementation since there are now up to three
coherent pools (DMA, DMA32, and kernel).

Note that even prior to this patch, coherent_pool= for sizes larger than
1 << (PAGE_SHIFT + MAX_ORDER-1) can fail.  With new dynamic expansion
support, this would be trivially extensible to allow even larger initial
sizes.

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 kernel/dma/pool.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
index dde6de7f8e83..35bb51c31fff 100644
--- a/kernel/dma/pool.c
+++ b/kernel/dma/pool.c
@@ -20,8 +20,8 @@ static unsigned long pool_size_dma32;
 static struct gen_pool *atomic_pool_kernel __ro_after_init;
 static unsigned long pool_size_kernel;
 
-#define DEFAULT_DMA_COHERENT_POOL_SIZE  SZ_256K
-static size_t atomic_pool_size = DEFAULT_DMA_COHERENT_POOL_SIZE;
+/* Size can be defined by the coherent_pool command line */
+static size_t atomic_pool_size;
 
 /* Dynamic background expansion when the atomic pool is near capacity */
 static struct work_struct atomic_pool_work;
@@ -170,6 +170,16 @@ static int __init dma_atomic_pool_init(void)
 {
 	int ret = 0;
 
+	/*
+	 * If coherent_pool was not used on the command line, default the pool
+	 * sizes to 128KB per 1GB of memory, min 128KB, max MAX_ORDER-1.
+	 */
+	if (!atomic_pool_size) {
+		atomic_pool_size = max(totalram_pages() >> PAGE_SHIFT, 1UL) *
+					SZ_128K;
+		atomic_pool_size = min_t(size_t, atomic_pool_size,
+					 1 << (PAGE_SHIFT + MAX_ORDER-1));
+	}
 	INIT_WORK(&atomic_pool_work, atomic_pool_work_fn);
 
 	atomic_pool_kernel = __dma_atomic_pool_init(atomic_pool_size,
-- 
2.28.0.618.gf4bc123cb7-goog

