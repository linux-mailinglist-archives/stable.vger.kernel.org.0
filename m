Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1341F395B96
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231714AbhEaNWZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:22:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:54382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232144AbhEaNUT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:20:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB10E61375;
        Mon, 31 May 2021 13:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467114;
        bh=W8qLB1IxyBrH6Z8d5bzb0KjvzyD5cfI5yUv0UxgfFQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kyIE6SRy1oOoXvEjkWzMIhe9gbqhzYjrJI1V61pDv8nlpU7mJ6Dns7b/lmKvtFnMN
         NupznTUYV5E74kd56N84IRnj7/tX3hg9KijmsmcU8Vx33TO44qAQZccU1osQDKKtnD
         kKOABGdHNHXKHEBFcOgrWmOuXqD/nuFyw5UlAjdk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Finn Behrens <me@kloenk.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Schier <nicolas@fjasle.eu>
Subject: [PATCH 4.9 02/66] tweewide: Fix most Shebang lines
Date:   Mon, 31 May 2021 15:13:35 +0200
Message-Id: <20210531130636.341656226@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130636.254683895@linuxfoundation.org>
References: <20210531130636.254683895@linuxfoundation.org>
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
[nicolas@fjasle.eu: update contexts for v4.9, adapt for old scripts]
Signed-off-by: Nicolas Schier <nicolas@fjasle.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/sphinx/parse-headers.pl                          |    2 +-
 Documentation/target/tcm_mod_builder.py                        |    2 +-
 Documentation/trace/postprocess/decode_msr.py                  |    2 +-
 Documentation/trace/postprocess/trace-pagealloc-postprocess.pl |    2 +-
 Documentation/trace/postprocess/trace-vmscan-postprocess.pl    |    2 +-
 arch/ia64/scripts/unwcheck.py                                  |    2 +-
 scripts/analyze_suspend.py                                     |    2 +-
 scripts/bloat-o-meter                                          |    2 +-
 scripts/bootgraph.pl                                           |    2 +-
 scripts/checkincludes.pl                                       |    2 +-
 scripts/checkstack.pl                                          |    2 +-
 scripts/config                                                 |    2 +-
 scripts/diffconfig                                             |    2 +-
 scripts/dtc/dt_to_config                                       |    2 +-
 scripts/extract_xc3028.pl                                      |    2 +-
 scripts/get_dvb_firmware                                       |    2 +-
 scripts/markup_oops.pl                                         |    2 +-
 scripts/profile2linkerlist.pl                                  |    2 +-
 scripts/show_delta                                             |    2 +-
 scripts/stackdelta                                             |    2 +-
 scripts/tracing/draw_functrace.py                              |    2 +-
 tools/kvm/kvm_stat/kvm_stat                                    |    2 +-
 tools/perf/python/tracepoint.py                                |    2 +-
 tools/perf/python/twatch.py                                    |    2 +-
 tools/perf/scripts/python/sched-migration.py                   |    2 +-
 tools/perf/util/setup.py                                       |    2 +-
 tools/testing/ktest/compare-ktest-sample.pl                    |    2 +-
 27 files changed, 27 insertions(+), 27 deletions(-)

--- a/Documentation/sphinx/parse-headers.pl
+++ b/Documentation/sphinx/parse-headers.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/env perl
 use strict;
 use Text::Tabs;
 
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
 #
 # Usage: unwcheck.py FILE
 #
--- a/scripts/analyze_suspend.py
+++ b/scripts/analyze_suspend.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python
 #
 # Tool for analyzing suspend/resume timing
 # Copyright (c) 2013, Intel Corporation.
--- a/scripts/bloat-o-meter
+++ b/scripts/bloat-o-meter
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python
 #
 # Copyright 2004 Matt Mackall <mpm@selenic.com>
 #
--- a/scripts/bootgraph.pl
+++ b/scripts/bootgraph.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/env perl
 
 # Copyright 2008, Intel Corporation
 #
--- a/scripts/checkincludes.pl
+++ b/scripts/checkincludes.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/env perl
 #
 # checkincludes: find/remove files included more than once
 #
--- a/scripts/checkstack.pl
+++ b/scripts/checkstack.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/env perl
 
 #	Check the stack usage of functions
 #
--- a/scripts/config
+++ b/scripts/config
@@ -1,4 +1,4 @@
-#!/bin/bash
+#!/usr/bin/env bash
 # Manipulate options in a .config file from the command line
 
 myname=${0##*/}
--- a/scripts/diffconfig
+++ b/scripts/diffconfig
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python
 #
 # diffconfig - a tool to compare .config files.
 #
--- a/scripts/dtc/dt_to_config
+++ b/scripts/dtc/dt_to_config
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/env perl
 
 # Copyright 2016 by Frank Rowand
 # Copyright 2016 by Gaurav Minocha
--- a/scripts/extract_xc3028.pl
+++ b/scripts/extract_xc3028.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/env perl
 
 # Copyright (c) Mauro Carvalho Chehab <mchehab@infradead.org>
 # Released under GPLv2
--- a/scripts/get_dvb_firmware
+++ b/scripts/get_dvb_firmware
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/env perl
 #     DVB firmware extractor
 #
 #     (c) 2004 Andrew de Quincey
--- a/scripts/markup_oops.pl
+++ b/scripts/markup_oops.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/env perl
 
 use File::Basename;
 use Math::BigInt;
--- a/scripts/profile2linkerlist.pl
+++ b/scripts/profile2linkerlist.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/env perl
 
 #
 # Takes a (sorted) output of readprofile and turns it into a list suitable for
--- a/scripts/show_delta
+++ b/scripts/show_delta
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python
 #
 # show_deltas: Read list of printk messages instrumented with
 # time data, and format with time deltas.
--- a/scripts/stackdelta
+++ b/scripts/stackdelta
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/env perl
 
 # Read two files produced by the stackusage script, and show the
 # delta between them.
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
--- a/tools/perf/scripts/python/sched-migration.py
+++ b/tools/perf/scripts/python/sched-migration.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python
 #
 # Cpu task migration overview toy
 #
--- a/tools/perf/util/setup.py
+++ b/tools/perf/util/setup.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python2
+#!/usr/bin/env python2
 
 from distutils.core import setup, Extension
 from os import getenv
--- a/tools/testing/ktest/compare-ktest-sample.pl
+++ b/tools/testing/ktest/compare-ktest-sample.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/env perl
 
 open (IN,"ktest.pl");
 while (<IN>) {


