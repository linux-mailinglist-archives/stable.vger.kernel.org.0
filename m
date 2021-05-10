Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 402F1379848
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 22:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbhEJUZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 16:25:23 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:57703 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbhEJUZX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 16:25:23 -0400
Received: from leknes.fjasle.eu ([92.116.68.92]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1M59am-1lhIM72gQW-00173u; Mon, 10 May 2021 22:22:55 +0200
Received: by leknes.fjasle.eu (Postfix, from userid 1000)
        id AC2D33C073; Mon, 10 May 2021 22:22:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fjasle.eu; s=mail;
        t=1620678171; bh=gk0qmFAERf56zLuzfNMV82ebykRlgcQAw4ZZ0AVm9AE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=5jehDnyfwsxD2/dvVULk1q1WXTlJvi3OYAy3E+ByQs25S8NfIUtgwYHeUxFz5T31B
         nso+K+Tsd22S9XcQ47VqSMsv6AzAxjzbNvAPbEwmyAnei0reswKQ/18OpBsUxvSDbs
         OpHAB64qpGpyPFq2vr90kM4xnWIz7VlwsfPqrNks=
From:   Nicolas Schier <nicolas@fjasle.eu>
To:     stable@vger.kernel.org
Cc:     Finn Behrens <me@kloenk.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Schier <nicolas@fjasle.eu>
Subject: [PATCH 1/2] tweewide: Fix most Shebang lines
Date:   Mon, 10 May 2021 22:22:20 +0200
Message-Id: <20210510202221.2601299-2-nicolas@fjasle.eu>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210510202221.2601299-1-nicolas@fjasle.eu>
References: <20210510202221.2601299-1-nicolas@fjasle.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:74ED84gX6dfE1PabhzVd2KfqWdXcmRxFrSzNIa9vsuCu7X/Kjk3
 UV+MQNpzZHA9r8cz8cwKJZb4eaKuNocib0TIyaFXqGTsaUvQOB7riTFqPb1RbZRGvSSrm+R
 E46oCPZ0iAkPvoSov27yQEDbVi1yLq4nIRheOrGv882T8/Xr14uNOO7qL74z7uJsyRygyj2
 nnu61XG3csG2MBIpJeqgg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:LsAIwCvgAaU=:lJREGgUwU3iw9i2xsNmeyr
 q3T+vF2U+k6ws21+bv7zj9K6hmbjulVqmGWNHydJySGLUPUSJZZ6zDsYqN6e5nCOnR3GdYIEg
 O3YMuSA2YgssVaT18gIrFRZKcDTdTduG7jDzBlfWsjvgCizWxXAm8IcHfdo5KeuAiettbECOL
 XHlfTnpKsr0E6syJDXmuIMeoIxBalAPRB8r4zgczbgSAcG5ZZpvcflMXFv7Yp5HNXPyqO5zaN
 geNGyqeOXLrPZdue/htbxfyh/KmiY7b0qTAlZDngL0Mg8+hvyaKoJlghecxzj6Hf1bnmAl2sz
 z7ghUCr4bujdv03uT/tTvU7wL+LtvwYOiXLO58ophJV9ckEykL98AuVCqtOXYEXzwZ2gFUpB+
 ZueRWsl2dvh7bJmZK6VPBLkJ+M0376DEzAUohAqtDganUZTGfDOKgpuMkm1Et5Cwm2uqTuJPc
 tqr1yBND3NWfw8+Klpn6NGxBgU+H5PvCJnJwJwt0xGxfWwWzRU3g+wCgRk06Rzake8mvjJUkm
 T/CelRZydpyZ5fOV/he/ss=
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
 Documentation/filesystems/cifs/winucase_convert.pl              | 2 +-
 Documentation/sphinx/parse-headers.pl                           | 2 +-
 Documentation/target/tcm_mod_builder.py                         | 2 +-
 Documentation/trace/postprocess/decode_msr.py                   | 2 +-
 Documentation/trace/postprocess/trace-pagealloc-postprocess.pl  | 2 +-
 Documentation/trace/postprocess/trace-vmscan-postprocess.pl     | 2 +-
 arch/ia64/scripts/unwcheck.py                                   | 2 +-
 drivers/scsi/script_asm.pl                                      | 2 +-
 .../staging/vc04_services/interface/vchiq_arm/vchiq_genversion  | 2 +-
 lib/build_OID_registry                                          | 2 +-
 scripts/analyze_suspend.py                                      | 2 +-
 scripts/bloat-o-meter                                           | 2 +-
 scripts/bootgraph.pl                                            | 2 +-
 scripts/checkincludes.pl                                        | 2 +-
 scripts/checkpatch.pl                                           | 2 +-
 scripts/checkstack.pl                                           | 2 +-
 scripts/cleanfile                                               | 2 +-
 scripts/cleanpatch                                              | 2 +-
 scripts/config                                                  | 2 +-
 scripts/diffconfig                                              | 2 +-
 scripts/dtc/dt_to_config                                        | 2 +-
 scripts/export_report.pl                                        | 2 +-
 scripts/extract-module-sig.pl                                   | 2 +-
 scripts/extract-sys-certs.pl                                    | 2 +-
 scripts/extract_xc3028.pl                                       | 2 +-
 scripts/get_dvb_firmware                                        | 2 +-
 scripts/get_maintainer.pl                                       | 2 +-
 scripts/headers_check.pl                                        | 2 +-
 scripts/kconfig/streamline_config.pl                            | 2 +-
 scripts/kernel-doc                                              | 2 +-
 scripts/kernel-doc-xml-ref                                      | 2 +-
 scripts/markup_oops.pl                                          | 2 +-
 scripts/namespace.pl                                            | 2 +-
 scripts/profile2linkerlist.pl                                   | 2 +-
 scripts/recordmcount.pl                                         | 2 +-
 scripts/show_delta                                              | 2 +-
 scripts/stackdelta                                              | 2 +-
 scripts/tracing/draw_functrace.py                               | 2 +-
 tools/kvm/kvm_stat/kvm_stat                                     | 2 +-
 tools/perf/python/tracepoint.py                                 | 2 +-
 tools/perf/python/twatch.py                                     | 2 +-
 tools/perf/scripts/perl/rw-by-file.pl                           | 2 +-
 tools/perf/scripts/perl/rw-by-pid.pl                            | 2 +-
 tools/perf/scripts/perl/rwtop.pl                                | 2 +-
 tools/perf/scripts/perl/wakeup-latency.pl                       | 2 +-
 tools/perf/scripts/python/call-graph-from-postgresql.py         | 2 +-
 tools/perf/scripts/python/sched-migration.py                    | 2 +-
 tools/perf/util/setup.py                                        | 2 +-
 tools/testing/ktest/compare-ktest-sample.pl                     | 2 +-
 tools/testing/ktest/ktest.pl                                    | 2 +-
 50 files changed, 50 insertions(+), 50 deletions(-)

diff --git a/Documentation/filesystems/cifs/winucase_convert.pl b/Documentation/filesystems/cifs/winucase_convert.pl
index 322a9c833f23..9d12be15619e 100755
--- a/Documentation/filesystems/cifs/winucase_convert.pl
+++ b/Documentation/filesystems/cifs/winucase_convert.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl -w
+#!/usr/bin/env perl -w
 #
 # winucase_convert.pl -- convert "Windows 8 Upper Case Mapping Table.txt" to
 #                        a two-level set of C arrays.
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
diff --git a/drivers/scsi/script_asm.pl b/drivers/scsi/script_asm.pl
index 7d651d99afcb..1e470cc3f11d 100644
--- a/drivers/scsi/script_asm.pl
+++ b/drivers/scsi/script_asm.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl -s
+#!/usr/bin/env perl -s
 
 # NCR 53c810 script assembler
 # Sponsored by 
diff --git a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_genversion b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_genversion
index 9f5b6344b9b7..bf2774537edf 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_genversion
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_genversion
@@ -1,4 +1,4 @@
-#!/usr/bin/perl -w
+#!/usr/bin/env perl -w
 
 use strict;
 
diff --git a/lib/build_OID_registry b/lib/build_OID_registry
index 5d9827217360..0e5214a7b71e 100755
--- a/lib/build_OID_registry
+++ b/lib/build_OID_registry
@@ -1,4 +1,4 @@
-#!/usr/bin/perl -w
+#!/usr/bin/env perl -w
 #
 # Build a static ASN.1 Object Identified (OID) registry
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
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index c3b23244e64f..d3cd52410e94 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl -w
+#!/usr/bin/env perl -w
 # (c) 2001, Dave Jones. (the file handling bit)
 # (c) 2005, Joel Schopp <jschopp@austin.ibm.com> (the ugly bit)
 # (c) 2007,2008, Andy Whitcroft <apw@uk.ibm.com> (new conditions, test suite)
diff --git a/scripts/checkstack.pl b/scripts/checkstack.pl
index b8f616545277..32828fafcf5b 100755
--- a/scripts/checkstack.pl
+++ b/scripts/checkstack.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/env perl
 
 #	Check the stack usage of functions
 #
diff --git a/scripts/cleanfile b/scripts/cleanfile
index cefd29e52298..4a4a4b2134c1 100755
--- a/scripts/cleanfile
+++ b/scripts/cleanfile
@@ -1,4 +1,4 @@
-#!/usr/bin/perl -w
+#!/usr/bin/env perl -w
 #
 # Clean a text file -- or directory of text files -- of stealth whitespace.
 # WARNING: this can be a highly destructive operation.  Use with caution.
diff --git a/scripts/cleanpatch b/scripts/cleanpatch
index 9680d03ad2b8..b134d66be8d5 100755
--- a/scripts/cleanpatch
+++ b/scripts/cleanpatch
@@ -1,4 +1,4 @@
-#!/usr/bin/perl -w
+#!/usr/bin/env perl -w
 #
 # Clean a patch file -- or directory of patch files -- of stealth whitespace.
 # WARNING: this can be a highly destructive operation.  Use with caution.
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
diff --git a/scripts/export_report.pl b/scripts/export_report.pl
index 8f79b701de87..f9d45f8fe1fc 100755
--- a/scripts/export_report.pl
+++ b/scripts/export_report.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl -w
+#!/usr/bin/env perl -w
 #
 # (C) Copyright IBM Corporation 2006.
 #	Released under GPL v2.
diff --git a/scripts/extract-module-sig.pl b/scripts/extract-module-sig.pl
index faac6f2e377f..bd757ba6674f 100755
--- a/scripts/extract-module-sig.pl
+++ b/scripts/extract-module-sig.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl -w
+#!/usr/bin/env perl -w
 #
 # extract-mod-sig <part> <module-file>
 #
diff --git a/scripts/extract-sys-certs.pl b/scripts/extract-sys-certs.pl
index 8227ca10a494..59b317d6624c 100755
--- a/scripts/extract-sys-certs.pl
+++ b/scripts/extract-sys-certs.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl -w
+#!/usr/bin/env perl -w
 #
 use strict;
 use Math::BigInt;
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
diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index aed4511f0304..16320cb878c9 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl -w
+#!/usr/bin/env perl -w
 # (c) 2007, Joe Perches <joe@perches.com>
 #           created from checkpatch.pl
 #
diff --git a/scripts/headers_check.pl b/scripts/headers_check.pl
index 8b2da054cdc3..218b38157ee1 100755
--- a/scripts/headers_check.pl
+++ b/scripts/headers_check.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl -w
+#!/usr/bin/env perl -w
 #
 # headers_check.pl execute a number of trivial consistency checks
 #
diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streamline_config.pl
index b8c7b29affc5..ac419a316745 100755
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl -w
+#!/usr/bin/env perl -w
 #
 # Copyright 2005-2009 - Steven Rostedt
 # Licensed under the terms of the GNU GPL License version 2
diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 7b163f99624c..bacdfee4de24 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1,4 +1,4 @@
-#!/usr/bin/perl -w
+#!/usr/bin/env perl -w
 
 use strict;
 
diff --git a/scripts/kernel-doc-xml-ref b/scripts/kernel-doc-xml-ref
index 104a5a5ba2c8..f39763f2fdb9 100755
--- a/scripts/kernel-doc-xml-ref
+++ b/scripts/kernel-doc-xml-ref
@@ -1,4 +1,4 @@
-#!/usr/bin/perl -w
+#!/usr/bin/env perl -w
 
 use strict;
 
diff --git a/scripts/markup_oops.pl b/scripts/markup_oops.pl
index c21d16328d3f..70dcfb6b3de1 100755
--- a/scripts/markup_oops.pl
+++ b/scripts/markup_oops.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/env perl
 
 use File::Basename;
 use Math::BigInt;
diff --git a/scripts/namespace.pl b/scripts/namespace.pl
index 4dddd4c01b62..997be1dad098 100755
--- a/scripts/namespace.pl
+++ b/scripts/namespace.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl -w
+#!/usr/bin/env perl -w
 #
 #	namespace.pl.  Mon Aug 30 2004
 #
diff --git a/scripts/profile2linkerlist.pl b/scripts/profile2linkerlist.pl
index 6943fa7cc95b..f23d7be94394 100755
--- a/scripts/profile2linkerlist.pl
+++ b/scripts/profile2linkerlist.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/env perl
 
 #
 # Takes a (sorted) output of readprofile and turns it into a list suitable for
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 113c7a071810..c8432a24d5c2 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl -w
+#!/usr/bin/env perl -w
 # (c) 2008, Steven Rostedt <srostedt@redhat.com>
 # Licensed under the terms of the GNU GPL License version 2
 #
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
diff --git a/tools/perf/scripts/perl/rw-by-file.pl b/tools/perf/scripts/perl/rw-by-file.pl
index 74844ee2be3e..06db66f98338 100644
--- a/tools/perf/scripts/perl/rw-by-file.pl
+++ b/tools/perf/scripts/perl/rw-by-file.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl -w
+#!/usr/bin/env perl -w
 # (c) 2009, Tom Zanussi <tzanussi@gmail.com>
 # Licensed under the terms of the GNU GPL License version 2
 
diff --git a/tools/perf/scripts/perl/rw-by-pid.pl b/tools/perf/scripts/perl/rw-by-pid.pl
index 9db23c9daf55..15f40150f39c 100644
--- a/tools/perf/scripts/perl/rw-by-pid.pl
+++ b/tools/perf/scripts/perl/rw-by-pid.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl -w
+#!/usr/bin/env perl -w
 # (c) 2009, Tom Zanussi <tzanussi@gmail.com>
 # Licensed under the terms of the GNU GPL License version 2
 
diff --git a/tools/perf/scripts/perl/rwtop.pl b/tools/perf/scripts/perl/rwtop.pl
index 8b20787021c1..5d778660da90 100644
--- a/tools/perf/scripts/perl/rwtop.pl
+++ b/tools/perf/scripts/perl/rwtop.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl -w
+#!/usr/bin/env perl -w
 # (c) 2010, Tom Zanussi <tzanussi@gmail.com>
 # Licensed under the terms of the GNU GPL License version 2
 
diff --git a/tools/perf/scripts/perl/wakeup-latency.pl b/tools/perf/scripts/perl/wakeup-latency.pl
index d9143dcec6c6..3f9f74579f1c 100644
--- a/tools/perf/scripts/perl/wakeup-latency.pl
+++ b/tools/perf/scripts/perl/wakeup-latency.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl -w
+#!/usr/bin/env perl -w
 # (c) 2009, Tom Zanussi <tzanussi@gmail.com>
 # Licensed under the terms of the GNU GPL License version 2
 
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
diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 223d88e25e05..892b8e474522 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl -w
+#!/usr/bin/env perl -w
 #
 # Copyright 2010 - Steven Rostedt <srostedt@redhat.com>, Red Hat Inc.
 # Licensed under the terms of the GNU GPL License version 2
-- 
2.30.1

