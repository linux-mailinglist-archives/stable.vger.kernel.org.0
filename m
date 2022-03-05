Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A69AF4CE5F6
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 17:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbiCEQpl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 11:45:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiCEQpk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 11:45:40 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDD68972E5
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 08:44:48 -0800 (PST)
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 6F3CC3F1CB
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 16:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1646498686;
        bh=EDwfNFL1fK+rOF/m99RkTD5BEbFCgIKUCdGfm95Kzlk=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version:Content-Type;
        b=Q/tJWlIegY/WBWTTxSOc7+3LM6oJo1rYP5uUMwqCro1JRIXtmBDxXFKLHpI6XMJ3O
         Y59AEBGHbjXuzrHkOdfi/PxoLBzVbiM7JW1FQlpI0du3fWNPpbdV+VjhCnzyGaS1xt
         toSGW0ppJ8vZUlQFkm7GdEe8K9ybIPD1ntH0k8MXhsc/MqXFM31juxFE3bm+Tb7kIK
         1Uz10o5r2eTLTzy27eySvUqyIQb9ai5vi9xk2j5Qnco8eyta3cu575VekU/y2ECloA
         300r6qH66tzoFnpeqtv2E7+SpZgrngOZmxRJEc9P/cfnaifVYcFMyjAt7q1FXIhS8V
         +feA21gez/ulw==
Received: by mail-io1-f71.google.com with SMTP id c13-20020a5e8f0d000000b00644c39c4c69so7572350iok.4
        for <stable@vger.kernel.org>; Sat, 05 Mar 2022 08:44:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EDwfNFL1fK+rOF/m99RkTD5BEbFCgIKUCdGfm95Kzlk=;
        b=Klruv6Mgq75pULWdo5QVhz7I3n28adO/QK2EYrPInQJBTI/w2bT2oJICUqnMREZ2b3
         692dQTleKfLzuENyC8MqgZc8JCbqzW6+MzHlt1njVS6k9jXlGfzB+uZkuILFdWKEsu6t
         dbPeXRrzYHNMSxo0awpCt2Hc8W5RPib2wDMU8suo9ClgSKyR5c6BP7VDq6+1+Phi8zZm
         xuSYVO5sAQQOVpmOa1ZXolik+8sfPQ5PHUfveWygbRKsPk98hAv5N4DKSzhBh7Cbo3dG
         FdEIwQdc8SxI7KX5EAWHBYzsvo0oU+HZyc5O2eiENSO817sXS/TJ+kccMmAg3Jnv6bwE
         h8Pg==
X-Gm-Message-State: AOAM5333ricddraBB09pJd5I7WB6oGtmZuVjLhQG2ihDXpyy7qmMP0mF
        XnDBwV1KpmTpyM1Dy3Rq/dLmNP4mHHgLrnBcd+UeXNAGPrzfCF3OjJDRLSc4CFzBao438KtBAq4
        4HpoBElOIiGby4ATAA8HavEzXQBFWt3qvKw==
X-Received: by 2002:a92:130b:0:b0:2c5:66a6:cad8 with SMTP id 11-20020a92130b000000b002c566a6cad8mr3712782ilt.285.1646498684307;
        Sat, 05 Mar 2022 08:44:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyDIL4xYKIxwtQDdT4LeDC1u5qF2R2Oa0m+5CXIkLZMfPBEDhpYRvgI7Hw5afkDidS1ua6GEg==
X-Received: by 2002:a92:130b:0:b0:2c5:66a6:cad8 with SMTP id 11-20020a92130b000000b002c566a6cad8mr3712760ilt.285.1646498683999;
        Sat, 05 Mar 2022 08:44:43 -0800 (PST)
Received: from localhost (c-71-196-238-11.hsd1.co.comcast.net. [71.196.238.11])
        by smtp.gmail.com with ESMTPSA id b10-20020a056602000a00b0064074921986sm6351319ioa.41.2022.03.05.08.44.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 08:44:42 -0800 (PST)
From:   dann frazier <dann.frazier@canonical.com>
To:     stable@vger.kernel.org
Cc:     Miao Xie <miaox@cn.fujitsu.com>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Barry Song <song.bao.hua@hisilicon.com>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Sergei Trofimovich <slyfox@gentoo.org>,
        Anatoly Pugachev <matorola@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5.10+5.4 1/3] sched/topology: Make sched_init_numa() use a set for the deduplicating sort
Date:   Sat,  5 Mar 2022 09:44:28 -0700
Message-Id: <20220305164430.245125-2-dann.frazier@canonical.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220305164430.245125-1-dann.frazier@canonical.com>
References: <20220305164430.245125-1-dann.frazier@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valentin Schneider <valentin.schneider@arm.com>

