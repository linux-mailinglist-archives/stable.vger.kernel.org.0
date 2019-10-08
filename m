Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3203CFFB7
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 19:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbfJHRVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 13:21:46 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:55971 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725900AbfJHRVq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 13:21:46 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id D3C7A215B2;
        Tue,  8 Oct 2019 13:21:44 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 08 Oct 2019 13:21:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=T8LoCC
        PGxHQ+yz/nYB05yDtheELdnaggrEVZDsybLTE=; b=F5IdiNjEkm+hDUojDkPptF
        Qi2U1av8hgJPMQ5pwk9Z1R8rdQwvglsDiIxNtaGV42gk6bs098gu/OqAAtSTtEJO
        Kz9mvwXTaRgCDi7mBX14SLrbi8hwqQgVXWwMk1c4SOV3109xiIqSsMzd8R353UhE
        MJq75iXE2ZIVcy0WKj8n7T8165FhOxwkZ13Rz5ixTK6olzQoTaJhTAN4F10GHGL+
        IlS2V3Tcx/vOVjVPvVHFtJQY0NPCcRTyaYJb3ZboKjOyl9QjtM0++oHOUB80mTKX
        pzAyinFbsYCaFJy9UNmj1gweJd874aEROUF1VYJDXOa/Rai/FsFblZ7G2QAv7rRA
        ==
X-ME-Sender: <xms:qMWcXQxfDlLkk-ZRSmthctDr0yfr-hIeopjXMHBVRfEzxWyRJ5JoLQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheelgdduudegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpeei
X-ME-Proxy: <xmx:qMWcXbP6Z-KMqsWL5VXUW1O6FF-p2KiYL9CEy3DFcjsa2zbdE6Atag>
    <xmx:qMWcXbTF-fJ_HzwV-8347vJRNqbmmYpcyHV01l16lSMsMzdI6dhWug>
    <xmx:qMWcXWXdtpKjxB9NkLyf3HEksKhwtG9weB8P_m4xhYvUJoLA3IwJ3Q>
    <xmx:qMWcXVFWY36yXP1Fmh7EZkOivhwaomFRINcGmqwT9268gi12Wcix8A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6987680061;
        Tue,  8 Oct 2019 13:21:44 -0400 (EDT)
Subject: FAILED: patch "[PATCH] perf stat: Reset previous counts on repeat with interval" failed to apply to 5.3-stable tree
To:     srikar@linux.vnet.ibm.com, acme@redhat.com, eranian@google.com,
        jolsa@kernel.org, namhyung@kernel.org,
        naveen.n.rao@linux.vnet.ibm.com, ravi.bangoria@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Oct 2019 19:21:43 +0200
Message-ID: <157055530314038@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.3-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b63fd11cced17fcb8e133def29001b0f6aaa5e06 Mon Sep 17 00:00:00 2001
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Date: Wed, 4 Sep 2019 15:17:37 +0530
Subject: [PATCH] perf stat: Reset previous counts on repeat with interval

When using 'perf stat' with repeat and interval option, it shows wrong
values for events.

The wrong values will be shown for the first interval on the second and
subsequent repetitions.

Without the fix:

  # perf stat -r 3 -I 2000 -e faults -e sched:sched_switch -a sleep 5

     2.000282489                 53      faults
     2.000282489                513      sched:sched_switch
     4.005478208              3,721      faults
     4.005478208              2,666      sched:sched_switch
     5.025470933                395      faults
     5.025470933              1,307      sched:sched_switch
     2.009602825 1,84,46,74,40,73,70,95,47,520      faults 		<------
     2.009602825 1,84,46,74,40,73,70,95,49,568      sched:sched_switch  <------
     4.019612206              4,730      faults
     4.019612206              2,746      sched:sched_switch
     5.039615484              3,953      faults
     5.039615484              1,496      sched:sched_switch
     2.000274620 1,84,46,74,40,73,70,95,47,520      faults		<------
     2.000274620 1,84,46,74,40,73,70,95,47,520      sched:sched_switch	<------
     4.000480342              4,282      faults
     4.000480342              2,303      sched:sched_switch
     5.000916811              1,322      faults
     5.000916811              1,064      sched:sched_switch
  #

prev_raw_counts is allocated when using intervals. This is used when
calculating the difference in the counts of events when using interval.

The current counts are stored in prev_raw_counts to calculate the
differences in the next iteration.

