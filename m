Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5BA1278E3D
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 18:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729593AbgIYQU0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 12:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728654AbgIYQUZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 12:20:25 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B30C0613CE
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:24 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id gc24so2442371pjb.4
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=ghrWx1K/+3JsMeSH86tJN8ucLNnB+daS1gHHtcEdzaM=;
        b=K+L7eZkoluS2PEadVJ6NwP0CoA7cdgFNv9bez0LNA03iLRVn+MGMShytCEvDqPhFQp
         WgVUiBhftJ7Qvc6XDaLySXYX+PQBcE+RkPvukG/tMuRLF1NzfuESnwlWrvilA3RhcREy
         iUuGFaAxVs25sK/96yJj9E4w8DGFEypYGzKCl/xjOvU7Xyac+KeqPbsWzlLlmebMWsV6
         2FAtAGzqzxahjb1AcpetOxRaw4sQfqEWNFV7hsouFxaeTnE5r5xYqYOSYxuoHiNMCyPA
         4JZ2FoSLRr4m+gRwxDzbAaUOL6tPD881Lr6WuYMN+ZFVJ7dvJombwnvwt+5tSkHhhK6q
         hAtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ghrWx1K/+3JsMeSH86tJN8ucLNnB+daS1gHHtcEdzaM=;
        b=iN8ULjUpGHm3k8BL+7HVJAk6Tu/wFARH3xjXfvLTcQc9UVNx/2m7jafGWPyNg/Mgme
         x5fSYOlH0/6yh3diA4/Fspno6FHV6Iq+PgwSB9jJh+5dUeE+cSwu9tVDU7dCDiiDguxM
         +ybDGp/kw0VkY7CXPP42QSXI5bNp6tm4LpGYl3XCawG1sCFxgP4izmWY5o5uKnTK7xVn
         JhTinIZa68XGE8NsLZWwocHlIRyE2JhpD/wtKPMtcHF7RNHdKCvUbPO8Wy4ZfWttj+sV
         W9IThZv0JY1Mn2F8ozZNU34lr0sC/nwN/2WXzs2D+MVlBHHcR1YTKkFIYAH7VqNpCevm
         4/2g==
X-Gm-Message-State: AOAM533nD1wI5ikV176uXrUdLCJ93mzlrC09XOmwDi7/+qviJGYV8ESk
        yUYLCGmdvRSHOmR+MH0uRBRaPjRFDhvzSPC+jBYZY0+ew8Hp8K7zUTZ+l13WYnh8nwFu/VqfG9e
        xObpAEt7e79q8DijF62DD3xMKs6aU1kHbhvzSncwL43kQgzzjFmTnOtChx4fU9A==
X-Google-Smtp-Source: ABdhPJw6giJceBWOBmp4Y9P/6acvyjC3ta60pOH7uZ41/gE28XMuwLTNO1hjBzopq0Vrjtz8+rAp589VnGI=
Sender: "pgonda via sendgmr" <pgonda@pgonda1.kir.corp.google.com>
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:1101:f693:9fff:fef4:e3a2])
 (user=pgonda job=sendgmr) by 2002:a17:902:8682:b029:d1:f289:1b8a with SMTP id
 g2-20020a1709028682b02900d1f2891b8amr132753plo.69.1601050823899; Fri, 25 Sep
 2020 09:20:23 -0700 (PDT)
Date:   Fri, 25 Sep 2020 09:19:05 -0700
In-Reply-To: <20200925161916.204667-1-pgonda@google.com>
Message-Id: <20200925161916.204667-20-pgonda@google.com>
Mime-Version: 1.0
References: <20200925161916.204667-1-pgonda@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH 19/30 for 5.4] dma-direct: re-encrypt memory if
 dma_direct_alloc_pages() fails
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

upstream 96a539fa3bb71f443ae08e57b9f63d6e5bb2207c commit.

If arch_dma_set_uncached() fails after memory has been decrypted, it needs
to be re-encrypted before freeing.

Fixes: fa7e2247c572 ("dma-direct: make uncached_kernel_address more general")
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 kernel/dma/direct.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index e72bb0dc8150..b4a5b7076399 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -234,7 +234,7 @@ void *dma_direct_alloc_pages(struct device *dev, size_t size,
 		arch_dma_prep_coherent(page, size);
 		ret = arch_dma_set_uncached(ret, size);
 		if (IS_ERR(ret))
-			goto out_free_pages;
+			goto out_encrypt_pages;
 	}
 done:
 	if (force_dma_unencrypted(dev))
@@ -242,6 +242,11 @@ void *dma_direct_alloc_pages(struct device *dev, size_t size,
 	else
 		*dma_handle = phys_to_dma(dev, page_to_phys(page));
 	return ret;
+
+out_encrypt_pages:
+	if (force_dma_unencrypted(dev))
+		set_memory_encrypted((unsigned long)page_address(page),
+				     1 << get_order(size));
 out_free_pages:
 	dma_free_contiguous(dev, page, size);
 	return NULL;
-- 
2.28.0.618.gf4bc123cb7-goog

