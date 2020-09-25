Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17D91278E41
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 18:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729009AbgIYQUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 12:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728654AbgIYQUb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 12:20:31 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767D3C0613CE
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:31 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id c18so2711849pfi.21
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=DjOs7Vs2zcu8GdodLlNI9Hhz23FEMcf2cbN96JZ9NVw=;
        b=aZzuPXxaZmW9uRRBErnEu4EXC3qjkW034qfvfDnMDLQupabGA+SSkg3L+nBh+1TMT4
         SpqaKvenAsydpd7VO3PXunfIQz2Vn7tOhSFWOaXCz7eAhs9Cj/kClw7G8ywNExNok1IS
         j8CBBCJSoFYaTDUSGnqs03mC3sjvSdGDmXeJDM2YITC8hmvr6Rsph2/2G2e3RmBjItLZ
         o/zzE3zfQr1yqSuhEALWrVG+x0MmNDQkWOvLGLm62ncTiT081qFJM7pvGrUGwn8Vb0oW
         mnixVkYn0u/SO2hBEsDn88ussA2AK7QjHDiEU7JYyfyBAW0+MJxiP6mrvq9VawFyrhoW
         BR0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=DjOs7Vs2zcu8GdodLlNI9Hhz23FEMcf2cbN96JZ9NVw=;
        b=fLjCXzPNAgPsKXzpFed3jauWK8eC5R495a1ckx7JB+8C4Kw+i9xrLGLFXRNoPBZikK
         t4xNldBAVQsZPAq/HytGZORGzfWGzvHfCe/SwvfgQzhO77aJmvY3uRGsllC6p/Zg1HI1
         qyrv4fNDEUFlCCQ+75xZTotKnk6N8VUy6KlCm4naewZjF2RCg8QIFwT21Jp//EvhnGo6
         Ph8Xppbirsj3li1EJ1pYA40JkQ1LYbH0PXMenjy0tCbj1JVRuLLt7nOmTAYIFzDLt05c
         VQtFpXWCjPM3flGfefqWQZt6RxggJRnf/wwhZm+SQ9COUjoSwoOC6KaWcT9fdrnaNIhs
         mVpw==
X-Gm-Message-State: AOAM531wOfjovLyaav4mZtQ8AjJYF7G7nCZPOa4cRAqLnpwqTPhQK7tv
        Xj9q1k5Jrm+0IIrnL0rIQqXWPY4RTt5oMNnT/s8/NkIisKl1w6RpBA+/pFbeYd08659OxZA3Ghr
        8zI5CRoBDh8GzU3JYqCh6CatEv8hxt5FRA8Gp6hkjBxQ5b5h2g3IWppoiX4aqMA==
X-Google-Smtp-Source: ABdhPJzHjWFbdAHuvwAWOLk0CeSIEkZxJEvYXaLm9cQ+ftbMwMqZOq8QXcT6gECnE1j0xhGGTh9J2JGFnw4=
Sender: "pgonda via sendgmr" <pgonda@pgonda1.kir.corp.google.com>
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:1101:f693:9fff:fef4:e3a2])
 (user=pgonda job=sendgmr) by 2002:a62:e90b:0:b029:13e:b622:3241 with SMTP id
 j11-20020a62e90b0000b029013eb6223241mr85905pfh.12.1601050830913; Fri, 25 Sep
 2020 09:20:30 -0700 (PDT)
Date:   Fri, 25 Sep 2020 09:19:09 -0700
In-Reply-To: <20200925161916.204667-1-pgonda@google.com>
Message-Id: <20200925161916.204667-24-pgonda@google.com>
Mime-Version: 1.0
References: <20200925161916.204667-1-pgonda@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH 23/30 for 5.4] dma-mapping: warn when coherent pool is depleted
From:   Peter Gonda <pgonda@google.com>
To:     stable@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        David Rientjes <rientjes@google.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Rientjes <rientjes@google.com>

upstream 71cdec4fab76667dabdbb2ca232b039004ebd40f commit.

When a DMA coherent pool is depleted, allocation failures may or may not
get reported in the kernel log depending on the allocator.

The admin does have a workaround, however, by using coherent_pool= on the
kernel command line.

Provide some guidance on the failure and a recommended minimum size for
the pools (double the size).

Signed-off-by: David Rientjes <rientjes@google.com>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 kernel/dma/pool.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
index 8cfa01243ed2..39ca26fa41b5 100644
--- a/kernel/dma/pool.c
+++ b/kernel/dma/pool.c
@@ -239,12 +239,16 @@ void *dma_alloc_from_pool(struct device *dev, size_t size,
 	}
 
 	val = gen_pool_alloc(pool, size);
-	if (val) {
+	if (likely(val)) {
 		phys_addr_t phys = gen_pool_virt_to_phys(pool, val);
 
 		*ret_page = pfn_to_page(__phys_to_pfn(phys));
 		ptr = (void *)val;
 		memset(ptr, 0, size);
+	} else {
+		WARN_ONCE(1, "DMA coherent pool depleted, increase size "
+			     "(recommended min coherent_pool=%zuK)\n",
+			  gen_pool_size(pool) >> 9);
 	}
 	if (gen_pool_avail(pool) < atomic_pool_size)
 		schedule_work(&atomic_pool_work);
-- 
2.28.0.618.gf4bc123cb7-goog

