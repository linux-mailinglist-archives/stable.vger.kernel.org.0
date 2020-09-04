Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5E5825D9B1
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 15:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730491AbgIDNeZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 09:34:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:38082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730467AbgIDNeW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Sep 2020 09:34:22 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BC5B21655;
        Fri,  4 Sep 2020 13:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599226262;
        bh=Qoayjoiq0uSKgxLGXmLIhulkMjEAiiCj6O1lrgz1Tlc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ygBMttGZzvyz7hq5c6blWlcm1lwWKR3tVUPr5h+ZkjA82qvuE4LvD1L1QESZit10V
         SJvC04yOVDN5k2SAmw3dHeryzWnRdtkdrdxKE+Jt5xQC7wt0yR8cVXnUBcZZAlrLJq
         Tc8G8DQv3xMDX5ELDtYvY1wURQIAikptpBZbJAQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kim Phillips <kim.phillips@amd.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexey Budankov <alexey.budankov@linux.intel.com>,
        Ian Rogers <irogers@google.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Paul Clarke <pc@us.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tony Jones <tonyj@suse.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.8 06/17] perf record/stat: Explicitly call out event modifiers in the documentation
Date:   Fri,  4 Sep 2020 15:30:05 +0200
Message-Id: <20200904120258.295056672@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200904120257.983551609@linuxfoundation.org>
References: <20200904120257.983551609@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kim Phillips <kim.phillips@amd.com>

commit e48a73a312ebf19cc3d72aa74985db25c30757c1 upstream.

Event modifiers are not mentioned in the perf record or perf stat
manpages.  Add them to orient new users more effectively by pointing
them to the perf list manpage for details.

Fixes: 2055fdaf8703 ("perf list: Document precise event sampling for AMD IBS")
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexey Budankov <alexey.budankov@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jin Yao <yao.jin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Clarke <pc@us.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tony Jones <tonyj@suse.de>
Cc: stable@vger.kernel.org
Link: http://lore.kernel.org/lkml/20200901215853.276234-1-kim.phillips@amd.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/Documentation/perf-record.txt |    4 ++++
 tools/perf/Documentation/perf-stat.txt   |    4 ++++
 2 files changed, 8 insertions(+)

--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -33,6 +33,10 @@ OPTIONS
         - a raw PMU event (eventsel+umask) in the form of rNNN where NNN is a
 	  hexadecimal event descriptor.
 
+        - a symbolic or raw PMU event followed by an optional colon
+	  and a list of event modifiers, e.g., cpu-cycles:p.  See the
+	  linkperf:perf-list[1] man page for details on event modifiers.
+
 	- a symbolically formed PMU event like 'pmu/param1=0x3,param2/' where
 	  'param1', 'param2', etc are defined as formats for the PMU in
 	  /sys/bus/event_source/devices/<pmu>/format/*.
--- a/tools/perf/Documentation/perf-stat.txt
+++ b/tools/perf/Documentation/perf-stat.txt
@@ -39,6 +39,10 @@ report::
 	- a raw PMU event (eventsel+umask) in the form of rNNN where NNN is a
 	  hexadecimal event descriptor.
 
+        - a symbolic or raw PMU event followed by an optional colon
+	  and a list of event modifiers, e.g., cpu-cycles:p.  See the
+	  linkperf:perf-list[1] man page for details on event modifiers.
+
 	- a symbolically formed event like 'pmu/param1=0x3,param2/' where
 	  param1 and param2 are defined as formats for the PMU in
 	  /sys/bus/event_source/devices/<pmu>/format/*