commit 620a6dc40754dc218f5b6389b5d335e9a107fd29 upstream.

The deduplicating sort in sched_init_numa() assumes that the first line in
the distance table contains all unique values in the entire table. I've
been trying to pen what this exactly means for the topology, but it's not
straightforward. For instance, topology.c uses this example:

  node   0   1   2   3
    0:  10  20  20  30
    1:  20  10  20  20
    2:  20  20  10  20
    3:  30  20  20  10

  0 ----- 1
  |     / |
  |   /   |
  | /     |
  2 ----- 3

Which works out just fine. However, if we swap nodes 0 and 1:

  1 ----- 0
  |     / |
  |   /   |
  | /     |
  2 ----- 3

we get this distance table:

  node   0  1  2  3
    0:  10 20 20 20
    1:  20 10 20 30
    2:  20 20 10 20
    3:  20 30 20 10

Which breaks the deduplicating sort (non-representative first line). In
this case this would just be a renumbering exercise, but it so happens that
we can have a deduplicating sort that goes through the whole table in O(n²)
at the extra cost of a temporary memory allocation (i.e. any form of set).

The ACPI spec (SLIT) mentions distances are encoded on 8 bits. Following
this, implement the set as a 256-bits bitmap. Should this not be
satisfactory (i.e. we want to support 32-bit values), then we'll have to go
for some other sparse set implementation.

This has the added benefit of letting us allocate just the right amount of
memory for sched_domains_numa_distance[], rather than an arbitrary
(nr_node_ids + 1).

Note: DT binding equivalent (distance-map) decodes distances as 32-bit
values.

Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20210122123943.1217-2-valentin.schneider@arm.com
Signed-off-by: dann frazier <dann.frazier@canonical.com>
---
 include/linux/topology.h |  1 +
 kernel/sched/topology.c  | 99 +++++++++++++++++++---------------------
 2 files changed, 49 insertions(+), 51 deletions(-)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index ad03df1cc266..7634cd737061 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -48,6 +48,7 @@ int arch_update_cpu_topology(void);
 /* Conform to ACPI 2.0 SLIT distance definitions */
 #define LOCAL_DISTANCE		10
 #define REMOTE_DISTANCE		20
+#define DISTANCE_BITS           8
 #ifndef node_distance
 #define node_distance(from,to)	((from) == (to) ? LOCAL_DISTANCE : REMOTE_DISTANCE)
 #endif
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index dd7770226086..f2951eba9592 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -1549,66 +1549,58 @@ static void init_numa_topology_type(void)
 	}
 }
 
