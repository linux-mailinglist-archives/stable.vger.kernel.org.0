Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE435E9223
	for <lists+stable@lfdr.de>; Sun, 25 Sep 2022 12:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231887AbiIYKg2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Sep 2022 06:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231981AbiIYKgW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Sep 2022 06:36:22 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD6362657A;
        Sun, 25 Sep 2022 03:36:17 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id e68so4131857pfe.1;
        Sun, 25 Sep 2022 03:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date;
        bh=YAG2GxsE4t0bLfgPr5VW0shEES+/po3vvusQv2HA2Js=;
        b=ZKBYsn8b4JyPdzlQgKO6AtuR+1MIC5Q9s3QYeABYc1itK6dyDCShYPHgdEH/bnVbDe
         b0GGxMHYoOUyV7KlganFwPHdQVCfpwGrw9tnONyBmsgKR9TXsxPp873WWx74joDwO5sJ
         zFYeKahACv5zcwob7+WC782IngIosOd2rzUwFkSvoaAxw8AdnU7KeNuOASk8ZeBeOgHc
         ZGflSLoAxg9DJkXp/kGXHaxbi5Bks9DdGPgHjWsWRJgYh3C0UeaBve1l3OEajwP93TKj
         QzQa9T4KtPrVinRSUzaJJA047qANd4/tB0i5O+HMB3tljHEfWQFu/g0A0yoQbDxH0py9
         ThEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date;
        bh=YAG2GxsE4t0bLfgPr5VW0shEES+/po3vvusQv2HA2Js=;
        b=yMD2+guxD0DjTqrgiS6e+EYSXwtS+06OEhr2ybVj+Z4WRszW0a8v1Ss/HvusD6XnH6
         LdYUdppeEMsim8xkdBU+dJBcdfV1dGkPCgYvizTn/ZDi/YvE1HZmAtIc+KXI8LGbkaPu
         N6pTlhvKD7MxbORtlfputDsG3qSTjEApsFELKaLXNQQE55mNFzh5gMb6BzKBELscKkH3
         8KU4P93jXAHxnQ6Ifc4qhqznjF4G5RPNGhUXLXvfA3vfzJoeK5gA7Mw9XbafzQoinEJZ
         7oX+yw3rIoScC1/verE4EVQHXhdmmCvXZWPJlr4vvOSnSun/wIZOli0g6k3cXb89hbni
         V6UA==
X-Gm-Message-State: ACrzQf0Ap3RpfUjLwzSQg9uxd9EmZ1SCXFBkcCUfxKF0sQiOMe/e4t3M
        Oh6H02V6qztHs8h0mqfknug=
X-Google-Smtp-Source: AMsMyM5egCXT7bxRhZDz5usCGA9JNKcOH2iWdJFtii5xiC47CJtoBOEaMCrNiB9EMrc+qEHD/9FMdQ==
X-Received: by 2002:a63:525a:0:b0:42b:28a9:8a34 with SMTP id s26-20020a63525a000000b0042b28a98a34mr14733816pgl.269.1664102177039;
        Sun, 25 Sep 2022 03:36:17 -0700 (PDT)
Received: from ubuntu.localdomain ([117.176.186.252])
        by smtp.gmail.com with ESMTPSA id u4-20020a170902e80400b00179c81f6693sm3722183plg.264.2022.09.25.03.36.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Sep 2022 03:36:16 -0700 (PDT)
From:   wangyong <yongw.pur@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     jaewon31.kim@samsung.com, linux-kernel@vger.kernel.org,
        mhocko@kernel.org, stable@vger.kernel.org, wang.yong12@zte.com.cn,
        yongw.pur@gmail.com, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH v2 stable-4.19 1/3] mm/page_alloc: use ac->high_zoneidx for classzone_idx
Date:   Sun, 25 Sep 2022 03:35:27 -0700
Message-Id: <20220925103529.13716-2-yongw.pur@gmail.com>
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

From: Joonsoo Kim <iamjoonsoo.kim@lge.com>

[ backport of commit 3334a45eb9e2bb040c880ef65e1d72357a0a008b ]

Patch series "integrate classzone_idx and high_zoneidx", v5.

This patchset is followup of the problem reported and discussed two years
ago [1, 2].  The problem this patchset solves is related to the
classzone_idx on the NUMA system.  It causes a problem when the lowmem
reserve protection exists for some zones on a node that do not exist on
other nodes.

This problem was reported two years ago, and, at that time, the solution
got general agreements [2].  But it was not upstreamed.

[1]: http://lkml.kernel.org/r/20180102063528.GG30397@yexl-desktop
[2]: http://lkml.kernel.org/r/1525408246-14768-1-git-send-email-iamjoonsoo.kim@lge.com

This patch (of 2):

Currently, we use classzone_idx to calculate lowmem reserve proetection
for an allocation request.  This classzone_idx causes a problem on NUMA
systems when the lowmem reserve protection exists for some zones on a node
that do not exist on other nodes.

Before further explanation, I should first clarify how to compute the
classzone_idx and the high_zoneidx.

- ac->high_zoneidx is computed via the arcane gfp_zone(gfp_mask) and
  represents the index of the highest zone the allocation can use

