Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A864C390F45
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 06:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbhEZET7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 00:19:59 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:39645 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbhEZET5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 May 2021 00:19:57 -0400
Received: from leknes.fjasle.eu ([92.116.119.165]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1N1cvQ-1lIyeh2rCy-011wfm; Wed, 26 May 2021 06:17:39 +0200
Received: by leknes.fjasle.eu (Postfix, from userid 1000)
        id 7B80F3C57E; Wed, 26 May 2021 06:17:38 +0200 (CEST)
From:   Nicolas Schier <nicolas@fjasle.eu>
To:     nicolas@fjasle.eu
Cc:     Finn Behrens <me@kloenk.de>, stable@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 4.14 1/2] tweewide: Fix most Shebang lines
Date:   Wed, 26 May 2021 06:17:27 +0200
Message-Id: <20210526041728.4114392-2-nicolas@fjasle.eu>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210526041728.4114392-1-nicolas@fjasle.eu>
References: <20210526041728.4114392-1-nicolas@fjasle.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:X6ZFHxYHavcfAx8rCBsUV6cS9bcQcnOzHRfNYvAkEsWlzBz8FI+
 YnJ/zj1CkN0GCPv88encsnflzO5I57WMAeYcaglDP/v2OMMvksCYuUNcYlMF04nPSsUKyPa
 CE/7rUGeviSdRhZvIDK4SjlwW/HNQFeldPy44BwfbL3ourDr55Id2mBVsQqklAStWkAxKCi
 OKvMLWPw9OSzW/hn3uhCA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:grrIetmVGyY=:BT++9Sefp+uqqorAuBpUZy
 z62sWVbVjrtYvDR5ybrxzSCftX9Ksc5Nkw792XPtKdKKDEojmbOGyZLfbe8zcogHF6xxKa7/g
 PcWL3dTT4CJ+EG6DSllXJpeYKv+HPTnJoawtvMJrIoGiC6BhRxLxFX+ux2oICagwRxF8CxOjb
 ns2f1vpKI9TnDMKsdYdP3O17mOvnsetWyPnbWDnTIFfImo50yx7JnE5z/flQgOvfFaqMo9fbU
 ZOJSW/fuoPIZjTkw23xmL6bNOa2PDGKdzrHwCmTpMBUej2VjPevCwK5DGDVLqWlyQ9KzGbDag
 lzpfzGbCcTc5/r+SMmCAZ7rFSLOABqOZUOBp8/Sk0GvDfGtHwrF2r+SsgSzkDyHvPeCylpbsM
 E8HCIQe+mpMRTyMxPzBpDRlHs7xk+KdUEwc9C8fMEpBr1Ba2jSeGIbghEvOLNyajl2dbh93Jl
 FoPaVGwC9n8HnSpUcVRnf7PrwPMiKY3YBerZZlmlFs0L7WcqjmWmcbfSgXhv1UHZbaFgYJ2zI
 a2AdjGJPzi8kaZ3F1clR2k=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Finn Behrens <me@kloenk.de>

commit c25ce589dca10d64dde139ae093abc258a32869c upstream.

Change every shebang which does not need an argument to use /usr/bin/env.
This is needed as not every distro has everything under /usr/bin,
sometimes not even bash.

Signed-off-by: Finn Behrens <me@kloenk.de>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
[nicolas@fjasle.eu: update contexts for v4.14, adapt for old scripts]
Signed-off-by: Nicolas Schier <nicolas@fjasle.eu>
---
 Documentation/sphinx/parse-headers.pl                          | 2 +-
 Documentation/target/tcm_mod_builder.py                        | 2 +-
 Documentation/trace/postprocess/decode_msr.py                  | 2 +-
 Documentation/trace/postprocess/trace-pagealloc-postprocess.pl | 2 +-
 Documentation/trace/postprocess/trace-vmscan-postprocess.pl    | 2 +-
 arch/ia64/scripts/unwcheck.py                                  | 2 +-
 scripts/bloat-o-meter                                          | 2 +-
 scripts/config                                                 | 2 +-
 scripts/diffconfig                                             | 2 +-
 scripts/show_delta                                             | 2 +-
 scripts/sphinx-pre-install                                     | 2 +-
 scripts/tracing/draw_functrace.py                              | 2 +-
 tools/kvm/kvm_stat/kvm_stat                                    | 2 +-
 tools/perf/python/tracepoint.py                                | 2 +-
 tools/perf/python/twatch.py                                    | 2 +-
 tools/perf/scripts/python/call-graph-from-sql.py               | 2 +-
 tools/perf/scripts/python/sched-migration.py                   | 2 +-
 tools/perf/tests/attr.py                                       | 2 +-
 tools/perf/util/setup.py                                       | 2 +-
 tools/power/pm-graph/analyze_boot.py                           | 2 +-
 tools/power/pm-graph/analyze_suspend.py                        | 2 +-
 tools/power/x86/intel_pstate_tracer/intel_pstate_tracer.py     | 2 +-
 tools/testing/ktest/compare-ktest-sample.pl                    | 2 +-
 tools/testing/selftests/tc-testing/tdc_batch.py                | 2 +-
 24 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/Documentation/sphinx/parse-headers.pl b/Documentation/sphinx/parse-headers.pl
