Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7A76D7A8D
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 13:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237644AbjDELB3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 07:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237270AbjDELB1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 07:01:27 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A3C46B2;
        Wed,  5 Apr 2023 04:01:25 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id lr16-20020a17090b4b9000b0023f187954acso36866841pjb.2;
        Wed, 05 Apr 2023 04:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680692485;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iJGAMvCER1Maz71WC4+d0+uJtDiWgp7hdUA5ioSAboA=;
        b=hEwXkknLt4/QXa+iW0HAL1xHl2WxZgLYRd25Wix9ug2M31GthLBb2gQ6B1KHAgXFRk
         Hh56NWJFg7+Ht4moggFzSw48UXB8Sk/EUlNXy3uuEjfN3DVjZL0pVD+8lW7VP91OxaLE
         61bF6FVt4o7Lhk88ghkElEEb7JR5ZiCEV3Ij681bdG2GeGtONm1VNGG+6R5zvKPW6+Gb
         Bck/Qui9VdXuYTqFW9edEpdO35H9mHE1rAS8wbKxe/PmbsBhwdlHt6Kk0T3+3uuwiRdq
         lmfbu6GhcYExWgxYgtFlDtBOVC5pTlLRWAYTf3t/iwF8FUi5Jk+5cxvW89+5FeG2KmE2
         fhPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680692485;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iJGAMvCER1Maz71WC4+d0+uJtDiWgp7hdUA5ioSAboA=;
        b=tBizntVRLlLVmZTe6Mr3P1wwgXuKR3Z1pSN9H6WyBXRjvUgOBXKW0fYRgQAJRJKM/g
         GhgTZViMhXR7h3EOJS7PEk0VH+58h5TUs9Im+rnnKaL7XuBZPqHkOYBGXtnvXTmoKaiI
         yAehwvBC+fyGiDtkz1gZwSiiPE2TLy/aqdSXNUcC8sqCCrP4wIiayklmkTlTtc1YtuGw
         Cd5hZIYCDXR1UwVk3E9E30KwAdeFvemvPF/cVFq+sblwwXL00BKna3nWex9NKUCmvEXY
         riOv5qdOA4/lqbOz8X15jgJW+RqFSSSeNM9OV5qCKihD7wvzJ/QVTsO69lCsUQHvQWdE
         S9vw==
X-Gm-Message-State: AAQBX9fpTl3aWz4b0CNvFI0THOX04s9WFG/UMphy2zpvHvdXM0MYzIbw
        Q6DYtZhOd39LiWKPtsP/NTA=
X-Google-Smtp-Source: AKy350YwlKoCBpiBymdY26Utiux0aRqLnTsThq8o6n5gNgRGHnQlVHaic+BuLQMT7CE0kVxzyTniAQ==
X-Received: by 2002:a17:90b:1b09:b0:237:f925:f63 with SMTP id nu9-20020a17090b1b0900b00237f9250f63mr6383415pjb.13.1680692484650;
        Wed, 05 Apr 2023 04:01:24 -0700 (PDT)
Received: from lunar.aeonazure.com ([182.2.143.216])
        by smtp.gmail.com with ESMTPSA id f11-20020a17090274cb00b001a065d3bb0esm9831373plt.211.2023.04.05.04.01.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 04:01:24 -0700 (PDT)
From:   Shaun Tancheff <shaun.tancheff@gmail.com>
To:     Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>
Cc:     Shaun Tancheff <shaun.tancheff@hpe.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] memcg-v1: Enable setting memory min, low, high
Date:   Wed,  5 Apr 2023 18:01:07 +0700
Message-Id: <20230405110107.127156-1-shaun.tancheff@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shaun Tancheff <shaun.tancheff@hpe.com>

For users that are unable to update to memcg-v2 this
provides a method where memcg-v1 can more effectively
apply enough memory pressure to effectively throttle
filesystem I/O or otherwise minimize being memcg oom
killed at the expense of reduced performance.

This patch extends the memcg-v1 legacy sysfs entries
with:
    limit_in_bytes.min, limit_in_bytes.low and
    limit_in_bytes.high
Since old software will need to be updated to take
advantage of the new files a secondary method
of setting min, low and high based on a percentage
of the limit is also provided. The percentages
are determined by module parameters.

The available module parameters can be set at
kernel boot time, for example:
   memcontrol.memcg_min=10
   memcontrol.memcg_low=30
   memcontrol.memcg_high=80

Would set min to 10%, low to 30% and high to 80% of
the value written to:
  /sys/fs/cgroup/memory/<grp>/memory.limit_in_bytes

Signed-off-by: Shaun Tancheff <shaun.tancheff@hpe.com>
---
v0: Initial hard coded limits by percent.
v1: Added sysfs access and module parameters for percent values to enable
v2: Fix 32-bit, remove need for missing __udivdi3
 mm/memcontrol.c | 83 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 82 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2eee092f8f11..3cf8386f4f45 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -73,6 +73,18 @@
 
 #include <trace/events/vmscan.h>
 
+static unsigned int memcg_v1_min_default_percent;
+module_param_named(memcg_min, memcg_v1_min_default_percent, uint, 0600);
+MODULE_PARM_DESC(memcg_min, "memcg v1 min default percent");
+
+static unsigned int memcg_v1_low_default_percent;
+module_param_named(memcg_low, memcg_v1_low_default_percent, uint, 0600);
+MODULE_PARM_DESC(memcg_low, "memcg v1 low default percent");
+
+static unsigned int memcg_v1_high_default_percent;
+module_param_named(memcg_high, memcg_v1_high_default_percent, uint, 0600);
+MODULE_PARM_DESC(memcg_high, "memcg v1 high default percent");
+
 struct cgroup_subsys memory_cgrp_subsys __read_mostly;
 EXPORT_SYMBOL(memory_cgrp_subsys);
 
