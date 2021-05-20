Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D262138A574
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235561AbhETKQ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:16:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:47740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236171AbhETKOb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:14:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF8516144B;
        Thu, 20 May 2021 09:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503887;
        bh=gvsp/+YTuEbkTTaKsTD/eb5TV+WbRyMZ3WhPfuuHFmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lD+Xz6A/Nki106hXZW/dFv7GsXo52dilDsDjjNRVtGz4AzXcx1pj7LW6F+QAJYRaj
         EHHy4DcO4cnx0S1zMNzU5fmkbdkbUUewNumyKcSVR0+RZlYii7FIujgI1GDC467fri
         MbcT0m7m8vxi+Qo/R1mhBC//yIrg5m7Whi7rYZEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Finn Behrens <me@kloenk.de>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 4.19 424/425] tweewide: Fix most Shebang lines
Date:   Thu, 20 May 2021 11:23:13 +0200
Message-Id: <20210520092145.330050955@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
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
 scripts/split-man.pl                                           |    2 +-
 tools/perf/python/tracepoint.py                                |    2 +-
 tools/testing/ktest/compare-ktest-sample.pl                    |    2 +-
 tools/testing/selftests/bpf/test_offload.py                    |    2 +-
 tools/testing/selftests/tc-testing/tdc_batch.py                |    2 +-
 14 files changed, 14 insertions(+), 14 deletions(-)

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
--- a/scripts/split-man.pl
+++ b/scripts/split-man.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/env perl
 # SPDX-License-Identifier: GPL-2.0
 #
 # Author: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
--- a/tools/perf/python/tracepoint.py
+++ b/tools/perf/python/tracepoint.py
@@ -1,4 +1,4 @@
-#! /usr/bin/python
+#! /usr/bin/env python
 # SPDX-License-Identifier: GPL-2.0
 # -*- python -*-
 # -*- coding: utf-8 -*-
--- a/tools/testing/ktest/compare-ktest-sample.pl
+++ b/tools/testing/ktest/compare-ktest-sample.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/env perl
 # SPDX-License-Identifier: GPL-2.0
 
 open (IN,"ktest.pl");
--- a/tools/testing/selftests/bpf/test_offload.py
+++ b/tools/testing/selftests/bpf/test_offload.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python3
+#!/usr/bin/env python3
 
 # Copyright (C) 2017 Netronome Systems, Inc.
 #
--- a/tools/testing/selftests/tc-testing/tdc_batch.py
+++ b/tools/testing/selftests/tc-testing/tdc_batch.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python3
+#!/usr/bin/env python3
 
 """
 tdc_batch.py - a script to generate TC batch file


