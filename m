Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 195AE5E9227
	for <lists+stable@lfdr.de>; Sun, 25 Sep 2022 12:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231883AbiIYKhK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Sep 2022 06:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231995AbiIYKgr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Sep 2022 06:36:47 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AA4D2CDFA;
        Sun, 25 Sep 2022 03:36:45 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id bu5-20020a17090aee4500b00202e9ca2182so10888292pjb.0;
        Sun, 25 Sep 2022 03:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date;
        bh=4Ot2lP39QN3yfVpgj7SLSWZBZZZnT/3K2vptG1qJdkE=;
        b=iSSeFgmmk/7jZG6g/b/9ADqG+LZ5HMjvms+2LNiqELFfkQ4VwSY/REwyxrBMHhVnDC
         6IZ9R8AUb9DlglQhlc9CwKEKCQO1UPW5q+NNnbH0YlbB+QAcb4tdcQlkIUjpJkRSwr3a
         f4EXiGSPRRvVU4T1PdsgyIUByuEL5ybCgX5rGtTxhpUrN1OFq5Gm6R97Qs/RGACao/h9
         iolaIXtceGriJm3JPOHaUUOb3h7l3z/SUbcIEUJLQy7cugQS8ffzDWe0O9sU1HM46Bbm
         vgimZqpaqT/DSUpV/8WTqC5EMyDC5TUKWJBGDqgDcYN+M7vI24wSYo8Rs0Jgkzl2bxy2
         G5JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date;
        bh=4Ot2lP39QN3yfVpgj7SLSWZBZZZnT/3K2vptG1qJdkE=;
        b=buBra9Bv32uXbM5I6dMjlRqDylrvqVS2t1WfNa2PSW7+nWtTlT+5r4endeLYKEXvzK
         cQXwdojr1DtljPjn2hHTaAktzaPdIElumaTkB3ukO1CHOQun9pdUi3D+kkE4ru/d9LSB
         gkVgbTZAk6OoJuTFDjPzLFtVl/6t9UfVYjkBaKptokYaGGnFA/dvjkub1zPKyp2iHyMQ
         Gahsh1OjQJWM/kj4kEE827++em94bVlWXxV89t7tovuqfn65pKGb9/piRxJ4FVgesXvH
         /3UKkL+Fjt1qJ5/x5oM6w385yDWP4446FCQZ4YxBrv+pSrvzcYP5euIbmmnOLZC4q9qE
         Uf8A==
X-Gm-Message-State: ACrzQf2zwur45OpszfrgQB8WP4QqRNQrLx4rs7d5blkMIW0oaZs0WenZ
        IbHNTm/cSihBwKAl4M0aZG8=
X-Google-Smtp-Source: AMsMyM4GXRh9T+Op3qFcLR9q/PCBQ7Qfq4wcJf1TBPzLMUTg+J6KwwvWxx1jadiiESOWNdG/ToWi6A==
X-Received: by 2002:a17:90b:33d1:b0:203:7b4b:ba1e with SMTP id lk17-20020a17090b33d100b002037b4bba1emr19178483pjb.128.1664102204547;
        Sun, 25 Sep 2022 03:36:44 -0700 (PDT)
Received: from ubuntu.localdomain ([117.176.186.252])
        by smtp.gmail.com with ESMTPSA id u4-20020a170902e80400b00179c81f6693sm3722183plg.264.2022.09.25.03.36.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Sep 2022 03:36:44 -0700 (PDT)
From:   wangyong <yongw.pur@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     jaewon31.kim@samsung.com, linux-kernel@vger.kernel.org,
        mhocko@kernel.org, stable@vger.kernel.org, wang.yong12@zte.com.cn,
        yongw.pur@gmail.com, Minchan Kim <minchan@kernel.org>,
        Baoquan He <bhe@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Yong-Taek Lee <ytk.lee@samsung.com>, stable@vger.kerenl.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 stable-4.19 3/3] page_alloc: fix invalid watermark check on a negative value
Date:   Sun, 25 Sep 2022 03:35:29 -0700
Message-Id: <20220925103529.13716-4-yongw.pur@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220925103529.13716-1-yongw.pur@gmail.com>
References: <Yyn7MoSmV43Gxog4@kroah.com>
 <20220925103529.13716-1-yongw.pur@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaewon Kim <jaewon31.kim@samsung.com>

[ backport of commit 9282012fc0aa248b77a69f5eb802b67c5a16bb13 ]

There was a report that a task is waiting at the
throttle_direct_reclaim. The pgscan_direct_throttle in vmstat was
increasing.

This is a bug where zone_watermark_fast returns true even when the free
is very low. The commit f27ce0e14088 ("page_alloc: consider highatomic
reserve in watermark fast") changed the watermark fast to consider
highatomic reserve. But it did not handle a negative value case which
can be happened when reserved_highatomic pageblock is bigger than the
actual free.

If watermark is considered as ok for the negative value, allocating
contexts for order-0 will consume all free pages without direct reclaim,
and finally free page may become depleted except highatomic free.

Then allocating contexts may fall into throttle_direct_reclaim. This
symptom may easily happen in a system where wmark min is low and other
reclaimers like kswapd does not make free pages quickly.

Handle the negative case by using MIN.

Link: https://lkml.kernel.org/r/20220725095212.25388-1-jaewon31.kim@samsung.com
Fixes: f27ce0e14088 ("page_alloc: consider highatomic reserve in watermark fast")
Signed-off-by: Jaewon Kim <jaewon31.kim@samsung.com>
Reported-by: GyeongHwan Hong <gh21.hong@samsung.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Yong-Taek Lee <ytk.lee@samsung.com>
Cc: <stable@vger.kerenl.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 mm/page_alloc.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 237463d..d6d8a37 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3243,11 +3243,15 @@ static inline bool zone_watermark_fast(struct zone *z, unsigned int order,
 	 * need to be calculated.
 	 */
 	if (!order) {
-		long fast_free;
+		long usable_free;
+		long reserved;
 
-		fast_free = free_pages;
-		fast_free -= __zone_watermark_unusable_free(z, 0, alloc_flags);
-		if (fast_free > mark + z->lowmem_reserve[classzone_idx])
+		usable_free = free_pages;
+		reserved = __zone_watermark_unusable_free(z, 0, alloc_flags);
+
+		/* reserved may over estimate high-atomic reserves. */
+		usable_free -= min(usable_free, reserved);
+		if (usable_free > mark + z->lowmem_reserve[classzone_idx])
 			return true;
 	}
 
-- 
2.7.4
