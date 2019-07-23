Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE7C8717D2
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 14:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730000AbfGWMKz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 08:10:55 -0400
Received: from wnew3-smtp.messagingengine.com ([64.147.123.17]:60355 "EHLO
        wnew3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729441AbfGWMKz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 08:10:55 -0400
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Jul 2019 08:10:54 EDT
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.west.internal (Postfix) with ESMTP id 76FD0529;
        Tue, 23 Jul 2019 08:05:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 08:05:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=6EslOt
        OrMc9nGx9xnywjPAnI8yNEn5nu0KAME2Whklg=; b=AbEQySpXilPJ0+WTDtNVpW
        6NyjJfVI3Jj8NKYjmxHAHjhWw9Opj9qN12ViemjXA0lTXUK7A8ZNu6GHAeps4YcO
        dOxgScslO8obwlbewyg/9m8kfsAY9SDV/Dj7M0TPeFi6p/3BAY6FLQLiE16EyAha
        6dS2V62uXfYhjHb6nKAQ4ui9XYPkGQVorQK72raIUPblphUgqHJskNqkpmu1kRke
        aaGuW/SKxtXeKjisOeueOmBNAnHDZmjOfjGyG3VVKTF1bBYuwN8uBkB8xpN7hucv
        5FBVY4X4s7PR5LOpRCYC03Wr/f3A1Sg+AGLeFF7voqmq60QZx1hcMx2rZ61o+mfg
        ==
X-ME-Sender: <xms:HPg2Xe6Jo-DTAdFgxGYkv8GfFjuY5bAHXIKn-68ktwzUg3qnHnRDvA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgdegkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdhgihhthhhusgdrtghomhenucfkph
    epkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvghes
    khhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:HPg2XY0MLlsC3pjyRAFZCHFQFecaDKDqaxo58krUKZMNc41pRzO6eg>
    <xmx:HPg2XdwLi-g1fx6QLLG8fKPmvYKCq3PUFpSn2VgLZPS5rQWn2Aw0gw>
    <xmx:HPg2XZl-LVT6e2DSC9MnFd_yV8BLkesEg_lWXSjXp9RUvx_m2AjZoQ>
    <xmx:Hfg2XTjRH3gfItYL3xl2kEzcohXFEIIpvmwMqF6Sec-2N7BrLKJSjfag-S0>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 820F5380087;
        Tue, 23 Jul 2019 08:05:48 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mm: vmscan: scan anonymous pages on file refaults" failed to apply to 4.19-stable tree
To:     vovoy@chromium.org, akpm@linux-foundation.org, hannes@cmpxchg.org,
        mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org,
        riel@redhat.com, sonnyrao@chromium.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vdavydov.dev@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 14:05:47 +0200
Message-ID: <156388354793123@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2c012a4ad1a2cd3fb5a0f9307b9d219f84eda1fa Mon Sep 17 00:00:00 2001
From: Kuo-Hsin Yang <vovoy@chromium.org>
Date: Thu, 11 Jul 2019 20:52:04 -0700
Subject: [PATCH] mm: vmscan: scan anonymous pages on file refaults

When file refaults are detected and there are many inactive file pages,
the system never reclaim anonymous pages, the file pages are dropped
aggressively when there are still a lot of cold anonymous pages and
system thrashes.  This issue impacts the performance of applications
with large executable, e.g.  chrome.

With this patch, when file refault is detected, inactive_list_is_low()
always returns true for file pages in get_scan_count() to enable
scanning anonymous pages.

The problem can be reproduced by the following test program.

---8<---
void fallocate_file(const char *filename, off_t size)
{
	struct stat st;
	int fd;

	if (!stat(filename, &st) && st.st_size >= size)
		return;

	fd = open(filename, O_WRONLY | O_CREAT, 0600);
	if (fd < 0) {
		perror("create file");
		exit(1);
	}
	if (posix_fallocate(fd, 0, size)) {
		perror("fallocate");
		exit(1);
	}
	close(fd);
}

long *alloc_anon(long size)
{
	long *start = malloc(size);
	memset(start, 1, size);
	return start;
}

long access_file(const char *filename, long size, long rounds)
{
	int fd, i;
	volatile char *start1, *end1, *start2;
	const int page_size = getpagesize();
	long sum = 0;

	fd = open(filename, O_RDONLY);
	if (fd == -1) {
		perror("open");
		exit(1);
	}

	/*
	 * Some applications, e.g. chrome, use a lot of executable file
	 * pages, map some of the pages with PROT_EXEC flag to simulate
	 * the behavior.
	 */
	start1 = mmap(NULL, size / 2, PROT_READ | PROT_EXEC, MAP_SHARED,
		      fd, 0);
	if (start1 == MAP_FAILED) {
		perror("mmap");
		exit(1);
	}
	end1 = start1 + size / 2;

	start2 = mmap(NULL, size / 2, PROT_READ, MAP_SHARED, fd, size / 2);
	if (start2 == MAP_FAILED) {
		perror("mmap");
		exit(1);
	}

	for (i = 0; i < rounds; ++i) {
		struct timeval before, after;
		volatile char *ptr1 = start1, *ptr2 = start2;
		gettimeofday(&before, NULL);
		for (; ptr1 < end1; ptr1 += page_size, ptr2 += page_size)
			sum += *ptr1 + *ptr2;
		gettimeofday(&after, NULL);
		printf("File access time, round %d: %f (sec)
", i,
		       (after.tv_sec - before.tv_sec) +
		       (after.tv_usec - before.tv_usec) / 1000000.0);
	}
	return sum;
}

int main(int argc, char *argv[])
{
	const long MB = 1024 * 1024;
	long anon_mb, file_mb, file_rounds;
	const char filename[] = "large";
	long *ret1;
	long ret2;

	if (argc != 4) {
		printf("usage: thrash ANON_MB FILE_MB FILE_ROUNDS
");
		exit(0);
	}
	anon_mb = atoi(argv[1]);
	file_mb = atoi(argv[2]);
	file_rounds = atoi(argv[3]);

	fallocate_file(filename, file_mb * MB);
	printf("Allocate %ld MB anonymous pages
", anon_mb);
	ret1 = alloc_anon(anon_mb * MB);
	printf("Access %ld MB file pages
", file_mb);
	ret2 = access_file(filename, file_mb * MB, file_rounds);
	printf("Print result to prevent optimization: %ld
",
	       *ret1 + ret2);
	return 0;
}
---8<---

Running the test program on 2GB RAM VM with kernel 5.2.0-rc5, the program
fills ram with 2048 MB memory, access a 200 MB file for 10 times.  Without
this patch, the file cache is dropped aggresively and every access to the
file is from disk.

  $ ./thrash 2048 200 10
  Allocate 2048 MB anonymous pages
  Access 200 MB file pages
  File access time, round 0: 2.489316 (sec)
  File access time, round 1: 2.581277 (sec)
  File access time, round 2: 2.487624 (sec)
  File access time, round 3: 2.449100 (sec)
  File access time, round 4: 2.420423 (sec)
  File access time, round 5: 2.343411 (sec)
  File access time, round 6: 2.454833 (sec)
  File access time, round 7: 2.483398 (sec)
  File access time, round 8: 2.572701 (sec)
  File access time, round 9: 2.493014 (sec)

With this patch, these file pages can be cached.

  $ ./thrash 2048 200 10
  Allocate 2048 MB anonymous pages
  Access 200 MB file pages
  File access time, round 0: 2.475189 (sec)
  File access time, round 1: 2.440777 (sec)
  File access time, round 2: 2.411671 (sec)
  File access time, round 3: 1.955267 (sec)
  File access time, round 4: 0.029924 (sec)
  File access time, round 5: 0.000808 (sec)
  File access time, round 6: 0.000771 (sec)
  File access time, round 7: 0.000746 (sec)
  File access time, round 8: 0.000738 (sec)
  File access time, round 9: 0.000747 (sec)

Checked the swap out stats during the test [1], 19006 pages swapped out
with this patch, 3418 pages swapped out without this patch. There are
more swap out, but I think it's within reasonable range when file backed
data set doesn't fit into the memory.

$ ./thrash 2000 100 2100 5 1 # ANON_MB FILE_EXEC FILE_NOEXEC ROUNDS
PROCESSES Allocate 2000 MB anonymous pages active_anon: 1613644,
inactive_anon: 348656, active_file: 892, inactive_file: 1384 (kB)
pswpout: 7972443, pgpgin: 478615246 Access 100 MB executable file pages
Access 2100 MB regular file pages File access time, round 0: 12.165,
(sec) active_anon: 1433788, inactive_anon: 478116, active_file: 17896,
inactive_file: 24328 (kB) File access time, round 1: 11.493, (sec)
active_anon: 1430576, inactive_anon: 477144, active_file: 25440,
inactive_file: 26172 (kB) File access time, round 2: 11.455, (sec)
active_anon: 1427436, inactive_anon: 476060, active_file: 21112,
inactive_file: 28808 (kB) File access time, round 3: 11.454, (sec)
active_anon: 1420444, inactive_anon: 473632, active_file: 23216,
inactive_file: 35036 (kB) File access time, round 4: 11.479, (sec)
active_anon: 1413964, inactive_anon: 471460, active_file: 31728,
inactive_file: 32224 (kB) pswpout: 7991449 (+ 19006), pgpgin: 489924366
(+ 11309120)

With 4 processes accessing non-overlapping parts of a large file, 30316
pages swapped out with this patch, 5152 pages swapped out without this
patch.  The swapout number is small comparing to pgpgin.

[1]: https://github.com/vovo/testing/blob/master/mem_thrash.c

Link: http://lkml.kernel.org/r/20190701081038.GA83398@google.com
Fixes: e9868505987a ("mm,vmscan: only evict file pages when we have plenty")
Fixes: 7c5bd705d8f9 ("mm: memcg: only evict file pages when we have plenty")
Signed-off-by: Kuo-Hsin Yang <vovoy@chromium.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Sonny Rao <sonnyrao@chromium.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>	[4.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 910e02c793ff..96aafbf8ce4e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2125,7 +2125,7 @@ static void shrink_active_list(unsigned long nr_to_scan,
  *   10TB     320        32GB
  */
 static bool inactive_list_is_low(struct lruvec *lruvec, bool file,
-				 struct scan_control *sc, bool actual_reclaim)
+				 struct scan_control *sc, bool trace)
 {
 	enum lru_list active_lru = file * LRU_FILE + LRU_ACTIVE;
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
@@ -2151,7 +2151,7 @@ static bool inactive_list_is_low(struct lruvec *lruvec, bool file,
 	 * rid of the stale workingset quickly.
 	 */
 	refaults = lruvec_page_state_local(lruvec, WORKINGSET_ACTIVATE);
-	if (file && actual_reclaim && lruvec->refaults != refaults) {
+	if (file && lruvec->refaults != refaults) {
 		inactive_ratio = 0;
 	} else {
 		gb = (inactive + active) >> (30 - PAGE_SHIFT);
@@ -2161,7 +2161,7 @@ static bool inactive_list_is_low(struct lruvec *lruvec, bool file,
 			inactive_ratio = 1;
 	}
 
-	if (actual_reclaim)
+	if (trace)
 		trace_mm_vmscan_inactive_list_is_low(pgdat->node_id, sc->reclaim_idx,
 			lruvec_lru_size(lruvec, inactive_lru, MAX_NR_ZONES), inactive,
 			lruvec_lru_size(lruvec, active_lru, MAX_NR_ZONES), active,