On the first interval of the second and subsequent repetitions,
prev_raw_counts would be the values stored in the last interval of the
previous repetitions, while the current counts will only be for the
first interval of the current repetition.

Hence there is a possibility of events showing up as big number.

Fix this by resetting prev_raw_counts whenever perf stat repeats the
command.

With the fix:

  # perf stat -r 3 -I 2000 -e faults -e sched:sched_switch -a sleep 5

     2.019349347              2,597      faults
     2.019349347              2,753      sched:sched_switch
     4.019577372              3,098      faults
     4.019577372              2,532      sched:sched_switch
     5.019415481              1,879      faults
     5.019415481              1,356      sched:sched_switch
     2.000178813              8,468      faults
     2.000178813              2,254      sched:sched_switch
     4.000404621              7,440      faults
     4.000404621              1,266      sched:sched_switch
     5.040196079              2,458      faults
     5.040196079                556      sched:sched_switch
     2.000191939              6,870      faults
     2.000191939              1,170      sched:sched_switch
     4.000414103                541      faults
     4.000414103                902      sched:sched_switch
     5.000809863                450      faults
     5.000809863                364      sched:sched_switch
  #

Committer notes:

This was broken since the cset introducing the --interval feature, i.e.
--repeat + --interval wasn't tested at that point, add the Fixes tag so
that automatic scripts can pick this up.

Fixes: 13370a9b5bb8 ("perf stat: Add interval printing")
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Tested-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: stable@vger.kernel.org # v3.9+
Link: http://lore.kernel.org/lkml/20190904094738.9558-2-srikar@linux.vnet.ibm.com
[ Fixed up conflicts with libperf, i.e. some perf_{evsel,evlist} lost the 'perf' prefix ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index eece3d1e429a..fa4b148ecfca 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -1952,6 +1952,9 @@ int cmd_stat(int argc, const char **argv)
 			fprintf(output, "[ perf stat: executing run #%d ... ]\n",
 				run_idx + 1);
 
+		if (run_idx != 0)
+			perf_evlist__reset_prev_raw_counts(evsel_list);
+
 		status = run_perf_stat(argc, argv, run_idx);
 		if (forever && status != -1) {
 			print_counters(NULL, argc, argv);
diff --git a/tools/perf/util/stat.c b/tools/perf/util/stat.c
index 06571209cb0b..fcd54342c04c 100644
--- a/tools/perf/util/stat.c
+++ b/tools/perf/util/stat.c
@@ -162,6 +162,15 @@ static void perf_evsel__free_prev_raw_counts(struct evsel *evsel)
 	evsel->prev_raw_counts = NULL;
 }
 
+static void perf_evsel__reset_prev_raw_counts(struct evsel *evsel)
+{
+	if (evsel->prev_raw_counts) {
+		evsel->prev_raw_counts->aggr.val = 0;
+		evsel->prev_raw_counts->aggr.ena = 0;
+		evsel->prev_raw_counts->aggr.run = 0;
+       }
+}
+
 static int perf_evsel__alloc_stats(struct evsel *evsel, bool alloc_raw)
 {
 	int ncpus = perf_evsel__nr_cpus(evsel);
@@ -212,6 +221,14 @@ void perf_evlist__reset_stats(struct evlist *evlist)
 	}
 }
 
+void perf_evlist__reset_prev_raw_counts(struct evlist *evlist)
+{
+	struct evsel *evsel;
+
+	evlist__for_each_entry(evlist, evsel)
+		perf_evsel__reset_prev_raw_counts(evsel);
+}
+
 static void zero_per_pkg(struct evsel *counter)
 {
 	if (counter->per_pkg_mask)
diff --git a/tools/perf/util/stat.h b/tools/perf/util/stat.h
index 0f9c9f6e2041..edbeb2f63e8d 100644
--- a/tools/perf/util/stat.h
+++ b/tools/perf/util/stat.h
@@ -193,6 +193,7 @@ void perf_stat__collect_metric_expr(struct evlist *);
 int perf_evlist__alloc_stats(struct evlist *evlist, bool alloc_raw);
 void perf_evlist__free_stats(struct evlist *evlist);
 void perf_evlist__reset_stats(struct evlist *evlist);
+void perf_evlist__reset_prev_raw_counts(struct evlist *evlist);
 
 int perf_stat_process_counter(struct perf_stat_config *config,
 			      struct evsel *counter);

