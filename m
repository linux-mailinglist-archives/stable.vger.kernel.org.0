Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB009278E40
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 18:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728907AbgIYQU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 12:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728654AbgIYQU2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 12:20:28 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA52C0613CE
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:28 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id k13so2745377pfh.4
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=xaiNLmruWZkYXJuAm2uivOeCM7fHk3EZ3wARxXweSRk=;
        b=MUQayPXoYvKrDXe5x9e2ft7TOuXR+lpZrTdLpXXivLk9Cr5ZQfDkRunAiBtufF4esR
         bJX+JjlJuiZZ5RUbHb+BHU7dRjVAQ7AkTlWYI1VxaIy9TFtfUiGQT01sYk5m1SuQI3gg
         Z1Bcn1XtM/kXk28wFarK1U589E9eGxiMey1COIjdDfGzqAiL1qnLMD3tC8yNgPkB1gWN
         keiV5qwgteJoGwt7lo4e6O7kMUhhfj0CUgZ1+ExnTj5xckR9tsi8SFon/QQrn/Xzo4ay
         op/ZqUy1hrNqc+MY6FYf5LRyR+CumoAvB3yhrUqcXJqt1TlCyVfv/Au6IOR9IF52Hd7f
         anAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xaiNLmruWZkYXJuAm2uivOeCM7fHk3EZ3wARxXweSRk=;
        b=G9TYCZ5k4tFNx+lNyE2x53nypE3tBDDNKHtTwsED6REw9X394U2eoEETZLRSLSrvhn
         KsaAUcdgto3qekVwDi+HtptiEg7aNWozI63Rp2VY4lbcd+Zpz0B3Kl5NIwa1HMGBoQXr
         /lFOXC1Ovz9TUGrtaTRzNjf1iROHONezCCFpd0dansIWUiqbNjNNbV69j9ChIZ1uzhoL
         /RKHE6QVkaDCR7YTZvHIjNONls/U2IxeMiz+bn0DRucTmwPzM7sGKW5Z/nQhkPs28CyP
         1Bajs5S5nolUgXOfsW1ChGy1aLAHzfxfUS89xZfvNvjcJsG2kLLiISw3IGOoYLZV+GR1
         ZkPQ==
X-Gm-Message-State: AOAM530jXlR/oTWi3hNF3ZCgOSaW3Ubepc586Ul5QI8jAoTyzZCGHhRf
        vj7TPxUuY7hdYm7krBol++4aXSXVRclzmCsOt9+qvrLJyrKVOwktuOIWrHiZQiulKNOCYs5rXpg
        Q4FWIqaKnq5ez4SoHVMraAR1N+Df6EtLgJgLztf47AdD2x4iTbH8U8eVQYXj0HQ==
X-Google-Smtp-Source: ABdhPJxTJs94/5x5UbbA8H52h77ExfCqgfBoqP8PpFvWR54dk/5gRHKpkkpoCMVDoN6qlTYhX4WYtIsUFWE=
Sender: "pgonda via sendgmr" <pgonda@pgonda1.kir.corp.google.com>
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:1101:f693:9fff:fef4:e3a2])
 (user=pgonda job=sendgmr) by 2002:aa7:9592:0:b029:13e:d13d:a054 with SMTP id
 z18-20020aa795920000b029013ed13da054mr77352pfj.26.1601050827421; Fri, 25 Sep
 2020 09:20:27 -0700 (PDT)
Date:   Fri, 25 Sep 2020 09:19:07 -0700
In-Reply-To: <20200925161916.204667-1-pgonda@google.com>
Message-Id: <20200925161916.204667-22-pgonda@google.com>
Mime-Version: 1.0
References: <20200925161916.204667-1-pgonda@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH 21/30 for 5.4] dma-direct: add missing set_memory_decrypted()
 for coherent mapping
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

upstream 1a2b3357e860d890f8045367b179c7e7e802cd71 commit.

When a coherent mapping is created in dma_direct_alloc_pages(), it needs
to be decrypted if the device requires unencrypted DMA before returning.

Fixes: 3acac065508f ("dma-mapping: merge the generic remapping helpers into dma-direct")
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 kernel/dma/direct.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index ac611b4f65b9..6c677ffdbd53 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -209,6 +209,12 @@ void *dma_direct_alloc_pages(struct device *dev, size_t size,
 				__builtin_return_address(0));
 		if (!ret)
 			goto out_free_pages;
+		if (force_dma_unencrypted(dev)) {
+			err = set_memory_decrypted((unsigned long)ret,
+						   1 << get_order(size));
+			if (err)
+				goto out_free_pages;
+		}
 		memset(ret, 0, size);
 		goto done;
 	}
-- 
2.28.0.618.gf4bc123cb7-goog