index a958d8b5e99d..35a2e5f2ef27 100755
--- a/Documentation/sphinx/parse-headers.pl
+++ b/Documentation/sphinx/parse-headers.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/env perl
 use strict;
 use Text::Tabs;
 use Getopt::Long;
diff --git a/Documentation/target/tcm_mod_builder.py b/Documentation/target/tcm_mod_builder.py
index 94bf6944bb1e..7e79ff6b09e0 100755
--- a/Documentation/target/tcm_mod_builder.py
+++ b/Documentation/target/tcm_mod_builder.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python
 # The TCM v4 multi-protocol fabric module generation script for drivers/target/$NEW_MOD
 #
 # Copyright (c) 2010 Rising Tide Systems
diff --git a/Documentation/trace/postprocess/decode_msr.py b/Documentation/trace/postprocess/decode_msr.py
index 0ab40e0db580..aa9cc7abd5c2 100644
--- a/Documentation/trace/postprocess/decode_msr.py
+++ b/Documentation/trace/postprocess/decode_msr.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python
 # add symbolic names to read_msr / write_msr in trace
 # decode_msr msr-index.h < trace
 import sys
diff --git a/Documentation/trace/postprocess/trace-pagealloc-postprocess.pl b/Documentation/trace/postprocess/trace-pagealloc-postprocess.pl
index 0a120aae33ce..b9b7d80c2f9d 100644
--- a/Documentation/trace/postprocess/trace-pagealloc-postprocess.pl
+++ b/Documentation/trace/postprocess/trace-pagealloc-postprocess.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/env perl
 # This is a POC (proof of concept or piece of crap, take your pick) for reading the
 # text representation of trace output related to page allocation. It makes an attempt
 # to extract some high-level information on what is going on. The accuracy of the parser
diff --git a/Documentation/trace/postprocess/trace-vmscan-postprocess.pl b/Documentation/trace/postprocess/trace-vmscan-postprocess.pl
index ba976805853a..c9b8b35468c3 100644
--- a/Documentation/trace/postprocess/trace-vmscan-postprocess.pl
+++ b/Documentation/trace/postprocess/trace-vmscan-postprocess.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/env perl
 # This is a POC for reading the text representation of trace output related to
 # page reclaim. It makes an attempt to extract some high-level information on
 # what is going on. The accuracy of the parser may vary
diff --git a/arch/ia64/scripts/unwcheck.py b/arch/ia64/scripts/unwcheck.py
index 89f3a1480a63..cfc02cb3931d 100644
--- a/arch/ia64/scripts/unwcheck.py
+++ b/arch/ia64/scripts/unwcheck.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python
 # SPDX-License-Identifier: GPL-2.0
 #
 # Usage: unwcheck.py FILE
diff --git a/scripts/bloat-o-meter b/scripts/bloat-o-meter
index a27677146410..654cce5614d8 100755
--- a/scripts/bloat-o-meter
+++ b/scripts/bloat-o-meter
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python
 #
 # Copyright 2004 Matt Mackall <mpm@selenic.com>
 #
diff --git a/scripts/config b/scripts/config
index eee5b7f3a092..8c8d7c3d7acc 100755
--- a/scripts/config
+++ b/scripts/config
@@ -1,4 +1,4 @@
-#!/bin/bash
+#!/usr/bin/env bash
 # SPDX-License-Identifier: GPL-2.0
 # Manipulate options in a .config file from the command line
 
diff --git a/scripts/diffconfig b/scripts/diffconfig
index 89abf777f197..627eba5849b5 100755
--- a/scripts/diffconfig
+++ b/scripts/diffconfig
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python
 # SPDX-License-Identifier: GPL-2.0
 #
 # diffconfig - a tool to compare .config files.
diff --git a/scripts/show_delta b/scripts/show_delta
index 5b365009e6a3..55c66dce6fc1 100755
--- a/scripts/show_delta
+++ b/scripts/show_delta
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python
 #
 # show_deltas: Read list of printk messages instrumented with
 # time data, and format with time deltas.
diff --git a/scripts/sphinx-pre-install b/scripts/sphinx-pre-install
index 3524dbc31316..acc185047805 100755
--- a/scripts/sphinx-pre-install
+++ b/scripts/sphinx-pre-install
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/env perl
 use strict;
 
 # Copyright (c) 2017 Mauro Carvalho Chehab <mchehab@kernel.org>
