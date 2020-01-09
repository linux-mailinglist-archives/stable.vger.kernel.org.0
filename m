Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDF65135236
	for <lists+stable@lfdr.de>; Thu,  9 Jan 2020 05:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbgAIEkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 23:40:55 -0500
Received: from wnew1-smtp.messagingengine.com ([64.147.123.26]:57393 "EHLO
        wnew1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727749AbgAIEkz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 23:40:55 -0500
X-Greylist: delayed 600 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Jan 2020 23:40:54 EST
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.west.internal (Postfix) with ESMTP id 9CFC29EA;
        Wed,  8 Jan 2020 23:30:52 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Wed, 08 Jan 2020 23:30:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm3; bh=T3IpaNh6tON7Z0J6BNGMp35jqP
        cvLlQMXYRa9Ey0PUY=; b=FxKTRHnD4I2nmGm01m/Qrb7EJgiipwTTvsfnKL6dV1
        s0MFPFrsqYdD/E2cCt1VASFOwPnVIlTZxSM92nSFR73g8+4JM/0W7mAW3VE57ybY
        8kAIr2bKxW2SS9RZhd9VK9bw+rPXsxUaZ/Cn6njZugYT/xQx+cF8ADbc/ZzQEhn9
        iB/LLcvpQKtr7hAMWub89RtK9s4VqZnb1FDk1mvo19Onz5GZKzsX9iqAdoW9aIyl
        Uk7P4j179XNu7Fi1xikWDAAuc2/vN9lm72M8zlZjYMQrVnCFngWXDyRBR1xb2AXo
        YJj7s8aI1J7JTuZE+c//ir9wTL7GdY7soVP2BbxO3KmQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=T3IpaNh6tON7Z0J6B
        NGMp35jqPcvLlQMXYRa9Ey0PUY=; b=fzf7yeMtz23cZcpTYXNROyfZXuDYDWxSM
        PrUF7lFIuia0DLnBZypneihyxytRmi06aatmvWAKbjk5+rxA9cqhjB9+I7J+VYNk
        wdbdj/5sECQyAdmjDgRSPT8NVCJe3uQLG2UE43TaFHzkA1QkZ/iS4OetQGK+vlfR
        tj7fJ27E2115LaDLdhmNIXLdybDXM3DN9me9XJZFZMLBSWWpmxlnikGPlUjoR9lR
        YxSxLULWNWymcB5S4DLQbncxclBg5ZnPyjzIQxA3u0119jPwyOzdTHicJwA3ODHD
        c7Y3jrAANeBWFcVGwbOAxIghUZkyL3JsD16HrwIXs6rIX7Yo7fJjQ==
X-ME-Sender: <xms:e6wWXgvKKBsGJIcyFg7XNPj2Fpaa9yHUz2p4azCKG6cfevK2A3v6UQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdehledgieefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffoggfgsedtkeertdertddtnecuhfhrohhmpeetnhgurhgvshcu
    hfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucfkphepieejrd
    duiedtrddvudejrddvhedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrnhgurhgvshes
    rghnrghrrgiivghlrdguvgenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:e6wWXi8Ip0xs3ExUbEn6_9lmGFVpX4sgqniUjJ4ffg-xivB2EQW_HQ>
    <xmx:e6wWXkFN52PjyGQMnUJyW7wiWB99xdtKUqigRjwjvJv7C_iiYVCRHA>
    <xmx:e6wWXhQKh4qxHJX8Y8BEpDpYMy-HE9WCfzkoBqEjyDVRPRFCsYkaHA>
    <xmx:fKwWXmg-rKXlkTEMzsYzgteBs8zX7wYegz_5Gte9QyygyYdBetCcyB2m6Vs>
Received: from intern.anarazel.de (c-67-160-217-250.hsd1.ca.comcast.net [67.160.217.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id 272E18005B;
        Wed,  8 Jan 2020 23:30:51 -0500 (EST)
From:   Andres Freund <andres@anarazel.de>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Andres Freund <andres@anarazel.de>,
        Jiri Olsa <jolsa@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Michael Petlan <mpetlan@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org
Subject: [PATCH] perf c2c: Fix sorting.
Date:   Wed,  8 Jan 2020 20:30:30 -0800
Message-Id: <20200109043030.233746-1-andres@anarazel.de>
X-Mailer: git-send-email 2.25.0.rc1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 722ddfde366f ("perf tools: Fix time sorting") changed -
correctly so - hist_entry__sort to return int64. Unfortunately several
of the builtin-c2c.c comparison routines only happened to work due the
cast caused by the wrong return type.

This causes meaningless ordering of both the cacheline list, and the
cacheline details page. E.g a simple
  perf c2c record -a sleep 3
  perf c2c report
will result in cacheline table like
  =================================================
             Shared Data Cache Line Table
  =================================================
  #
  #        ----------- Cacheline ----------    Total      Tot  ----- LLC Load Hitm -----  ---- Store Reference ----  --- Load Dram ----      LLC    Total  ----- Core Load Hit -----  -- LLC Load Hit --
  # Index             Address  Node  PA cnt  records     Hitm    Total      Lcl      Rmt    Total    L1Hit   L1Miss       Lcl       Rmt  Ld Miss    Loads       FB       L1       L2       Llc       Rmt
  # .....  ..................  ....  ......  .......  .......  .......  .......  .......  .......  .......  .......  ........  ........  .......  .......  .......  .......  .......  ........  ........
  #
        0      0x7f0d27ffba00   N/A       0       52    0.12%       13        6        7       12       12        0         0         7       14       40        4       16        0         0         0
        1      0x7f0d27ff61c0   N/A       0     6353   14.04%     1475      801      674      779      779        0         0       718     1392     5574     1299     1967        0       115         0
        2      0x7f0d26d3ec80   N/A       0       71    0.15%       16        4       12       13       13        0         0        12       24       58        1       20        0         9         0
        3      0x7f0d26d3ec00   N/A       0       98    0.22%       23       17        6       19       19        0         0         6       12       79        0       40        0        10         0
i.e. with the list not being ordered by Total Hitm.

Fixes: 722ddfde366f ("perf tools: Fix time sorting")
Signed-off-by: Andres Freund <andres@anarazel.de>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Michael Petlan <mpetlan@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: stable@vger.kernel.org # v3.16+
---
 tools/perf/builtin-c2c.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index e69f44941aad..f2e9d2b1b913 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -595,8 +595,8 @@ tot_hitm_cmp(struct perf_hpp_fmt *fmt __maybe_unused,
 {
 	struct c2c_hist_entry *c2c_left;
 	struct c2c_hist_entry *c2c_right;
-	unsigned int tot_hitm_left;
-	unsigned int tot_hitm_right;
+	uint64_t tot_hitm_left;
+	uint64_t tot_hitm_right;
 
 	c2c_left  = container_of(left, struct c2c_hist_entry, he);
 	c2c_right = container_of(right, struct c2c_hist_entry, he);
@@ -629,7 +629,8 @@ __f ## _cmp(struct perf_hpp_fmt *fmt __maybe_unused,			\
 									\
 	c2c_left  = container_of(left, struct c2c_hist_entry, he);	\
 	c2c_right = container_of(right, struct c2c_hist_entry, he);	\
-	return c2c_left->stats.__f - c2c_right->stats.__f;		\
+	return (uint64_t) c2c_left->stats.__f -				\
+	       (uint64_t) c2c_right->stats.__f;				\
 }
 
 #define STAT_FN(__f)		\
@@ -682,7 +683,8 @@ ld_llcmiss_cmp(struct perf_hpp_fmt *fmt __maybe_unused,
 	c2c_left  = container_of(left, struct c2c_hist_entry, he);
 	c2c_right = container_of(right, struct c2c_hist_entry, he);
 
-	return llc_miss(&c2c_left->stats) - llc_miss(&c2c_right->stats);
+	return (uint64_t) llc_miss(&c2c_left->stats) -
+	       (uint64_t) llc_miss(&c2c_right->stats);
 }
 
 static uint64_t total_records(struct c2c_stats *stats)
-- 
2.25.0.rc1

