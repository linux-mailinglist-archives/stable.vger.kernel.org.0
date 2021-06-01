Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20A42395D19
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232163AbhEaNlP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:41:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:44098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232731AbhEaNj0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:39:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AF996140C;
        Mon, 31 May 2021 13:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467627;
        bh=EZZHWiJ5fwj0D0t5jPZ/36JgAQ/mVMZE65bd8sftyGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WkRbZ5eFEl/kCSXzMrsY0xbK7Fa0S0Jso2lBPjVyYll1eiPZa3ErpAvmrfl1o1YvQ
         qEM0pgMdvloextFKJvX3wKFrbYbMcjhhZ1+v9OGHPu3eI2qU6m44AY1xMn04e0F5Vs
         9bF50bL45H6qyQov1l3MLYVKYMiKpxb2luh6qu3c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Finn Behrens <me@kloenk.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Schier <nicolas@fjasle.eu>
Subject: [PATCH 4.14 02/79] tweewide: Fix most Shebang lines
Date:   Mon, 31 May 2021 15:13:47 +0200
Message-Id: <20210531130636.081214990@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130636.002722319@linuxfoundation.org>
References: <20210531130636.002722319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/sphinx/parse-headers.pl                          |    2 +-
 Documentation/target/tcm_mod_builder.py                        |    2 +-
 Documentation/trace/postprocess/decode_msr.py                  |    2 +-
 Documentation/trace/postprocess/trace-pagealloc-postprocess.pl |    2 +-
 Documentation/trace/postprocess/trace-vmscan-postprocess.pl    |    2 +-
 arch/ia64/scripts/unwcheck.py                                  |    2 +-
 scripts/bloat-o-meter                                          |    2 +-
 scripts/config                                                 |    2 +-
 scripts/diffconfig                                             |    2 +-
 scripts/show_delta                                             |    2 +-
 scripts/sphinx-pre-install                                     |    2 +-
 scripts/tracing/draw_functrace.py                              |    2 +-
 tools/kvm/kvm_stat/kvm_stat                                    |    2 +-
 tools/perf/python/tracepoint.py                                |    2 +-
 tools/perf/python/twatch.py                                    |    2 +-
 tools/perf/scripts/python/call-graph-from-sql.py               |    2 +-
 tools/perf/scripts/python/sched-migration.py                   |    2 +-
 tools/perf/tests/attr.py                                       |    2 +-
 tools/perf/util/setup.py                                       |    2 +-
 tools/power/pm-graph/analyze_boot.py                           |    2 +-
 tools/power/pm-graph/analyze_suspend.py                        |    2 +-
 tools/power/x86/intel_pstate_tracer/intel_pstate_tracer.py     |    2 +-
 tools/testing/ktest/compare-ktest-sample.pl                    |    2 +-
 tools/testing/selftests/tc-testing/tdc_batch.py                |    2 +-
 24 files changed, 24 insertions(+), 24 deletions(-)

--- a/Documentation/sphinx/parse-headers.pl
+++ b/Documentation/sphinx/parse-headers.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/env perl
 use strict;
 use Text::Tabs;
 use Getopt::Long;
--- a/Documentation/target/tcm_mod_builder.py
+++ b/Documentation/target/tcm_mod_builder.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python
 # The TCM v4 multi-protocol fabric module generation script for drivers/target/$NEW_MOD
 #
 # Copyright (c) 2010 Rising Tide Systems
--- a/Documentation/trace/postprocess/decode_msr.py
+++ b/Documentation/trace/postprocess/decode_msr.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python
 # add symbolic names to read_msr / write_msr in trace
 # decode_msr msr-index.h < trace
 import sys
--- a/Documentation/trace/postprocess/trace-pagealloc-postprocess.pl
+++ b/Documentation/trace/postprocess/trace-pagealloc-postprocess.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/env perl
 # This is a POC (proof of concept or piece of crap, take your pick) for reading the
 # text representation of trace output related to page allocation. It makes an attempt
 # to extract some high-level information on what is going on. The accuracy of the parser
--- a/Documentation/trace/postprocess/trace-vmscan-postprocess.pl
+++ b/Documentation/trace/postprocess/trace-vmscan-postprocess.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/env perl
 # This is a POC for reading the text representation of trace output related to
 # page reclaim. It makes an attempt to extract some high-level information on
 # what is going on. The accuracy of the parser may vary