+
+#define NR_DISTANCE_VALUES (1 << DISTANCE_BITS)
+
 void sched_init_numa(void)
 {
-	int next_distance, curr_distance = node_distance(0, 0);
 	struct sched_domain_topology_level *tl;
-	int level = 0;
-	int i, j, k;
-
-	sched_domains_numa_distance = kzalloc(sizeof(int) * (nr_node_ids + 1), GFP_KERNEL);
-	if (!sched_domains_numa_distance)
-		return;
-
-	/* Includes NUMA identity node at level 0. */
-	sched_domains_numa_distance[level++] = curr_distance;
-	sched_domains_numa_levels = level;
+	unsigned long *distance_map;
+	int nr_levels = 0;
+	int i, j;
 
 	/*
 	 * O(nr_nodes^2) deduplicating selection sort -- in order to find the
 	 * unique distances in the node_distance() table.
-	 *
-	 * Assumes node_distance(0,j) includes all distances in
-	 * node_distance(i,j) in order to avoid cubic time.
 	 */
-	next_distance = curr_distance;
+	distance_map = bitmap_alloc(NR_DISTANCE_VALUES, GFP_KERNEL);
+	if (!distance_map)
+		return;
+
+	bitmap_zero(distance_map, NR_DISTANCE_VALUES);
 	for (i = 0; i < nr_node_ids; i++) {
 		for (j = 0; j < nr_node_ids; j++) {
-			for (k = 0; k < nr_node_ids; k++) {
-				int distance = node_distance(i, k);
-
-				if (distance > curr_distance &&
-				    (distance < next_distance ||
-				     next_distance == curr_distance))
-					next_distance = distance;
-
-				/*
-				 * While not a strong assumption it would be nice to know
-				 * about cases where if node A is connected to B, B is not
-				 * equally connected to A.
-				 */
-				if (sched_debug() && node_distance(k, i) != distance)
-					sched_numa_warn("Node-distance not symmetric");
+			int distance = node_distance(i, j);
 
-				if (sched_debug() && i && !find_numa_distance(distance))
-					sched_numa_warn("Node-0 not representative");
+			if (distance < LOCAL_DISTANCE || distance >= NR_DISTANCE_VALUES) {
+				sched_numa_warn("Invalid distance value range");
+				return;
 			}
-			if (next_distance != curr_distance) {
-				sched_domains_numa_distance[level++] = next_distance;
-				sched_domains_numa_levels = level;
-				curr_distance = next_distance;
-			} else break;
+
+			bitmap_set(distance_map, distance, 1);
 		}
+	}
+	/*
+	 * We can now figure out how many unique distance values there are and
+	 * allocate memory accordingly.
+	 */
+	nr_levels = bitmap_weight(distance_map, NR_DISTANCE_VALUES);
 
-		/*
-		 * In case of sched_debug() we verify the above assumption.
-		 */
-		if (!sched_debug())
-			break;
+	sched_domains_numa_distance = kcalloc(nr_levels, sizeof(int), GFP_KERNEL);
+	if (!sched_domains_numa_distance) {
+		bitmap_free(distance_map);
+		return;
+	}
+
+	for (i = 0, j = 0; i < nr_levels; i++, j++) {
+		j = find_next_bit(distance_map, NR_DISTANCE_VALUES, j);
+		sched_domains_numa_distance[i] = j;
 	}
 
+	bitmap_free(distance_map);
+
 	/*
-	 * 'level' contains the number of unique distances
+	 * 'nr_levels' contains the number of unique distances
 	 *
 	 * The sched_domains_numa_distance[] array includes the actual distance
 	 * numbers.
@@ -1617,15 +1609,15 @@ void sched_init_numa(void)
 	/*
 	 * Here, we should temporarily reset sched_domains_numa_levels to 0.
 	 * If it fails to allocate memory for array sched_domains_numa_masks[][],
-	 * the array will contain less then 'level' members. This could be
+	 * the array will contain less then 'nr_levels' members. This could be
 	 * dangerous when we use it to iterate array sched_domains_numa_masks[][]
 	 * in other functions.
 	 *
-	 * We reset it to 'level' at the end of this function.
+	 * We reset it to 'nr_levels' at the end of this function.
 	 */
 	sched_domains_numa_levels = 0;
 
-	sched_domains_numa_masks = kzalloc(sizeof(void *) * level, GFP_KERNEL);
+	sched_domains_numa_masks = kzalloc(sizeof(void *) * nr_levels, GFP_KERNEL);
 	if (!sched_domains_numa_masks)
 		return;
 
@@ -1633,7 +1625,7 @@ void sched_init_numa(void)
 	 * Now for each level, construct a mask per node which contains all
 	 * CPUs of nodes that are that many hops away from us.
 	 */
-	for (i = 0; i < level; i++) {
+	for (i = 0; i < nr_levels; i++) {
 		sched_domains_numa_masks[i] =
 			kzalloc(nr_node_ids * sizeof(void *), GFP_KERNEL);
 		if (!sched_domains_numa_masks[i])
@@ -1641,12 +1633,17 @@ void sched_init_numa(void)
 
 		for (j = 0; j < nr_node_ids; j++) {
 			struct cpumask *mask = kzalloc(cpumask_size(), GFP_KERNEL);
+			int k;
+
 			if (!mask)
 				return;
 
 			sched_domains_numa_masks[i][j] = mask;
 
 			for_each_node(k) {
+				if (sched_debug() && (node_distance(j, k) != node_distance(k, j)))
+					sched_numa_warn("Node-distance not symmetric");
+
 				if (node_distance(j, k) > sched_domains_numa_distance[i])
 					continue;
 
@@ -1658,7 +1655,7 @@ void sched_init_numa(void)
 	/* Compute default topology size */
 	for (i = 0; sched_domain_topology[i].mask; i++);
 
-	tl = kzalloc((i + level + 1) *
+	tl = kzalloc((i + nr_levels) *
 			sizeof(struct sched_domain_topology_level), GFP_KERNEL);
 	if (!tl)
 		return;
@@ -1681,7 +1678,7 @@ void sched_init_numa(void)
 	/*
 	 * .. and append 'j' levels of NUMA goodness.
 	 */
-	for (j = 1; j < level; i++, j++) {
+	for (j = 1; j < nr_levels; i++, j++) {
 		tl[i] = (struct sched_domain_topology_level){
 			.mask = sd_numa_mask,
 			.sd_flags = cpu_numa_flags,
@@ -1693,8 +1690,8 @@ void sched_init_numa(void)
 
 	sched_domain_topology = tl;
 
-	sched_domains_numa_levels = level;
-	sched_max_numa_distance = sched_domains_numa_distance[level - 1];
+	sched_domains_numa_levels = nr_levels;
+	sched_max_numa_distance = sched_domains_numa_distance[nr_levels - 1];
 
 	init_numa_topology_type();
 }
-- 
2.25.1