@@ -205,6 +217,7 @@ enum res_type {
 	_MEMSWAP,
 	_KMEM,
 	_TCP,
+	_MEM_V1,
 };
 
 #define MEMFILE_PRIVATE(x, val)	((x) << 16 | (val))
@@ -3676,6 +3689,9 @@ enum {
 	RES_MAX_USAGE,
 	RES_FAILCNT,
 	RES_SOFT_LIMIT,
+	RES_LIMIT_MIN,
+	RES_LIMIT_LOW,
+	RES_LIMIT_HIGH,
 };
 
 static u64 mem_cgroup_read_u64(struct cgroup_subsys_state *css,
@@ -3686,6 +3702,7 @@ static u64 mem_cgroup_read_u64(struct cgroup_subsys_state *css,
 
 	switch (MEMFILE_TYPE(cft->private)) {
 	case _MEM:
+	case _MEM_V1:
 		counter = &memcg->memory;
 		break;
 	case _MEMSWAP:
@@ -3716,6 +3733,12 @@ static u64 mem_cgroup_read_u64(struct cgroup_subsys_state *css,
 		return counter->failcnt;
 	case RES_SOFT_LIMIT:
 		return (u64)memcg->soft_limit * PAGE_SIZE;
+	case RES_LIMIT_MIN:
+		return (u64)READ_ONCE(memcg->memory.min);
+	case RES_LIMIT_LOW:
+		return (u64)READ_ONCE(memcg->memory.low);
+	case RES_LIMIT_HIGH:
+		return (u64)READ_ONCE(memcg->memory.high);
 	default:
 		BUG();
 	}
@@ -3815,6 +3838,34 @@ static int memcg_update_tcp_max(struct mem_cgroup *memcg, unsigned long max)
 	return ret;
 }
 
+static inline void mem_cgroup_v1_set_defaults(struct mem_cgroup *memcg,
+					      unsigned long nr_pages)
+{
+	unsigned long min, low, high;
+
+	if (mem_cgroup_is_root(memcg) || PAGE_COUNTER_MAX == nr_pages)
+		return;
+
+	min = READ_ONCE(memcg->memory.min);
+	low = READ_ONCE(memcg->memory.low);
+	if (min || low)
+		return;
+
+	if (!min && memcg_v1_min_default_percent) {
+		min = (nr_pages * memcg_v1_min_default_percent) / 100;
+		page_counter_set_min(&memcg->memory, min);
+	}
+	if (!low && memcg_v1_low_default_percent) {
+		low = (nr_pages * memcg_v1_low_default_percent) / 100;
+		page_counter_set_low(&memcg->memory, low);
+	}
+	high = READ_ONCE(memcg->memory.high);
+	if (high == PAGE_COUNTER_MAX && memcg_v1_high_default_percent) {
+		high = (nr_pages * memcg_v1_high_default_percent) / 100;
+		page_counter_set_high(&memcg->memory, high);
+	}
+}
+
 /*
  * The user of this function is...
  * RES_LIMIT.
@@ -3838,6 +3889,11 @@ static ssize_t mem_cgroup_write(struct kernfs_open_file *of,
 			break;
 		}
 		switch (MEMFILE_TYPE(of_cft(of)->private)) {
+		case _MEM_V1:
+			ret = mem_cgroup_resize_max(memcg, nr_pages, false);
+			if (!ret)
+				mem_cgroup_v1_set_defaults(memcg, nr_pages);
+			break;
 		case _MEM:
 			ret = mem_cgroup_resize_max(memcg, nr_pages, false);
 			break;
@@ -4986,6 +5042,13 @@ static int mem_cgroup_slab_show(struct seq_file *m, void *p)
 }
 #endif
 
+static ssize_t memory_min_write(struct kernfs_open_file *of,
+				char *buf, size_t nbytes, loff_t off);
+static ssize_t memory_low_write(struct kernfs_open_file *of,
+				char *buf, size_t nbytes, loff_t off);
+static ssize_t memory_high_write(struct kernfs_open_file *of,
+				 char *buf, size_t nbytes, loff_t off);
+
 static struct cftype mem_cgroup_legacy_files[] = {
 	{
 		.name = "usage_in_bytes",
@@ -5000,10 +5063,28 @@ static struct cftype mem_cgroup_legacy_files[] = {
 	},
 	{
 		.name = "limit_in_bytes",
-		.private = MEMFILE_PRIVATE(_MEM, RES_LIMIT),
+		.private = MEMFILE_PRIVATE(_MEM_V1, RES_LIMIT),
 		.write = mem_cgroup_write,
 		.read_u64 = mem_cgroup_read_u64,
 	},
+	{
+		.name = "limit_in_bytes.min",
+		.private = MEMFILE_PRIVATE(_MEM_V1, RES_LIMIT_MIN),
+		.write = memory_min_write,
+		.read_u64 = mem_cgroup_read_u64,
+	},
+	{
+		.name = "limit_in_bytes.low",
+		.private = MEMFILE_PRIVATE(_MEM_V1, RES_LIMIT_LOW),
+		.write = memory_low_write,
+		.read_u64 = mem_cgroup_read_u64,
+	},
+	{
+		.name = "limit_in_bytes.high",
+		.private = MEMFILE_PRIVATE(_MEM_V1, RES_LIMIT_HIGH),
+		.write = memory_high_write,
+		.read_u64 = mem_cgroup_read_u64,
+	},
 	{
 		.name = "soft_limit_in_bytes",
 		.private = MEMFILE_PRIVATE(_MEM, RES_SOFT_LIMIT),
-- 
2.34.1