- classzone_idx was supposed to be the index of the highest zone on the
  local node that the allocation can use, that is actually available in
  the system

Think about following example.  Node 0 has 4 populated zone,
DMA/DMA32/NORMAL/MOVABLE.  Node 1 has 1 populated zone, NORMAL.  Some
zones, such as MOVABLE, doesn't exist on node 1 and this makes following
difference.

Assume that there is an allocation request whose gfp_zone(gfp_mask) is the
zone, MOVABLE.  Then, it's high_zoneidx is 3.  If this allocation is
initiated on node 0, it's classzone_idx is 3 since actually
available/usable zone on local (node 0) is MOVABLE.  If this allocation is
initiated on node 1, it's classzone_idx is 2 since actually
available/usable zone on local (node 1) is NORMAL.

You can see that classzone_idx of the allocation request are different
according to their starting node, even if their high_zoneidx is the same.

Think more about these two allocation requests.  If they are processed on
local, there is no problem.  However, if allocation is initiated on node 1
are processed on remote, in this example, at the NORMAL zone on node 0,
due to memory shortage, problem occurs.  Their different classzone_idx
leads to different lowmem reserve and then different min watermark.  See
the following example.

root@ubuntu:/sys/devices/system/memory# cat /proc/zoneinfo
Node 0, zone      DMA
  per-node stats
...
  pages free     3965
        min      5
        low      8
        high     11
        spanned  4095
        present  3998
        managed  3977
        protection: (0, 2961, 4928, 5440)
...
Node 0, zone    DMA32
  pages free     757955
        min      1129
        low      1887
        high     2645
        spanned  1044480
        present  782303
        managed  758116
        protection: (0, 0, 1967, 2479)
...
Node 0, zone   Normal
  pages free     459806
        min      750
        low      1253
        high     1756
        spanned  524288
        present  524288
        managed  503620
        protection: (0, 0, 0, 4096)
...
Node 0, zone  Movable
  pages free     130759
        min      195
        low      326
        high     457
        spanned  1966079
        present  131072
        managed  131072
        protection: (0, 0, 0, 0)
...
Node 1, zone      DMA
  pages free     0
        min      0
        low      0
        high     0
        spanned  0
        present  0
        managed  0
        protection: (0, 0, 1006, 1006)
Node 1, zone    DMA32
  pages free     0
        min      0
        low      0
        high     0
        spanned  0
        present  0
        managed  0
        protection: (0, 0, 1006, 1006)
Node 1, zone   Normal
  per-node stats
...
  pages free     233277
        min      383
        low      640
        high     897
        spanned  262144
        present  262144
        managed  257744
        protection: (0, 0, 0, 0)
...
Node 1, zone  Movable
  pages free     0
        min      0
        low      0
        high     0
        spanned  262144
        present  0
        managed  0
        protection: (0, 0, 0, 0)

- static min watermark for the NORMAL zone on node 0 is 750.

- lowmem reserve for the request with classzone idx 3 at the NORMAL on
  node 0 is 4096.

- lowmem reserve for the request with classzone idx 2 at the NORMAL on
  node 0 is 0.

So, overall min watermark is:
allocation initiated on node 0 (classzone_idx 3): 750 + 4096 = 4846
allocation initiated on node 1 (classzone_idx 2): 750 + 0 = 750

Allocation initiated on node 1 will have some precedence than allocation
initiated on node 0 because min watermark of the former allocation is
lower than the other.  So, allocation initiated on node 1 could succeed on
node 0 when allocation initiated on node 0 could not, and, this could
cause too many numa_miss allocation.  Then, performance could be
downgraded.

Recently, there was a regression report about this problem on CMA patches
since CMA memory are placed in ZONE_MOVABLE by those patches.  I checked
that problem is disappeared with this fix that uses high_zoneidx for
classzone_idx.

http://lkml.kernel.org/r/20180102063528.GG30397@yexl-desktop

Using high_zoneidx for classzone_idx is more consistent way than previous
approach because system's memory layout doesn't affect anything to it.
With this patch, both classzone_idx on above example will be 3 so will
have the same min watermark.

allocation initiated on node 0: 750 + 4096 = 4846
allocation initiated on node 1: 750 + 4096 = 4846

One could wonder if there is a side effect that allocation initiated on
node 1 will use higher bar when allocation is handled on local since
classzone_idx could be higher than before.  It will not happen because the
zone without managed page doesn't contributes lowmem_reserve at all.

Reported-by: Ye Xiaolong <xiaolong.ye@intel.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Ye Xiaolong <xiaolong.ye@intel.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Link: http://lkml.kernel.org/r/1587095923-7515-1-git-send-email-iamjoonsoo.kim@lge.com
Link: http://lkml.kernel.org/r/1587095923-7515-2-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 mm/internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/internal.h b/mm/internal.h
index 3a2e973..922a173 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -123,7 +123,7 @@ struct alloc_context {
 	bool spread_dirty_pages;
 };
 
-#define ac_classzone_idx(ac) zonelist_zone_idx(ac->preferred_zoneref)
+#define ac_classzone_idx(ac) (ac->high_zoneidx)
 
 /*
  * Locate the struct page for both the matching buddy in our
-- 
2.7.4

