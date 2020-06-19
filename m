Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0082200AE8
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 16:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgFSOHQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:07:16 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:41303 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726008AbgFSOHQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 10:07:16 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 32FB1194599E;
        Fri, 19 Jun 2020 10:07:15 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 19 Jun 2020 10:07:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=u+/WaT
        AyFpm0F3UeWykLa7UQhMMVifvtVPltQxM7NPU=; b=E8AeUwm8CLc6TfBwEh0/L6
        BOH5pKrQTjSSTc0WSGmTCp+TyvR8rnWoFu93DMGHPkAVLCOUhLP55CCVMCko5MGn
        /td8FaYNhYF26pWwcTgyZaUKg/NRGrxodL6ALubFyGAiFkPOKMjmtPqwjvbMWzeZ
        Ev5P+rpAaHpCALa9QH5VQeiQR6nV1GcBuFzK6Ps5x25tERgcoPA7wmOqT7hoF4Xy
        yYzi1VwWTk2HKK/qA0FmV29oxH4ZQqXw5iXnVQ1KDCLzUNCsd7mKmIfhR5XITUck
        mVpde8ddTN5DCUSIXyhsz8Z0E6aZwDR5WlP5ZXm+K8QrBRlx8lMcNvTLuhdR5DXQ
        ==
X-ME-Sender: <xms:k8bsXlX5X69YRrK4m16DbU18ND59V9jDd4fQ7U3SqscrhVxNcxED2A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejiedgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:k8bsXlmjMb6z0m5o2QdhyjEoD-ncOI05IJ5isTTsqyq-bJgIBnd4PQ>
    <xmx:k8bsXhbbUE-Zcse4MmrMHsE37QeiB-jLJu9uV5Mva1eJezLH-DvCew>
    <xmx:k8bsXoV4brt2zjzjnqhwFKbdGeVobA6U__dlj27ABezsvyZPzWyu1Q>
    <xmx:k8bsXnsvqOehBV32QqBlLZ77svbXIaLodYwN3oIXbZ-91cf5opD7CA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D503B30614FA;
        Fri, 19 Jun 2020 10:07:14 -0400 (EDT)
Subject: FAILED: patch "[PATCH] perf probe: Fix to check blacklist address correctly" failed to apply to 4.9-stable tree
To:     mhiramat@kernel.org, acme@redhat.com, jolsa@kernel.org,
        namhyung@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 19 Jun 2020 16:07:05 +0200
Message-ID: <159257562524637@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 80526491c2ca6abc028c0f0dbb0707a1f35fb18a Mon Sep 17 00:00:00 2001
From: Masami Hiramatsu <mhiramat@kernel.org>
Date: Thu, 23 Apr 2020 20:01:04 +0900
Subject: [PATCH] perf probe: Fix to check blacklist address correctly

Fix to check kprobe blacklist address correctly with relocated address
by adjusting debuginfo address.

Since the address in the debuginfo is same as objdump, it is different
from relocated kernel address with KASLR.  Thus, 'perf probe' always
misses to catch the blacklisted addresses.

Without this patch, 'perf probe' can not detect the blacklist addresses
on a KASLR enabled kernel.

  # perf probe kprobe_dispatcher
  Failed to write event: Invalid argument
    Error: Failed to add events.
  #

With this patch, it correctly shows the error message.

  # perf probe kprobe_dispatcher
  kprobe_dispatcher is blacklisted function, skip it.
  Probe point 'kprobe_dispatcher' not found.
    Error: Failed to add events.
  #

Fixes: 9aaf5a5f479b ("perf probe: Check kprobes blacklist when adding new events")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: stable@vger.kernel.org
Link: http://lore.kernel.org/lkml/158763966411.30755.5882376357738273695.stgit@devnote2
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index c6bcf5709564..63d936f6e993 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -102,7 +102,7 @@ void exit_probe_symbol_maps(void)
 	symbol__exit();
 }
 
-static struct ref_reloc_sym *kernel_get_ref_reloc_sym(void)
+static struct ref_reloc_sym *kernel_get_ref_reloc_sym(struct map **pmap)
 {
 	/* kmap->ref_reloc_sym should be set if host_machine is initialized */
 	struct kmap *kmap;
@@ -114,6 +114,10 @@ static struct ref_reloc_sym *kernel_get_ref_reloc_sym(void)
 	kmap = map__kmap(map);
 	if (!kmap)
 		return NULL;
+
+	if (pmap)
+		*pmap = map;
+
 	return kmap->ref_reloc_sym;
 }
 
@@ -125,7 +129,7 @@ static int kernel_get_symbol_address_by_name(const char *name, u64 *addr,
 	struct map *map;
 
 	/* ref_reloc_sym is just a label. Need a special fix*/
-	reloc_sym = kernel_get_ref_reloc_sym();
+	reloc_sym = kernel_get_ref_reloc_sym(NULL);
 	if (reloc_sym && strcmp(name, reloc_sym->name) == 0)
 		*addr = (reloc) ? reloc_sym->addr : reloc_sym->unrelocated_addr;
 	else {
@@ -745,6 +749,7 @@ post_process_kernel_probe_trace_events(struct probe_trace_event *tevs,
 				       int ntevs)
 {
 	struct ref_reloc_sym *reloc_sym;
+	struct map *map;
 	char *tmp;
 	int i, skipped = 0;
 
@@ -753,7 +758,7 @@ post_process_kernel_probe_trace_events(struct probe_trace_event *tevs,
 		return post_process_offline_probe_trace_events(tevs, ntevs,
 						symbol_conf.vmlinux_name);
 
-	reloc_sym = kernel_get_ref_reloc_sym();
+	reloc_sym = kernel_get_ref_reloc_sym(&map);
 	if (!reloc_sym) {
 		pr_warning("Relocated base symbol is not found!\n");
 		return -EINVAL;
@@ -764,9 +769,13 @@ post_process_kernel_probe_trace_events(struct probe_trace_event *tevs,
 			continue;
 		if (tevs[i].point.retprobe && !kretprobe_offset_is_supported())
 			continue;
-		/* If we found a wrong one, mark it by NULL symbol */
+		/*
+		 * If we found a wrong one, mark it by NULL symbol.
+		 * Since addresses in debuginfo is same as objdump, we need
+		 * to convert it to addresses on memory.
+		 */
 		if (kprobe_warn_out_range(tevs[i].point.symbol,
-					  tevs[i].point.address)) {
+			map__objdump_2mem(map, tevs[i].point.address))) {
 			tmp = NULL;
 			skipped++;
 		} else {
@@ -2935,7 +2944,7 @@ static int find_probe_trace_events_from_map(struct perf_probe_event *pev,
 	/* Note that the symbols in the kmodule are not relocated */
 	if (!pev->uprobes && !pev->target &&
 			(!pp->retprobe || kretprobe_offset_is_supported())) {
-		reloc_sym = kernel_get_ref_reloc_sym();
+		reloc_sym = kernel_get_ref_reloc_sym(NULL);
 		if (!reloc_sym) {
 			pr_warning("Relocated base symbol is not found!\n");
 			ret = -EINVAL;