diff --git a/scripts/tracing/draw_functrace.py b/scripts/tracing/draw_functrace.py
index db40fa04cd51..30f117dfab43 100755
--- a/scripts/tracing/draw_functrace.py
+++ b/scripts/tracing/draw_functrace.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python
 
 """
 Copyright 2008 (c) Frederic Weisbecker <fweisbec@gmail.com>
diff --git a/tools/kvm/kvm_stat/kvm_stat b/tools/kvm/kvm_stat/kvm_stat
index fb02aa4591eb..5a1c92afdb01 100755
--- a/tools/kvm/kvm_stat/kvm_stat
+++ b/tools/kvm/kvm_stat/kvm_stat
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python
 #
 # top-like utility for displaying kvm statistics
 #
diff --git a/tools/perf/python/tracepoint.py b/tools/perf/python/tracepoint.py
index eb76f6516247..461848c7f57d 100755
--- a/tools/perf/python/tracepoint.py
+++ b/tools/perf/python/tracepoint.py
@@ -1,4 +1,4 @@
-#! /usr/bin/python
+#! /usr/bin/env python
 # SPDX-License-Identifier: GPL-2.0
 # -*- python -*-
 # -*- coding: utf-8 -*-
diff --git a/tools/perf/python/twatch.py b/tools/perf/python/twatch.py
index c235c22b107a..5a55b25f0b8c 100755
--- a/tools/perf/python/twatch.py
+++ b/tools/perf/python/twatch.py
@@ -1,4 +1,4 @@
-#! /usr/bin/python
+#! /usr/bin/env python
 # -*- python -*-
 # -*- coding: utf-8 -*-
 #   twatch - Experimental use of the perf python interface
diff --git a/tools/perf/scripts/python/call-graph-from-sql.py b/tools/perf/scripts/python/call-graph-from-sql.py
index b494a67a1c67..40eb659023f6 100644
--- a/tools/perf/scripts/python/call-graph-from-sql.py
+++ b/tools/perf/scripts/python/call-graph-from-sql.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python2
+#!/usr/bin/env python2
 # call-graph-from-sql.py: create call-graph from sql database
 # Copyright (c) 2014-2017, Intel Corporation.
 #
diff --git a/tools/perf/scripts/python/sched-migration.py b/tools/perf/scripts/python/sched-migration.py
index de66cb3b72c9..dd3e7ae2a1af 100644
--- a/tools/perf/scripts/python/sched-migration.py
+++ b/tools/perf/scripts/python/sched-migration.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python
 #
 # Cpu task migration overview toy
 #
diff --git a/tools/perf/tests/attr.py b/tools/perf/tests/attr.py
index 44090a9a19f3..6c68435585c7 100644
--- a/tools/perf/tests/attr.py
+++ b/tools/perf/tests/attr.py
@@ -1,4 +1,4 @@
-#! /usr/bin/python
+#! /usr/bin/env python
 # SPDX-License-Identifier: GPL-2.0
 
 import os
diff --git a/tools/perf/util/setup.py b/tools/perf/util/setup.py
index 23f1bf175179..393e7a1451f6 100644
--- a/tools/perf/util/setup.py
+++ b/tools/perf/util/setup.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python2
+#!/usr/bin/env python2
 
 from os import getenv
 
diff --git a/tools/power/pm-graph/analyze_boot.py b/tools/power/pm-graph/analyze_boot.py
index e83df141a597..4cb5d5aab911 100755
--- a/tools/power/pm-graph/analyze_boot.py
+++ b/tools/power/pm-graph/analyze_boot.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python
 #
 # Tool for analyzing boot timing
 # Copyright (c) 2013, Intel Corporation.
diff --git a/tools/power/pm-graph/analyze_suspend.py b/tools/power/pm-graph/analyze_suspend.py
index 1b60fe203741..d9c467bf8588 100755
--- a/tools/power/pm-graph/analyze_suspend.py
+++ b/tools/power/pm-graph/analyze_suspend.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python
 #
 # Tool for analyzing suspend/resume timing
 # Copyright (c) 2013, Intel Corporation.
diff --git a/tools/power/x86/intel_pstate_tracer/intel_pstate_tracer.py b/tools/power/x86/intel_pstate_tracer/intel_pstate_tracer.py
index 98c9f2df8aa7..84862a1842d6 100755
--- a/tools/power/x86/intel_pstate_tracer/intel_pstate_tracer.py
+++ b/tools/power/x86/intel_pstate_tracer/intel_pstate_tracer.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python
 # -*- coding: utf-8 -*-
 #
 """ This utility can be used to debug and tune the performance of the
diff --git a/tools/testing/ktest/compare-ktest-sample.pl b/tools/testing/ktest/compare-ktest-sample.pl
index 4118eb4a842d..ebea21d0a1be 100755
--- a/tools/testing/ktest/compare-ktest-sample.pl
+++ b/tools/testing/ktest/compare-ktest-sample.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/env perl
 # SPDX-License-Identifier: GPL-2.0
 
 open (IN,"ktest.pl");
diff --git a/tools/testing/selftests/tc-testing/tdc_batch.py b/tools/testing/selftests/tc-testing/tdc_batch.py
index 707c6bfef689..174646b14117 100755
--- a/tools/testing/selftests/tc-testing/tdc_batch.py
+++ b/tools/testing/selftests/tc-testing/tdc_batch.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python3
+#!/usr/bin/env python3
 
 """
 tdc_batch.py - a script to generate TC batch file
-- 
2.30.2

