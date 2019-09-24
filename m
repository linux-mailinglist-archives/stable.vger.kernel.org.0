Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCBBBC1A5
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 08:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438582AbfIXGRa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 02:17:30 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45028 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387676AbfIXGRa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Sep 2019 02:17:30 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8O6CxZ8047521
        for <stable@vger.kernel.org>; Tue, 24 Sep 2019 02:17:28 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2v7btnb2xu-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 24 Sep 2019 02:17:28 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <srikar@linux.vnet.ibm.com>;
        Tue, 24 Sep 2019 07:17:26 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 24 Sep 2019 07:17:22 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8O6HLiG44695800
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Sep 2019 06:17:21 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 71141A405F;
        Tue, 24 Sep 2019 06:17:21 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D7EC2A405B;
        Tue, 24 Sep 2019 06:17:19 +0000 (GMT)
Received: from linux.vnet.ibm.com (unknown [9.122.211.244])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Tue, 24 Sep 2019 06:17:19 +0000 (GMT)
Date:   Tue, 24 Sep 2019 11:47:19 +0530
From:   Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH 26/31] perf stat: Reset previous counts on repeat with
 interval
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20190920142542.12047-27-acme@kernel.org>
 <20190921120623.7B67920717@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20190921120623.7B67920717@mail.kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-TM-AS-GCONF: 00
x-cbid: 19092406-0016-0000-0000-000002AFDD44
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19092406-0017-0000-0000-000033109DC1
Message-Id: <20190924061719.GA4705@linux.vnet.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-24_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909240063
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: 13370a9b5bb8 perf stat: Add interval printing.
> 
> The bot has tested the following trees: v5.2.16, v4.19.74, v4.14.145, v4.9.193, v4.4.193.
> 
> v5.2.16: Failed to apply! Possible dependencies:
>     1c839a5a4061 ("perf cs-etm: Configure timestamp generation in CPU-wide mode")
>     32dcd021d004 ("perf evsel: Rename struct perf_evsel to struct evsel")
>     3399ad9ac234 ("perf cs-etm: Configure contextID tracing in CPU-wide mode")
>     acae8b36cded ("perf header: Add die information in CPU topology")
>     b74d8686a18b ("perf cpumap: Retrieve die id information")
>     db5742b6849e ("perf stat: Support per-die aggregation")
>     f854839ba2a5 ("perf cpu_map: Rename struct cpu_map to struct perf_cpu_map")
> 
> v4.19.74: Failed to apply! Possible dependencies:
>     121dd9ea0116 ("perf bench: Add epoll parallel epoll_wait benchmark")
>     1c839a5a4061 ("perf cs-etm: Configure timestamp generation in CPU-wide mode")
>     231457ec7074 ("perf bench: Add epoll_ctl(2) benchmark")
>     32dcd021d004 ("perf evsel: Rename struct perf_evsel to struct evsel")
>     3399ad9ac234 ("perf cs-etm: Configure contextID tracing in CPU-wide mode")
>     6ca9a082b190 ("perf stat: Pass a 'struct perf_stat_config' argument to global print functions")
>     6f6b6594b5f3 ("perf stat: Move *_aggr_* data to 'struct perf_stat_config'")
>     77e0faf8552c ("perf stat: Pass 'evlist' to aggr_update_shadow()")
>     8897a8916efb ("perf stat: Move ru_* data to 'struct perf_stat_config'")
>     ae2d7da554f0 ("perf stat: Pass 'struct perf_stat_config' to first_shadow_cpu()")
>     d97ae04b3d52 ("perf stat: Move 'run_count' to 'struct perf_stat_config'")
>     df4f7b4d4b1e ("perf stat: Move 'unit_width' to 'struct perf_stat_config'")
>     f3ca50e61ff4 ("perf stat: Pass 'struct perf_stat_config' argument to local print functions")
>     f854839ba2a5 ("perf cpu_map: Rename struct cpu_map to struct perf_cpu_map")
>     fa4e819bbca9 ("perf arm cs-etm: Use event attributes to send sink information to kernel")
>     fa7070a38676 ("perf stat: Move csv_* to 'struct perf_stat_config'")
> 

As suggested by Arnaldo, I am adding my patch which applies and
builds well on v5.2.16 and v4.14.145. This one differs from the one
committed by Arnaldo with respect to structure name change.

Meanwhile I will investigate on v4.14.145 v4.9.193 v4.4.193 and get back to
to you.

-- 
Thanks and Regards
Srikar Dronamraju

---->8------------8<-----------------
From b63fd11cced17fcb8e133def29001b0f6aaa5e06 Mon Sep 17 00:00:00 2001
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Date: Wed, 4 Sep 2019 15:17:37 +0530
Subject: [PATCH 1/2] perf stat: Reset previous counts on repeat with interval

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
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c |  3 +++
 tools/perf/util/stat.c    | 17 +++++++++++++++++
 tools/perf/util/stat.h    |  1 +
 3 files changed, 21 insertions(+)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 352cf39d7c2f..eda451842bfd 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -1961,6 +1961,9 @@ int cmd_stat(int argc, const char **argv)
 			fprintf(output, "[ perf stat: executing run #%d ... ]\n",
 				run_idx + 1);
 
+		if (run_idx != 0)
+			perf_evlist__reset_prev_raw_counts(evsel_list);
+
 		status = run_perf_stat(argc, argv, run_idx);
 		if (forever && status != -1) {
 			print_counters(NULL, argc, argv);
diff --git a/tools/perf/util/stat.c b/tools/perf/util/stat.c
index db8a6cf336be..773f29d4f6a7 100644
--- a/tools/perf/util/stat.c
+++ b/tools/perf/util/stat.c
@@ -155,6 +155,15 @@ static void perf_evsel__free_prev_raw_counts(struct perf_evsel *evsel)
 	evsel->prev_raw_counts = NULL;
 }
 
+static void perf_evsel__reset_prev_raw_counts(struct perf_evsel *evsel)
+{
+	if (evsel->prev_raw_counts) {
+		evsel->prev_raw_counts->aggr.val = 0;
+		evsel->prev_raw_counts->aggr.ena = 0;
+		evsel->prev_raw_counts->aggr.run = 0;
+       }
+}
+
 static int perf_evsel__alloc_stats(struct perf_evsel *evsel, bool alloc_raw)
 {
 	int ncpus = perf_evsel__nr_cpus(evsel);
@@ -205,6 +214,14 @@ void perf_evlist__reset_stats(struct perf_evlist *evlist)
 	}
 }
 
+void perf_evlist__reset_prev_raw_counts(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel;
+
+	evlist__for_each_entry(evlist, evsel)
+		perf_evsel__reset_prev_raw_counts(evsel);
+}
+
 static void zero_per_pkg(struct perf_evsel *counter)
 {
 	if (counter->per_pkg_mask)
diff --git a/tools/perf/util/stat.h b/tools/perf/util/stat.h
index 0f9c9f6e2041..edbeb2f63e8d 100644
--- a/tools/perf/util/stat.h
+++ b/tools/perf/util/stat.h
@@ -194,6 +194,7 @@ void perf_stat__collect_metric_expr(struct perf_evlist *);
 int perf_evlist__alloc_stats(struct perf_evlist *evlist, bool alloc_raw);
 void perf_evlist__free_stats(struct perf_evlist *evlist);
 void perf_evlist__reset_stats(struct perf_evlist *evlist);
+void perf_evlist__reset_prev_raw_counts(struct perf_evlist *evlist);
 
 int perf_stat_process_counter(struct perf_stat_config *config,
 			      struct perf_evsel *counter);
-- 
2.18.1



