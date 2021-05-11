Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 990A537AEF8
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 20:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbhEKTAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 15:00:51 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:52755 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231851AbhEKTAt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 May 2021 15:00:49 -0400
Received: from leknes.fjasle.eu ([92.116.95.191]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MJmCV-1lw9ZA23sv-00K9mK; Tue, 11 May 2021 20:58:41 +0200
Received: by leknes.fjasle.eu (Postfix, from userid 1000)
        id AD13D3C082; Tue, 11 May 2021 20:58:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fjasle.eu; s=mail;
        t=1620759517; bh=fi3OfjSWyNA1twDcC3hwkr0kdSzU5XmVNIXowzUfhRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AUhuwDkNlymjJ8lT26zYcGs359COentANRxTYA045QDUCncbDOEmRv2w79d9XCQcu
         vCnFXVsDQcNE87BrFiadhtcfGWWbw4LHENNxU2iMzL5krpWS36AqlzDdNY7ymnVCgo
         JIg+0NRub3QR16BFEbIDpddPJYDwQeGmJmeggwps=
From:   Nicolas Schier <nicolas@fjasle.eu>
To:     stable@vger.kernel.org
Cc:     Finn Behrens <me@kloenk.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Schier <nicolas@fjasle.eu>
Subject: [PATCH v2 1/2] tweewide: Fix most Shebang lines
Date:   Tue, 11 May 2021 20:58:16 +0200
Message-Id: <20210511185817.2695437-2-nicolas@fjasle.eu>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210511185817.2695437-1-nicolas@fjasle.eu>
References: <20210511185817.2695437-1-nicolas@fjasle.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:CcEjeOWqJuEWlaGdzySm0UD9A6tpncALg1O7blZJ79Qvy74BA7C
 4IXHqCobvMzpRiyMu3TjGi0K/XQ+kZMxSdrxGXzoITGvHluheR5CLQtq9t2WsfuZ7gPRCDt
 7qG7qAano4Qrg4GKfDTiKyn+88gzn34X38htNUDaQGfo2qxlgzhFSiaNAtkr9hHtPuztgag
 pT52lQyIM5dxp107qNcoQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:g7fxgTJUCOw=:VDL8ULgRNYja5qkveuNfaw
 rxoKghkca1vMNve3VdUCPTI9kKNI0RfBCBDZM9PXUx7+9CA4b62fZVtBzC1Eis723tfdldxo2
 4vWdPmxla4b8tzJqvxTOqOr5cs1qe37hXrUPtfgjL+XNU7Z1l3Sn5A695J3l1fHvjVDvX+4kf
 bnL6MhyON3SQ6NFRzEOVk0LL6U/gupLoJkyo8lhmE0nVci8Zc8/8bgUkliuaJ2OQ/BBQCVFbo
 4km8lnTFYyBWImSKSzI57BrLzNZnUKdqQpHQplzESI0YOfVLut/j2xBsMahGPDZ7vVXNxX5E2
 QEKk51Ii2PJYjaDsx+43ddzp5kEzoNTNyB/zihrk19djMeGGu8VG/UnxixjFCeMos17H9cu1T
 U5/qjDVBLSlir4cl72LCDRWkj/tWEWS88v9HQnkf6OdVlRn6B41jzCedYIZlnVMpzNu2O5F81
 CJ0+qG6d1G/XHvze6FHn6g2J0xoIWUqep084Q3Gd+vWVF/6ezg9mk86wMFb9OTNUsrMuBavhZ
 ONLuDY1KjzjBtVOL1LoK/Q=
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
[nicolas@fjasle.eu: ported to v4.9, updated contexts, adapt for old
 scripts]
Signed-off-by: Nicolas Schier <nicolas@fjasle.eu>
---
 Documentation/sphinx/parse-headers.pl                          | 2 +-
 Documentation/target/tcm_mod_builder.py                        | 2 +-
 Documentation/trace/postprocess/decode_msr.py                  | 2 +-
 Documentation/trace/postprocess/trace-pagealloc-postprocess.pl | 2 +-
 Documentation/trace/postprocess/trace-vmscan-postprocess.pl    | 2 +-
 arch/ia64/scripts/unwcheck.py                                  | 2 +-
 scripts/analyze_suspend.py                                     | 2 +-
 scripts/bloat-o-meter                                          | 2 +-
 scripts/bootgraph.pl                                           | 2 +-
 scripts/checkincludes.pl                                       | 2 +-
 scripts/checkstack.pl                                          | 2 +-
 scripts/config                                                 | 2 +-
 scripts/diffconfig                                             | 2 +-
 scripts/dtc/dt_to_config                                       | 2 +-
 scripts/extract_xc3028.pl                                      | 2 +-
 scripts/get_dvb_firmware                                       | 2 +-
 scripts/markup_oops.pl                                         | 2 +-
 scripts/profile2linkerlist.pl                                  | 2 +-
 scripts/show_delta                                             | 2 +-
 scripts/stackdelta                                             | 2 +-
 scripts/tracing/draw_functrace.py                              | 2 +-
 tools/kvm/kvm_stat/kvm_stat                                    | 2 +-
 tools/perf/python/tracepoint.py                                | 2 +-
 tools/perf/python/twatch.py                                    | 2 +-
 tools/perf/scripts/python/call-graph-from-postgresql.py        | 2 +-
 tools/perf/scripts/python/sched-migration.py                   | 2 +-
 tools/perf/util/setup.py                                       | 2 +-
 tools/testing/ktest/compare-ktest-sample.pl                    | 2 +-
 28 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/Documentation/sphinx/parse-headers.pl b/Documentation/sphinx/parse-headers.pl
index db0186a7618f..299b0f82af27 100755
--- a/Documentation/sphinx/parse-headers.pl
+++ b/Documentation/sphinx/parse-headers.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/env perl
 use strict;
 use Text::Tabs;
 
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
index 8f961ef2b457..7749cdf372f7 100644
--- a/Documentation/trace/postprocess/trace-vmscan-postprocess.pl
+++ b/Documentation/trace/postprocess/trace-vmscan-postprocess.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/env perl
 # This is a POC for reading the text representation of trace output related to
 # page reclaim. It makes an attempt to extract some high-level information on
 # what is going on. The accuracy of the parser may vary
diff --git a/arch/ia64/scripts/unwcheck.py b/arch/ia64/scripts/unwcheck.py
index 2bfd941ff7c7..c27849889e19 100644
--- a/arch/ia64/scripts/unwcheck.py
+++ b/arch/ia64/scripts/unwcheck.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python
 #
 # Usage: unwcheck.py FILE
 #
diff --git a/scripts/analyze_suspend.py b/scripts/analyze_suspend.py
index a0ba48fa2c5e..edc4f1255f9b 100755
--- a/scripts/analyze_suspend.py
+++ b/scripts/analyze_suspend.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python
 #
 # Tool for analyzing suspend/resume timing
 # Copyright (c) 2013, Intel Corporation.
diff --git a/scripts/bloat-o-meter b/scripts/bloat-o-meter
index d9ff038c1b28..08e607e829c0 100755
--- a/scripts/bloat-o-meter
+++ b/scripts/bloat-o-meter
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python
 #
 # Copyright 2004 Matt Mackall <mpm@selenic.com>
 #
diff --git a/scripts/bootgraph.pl b/scripts/bootgraph.pl
index 9ca667bcaee9..594c55541b16 100755
--- a/scripts/bootgraph.pl
+++ b/scripts/bootgraph.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/env perl
 
 # Copyright 2008, Intel Corporation
 #
diff --git a/scripts/checkincludes.pl b/scripts/checkincludes.pl
index 97b2c6143fe4..cfdfa02d4d92 100755
--- a/scripts/checkincludes.pl
+++ b/scripts/checkincludes.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/env perl
 #
 # checkincludes: find/remove files included more than once
 #
diff --git a/scripts/checkstack.pl b/scripts/checkstack.pl
index b8f616545277..32828fafcf5b 100755
--- a/scripts/checkstack.pl
+++ b/scripts/checkstack.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/env perl
 
 #	Check the stack usage of functions
 #
diff --git a/scripts/config b/scripts/config
index 73de17d39698..06ac9882e1de 100755
--- a/scripts/config
+++ b/scripts/config
@@ -1,4 +1,4 @@
-#!/bin/bash
+#!/usr/bin/env bash
 # Manipulate options in a .config file from the command line
 
 myname=${0##*/}
diff --git a/scripts/diffconfig b/scripts/diffconfig
index 0db267d0adc9..ad1b16ec0f5b 100755
--- a/scripts/diffconfig
+++ b/scripts/diffconfig
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python
 #
 # diffconfig - a tool to compare .config files.
 #
diff --git a/scripts/dtc/dt_to_config b/scripts/dtc/dt_to_config
index 9a248b505c58..5dfd1bff351f 100755
--- a/scripts/dtc/dt_to_config
+++ b/scripts/dtc/dt_to_config
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/env perl
 
 # Copyright 2016 by Frank Rowand
 # Copyright 2016 by Gaurav Minocha
diff --git a/scripts/extract_xc3028.pl b/scripts/extract_xc3028.pl
index 47877deae6d7..61d9b256c658 100755
--- a/scripts/extract_xc3028.pl
+++ b/scripts/extract_xc3028.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/env perl
 
 # Copyright (c) Mauro Carvalho Chehab <mchehab@infradead.org>
 # Released under GPLv2
diff --git a/scripts/get_dvb_firmware b/scripts/get_dvb_firmware
index 1a0a04125f71..f3f230225aba 100755
--- a/scripts/get_dvb_firmware
+++ b/scripts/get_dvb_firmware
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/env perl
 #     DVB firmware extractor
 #
 #     (c) 2004 Andrew de Quincey
diff --git a/scripts/markup_oops.pl b/scripts/markup_oops.pl
index c21d16328d3f..70dcfb6b3de1 100755
--- a/scripts/markup_oops.pl
+++ b/scripts/markup_oops.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/env perl
 
 use File::Basename;
 use Math::BigInt;
diff --git a/scripts/profile2linkerlist.pl b/scripts/profile2linkerlist.pl
index 6943fa7cc95b..f23d7be94394 100755
--- a/scripts/profile2linkerlist.pl
+++ b/scripts/profile2linkerlist.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/env perl
 
 #
 # Takes a (sorted) output of readprofile and turns it into a list suitable for
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
diff --git a/scripts/stackdelta b/scripts/stackdelta
index 48eabf2f48f8..20a79f19a111 100755
--- a/scripts/stackdelta
+++ b/scripts/stackdelta
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/env perl
 
 # Read two files produced by the stackusage script, and show the
 # delta between them.
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
index 581278c58488..5e5797cc3757 100755
--- a/tools/kvm/kvm_stat/kvm_stat
+++ b/tools/kvm/kvm_stat/kvm_stat
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python
 #
 # top-like utility for displaying kvm statistics
 #
diff --git a/tools/perf/python/tracepoint.py b/tools/perf/python/tracepoint.py
index eb4dbed57de7..ce273c8b512b 100755
--- a/tools/perf/python/tracepoint.py
+++ b/tools/perf/python/tracepoint.py
@@ -1,4 +1,4 @@
-#! /usr/bin/python
+#! /usr/bin/env python
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
diff --git a/tools/perf/scripts/python/call-graph-from-postgresql.py b/tools/perf/scripts/python/call-graph-from-postgresql.py
index e78fdc2a5a9d..ce45699feaea 100644
--- a/tools/perf/scripts/python/call-graph-from-postgresql.py
+++ b/tools/perf/scripts/python/call-graph-from-postgresql.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python2
+#!/usr/bin/env python2
 # call-graph-from-postgresql.py: create call-graph from postgresql database
 # Copyright (c) 2014, Intel Corporation.
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
diff --git a/tools/perf/util/setup.py b/tools/perf/util/setup.py
index c8680984d2d6..163f38fbd79c 100644
--- a/tools/perf/util/setup.py
+++ b/tools/perf/util/setup.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python2
+#!/usr/bin/env python2
 
 from distutils.core import setup, Extension
 from os import getenv
diff --git a/tools/testing/ktest/compare-ktest-sample.pl b/tools/testing/ktest/compare-ktest-sample.pl
index a373a5bfff68..c488e863d83f 100755
--- a/tools/testing/ktest/compare-ktest-sample.pl
+++ b/tools/testing/ktest/compare-ktest-sample.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/env perl
 
 open (IN,"ktest.pl");
 while (<IN>) {
-- 
2.30.1

