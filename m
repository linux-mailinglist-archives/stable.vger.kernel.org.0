Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0619E5BB17D
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 19:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiIPRHT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 13:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiIPRHM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 13:07:12 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F451B69D7;
        Fri, 16 Sep 2022 10:07:03 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id s18so16059981plr.4;
        Fri, 16 Sep 2022 10:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date;
        bh=ZQ4epJy4kuC71aqt6/p49SxHHX9PRTr4w8eT6UANlFc=;
        b=UrXbed1sCIkZkoXBLB070iyqZTAzOAN2KFDdu45xcMpXshpGd3wMlebzLUat9IFHMt
         Y5kJ17jTnRaD8bsyStt0bfoTJv80SeaWYfcs0pTOtcHdsV9DmKouMLlcvsfuE4LPuOF7
         QAD1TAlbgowEDf0XOGYzNIcB/mNl9+CIr7sAdOBwFOaeyDg/45C7TEdvUxkcNvFhgAWA
         LjBxZ29QPC94uvnEM3upZDPSZBC9RQtIXM3vpLBqc6eo7TBHgRANzdWNnU8EXSDmzFTr
         qQZys+qqptAtEqvzt17ZSOLFRv5JCCWqhcJJ6Ky2Ypq2wXQDCTdsdOtSSLNtvsCeRk1V
         XdGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date;
        bh=ZQ4epJy4kuC71aqt6/p49SxHHX9PRTr4w8eT6UANlFc=;
        b=TW9eLMnD9+4i5p96vlHrDJDTMus13dWF+VyIqrocyNE7dodPccmNVHVvdY1DmnS4PZ
         g4GuPFhY+xtnGXjQN7AWx4DTifAUFR8EeKUni+dH6+e1eaTlR0nQ0bUmbryqlNrOWQ9o
         TWXsfehtmdhsX4t3dD+piaPhvoOdiFLGbfgmmY1lwT2yiZ3bHbFgc6au4lr/Qi/V/pxR
         /fH2iebfBPAznFzP+dho1gVXcqQ5VxTOSUoYcXYlfHTF3YLDxFz64lE7uyAKsQ/1Wbli
         neX0we0BmjIehTjxnBMeGPwvxLtYV/ESN9nwwPPHp1QPOVEZe4eRav4dcm0j0nuuG7xN
         XMjg==
X-Gm-Message-State: ACrzQf2CYzAHwSIQCl4c1dlFQf856IYq469y7yLgIv5EVFO8ChmyW0J3
        liOvGo6nFMO4GmRmoqAVwoc=
X-Google-Smtp-Source: AMsMyM7jbIDEJhuPlPlo7kKEFpNNyEEHgQV6Vx9+PE4XLaM6YEfj447Jz2V9H2h1kUCkdvWeAdoSbA==
X-Received: by 2002:a17:903:2290:b0:178:272b:e414 with SMTP id b16-20020a170903229000b00178272be414mr805886plh.120.1663348022490;
        Fri, 16 Sep 2022 10:07:02 -0700 (PDT)
Received: from localhost.localdomain ([117.176.186.9])
        by smtp.gmail.com with ESMTPSA id z12-20020a170903018c00b00176d4b093e1sm15386677plg.16.2022.09.16.10.06.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Sep 2022 10:07:02 -0700 (PDT)
From:   wangyong <yongw.pur@gmail.com>
X-Google-Original-From: wangyong <wang.yong12@zte.com.cn>
To:     gregkh@linuxfoundation.org
Cc:     jaewon31.kim@samsung.com, linux-kernel@vger.kernel.org,
        mhocko@kernel.org, stable@vger.kernel.org, wang.yong12@zte.com.cn,
        yongw.pur@gmail.com, Minchan Kim <minchan@kernel.org>,
        Baoquan He <bhe@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Yong-Taek Lee <ytk.lee@samsung.com>, stable@vger.kerenl.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/3] page_alloc: fix invalid watermark check on a negative value
Date:   Fri, 16 Sep 2022 10:05:49 -0700
Message-Id: <1663347949-20389-4-git-send-email-wang.yong12@zte.com.cn>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1663347949-20389-1-git-send-email-wang.yong12@zte.com.cn>
References: <YyREk5hHs2F0eWiE@kroah.com>
 <1663347949-20389-1-git-send-email-wang.yong12@zte.com.cn>
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