--- a/arch/ia64/scripts/unwcheck.py
+++ b/arch/ia64/scripts/unwcheck.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python
 # SPDX-License-Identifier: GPL-2.0
 #
 # Usage: unwcheck.py FILE
--- a/scripts/bloat-o-meter
+++ b/scripts/bloat-o-meter
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python
 #
 # Copyright 2004 Matt Mackall <mpm@selenic.com>
 #
--- a/scripts/config
+++ b/scripts/config
@@ -1,4 +1,4 @@
-#!/bin/bash
+#!/usr/bin/env bash
 # SPDX-License-Identifier: GPL-2.0
 # Manipulate options in a .config file from the command line
 
--- a/scripts/diffconfig
+++ b/scripts/diffconfig
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python
 # SPDX-License-Identifier: GPL-2.0
 #
 # diffconfig - a tool to compare .config files.
--- a/scripts/show_delta
+++ b/scripts/show_delta
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python
 #
 # show_deltas: Read list of printk messages instrumented with
 # time data, and format with time deltas.
--- a/scripts/sphinx-pre-install
+++ b/scripts/sphinx-pre-install
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/env perl
 use strict;
 
 # Copyright (c) 2017 Mauro Carvalho Chehab <mchehab@kernel.org>
--- a/scripts/tracing/draw_functrace.py
+++ b/scripts/tracing/draw_functrace.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python
 
 """
 Copyright 2008 (c) Frederic Weisbecker <fweisbec@gmail.com>
--- a/tools/kvm/kvm_stat/kvm_stat
+++ b/tools/kvm/kvm_stat/kvm_stat
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python
 #
 # top-like utility for displaying kvm statistics
 #
--- a/tools/perf/python/tracepoint.py
+++ b/tools/perf/python/tracepoint.py
@@ -1,4 +1,4 @@
-#! /usr/bin/python
+#! /usr/bin/env python
 # SPDX-License-Identifier: GPL-2.0
 # -*- python -*-
 # -*- coding: utf-8 -*-
--- a/tools/perf/python/twatch.py
+++ b/tools/perf/python/twatch.py
@@ -1,4 +1,4 @@
-#! /usr/bin/python
+#! /usr/bin/env python
 # -*- python -*-
 # -*- coding: utf-8 -*-
 #   twatch - Experimental use of the perf python interface
--- a/tools/perf/scripts/python/call-graph-from-sql.py
+++ b/tools/perf/scripts/python/call-graph-from-sql.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python2
+#!/usr/bin/env python2
 # call-graph-from-sql.py: create call-graph from sql database
 # Copyright (c) 2014-2017, Intel Corporation.
 #
--- a/tools/perf/scripts/python/sched-migration.py
+++ b/tools/perf/scripts/python/sched-migration.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python
 #
 # Cpu task migration overview toy
 #
--- a/tools/perf/tests/attr.py
+++ b/tools/perf/tests/attr.py
@@ -1,4 +1,4 @@
-#! /usr/bin/python
+#! /usr/bin/env python
 # SPDX-License-Identifier: GPL-2.0
 
 import os
--- a/tools/perf/util/setup.py
+++ b/tools/perf/util/setup.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python2
+#!/usr/bin/env python2
 
 from os import getenv
 
--- a/tools/power/pm-graph/analyze_boot.py
+++ b/tools/power/pm-graph/analyze_boot.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python
 #
 # Tool for analyzing boot timing
 # Copyright (c) 2013, Intel Corporation.
--- a/tools/power/pm-graph/analyze_suspend.py
+++ b/tools/power/pm-graph/analyze_suspend.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python
 #
 # Tool for analyzing suspend/resume timing
 # Copyright (c) 2013, Intel Corporation.
--- a/tools/power/x86/intel_pstate_tracer/intel_pstate_tracer.py
+++ b/tools/power/x86/intel_pstate_tracer/intel_pstate_tracer.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python
 # -*- coding: utf-8 -*-
 #
 """ This utility can be used to debug and tune the performance of the
--- a/tools/testing/ktest/compare-ktest-sample.pl
+++ b/tools/testing/ktest/compare-ktest-sample.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/env perl
 # SPDX-License-Identifier: GPL-2.0
 
 open (IN,"ktest.pl");
--- a/tools/testing/selftests/tc-testing/tdc_batch.py
+++ b/tools/testing/selftests/tc-testing/tdc_batch.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python3
+#!/usr/bin/env python3
 
 """
 tdc_batch.py - a script to generate TC batch file


